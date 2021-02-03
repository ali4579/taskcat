#!/bin/bash -e

EXIT_CODE=0
PROJECT_ROOT='../../tests/data/lambda_build_with_submodules'

${COV_CMD} ${BIN} package -p ${PROJECT_ROOT}  >& /tmp/output || EXIT_CODE=$?

if [[ ${EXIT_CODE} -ne 0 ]] ; then
    echo '$ taskcat package -p ./tests/data/lambda_build_with_submodules'
    cat /tmp/output
    echo "FAILED: expected exit code to be 0"
    exit 1
fi

if [[ $(cat /tmp/output | grep -c 'Packaging lambda source from ') -ne 3 ]] ; then
    echo '$ taskcat package -p ./tests/data/lambda_build_with_submodules'
    cat /tmp/output
    echo "FAILED: expecting 3 lambda functions to be zipped"
    exit 1
fi

if [[ ! -f ${PROJECT_ROOT}/lambda_functions/packages/TestFunc/lambda.zip ]] ; then
    echo '$ taskcat package -p ./tests/data/lambda_build_with_submodules'
    cat /tmp/output
    echo "expected packages/TestFunc/lambda.zip zip file to be present"
    exit 1
fi
rm -rf ${PROJECT_ROOT}/lambda_functions/packages/

PROJECT_ROOT=${PROJECT_ROOT}/submodules/SomeSub
if [[ ! -f ${PROJECT_ROOT}/lambda_functions/packages/TestFunc/lambda.zip ]] ; then
    echo '$ taskcat package -p ./tests/data/lambda_build_with_submodules'
    cat /tmp/output
    echo "expected submodule packages/TestFunc/lambda.zip zip file to be present"
    exit 1
fi
rm -rf ${PROJECT_ROOT}/lambda_functions/packages/

PROJECT_ROOT=${PROJECT_ROOT}/submodules/DeepSub
if [[ ! -f ${PROJECT_ROOT}/lambda_functions/packages/TestFunc/lambda.zip ]] ; then
    echo '$ taskcat package -p ./tests/data/lambda_build_with_submodules'
    cat /tmp/output
    echo "expected submodule DeepSub packages/TestFunc/lambda.zip zip file to be
    present"
    exit 1
fi
rm -rf ${PROJECT_ROOT}/lambda_functions/packages/
