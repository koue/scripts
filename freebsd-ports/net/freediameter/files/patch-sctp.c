--- libfdcore/sctp.c.orig	2015-01-22 12:26:28.000000000 +0200
+++ libfdcore/sctp.c	2015-01-22 12:27:02.000000000 +0200
@@ -575,7 +575,7 @@ static int fd_setsockopt_prebind(int sk)
 		
 		struct sctp_event event;
 		
-		for (i = 0; i < (sizeof(events_I_want) / sizeof(events_I_want[0]) - 1; i++) {
+		for (i = 0; i < (sizeof(events_I_want) / sizeof(events_I_want[0]) - 1); i++) {
 			memset(&event, 0, sizeof(event));
 			event.se_type = events_I_want[i];
 			event.se_on = 1;
