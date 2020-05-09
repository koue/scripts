/*
 * Copyright (c) 2020 Nikola Kolev <koue@chaosophia.net>
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
					<p>
 					<span class="chunk" data-chord="Am">Show me </span>
			 		<span class="chunk" data-chord="E">the money </span>
					</p>
					<p>
					<p>
 [Am]Show me [E]the money		<span class="chunk" data-chord="G">Black </span>
 [G]Black [C]sheep [Am]wall		<span class="chunk" data-chord="C">sheep </span>
				===>	<span class="chunk" data-chord="Am">wall</span>
 Show me the money			</p>
 Black sheep wall			<br />
					<p>
					<span>Show me the money</span><br />
					<span>Black sheep wall</span><br />
					</p>
					<br />
 */

#include <errno.h>
#include <stdio.h>
#include <string.h>

int
main(int argc, char *argv[])
{
	FILE *f;
	char s[8192];
	int start, paragraph = 1;

	if (argc != 2) {
		printf("No input file\n");
		return (1);
	}

	if ((f = fopen(argv[1], "re")) == NULL) {
		printf("ERROR: fopen: %s: %s\n", argv[1], strerror(errno));
		return (1);
	}
	while (fgets(s, sizeof(s), f)) {
		if (strlen(s) == 1) {	// if empty line print '<br />'
			if (paragraph == 0) { // close last '<p>'
				printf("</p>\n");
			}
			printf("<br />\n");
			paragraph = 1; // open new '<p>'
			continue;
		}
		else {
			if (paragraph) // open new '<p>'
				printf("<p>\n");
		}
		char *a, *b;
		start = 0;
		if (s[0])
			s[strlen(s) - 1] = 0; // chomp string
		for (a = s; (b = strstr(a, "[")) != NULL; start++) {
			*b = 0;
			if (strlen(a)) {
				if (start == 0) // first char is not chord
					printf("<span>");
				printf("%s</span>\n", a);
			}
			a = b + 1;
			if ((b = strstr(a, "]")) != NULL) {
				*b = 0;
				// print chord
				printf("<span class=\"chunk\" data-chord=\"%s\">", a);
				a = b + 1;
			}
		}
		if (start == 0) // no chord in line
			printf("<span>");
		printf("%s</span>", a);
		if (start == 0) { // no chord in line
			printf("<br />\n");
			paragraph = 0; // don't close '<p>'
		}
		else // close '<p>'
			printf("\n</p>\n");
	}
	fclose(f);

	return (0);
}
