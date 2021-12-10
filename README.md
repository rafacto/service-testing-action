# Action for Service Testing
Docker Action que executa testes de API do Postman utilizando o Newman. A action só executa os testes para branches de release.

## Usage
```yaml
  - uses: actions/checkout@master
  - name: Service Test
    uses: rafacto/service-testing-action@main
    with:
      collectionPath: './tests/postman-collection.json'
      environmentPath: './tests/postman-environment.json
```

## Inputs
* `collectionPath`: Obrigatório. Caminho até o arquivo da Postman Collection no repositório.
* `environmentPath`: Opcional. Caminho até o arquivo do Postman Environment no repositório.
* `stopPipeline`: Opcional. Valor default: YES. Se testes falharem, retorna saída 1, o que parará a esteira de ci/cd.
* `waitingTime`: Opcional. Valor default: 3m. Tempo de espera (em minutos) antes de começar a executar os testes. Pode ser útil quando necessário esperar pela subida da aplicação no host onde os testes foram programados para serem executados.

## Outputs
* `testReportPath`: Caminho do relatório html dos testes.
 
## Workflow Example
```yaml
name: Service Testing
on:
  push:
  workflow_dispatch:

env:
  SANDBOX_NAMESPACE: cargas
  SANDBOX_BRANCH: release/*
  
jobs:
  test-api:
    runs-on: self-hosted
    steps:

    - uses: actions/checkout@v2
	
    - name: Checkout Convair Actions
      uses: actions/checkout@v2
      with:
        repository: viavarejo-internal/convair-actions
        token: ${{ secrets.ACTIONS_TOKEN }}
        path: ./.convair-actions
        ref: main
	
    - name: AKS Sandbox Deploy
      uses: ./.convair-actions/aks-sandbox-deploy
      env:
        SHOULD_DEPLOY_SANDBOX: "YES"
      with:
        tool: kustomize
        projectNames: "${{ env.PROJECT_NAME }}"
        azureClientId: ${{ secrets.AZURE_CLIENT_ID }}
        azureClientSecret: ${{ secrets.AZURE_CLIENT_SECRET }}
        azureTenantId: ${{ secrets.AZURE_TENANT_ID }}
        namespaceSuffix: "-sit"
        sandboxPath: kustomize/base
        restrictedBranches: "${{ env.SANDBOX_BRANCH }}"
	
    - name: Service Tests
      id: servicetest
      uses: rafacto/service-testing-action@main
      with:
        collectionPath: './tests/pokemon-api-collection.json'
        environmentPath: './tests/pokemonapi-env.json'
	
    - name: Upload as Artifact the test html report
      uses: actions/upload-artifact@v2
      if: always()
      with:
        name: test-report
        path: ${{ steps.servicetest.outputs.testReportPath }}
        if-no-files-found: ignore
        retention-days: 30
```        
