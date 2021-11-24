#!/bin/sh

npm install -g newman

npm install -g newman-reporter-htmlextra

mkdir -p testResults

# verifica se o environment não foi passado (is empty)
if [ -z "$INPUT_ENVIRONMENT_PATH" ] ; then
  echo "environment empty"
  newman run $INPUT_COLLECTION_PATH
  newman run $INPUT_COLLECTION_PATH -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html
else
  echo "environment filled"
  newman run $INPUT_COLLECTION_PATH -e $INPUT_ENVIRONMENT_PATH 
  newman run $INPUT_COLLECTION_PATH -e $INPUT_ENVIRONMENT_PATH -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html
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
