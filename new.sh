#! /bin/sh
Y=$(date +%Y)
M=$(date +%m)
D=$(date +%d)
title=$1
hugo new content posts/$Y/$M/$D/$title/index.md