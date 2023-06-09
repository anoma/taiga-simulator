
all: test

deps/containers:
	@mkdir -p deps/
	@git clone --branch v0.6.2 --depth 1 https://github.com/anoma/juvix-containers.git deps/containers
	$(MAKE) -C deps/containers deps

deps/stdlib:
	@mkdir -p deps/
	@git clone https://github.com/anoma/juvix-stdlib.git deps/stdlib
	@git -C deps/stdlib checkout e94ea21027ffa63929ab67e12e917b23792b8c57

deps/test:
	@mkdir -p deps/
	@git clone --branch v0.5.2 --depth 1 https://github.com/anoma/juvix-test.git deps/test
	$(MAKE) -C deps/test deps

deps: deps/containers deps/stdlib deps/test

build/AppsTest: $(wildcard *.juvix) $(wildcard ./**/*.juvix) deps
	@mkdir -p build
	juvix compile -o build/AppsTest Test/AppsTest.juvix

build/SudokuValidatorTest: $(wildcard ./Sudoku/**/*.juvix) $(wildcard ./deps/**/*.juvix) deps
	@mkdir -p build
	juvix compile -o build/SudokuValidatorTest Test/SudokuValidatorTest.juvix

.PHONY: sudoku-test
sudoku-test: build/SudokuValidatorTest
	./build/SudokuValidatorTest

.PHONY: test
test: build/AppsTest sudoku-test
	./build/AppsTest

.PHONY: clean-deps
clean-deps:
	@rm -rf deps/

.PHONY: clean-build
clean-build:
	@rm -rf build/

.PHONY: clean
clean: clean-deps clean-build
