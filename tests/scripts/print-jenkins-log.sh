#!/usr/bin/env bash
set -eu
set -o pipefail

PROJECT=$1
BUILD_NAME=$2
LOG_URL=$(oc -n ${PROJECT} get build ${BUILD_NAME} -o jsonpath='{.metadata.annotations.openshift\.io/jenkins-log-url}')
TOKEN=$(oc -n ${PROJECT} get sa/builder --template='{{range .secrets}}{{ .name }} {{end}}' | xargs -n 1 oc -n ${PROJECT} get secret --template='{{ if .data.token }}{{ .data.token }}{{end}}' | head -n 1 | base64 -d -)

curl --insecure -sS --header "Authorization: Bearer ${TOKEN}" ${LOG_URL}
