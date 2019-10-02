#!/bin/sh

# load conf
. _pkg.conf

[ -z ${c_PDDIR} ] && c_empty c_PDDIR
[ -z ${c_PJ} ] && c_empty c_PJ
[ -z ${c_PR} ] && c_empty c_PR
[ -z ${c_SDIR} ] && c_empty c_SDIR
[ -z ${c_PEDIR} ] && c_empty c_PEDIR

[ ! -d ${c_PEDIR} ] && echo "${c_PEDIR} doesn't exist." && exit 1
[ -d ${c_PEDIR}/options ] && echo "${c_PEDIR}/options exists already." && exit 1
cp -r options ${c_PEDIR}/

mkdir -p ${c_SDIR}
cp pkg-build ${c_SDIR}/

cat << EOF >> ${c_SDIR}/pkg-run.sh
#!/bin/sh

PDDIR=${c_PDDIR}
PJ=${c_PJ}
PR=${c_PR}
SDIR=${c_SDIR}

[ -d \${PDDIR}/jails/\${PJ} ] && poudriere jails -u -j \${PJ} || poudriere jails -c -j \${PJ} -v \${PR} -a amd64
[ -d \${PDDIR}/ports/default ] && poudriere ports -u || poudriere ports -c
poudriere bulk -f \${SDIR}/pkg-build -j \${PJ}
EOF

chmod +x ${c_SDIR}/pkg-run.sh
