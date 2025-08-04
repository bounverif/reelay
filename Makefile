WORKSPACE := ${PWD}
BUILD_DIRECTORY := /tmp/$(basename $(notdir ${WORKSPACE}))/build
CMAKE_INSTALL_PREFIX ?= /tmp/install

.PHONY: all configure build test cbuild cryjson

configure:
	cmake -S $(WORKSPACE) -B $(BUILD_DIRECTORY) -DCMAKE_INSTALL_PREFIX="/usr/local"

configure-devel:
	cmake -S $(WORKSPACE) -B $(BUILD_DIRECTORY) -DCMAKE_INSTALL_PREFIX=$(CMAKE_INSTALL_PREFIX) -DREELAY_BUILD_TESTS=ON -DREELAY_BUILD_APPS=ON

build: configure
	cmake --build $(BUILD_DIRECTORY)

devel: configure-devel
	cmake --build $(BUILD_DIRECTORY)

test: devel
	ctest --test-dir $(BUILD_DIRECTORY) --output-on-failure

install:
	cmake --install $(BUILD_DIRECTORY)

cdevel:
	docker build -t ghcr.io/doganulus/reelay:devel docker/devel

cryjson:
	docker build -t ghcr.io/doganulus/reelay:ryjson docker/ryjson

cbenchmark:
	docker build -t ghcr.io/doganulus/reelay-benchmark:latest docker/benchmark

