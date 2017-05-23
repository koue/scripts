/*
 * Copyright (c) 2017 Nikola Kolev <koue@chaosophia.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *    - Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *    - Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following
 *      disclaimer in the documentation and/or other materials provided
 *      with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 */

/* $ cc -o whatever_you_want_to_name_me extract_c_function_from_source.c */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void usage(void){
  extern char *__progname;
  printf("Usage: %s [pattern] [file]\n", __progname);
  printf("Example: %s \"static int func(char *str)\" src.c\n", __progname);
  exit(1);
}

int main(int argc, char *argv[]){
  FILE *f;
  char s[8192], pattern[128];
  int found = 0, i, open =0, stop = 0;

  if(argc!=3){
    usage();
  }

  if ((f = fopen(argv[2], "r")) == NULL) {
    printf("Error: fopen: %s: %s\n", argv[2], strerror(errno));
    return (1);
  }

  while (fgets(s, sizeof(s), f) && !stop) {
    char *a, *b;

    for (a = s; (b = strstr(a, argv[1])) != NULL;){
      found = 1;                 /* pattern found */
      *b = 0;
      printf("%s", argv[1]);     /* print the pattern */
      a = b + strlen(argv[1]);   /* move string position after the pattern */
    }
    if(found){
      for(i = 0; a[i]; i++){
        if(a[i] == 0x7B){        /* '{' found, increase counter*/
          open++;
        }else if(a[i] == 0x7D){  /* '}' found, decrease counter */
          open--;
          if(open == 0){         /* last closing bracket of the function*/
            stop = 1;
            break;
          }
        }
      }
      printf("%s", a);           /* print function content */
    }
  }
  fclose(f);

  return (0);
}
