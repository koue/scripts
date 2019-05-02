/*
 * Copyright (c) 2019 Nikola Kolev <koue@chaosophia.net>
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
 * Output:
 *
 * [  1][  8][  7]
 * [  2][  9][  6]
 * [  3][  4][  5]
 *
 */

#include <stdio.h>
#include <stdlib.h>

#define MIN 1
#define MAX 26	/* increase the value if you have bigger screen */

void
range_print(void)
{
	printf("Valid range: [%d - %d]\n", MIN, MAX);
}

int
main(int argc, char *argv[])
{
	long num, i, j, min, max;
	int a[MAX][MAX], count = 1;
	char *str;

	if (argc != 2) {
		printf("Usage: %s [number]\n", argv[0]);
		range_print();
		return (1);
	}

	if (((num = strtol(argv[1], &str, 10)) > MAX) || num < MIN) {
		printf("Wrong number.\n");
		range_print();
		return (1);
	}
	/* first row/column */
	min = 0;
	/* last row/column */
	max = num - 1;
	/* fill matrix */
	while (count <= (num * num)) {
		/* if num is odd, min == max for the last count */
		if (min == max)
			a[min][max] = count++;
		/* fill column down */
		for (i = min, j = min; i < max; i++)
			a[i][j] = count++;
		/* fill row right */
		for (; j < max; j++)
			a[i][j] = count++;
		/* fill column up */
		for (; i > min; i--)
			a[i][j] = count++;
		/* fill row left */
		for (; j > min; j--)
			a[i][j] = count++;
		min++;
		max--;
	}
	/* print matrix */
	for (i = 0; i < num; i++) {
		for (j = 0; j < num; j++)
			printf("[%3d]", a[i][j]);
		printf("\n");
	}

	return (0);
}
