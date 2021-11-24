# Action for Service Testing
Docker Action for running Postman API tests using Newman

## Usage
```yaml
  - uses: actions/checkout@master
  - name: Service Test
    uses: rafacto/service-testing-action@main
    with:
      collection-path: './testes/postman-collection.json'
      environment-path: './tests/postman-environment.json
```

## Inputs
* `collection-path`: Required. Path to the Postman collection file in the repository.
* `environment-path`: Optional. Path to the Postman environment file in the repository.

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
      uses: ./.github/actions/service-test
      with:
        collection: './tests/pokemon-api-collection.json'
        environment: './tests/pokemonapi-env.json'
```        
