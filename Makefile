.PHONY: test
test: config-test
	@./test

.PHONY: examples
examples: dist/bash-completor
	@find ./example -name '*.completor.bash' -exec $^ -c {} \;

.PHONY: build
build: clean dist/bash-completor.completion.bash

.PHONY: clean
clean:
	rm -rf dist/

.PHONY: check-style
check-style: dist/bash-completor
	shellcheck $^

.PHONY: md5-check
md5-check:
	@cd ./dist && md5sum -c ./*.md5

.PHONY: md5
md5:
	@rm -f ./dist/*.md5
	@cd ./dist && for file in *; do [ -f "$$file" ] && md5sum -- "$$file" > "$$file.md5"; done

dist/bash-completor.completion.bash: dist/bash-completor
	$^ -c ./completor.bash

dist/bash-completor:
ifdef VERSION
	./tools/build-dist ${VERSION}
else
	./tools/build-dist $$(git rev-parse --short HEAD)
endif

fixtures = bats assert bats-file support

.PHONY: config-test
config-test: $(addprefix tests/fixture/,${fixtures})

tests/fixture/bats:
	git clone --depth 1 --single-branch --branch a https://github.com/adoyle-h/bats-core.git $@

tests/fixture/assert:
	git clone --depth 1 --single-branch --branch feat/stderr https://github.com/adoyle-h/bats-assert.git $@

tests/fixture/bats-file:
	git clone --depth 1 --single-branch https://github.com/bats-core/bats-file.git $@

tests/fixture/support:
	git clone --depth 1 --single-branch https://github.com/bats-core/bats-support.git $@
