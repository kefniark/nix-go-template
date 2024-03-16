# Cleanup / Setup
clean:
    rm bin/* || true
    go mod tidy
    gomod2nix generate

# Dev Tools
check: fmt lint test

fmt:
    @echo "Formatting ..."
    goimports -w .
    gofmt -s -w .

lint:
    @echo "Linting ..."
    golangci-lint run ./...

test:
    #!/bin/bash
    set -euxo pipefail

    PGKS=$(go list ./internal/...)
    go test -race -coverprofile coverage.out $PGKS

    go tool cover -func ./coverage.out
    go tool cover -html=coverage.out -o coverage.html
    gocover-cobertura < coverage.out > coverage.xml


# Run our application during development
app1 +ARGS:
    go run ./cmd/app1/app1.go {{ARGS}}

app2 +ARGS:
    go run ./cmd/app2/app2.go {{ARGS}}

build:
    @echo "Create local build in ./bin"
    go build -ldflags "-s -w -X main.BuildVersion=develop" -o bin/app1 cmd/app1/app1.go
    go build -ldflags "-s -w -X main.BuildVersion=develop" -o bin/app2 cmd/app2/app2.go
