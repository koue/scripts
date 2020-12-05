#!/bin/sh
#
##############################################################################
#
# Author:
#   2020 Nikola Kolev <koue@chaosophia.net>
#
# Requirements:
#   lame
#   youtube_dl
#
# Usage:
#   youtube.sh [-h] [-i index.html] -f file.txt
#
# File format:
#   file_title_1;youtubelink1
#   file_title_2;youtubelink2
#
# How it works:
#   download link as [title.wav] if [title.mp3] doesn't exist
#   convert to [title.mp3]
#   remove [title.wav]
#
##############################################################################
set -e

# variables
INDEXFILE=
LISTFILE=

# functions
_usage() {
cat << EOF

Usage: ${0} [-h ] [-i index.html] -f file
    -h				print help
    -i index.html		create list in html file
    -f file			file to parse
EOF
exit 1
}

_html_header() {
cat <<EOF > "${INDEXFILE}"
<html>
<head>
<title>youtube.com</title>
<body>
EOF
}

_html_footer() {
cat <<EOF >> "${INDEXFILE}"
</body>
</html>
EOF
}

# main
while getopts ":hi:f:" opt; do
    case ${opt} in
        h)
            _usage
            ;;
        i)
            INDEXFILE="${OPTARG}"
            ;;
        f)
            LISTFILE="${OPTARG}"
            ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            _usage
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            _usage
            ;;
    esac
done
if [ "$OPTIND" -eq 1 ]
then
    _usage
fi
shift $((OPTIND -1))

if [ -z "${LISTFILE}" ]
then
    _usage
fi

if [ `uname` = "Linux" ]
then
    if [ ! -x "youtube-dl" ]
    then
        wget https://yt-dl.org/downloads/latest/youtube-dl -O youtube-dl
        chmod +x youtube-dl
    fi
    YOUTUBEBIN="./youtube-dl"
else
    YOUTUBEBIN="youtube-dl"
fi

if [ ! -z "${INDEXFILE}" ]
then
    _html_header
fi

for line in `cat "${LISTFILE}" | grep -v "^#"`
do
    FNAME=`echo "${line}" | cut -d ';' -f 1`
    URL=`echo "${line}" | cut -d ';' -f 2`
    if [ ! -f "${FNAME}.mp3" ]
    then
        echo "Title: ${FNAME}"
        echo "Download: ${URL}"
        ${YOUTUBEBIN} --no-check-certificate --extract-audio \
            --audio-format wav -o "${FNAME}.%(ext)s" "${URL}"
        lame ${FNAME}.wav ${FNAME}.mp3
        rm ${FNAME}.wav
    fi
    if [ ! -z "${INDEXFILE}" ]
    then
        echo "<a href=\"${FNAME}.mp3\">${FNAME}</a><br />" >> "${INDEXFILE}"
    fi
done

if [ ! -z "${INDEXFILE}" ]
then
    _html_footer
fi
