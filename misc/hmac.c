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

/*
** cc -c hmac.c
** cc -o program program.c hmac.o -lcrypto
*/

#include <stdio.h>
#include <string.h>
#include <openssl/hmac.h>

#include "hmac.h"

/* /usr/bin/head -c 200 /dev/urandom | tr -cd '[:graph:]' | head -c 100 */
static const char *secret =
  "kG/+wtEm~bl7w|</vNLIa|CR6R|JO]K4(w2#!(:AHn;-}Y.Y^HL/?+F}/e),k.2cYj>{2vS";

/*
** Malloc routine.
*/
static void *hmac_malloc(size_t n){
  void *p = malloc(n==0 ? 1: n);
  if (p==0) {
    fprintf(stderr, "out of memory");
    exit(1);
  }
  return p;
}

/*
** Duplicate a string.
*/
static char *hmac_strdup(const char *zOrig){
  char *z = 0;
  if( zOrig ){
    int n = strlen(zOrig);
    z = hmac_malloc(n + 1);
    memcpy(z, zOrig, n + 1);
  }
  return z;
}

/*
** HMAC encrypt string. zResult should be freed in calling function.
**
** char *result = NULL;
** HMAC_encrypt_me(string, &result);
** free(result);
*/
void HMAC_encrypt_me(const char *zString, char **zResult){
  char hmac_result[64];
  unsigned char *result;
  unsigned int len = 20;
  HMAC_CTX ctx;

  result = (unsigned char*)malloc(sizeof(char) * len);

  HMAC_CTX_init(&ctx);
  HMAC_Init_ex(&ctx, secret, strlen(secret), EVP_sha1(), NULL);
  HMAC_Update(&ctx, (unsigned char*)zString, strlen(zString));
  HMAC_Final(&ctx, result, &len);

  for (int i = 0; i < len; i++)
    snprintf(&hmac_result[i*2], sizeof(hmac_result), "%02x",
						(unsigned int)result[i]);
  free(result);
  HMAC_CTX_cleanup(&ctx);
  *zResult = hmac_strdup(hmac_result);
}
