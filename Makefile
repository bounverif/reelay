REELAY_SOURCE_DIR ?= $(PWD)
REELAY_BUILD_DIR := /tmp/build/$(notdir $(REELAY_SOURCE_DIR))
CMAKE_INSTALL_PREFIX ?= /tmp/install

.PHONY: all configure build test cbuild cryjson

configure:
	cmake -S $(REELAY_SOURCE_DIR) -B $(REELAY_BUILD_DIR)

configure-devel:
	PYTHON_BIN_PATH=/opt/python/cp311-cp311/bin/python \
	cmake -S $(REELAY_SOURCE_DIR) -B $(REELAY_BUILD_DIR) \
		-DREELAY_BUILD_TESTS=ON \
		-DREELAY_BUILD_APPS=ON \
		-DREELAY_BUILD_PYTHON_BINDINGS=ON \
		-DPython_EXECUTABLE=python3.11

build: configure
	cmake --build $(REELAY_BUILD_DIR)

devel: configure-devel
	cmake --build $(REELAY_BUILD_DIR)

test: devel
	ctest --test-dir $(REELAY_BUILD_DIR) --output-on-failure

install:
	cmake --install $(REELAY_BUILD_DIR) --prefix $(CMAKE_INSTALL_PREFIX)

cdevel:
	docker build -t ghcr.io/doganulus/reelay:devel docker/devel

cryjson:
	docker build -t ghcr.io/doganulus/reelay:ryjson docker/ryjson

cbenchmark:
	docker build -t ghcr.io/doganulus/reelay-benchmark:latest docker/benchmark

