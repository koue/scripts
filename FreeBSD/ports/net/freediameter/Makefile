# $FreeBSD$

PORTNAME=	freeDiameter
PORTVERSION=	1.2.0
CATEGORIES=	net
MASTER_SITES=	http://www.freediameter.net/hg/freeDiameter/archive/

MAINTAINER=	koue@chaosophia.net
COMMENT=	Open source Diameter protocol implementation

LICENSE=	BSD3CLAUSE

USES=		cmake
CMAKE_ARGS+=	-DFLEX_EXECUTABLE:FILEPATH=/usr/bin/flex -DSCTP_USE_MAPPED_ADDRESSES:BOOL=ON

.include <bsd.port.mk>
