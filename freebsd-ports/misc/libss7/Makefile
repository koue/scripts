# $FreeBSD$

PORTNAME=	libss7
PORTVERSION=	2.0.0
CATEGORIES=	misc
MASTER_SITES=	http://downloads.asterisk.org/pub/telephony/libss7/releases/

MAINTAINER=	koue@chaosophia.net
COMMENT=	C implementation of SS7 protocol services to application

LICENSE=	GPLv2

USES=		gmake
USE_LDCONFIG=	yes
PLIST_FILES=	include/libss7.h lib/libss7.a lib/libss7.so lib/libss7.so.2.0
MAKE_ARGS=	INSTALL_PREFIX=${STAGEDIR}${PREFIX}

ONLY_FOR_ARCHS=	amd64 i386 sparc64

.include <bsd.port.mk>
