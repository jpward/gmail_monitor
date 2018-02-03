#!/bin/bash

set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

$HERE/../firestick_text_input/firestick_text_input.sh "$1"

