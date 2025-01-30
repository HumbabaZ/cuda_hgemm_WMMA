# Copyright 2023. All Rights Reserved.
# Author: Bruce-Lee-LY
# Date: 20:42:28 on Sun, Feb 12, 2023
#
# Description: performance script

#!/bin/bash

# exec > performance.log 2>&1

set -euo pipefail

WORK_PATH=$(cd $(dirname $0) && pwd) && cd $WORK_PATH

python3 $WORK_PATH/performance2.py -p $WORK_PATH/../../log/
