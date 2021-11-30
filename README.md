# Action for Service Testing
Docker Action for running Postman API tests using Newman. The action executes the tests only for pull requests to release branches (branches that start with "release/")

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
* `collectionPath`: Required. Path to the Postman collection file in the repository.
* `environmentPath`: Optional. Path to the Postman environment file in the repository.

## Outputs
* `testReportPath`: Path to the html test report.
 
## Workflow Example
```yaml
name: Service Testing
on:
  push:
  pull_request:
  
jobs:
  test-api:
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@v2
    
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
