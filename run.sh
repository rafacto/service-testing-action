#!/bin/sh

npm install -g newman

npm install -g newman-reporter-htmlextra

mkdir -p testResults

# verifica se o environment não foi passado
if [ -z "$INPUT_ENVIRONMENT" ] ; then
#  newman run $INPUT_COLLECTION 
#  newman run $INPUT_COLLECTION -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html
  echo "environment is empty"
else
  newman run $INPUT_COLLECTION -e $INPUT_ENVIRONMENT 
  newman run $INPUT_COLLECTION -e $INPUT_ENVIRONMENT -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html
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
