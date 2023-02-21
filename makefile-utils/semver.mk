# Source Code: https://github.com/adoyle-h/makefile-utils

# @target makefile-utils/semver  Download semver tool
SEMVER_BIN ?= makefile-utils/semver
${SEMVER_BIN}:
	@mkdir -p $$(dirname '$@')
	@curl -sSLo '$@' https://raw.githubusercontent.com/fsaintjacques/semver-tool/master/src/semver
	@chmod +x '$@'

# @target semver-major  Print next major version (x) based on current git tag
# @target semver-minor  Print next minor version (y) based on current git tag
# @target semver-patch  Print next patch version (z) based on current git tag
SEMVER_TARGETS := $(addprefix semver-,major minor patch)
.PHONY: $(SEMVER_TARGETS)
$(SEMVER_TARGETS): ${SEMVER_BIN}
	$(eval VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null))
ifeq ($(VERSION),)
	$(eval VERSION := v0.0.0)
endif

	@${SEMVER_BIN} bump $(subst semver-,,$@) "${VERSION}"
