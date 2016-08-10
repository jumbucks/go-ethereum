# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gjbsee gjbsee-cross evm all test travis-test-with-coverage xgo clean
.PHONY: gjbsee-linux gjbsee-linux-386 gjbsee-linux-amd64
.PHONY: gjbsee-linux-arm gjbsee-linux-arm-5 gjbsee-linux-arm-6 gjbsee-linux-arm-7 gjbsee-linux-arm64
.PHONY: gjbsee-darwin gjbsee-darwin-386 gjbsee-darwin-amd64
.PHONY: gjbsee-windows gjbsee-windows-386 gjbsee-windows-amd64
.PHONY: gjbsee-android gjbsee-ios

GOBIN = build/bin
GO ?= latest

gjbsee:
	build/env.sh go build -i -v $(shell build/flags.sh) -o $(GOBIN)/gjbsee ./cmd/gjbsee
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gjbsee\" to launch gjbsee."

gjbsee-cross: gjbsee-linux gjbsee-darwin gjbsee-windows gjbsee-android gjbsee-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-*

gjbsee-linux: gjbsee-linux-386 gjbsee-linux-amd64 gjbsee-linux-arm
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-*

gjbsee-linux-386: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=linux/386 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep 386

gjbsee-linux-amd64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=linux/amd64 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep amd64

gjbsee-linux-arm: gjbsee-linux-arm-5 gjbsee-linux-arm-6 gjbsee-linux-arm-7 gjbsee-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep arm

gjbsee-linux-arm-5: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=linux/arm-5 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep arm-5

gjbsee-linux-arm-6: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=linux/arm-6 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep arm-6

gjbsee-linux-arm-7: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=linux/arm-7 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep arm-7

gjbsee-linux-arm64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=linux/arm64 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-linux-* | grep arm64

gjbsee-darwin: gjbsee-darwin-386 gjbsee-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-darwin-*

gjbsee-darwin-386: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=darwin/386 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-darwin-* | grep 386

gjbsee-darwin-amd64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=darwin/amd64 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-darwin-* | grep amd64

gjbsee-windows: gjbsee-windows-386 gjbsee-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-windows-*

gjbsee-windows-386: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=windows/386 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-windows-* | grep 386

gjbsee-windows-amd64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=windows/amd64 -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-windows-* | grep amd64

gjbsee-android: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=android-21/aar -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "Android cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-android-*

gjbsee-ios: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --targets=ios-7.0/framework -v $(shell build/flags.sh) ./cmd/gjbsee
	@echo "iOS framework cross compilation done:"
	@ls -ld $(GOBIN)/gjbsee-ios-*

evm:
	build/env.sh $(GOROOT)/bin/go install -v $(shell build/flags.sh) ./cmd/evm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/evm to start the evm."

all:
	for cmd in `ls ./cmd/`; do \
		 build/env.sh go build -i -v $(shell build/flags.sh) -o $(GOBIN)/$$cmd ./cmd/$$cmd; \
	done

test: all
	build/env.sh go test ./...

travis-test-with-coverage: all
	build/env.sh go vet ./...
	build/env.sh build/test-global-coverage.sh

xgo:
	build/env.sh go get github.com/karalabe/xgo

clean:
	rm -fr build/_workspace/pkg/ Godeps/_workspace/pkg $(GOBIN)/*
