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
 					<span class="chunk" data-chord="Am">Show me </span>
			 		<span class="chunk" data-chord="E">the money </span>
					<br />
					<br />
 [Am]Show me [E]the money		<span class="chunk" data-chord="G">Black </span>
 [G]Black [C]sheep [Am]wall		<span class="chunk" data-chord="C">sheep </span>
				===>	<span class="chunk" data-chord="Am">wall</span>
 Show me the money			<br />
 Black sheep wall			<br />
					<span>Show me the money</span><br />
					<span>Black sheep wall</span><br />
					<br />
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
	int chords = 0, line = 1;

	if (argc != 2) {
		printf("No input file\n");
		return (1);
	}

	if ((f = fopen(argv[1], "re")) == NULL) {
		printf("ERROR: fopen: %s: %s\n", argv[1], strerror(errno));
		return (1);
	}
	while (fgets(s, sizeof(s), f)) {
		if (line == 1) { // first line
			if (strlen(s) < 2) { // missing title
				fclose(f);
				printf("Missing title\n");
				return (1);
			} else {
				s[strlen(s) - 1] = 0; // chomp string
				printf("<html>\n<head>\n");
				printf("<meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">\n");
				printf("<title>%s</title>\n", s);
				printf("<link rel=\"stylesheet\" type=\"text/css\" href=\"chords.css\" />\n");
				printf("</head>\n<body>\n<a href=\"index.html\">index.html</a><br />\n");
				printf("<hr>\n<b>%s</b><br />\n", s);
			}
			line++;
			continue;
		}
		if (line == 2) {
			if (strlen(s) == 1) { // second line is empty
				printf("<br />\n");
			} else {
				s[strlen(s) - 1] = 0; // chomp string
				printf("<i>%s</i><br />\n", s); // additional info
			}
			line++;
			continue;
		}
		if (strlen(s) == 1) {	// empty line
			if (chords == 0) // no chords in previous line
				printf("<br />\n");
			line++;
			continue;
		}
		char *a, *b;
		chords = 0;
		if (s[0])
			s[strlen(s) - 1] = 0; // chomp string
		for (a = s; (b = strstr(a, "[")) != NULL; chords++) {
			*b = 0;
			if (strlen(a)) {
				if (chords == 0) // first char is not chord
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
		if (chords == 0) // no chord in line
			printf("<span>");
		printf("%s</span>\n<br />\n", a);
		if (chords > 0)
			printf("<br />\n");
		line++;
	}
	printf("<hr>\n</body>\n</html>\n");
	fclose(f);

	return (0);
}
