#! /bin/sh
Y=$(date +%Y)
M=$(date +%m)
D=$(date +%d)
title=$1
if [[ $2 == "draft" ]]; then
  path="drafts"
else
  path="$Y/$M/$D"
fi
hugo new content posts/$path/$title/index.md