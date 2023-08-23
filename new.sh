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
if [[ $2 == "undraft" ]]; then
  directory="content/posts/drafts/$title"
  if [[ -d $directory ]]; then
    newDirectory="content/posts/$path/$title"
    mv $directory $newDirectory
    mv $newDirectory/index.md $newDirectory/index.md.bak
  else
    exit 1
  fi
fi
hugo new content posts/$path/$title/index.md
if [[ $2 == "undraft" ]]; then
  cat $newDirectory/index.md.bak >> $newDirectory/index.md
  rm $newDirectory/index.md.bak
fi