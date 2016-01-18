#include <stdio.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>

#include "hashes.h"

int main(int argc, char **argv)
{
	DIR *dp;
	struct dirent *ep;


	void *lib_handle;
	unsigned long (*fptr)(char[256]);
	unsigned long HASH;
	
	char dufel[]="nikoganikoganikoga";

	char hashes[20][256];
	int len, i, j, k;
	char *error;
	char temp[256];

	dp = opendir ("./LIBS");
	if (dp != NULL)
	{
		i = 0;
		while (ep = readdir (dp))
		{
			len = strlen(ep->d_name);	
			if(ep->d_name[len-1] == 'o')
			{
				strncpy(hashes[i],ep->d_name,len-3);
				hashes[i][len]='\0';
				i++;
			}
		}
		(void) closedir (dp);
	}
	else
	{
		perror ("Couldn't open the LIB directory");
		return 1;
	}




	j = 1;	
	while(j)
	{
		printf("Available hash algorithms:\n");	
		for(j = 1; j < i + 1; j++)
		{
	
			printf("[%d] - %s\n", j, hashes[j-1]);
		}
		printf("------------------------------------\n");
		printf("[0] - Exit\n");
		printf("Choose one: ");
		scanf("%d", &j);
		if(!j) break;
		len = strlen(hashes[j-1]);	
		strcpy(temp, "./LIBS/");
		strcat(temp, hashes[j-1]);
		strcat(temp, ".so");
	
		lib_handle = dlopen(temp, RTLD_LAZY);
		if (!lib_handle) 
		{
			fprintf(stderr, "%s\n", dlerror());
			return 1;
		}
		sscanf(hashes[j-1],"lib%s", temp);
		fptr = dlsym(lib_handle, temp);
		if ((error = dlerror()) != NULL)  
		{
			fprintf(stderr, "%s\n", error);
			return 1;
		}

		HASH = (*fptr)(dufel);
		printf("%s - fhash - %lu\n",dufel, HASH);	
		dlclose(lib_handle);
	}




	return 0;
		
}
