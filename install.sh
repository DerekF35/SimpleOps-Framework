#!/bin/bash
set -eu

INSTALL_LOCATION=~/.local/bin

echo "CHECKING PATH FOR ${INSTALL_LOCATION}"

if [[ ":$PATH:" != *":${INSTALL_LOCATION}:"* ]]; then
    echo "ERROR: INSTALL LOCATION NOT FOUND IN PATH.  Please fix this for this to fully work."
    echo $PATH
fi

OPS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -x

chmod +x ${OPS_DIR}/*.sh

mkdir -p ${INSTALL_LOCATION}

rm -f ${INSTALL_LOCATION}/simpleops-menu ${INSTALL_LOCATION}/simpleops-run

ln -s ${OPS_DIR}/simpleops-menu.sh ${INSTALL_LOCATION}/simpleops-menu
ln -s ${OPS_DIR}/simpleops-run.sh ${INSTALL_LOCATION}/simpleops-run

echo "INSTALL COMPLETED!"
