PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags --always) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')
COSMOS_SDK := $(shell grep -i cosmos-sdk go.mod | awk '{print $$2}')
TEST_DOCKER_REPO=saisunkari19/coco

build_tags := $(strip netgo $(build_tags))

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=CoCo \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=cocod \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=cococli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
	-X "github.com/cosmos/cosmos-sdk/version.BuildTags=$(build_tags),cosmos-sdk $(COSMOS_SDK)"

BUILD_FLAGS := -ldflags '$(ldflags)'

all: go.sum install

create-wallet:
	cococli keys add validator

init:
	rm -rf ~/.cocod
	cocod init coco-post-chain  --chain-id coco-post-chain --stake-denom coco
	cocod add-genesis-account $(shell cococli keys show validator -a) 1000000000000coco,1000000000000mdm
	cocod gentx --name=validator --amount 100000000coco
	cocod collect-gentxs

install: go.sum
	go install -mod=readonly  $(BUILD_FLAGS) ./cmd/cocod
	go install -mod=readonly $(BUILD_FLAGS) ./cmd/cococli
build:
	go build -o bin/cocod ./cmd/cocod
	go build -o bin/cococli ./cmd/cococli

go.sum: go.mod
	@echo "--> Ensure dependencies have not been modified"
	GO111MODULE=on go mod verify

lint:
	@echo "--> Running linter"
	@golangci-lint run
	@go mod verify

docker-test:
	@docker build -f Dockerfile.test -t ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) .
	@docker tag ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) ${TEST_DOCKER_REPO}:$(shell git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')
	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD)
	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --abbrev-ref HEAD | sed 's#/#_#g')

.PHONY: build install