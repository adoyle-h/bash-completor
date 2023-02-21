include ./makefile-utils/*.mk
.DEFAULT_GOAL = help

.PHONY: test
# @desc run test
test: config-test
	@./test

.PHONY: examples
# @desc print examples
examples: dist/bash-completor
	@find ./example -name '*.completor.bash' -exec $^ -c {} \;

.PHONY: build
# @desc build bash-completor and its completion script
build: clean dist/bash-completor.completion.bash

.PHONY: clean
# @desc rm -rf dist
clean:
	rm -rf dist/

.PHONY: check-style
check-style: dist/bash-completor
	shellcheck $^

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

# @target bump-major  bump major version (x)
# @target bump-minor  bump minor version (y)
# @target bump-patch  bump patch version (z)
BUMP_TARGETS := $(addprefix bump-,major minor patch)
.PHONY: $(BUMP_TARGETS)
$(BUMP_TARGETS):
	@$(MAKE) $(subst bump-,semver-,$@) > VERSION
	@sed -i.bak -E "s/^VERSION=.+/VERSION=v$$(cat VERSION)/" README.md
	@sed -i.bak -E "s/^VERSION=.+/VERSION=v$$(cat VERSION)/" README.zh.md
	@rm README.md.bak README.zh.md.bak VERSION
