#!/bin/sh

npm install -g newman

npm install -g newman-reporter-htmlextra

mkdir -p testResults

newman run $INPUT_COLLECTION -e $INPUT_ENVIRONMENT 
 
newman run $INPUT_COLLECTION -e $INPUT_ENVIRONMENT -r htmlextra --reporter-htmlextra-export testResults/htmlreport.html

if [ $? -eq 1 ] ; then
  echo "Game over!"
  exit 1
fi

cd testResults
for entry in "$PWD"/*
do
  echo "$entry"
done
