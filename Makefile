# Makefile provided as a convenience wrapper around setup.sh and bitbake

UI ?= knotty

default:
	@$(call bitbake)

help:
	@echo >&2 "Note: Default target is $(defaulttarget)"
	@echo >&2
	@echo >&2 "Usage: make [TARGET]"
	@echo >&2 "       make clean"
	@echo >&2 "       make clean-sstate"
	@echo >&2 "       make clean-TARGET"
	@echo >&2 "       make cleanall-TARGET"
	@echo >&2 "       make cleansstate-TARGET"
	@echo >&2 "       make graph-TARGET"
	@echo >72 "         Generate dependency graphs for TARGET"
	@echo >&2 "       make update"
	@echo >72 "         Update to the latest bitbake and metadata"

parse:
	@echo Parsing metadata...
	@$(call bitbake,-p)

clean:
	@echo Cleaning build directory...
	@-rm -rf build/tmp* pseudodone

clean-sstate:
	@echo Cleaning sstate files...
	@-rm -rf build/shared-state-cache

graph-%:
	@echo Graphing $*...
	@$(call bitbake,-g,$*)

rebuild-%:
	@echo Cleaning $*...
	@$(call bitbake,-c cleansstate,$*)
	@echo Building $*...
	@$(call bitbake,$*)

clean-%:
	@echo Cleaning $*...
	@$(call bitbake,-c clean,$*)

cleanall-%:
	@echo Running cleanall against $*...
	@$(call bitbake,-c cleanall,$*)

cleansstate-%:
	@echo Running cleansstate against $*...
	@$(call bitbake,-c cleansstate,$*)

update:
	@echo Updating repositories...
	@repo sync

env:
	@echo Showing environment
	@$(call bitbake,-e)

env-%:
	@echo Showing environment for $*
	@$(call bitbake,-e,$*)

devshell-%:
	@echo Starting devshell for $*
	@$(call bitbake,-c,devshell,$*)

%:
	@echo Building $*...
	@$(call bitbake,$*)

define bitbake
. ./setup.sh && bitbake -k $(if $(UI),-u $(UI)) $1 $2 $3 $4
endef
