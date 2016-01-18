#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <net/ethernet.h>
#include <netinet/in_systm.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <pcap.h>
#include <err.h>
#include <regex.h>
#include <unistd.h>
#include <pthread.h>

#include "dhcp_options.h"

#define SPERW	(7 * 24 * 3600)
#define SPERD	(24 * 3600)
#define SPERH	(3600)
#define SPERM	(60)

#define LARGESTRING 1024

#define BACKLOG 4

#define S_INTERFACE "em0"
#define S_PORT	1313

// header variables
u_char	timestamp[40];			// timestamp on header
u_char	mac_origin[40];			// mac address of origin
u_char	mac_destination[40];		// mac address of destination
u_char	ip_origin[40];			// ip address of origin
u_char	ip_destination[40];		// ip address of destination
int	max_data_len;			// maximum size of a packet

int	tcpdump_style = -1;
char	errbuf[PCAP_ERRBUF_SIZE];
char	*hmask = NULL;
regex_t	preg;

int snif[2];

int	check_ch(u_char *data, int data_len);
int	readheader(u_char *buf);
int	readdata(u_char *buf, u_char *data, int *data_len);
int	printdata(u_char *data, int data_len);
void	pcap_callback(u_char *user, const struct pcap_pkthdr *h,
	    const u_char *sp);

void	printIPaddress(u_char *data);
void	printIPaddressAddress(u_char *data);
void	printIPaddressMask(u_char *data);
void	print8bits(u_char *data);
void	print16bits(u_char *data);
void	print32bits(u_char *data);
void	printTime8(u_char *data);
void	printTime32(u_char *data);
void	printReqParmList(u_char *data, int len);
void	printHexColon(u_char *data, int len);
void	printHex(u_char *data, int len);
void	printHexString(u_char *data, int len);

void 	*print_message_function( void *ptr );
