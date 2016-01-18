/************************************************************************************
 * Info: 	Replace %20 with ' ' (space) in the name of the file
 * Author:  	Nikola Kolev
 * Date:    	25-Jan-2005
 *
 ************************************************************************************/

#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>

int NEWSTR(char *ptr) 			/* checking the name of the file */
 { char newstr[100];
   int i,j=0,flag=0;
   
   memset(newstr,0,100);
   for(i=0;ptr[i];i++)
      if(!(ptr[i]=='%'))		/* checking the position of the % sign  */
        {  newstr[j]=ptr[i];
           j++;
        }
      else
         if((ptr[i+1]=='2') && (ptr[i+2]=='0')) /* if next signs are 2 and 0 */
	   { i+=2;				/* remove %20 from the name */
             newstr[j]=' ';
             j++;
	     flag=1;
           }
         else
	   { newstr[j]=ptr[i];			/* if next signs are not 2 and 0 */
	     j++;				/* leave % in the name of the file */
	   }
   if(flag) rename(ptr,newstr);	
   return 1;
}

int main() {
  int yep=0;
  DIR* D=opendir(".");
  struct dirent* d;

  if (!D) {
    perror("opendir");
    return 1;
  }
  while ((d=readdir(D)))
    yep = NEWSTR(d->d_name);  /* d->d_name, name of the file */
  if(yep) puts("Done!");
  return 0;
}
