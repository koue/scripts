#include "config.h"

#include "dhcpdump.c"

typedef struct _thread_data_
{
	pthread_t tid;
	int sock;
} thread_data;

int main(int argc, char **argv) {
	register int s, c;
	int b, iret;
	pid_t start_sniff;
	struct sockaddr_in sa;
	thread_data *pthr_data;

	if ((s = socket(PF_INET, SOCK_STREAM, 0)) < 0) {
		perror("socket");
		return 1;
	}

	bzero(&sa, sizeof sa);

	sa.sin_family = AF_INET;
	sa.sin_port   = htons(S_PORT);

	if (INADDR_ANY)
		sa.sin_addr.s_addr = htonl(INADDR_ANY);

	if (bind(s, (struct sockaddr *)&sa, sizeof sa) < 0) {
		perror("bind");
		return 2;
	}

	printf("\nStarting sniffer...\n");

	pipe(snif);

	start_sniff = fork();
	if(start_sniff < 0){
		fprintf(stderr,"sniffer fork failed!\n");
		return 3;
	}
	else if (start_sniff == 0){
		dhcp_sniff();
	}
	else{
		sleep(1);
		switch (fork()) {
			case -1:
				perror("fork");
				return 4;
				break;
			default:
				close(s);
				return 0;
				break;
			case 0:
				break;
		}
		listen(s, BACKLOG);
		printf("\nWaiting fo clients connection in background.\n");
		for (;;) {
			b = sizeof sa;
			pthr_data = (thread_data *)malloc(sizeof(thread_data));
			if (pthr_data == NULL){
				fprintf(stderr, "Cannot create client thread,\n");
				return 6;
			}
			if ((pthr_data->sock = accept(s, (struct sockaddr *)&sa, &b)) < 0) {
				fprintf(stderr, "Cannot accept client connection.\n");
				return 68;
			}

			fprintf(stderr, "create thread\n");
			if (pthread_create( &(pthr_data->tid), NULL, print_message_function, pthr_data)){
				fprintf(stderr, "Cannot create client thread.\n");
				return 7;
			}
			free(pthr_data);
		}
	}
}

void *print_message_function( void *ptr)
{
	int bytes, sock;
	FILE *client;
	char buffer[BUFSIZ+1];

	pthread_detach(pthread_self());

	sock = ((thread_data*)ptr)->sock;	
	if ((client = fdopen(sock, "w")) == NULL) {
		fprintf(stderr, "Cannot open client connection for writing.\n");
		return;
	}
	fprintf(client, "DHCP dump started.\n");	
	fflush(client);
	while(1){
		bytes = read(snif[0], buffer, BUFSIZ);
		fprintf(client, "%s\n", buffer);
		fflush(client);
	}
}
