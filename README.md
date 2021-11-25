# Action for Service Testing
Docker Action for running Postman API tests using Newman

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

## Workflow Example
```yaml
name: Test-Build
on:
  push:
    branches:
      - master
jobs:
  test-api:
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@v2
    
    - name: Service Test
      uses: rafacto/service-testing-action@main
      with:
        collection: './tests/pokemon-api-collection.json'
        environment: './tests/pokemonapi-env.json'
```        
