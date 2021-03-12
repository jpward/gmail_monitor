#!/bin/bash -x

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
INPUT="$(echo $1 | sed 's/^stick //')"
$HERE/../firestick_text_input/firestick_text_input.sh "$INPUT" > /tmp/firestick.output 2>&1
