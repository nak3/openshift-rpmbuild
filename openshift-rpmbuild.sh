#!/bin/bash

# openshift-rpmbuild.sh
#
#   This script is to build openshift RPM packages.

SRPM=false
RESULT_OUTPUT=false
SRC_HOME=""
TMPREPOS="tmp.repos"
SUCCESS_CNT=0
SUCCESS_PKG=""
FAIL_CNT=0
FAIL_PKG=""

showusage() {
  echo "usage: $0 [options] PKGNAME|ALL"
  echo ""
  echo "eg)"
  echo "   \$ $0 openshift-origin-broker"
  echo "   \$ $0 buildall"
  echo ""
  echo "Options:"
  echo "  -s                     build SRPM only"
  echo "  -r                     show build result"
  echo "  -D <OPENSHIFT_SRC>     specify to search OpenShift source code home directory. default value is current direcotry"
  exit 1
}

showresult(){
  echo ""
  echo "BUILD RESULT"
  echo "================"
  echo "success to build: ${SUCCESS_CNT}"
  echo "-----------------------------"
  echo "    ${SUCCESS_PKG}"
  echo ""
  echo "failed to build: ${FAIL_CNT} "
  echo "-----------------------------"
  echo "    ${FAIL_PKG}"
}

while getopts srD: flag
do
  case $flag in
    s)  SRPM=true;;
    r)  RESULT_OUTPUT=true;;
    D)  SRC_HOME=$OPTARG;;
    \?) showusage ; break;;
  esac
done
shift $((OPTIND - 1))

if [ $# -lt 1 ];then
  echo "[ERROR] Unsufficient arguments"
  echo ""
  showusage
fi

if [ "x${SRC_HOME}" = "x" ]; then
  SRC_HOME=`pwd`
fi

if [ "${PKGNAME}" = "buildall" ]; then
  PKGNAME="*"
else
	PKGNAME=$1
fi

SPEC_PATH=`find ${SRC_HOME} -name ${PKGNAME}.spec -print -o -path "*${TMPREPOS}*" -prune`

if [ "x${SPEC_PATH}" = "x" ]; then
  echo "[ERROR] No ${PKGNAME}.spec found"
  exit 1
fi

building() {
  PKGNAME=`basename ${SPEC_PATH} .spec`
  VERSION=`grep "^Version:" ${SPEC_PATH} |grep -o -e "[0-9]\+\.[0-9]\+\.[0-9]\+.*"`
  RELEASE=`grep "^Release:" ${SPEC_PATH} |grep -o "[0-9]*"`
  SRC_DIR=`dirname ${SPEC_PATH}`

  # NOTE: (exception) openshift-origin-logshifter is different from spec filename
  if [ ${PKGNAME} = "logshifter" ] ; then PKGNAME=openshift-origin-logshifter ; fi

  mkdir -p ${TMPREPOS}/{SPECS,RPMS,SRPMS,SOURCES,PLAIN}
  cp -r ${SRC_DIR} ${TMPREPOS}/PLAIN/"${PKGNAME}-${VERSION}"
  cd ${TMPREPOS}/PLAIN/
  tar cfvz ../SOURCES/"${PKGNAME}-${VERSION}".tar.gz "${PKGNAME}-${VERSION}"
  rm -rf "${PKGNAME}-${VERSION}"
  cd ../..

  # srpm build
   rpmbuild --define="_source_filedigest_algorithm md5" --define="_topdir `pwd`/${TMPREPOS}" -bs ${SPEC_PATH}
  tmp=$? ; if ${SRPM} ; then return ${tmp}; fi

  #rpm build
  rpmbuild --define="_topdir `pwd`/${TMPREPOS}" --rebuild "${TMPREPOS}"/SRPMS/${PKGNAME}-${VERSION}-${RELEASE}.*.src.rpm
}

main() {
  for SPEC_PATH in `find ${SRC_HOME} -name ${PKGNAME}.spec -print -o -path "*${TMPREPOS}*" -prune`; do
    if ! building; then
      FAIL_CNT=$((${FAIL_CNT} + 1)) ; FAIL_PKG="${FAIL_PKG} ${PKGNAME}"
    else
      SUCCESS_CNT=$((${SUCCESS_CNT} + 1)) ; SUCCESS_PKG="${SUCCESS_PKG} ${PKGNAME}"
    fi
  done

  if ${RESULT_OUTPUT} ; then showresult ; fi
}

main
exit 0
