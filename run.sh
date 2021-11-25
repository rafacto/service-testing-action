#!/bin/sh

npm install -g newman

npm install -g newman-reporter-htmlextra

mkdir -p testResults

# verifica se o environment não foi passado (is empty)
if [ -z "$INPUT_ENVIRONMENTPATH" ] ; then
  newman run $INPUT_COLLECTIONPATH
  newman run $INPUT_COLLECTIONPATH -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html
else
  newman run $INPUT_COLLECTIONPATH -e $INPUT_ENVIRONMENTPATH 
  newman run $INPUT_COLLECTIONPATH -e $INPUT_ENVIRONMENTPATH -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html
fi

# verifica se a saída do último processo executado (o newman) foi mal sucedida (= 1)
if [ $? -eq 1 ] ; then
  echo "Game over!"
  exit 1
fi

cd testResults
for entry in "$PWD"/*
do
  echo "$entry"
done
