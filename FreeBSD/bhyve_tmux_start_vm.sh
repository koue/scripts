#!/bin/sh
#
# Copyright (c) 2015 Nikola Kolev
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

usage()
{
    echo ""
    echo "$0 /path/to/conf"
    echo ""
}

if [ -z "$1" -o ! -f "$1" ]; then
    usage
    exit 1
fi

. $1

ifconfig | grep -q ${TAP}
if [ $? -eq 0 ]
then
	echo "${TAP} interface already exists."
	exit 1	
fi

echo "Starting BHyve virtual machine named '${VM}'.  Use 'tmux a -t ${VM}' to access console"
ifconfig ${BRIDGE} up
/usr/local/bin/tmux new -s ${VM} -d "/bin/sh /usr/share/examples/bhyve/vmrun.sh -c 1 -m ${MEM} -d ${IMG} -t ${TAP} ${VM}"
iface=1
while [ $iface -eq 1 ]
do
	echo -n .
	sleep 1
	ifconfig | grep -q ${TAP}
	iface=$?
done
echo " [done]"
ifconfig ${BRIDGE} addm ${TAP}
