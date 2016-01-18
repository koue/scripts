# 

PROG=	gpsgraph	
SRCS=	gd.c gd_io.c gdfonts.c gdfx.c gdhelpers.c gd_security.c gdtables.c gdft.c gd_png.c gd_io_dp.c gd_io_file.c gd_jpeg.c gpsgraph.c data.c graph.c parse.y
MAN=	gpsgraph.8
CFLAGS+=	-Wall
CFLAGS+=	-I/usr/local/include -I/usr/local/include/libxml2 -I${.CURDIR}
LDFLAGS+=	-L/usr/local/lib -L${X11BASE}/lib
LDFLAGS+=	-lm -lpng -lz -ljpeg -lxml2

.include <bsd.prog.mk>
