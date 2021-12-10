#!/bin/bash

# verifica se o evento que disparou a pipeline é um pull_request para alguma branch de release
# if [[ $GITHUB_BASE_REF =~ release/* ]] ; then

# verifica se a branch que disparou o workflow é de release
if [ "$BRANCH_PREFIX" = "release" ] ; then
  echo "Esperando aplicação subir para Sit. Isso leva $INPUT_WAITINGTIME minutos."
  sleep $INPUT_WAITINGTIME
  
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

  # armazena o status (0: sucesso, 1: falhou) do último comando executado (o newman)
  testFailed=$?

  testReportPath="testResults/htmlreport.html"
  echo "::set-output name=testReportPath::$testReportPath"

  echo "INPUT_STOPPIPELINE: $INPUT_STOPPIPELINE"
  if [ $testFailed -eq 1 ] && [ "$INPUT_STOPPIPELINE" = "YES" ] ; then
    echo "Some test scenarios have failed. Check generated report for more information."
    exit 1
  fi

  cd testResults
  for entry in "$PWD"/*
  do
    echo "$entry"
  done
  
else
  echo "Service tests were not performed. They are executed only for pull requests to release branches."
  testReportPath="tests were not executed"
fi

echo "::set-output name=testReportPath::$testReportPath"


