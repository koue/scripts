/*
 * Copyright (c) 2025 Nikola Kolev <koue@chaosophia.net>
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
 Print socket info for pid. Tested on FreeBSD 14.
*/

#include <sys/param.h>
#include <sys/user.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/socketvar.h>
#include <sys/sysctl.h>
#include <sys/queue.h>
#include <sys/un.h>

#include <netinet/in.h>

#include <arpa/inet.h>

#include <assert.h>
#include <ctype.h>
#include <err.h>
#include <libprocstat.h>
#include <limits.h>
#include <pwd.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>

void
statproc(int pid)
{
	struct kinfo_proc *p;
	struct procstat *procstat;
	struct filestat *fst;
	struct filestat_list *head;
	struct sockstat sock;
	int what, cnt, error;
	char errbuf[_POSIX2_LINE_MAX];
	static const char *stypename[] = {
		"unused",	/* 0 */
		"stream",	/* 1 */
		"dgram",	/* 2 */
		"raw",		/* 3 */
		"rdm",		/* 4 */
		"seqpak"	/* 5 */
	};
	#define STYPEMAX 5

	what = KERN_PROC_PID;

	procstat = procstat_open_sysctl();
	if (procstat == NULL)
		errx(1, "procstat_open()");
	p = procstat_getprocs(procstat, what, pid, &cnt);
	if (p == NULL)
		errx(1, "procstat_getprocs()");

	for (int i = 0; i < cnt; i++) {
		if (p[i].ki_stat == SZOMB)
			continue;
		head = procstat_getfiles(procstat, p, 0);
		if (head == NULL)
			break;
		STAILQ_FOREACH(fst, head, next)
			switch (fst->fs_type) {
			case PS_FST_TYPE_SOCKET:
				error = procstat_get_socket_info(procstat, fst, &sock, errbuf);
				if (sock.type > STYPEMAX)
					printf("* %s ?%d", sock.dname, sock.type);
				else
					printf("* %s %s", sock.dname, stypename[sock.type]);
				if (sock.so_pcb != 0)
					printf(" %lx", (u_long)sock.so_pcb);
				/* print protocol number and socket address */
				printf(" %d %lx\n", sock.proto, (u_long)sock.so_addr);
				break;
			default:
				break;
			}
		procstat_freefiles(procstat, head);
	}
	procstat_freeprocs(procstat, p);
	procstat_close(procstat);
}
