#!/bin/sh

REPO=devports
REPO_URL=git://github.com/koue/$REPO.git
POUDRIERE_DATA=/usr/local/poudriere
POUDRIERE_SCRIPTS=/usr/local/etc/poudriere.d/scripts

if [ ! -d $POUDRIERE_SCRIPTS ]
then
	echo "Missing poudriere scripts directory."
	exit 1
fi

cd $POUDRIERE_SCRIPTS

if [ ! -f git_last ]
then
	touch git_last
fi

git ls-remote "$REPO_URL" HEAD > git_current

diff -q git_last git_current

if [ $? -eq 1 ]
then
	if [ -d "$REPO" ]
	then
		rm -rf $REPO
	fi
	
	git clone $REPO_URL

	poudriere ports -d 
	poudriere ports -c

	CATEGORY=`find $REPO/ -depth 2 -type d | grep -v git | cut -d '/' -f 2`
	PORT=`find $REPO/ -depth 2 -type d | grep -v git | cut -d '/' -f 3`

	if [ -d $POUDRIERE_DATA/ports/default/$CATEGORY/$PORT ]
	then
		mv $POUDRIERE_DATA/ports/default/$CATEGORY/$PORT $POUDRIERE_DATA/ports/default/$CATEGORY/$PORT.orig
	fi

	cp -rv $REPO/$CATEGORY/$PORT $POUDRIERE_DATA/ports/default/$CATEGORY

	echo $CATEGORY/$PORT > $POUDRIERE_SCRIPTS/build

	mv git_current git_last

	$POUDRIERE_SCRIPTS/build.sh
	$POUDRIERE_SCRIPTS/copy_logs.sh $PORT
fi
