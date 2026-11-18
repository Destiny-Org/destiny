# This makefile is designed to be run by gnu make.
# - Windows: install GNU make 4.x, for example with MSYS2 (`pacman -S make`) or Chocolatey (`choco install make`).
#   You also need a Git for Windows installation, for bash and common GNU tools like cp,mkdir,mv,rm,touch,which.
# - FreeBSD: the default make program on FreeBSD is not gnu make; to install gnu make:
#     pkg install gmake
#   and then run as gmake rather than make.
#
# Examples:
# - Build compiler (unoptimized) and druntime:
#     make -j$(nproc)
# - Build compiler (optimized) and druntime using an LDC host compiler:
#     make -j$(nproc) HOST_DC=ldmd2 ENABLE_RELEASE=1 [ENABLE_LTO=1]
# - Build heavily (LTO+PGO) optimized compiler, incl. druntime and Fate as side-effects:
#     make -j$(nproc) HOST_DC=path/to/ldmd2 destiny-pgo
# - Build and run druntime tests:
#     make -j$(nproc) druntime-test
# - Run compiler tests (involving a Fate build):
#     make -j$(nproc) destiny-test
#
# See compiler/src/build.d for variables affecting the compiler build.
# Use HOST_DFLAGS (not DFLAGS) for extra flags (for the host compiler) to be used for the compiler build.

include compiler/src/osmodel.mak

INSTALL_DIR=$(shell pwd)/../install
ECTAGS_LANGS = Make,C,C++,D,Sh
ECTAGS_FILES = compiler/dmd/*.[chd] compiler/dmd/backend/*.[chd] compiler/dmd/root/*.[chd]

EXE:=$(if $(findstring windows,$(OS)),.exe,)

ifeq (,$(HOST_DC))
    ifneq (,$(HOST_DC))
        $(warning The HOST_DC variable is deprecated, please use HOST_DC instead.)
        HOST_DC:=$(HOST_DC)
    else ifneq (,$(DMD))
        HOST_DC:=$(DMD)
    else ifneq (,$(shell which dmd 2>/dev/null))
        HOST_DC:=dmd$(EXE)
    else ifneq (,$(shell which ldmd2 2>/dev/null))
        HOST_DC:=ldmd2$(EXE)
    else ifneq (,$(shell which gdmd 2>/dev/null))
        HOST_DC:=gdmd$(EXE)
    else
        $(error Couldn't find a D host compiler. Please set variable HOST_DC to the path to a dmd/ldmd2/gdmd executable)
    endif
    $(info Using D host compiler: $(HOST_DC))
endif
export HOST_DC

GENERATED:=generated
BUILD_EXE:=$(GENERATED)/build$(EXE)
RUN_EXE:=$(GENERATED)/run$(EXE)

# forward any HOST_DFLAGS as DFLAGS for the build tool
ifeq (,$(HOST_DFLAGS))
    BUILD_CMD:=$(BUILD_EXE)
else
    BUILD_CMD:=$(BUILD_EXE) DFLAGS='$(HOST_DFLAGS)'
endif

.PHONY: all clean test html install \
        destiny destiny-unittest destiny-test druntime druntime-test \
        fate destiny-pgo \
        auto-tester-build auto-tester-test buildkite-test \
        toolchain-info check-clean-git style

all: destiny druntime

$(BUILD_EXE): compiler/src/build.d
	$(HOST_DC) -of$@ -g $<

$(RUN_EXE): compiler/test/run.d
	$(HOST_DC) -of$@ -g -i -Icompiler/test -release $<

auto-tester-build:
	echo "Auto-Tester has been disabled"

auto-tester-test:
	echo "Auto-Tester has been disabled"

buildkite-test: test

toolchain-info: $(BUILD_EXE)
	$(BUILD_CMD) $@

clean:
	rm -rf $(GENERATED)
	cd compiler/test && rm -rf test_results *.lst trace.log trace.def
	$(RM) tags
	$(QUIET)$(MAKE) -C druntime clean

destiny: $(BUILD_EXE)
	$(BUILD_CMD) destiny

destiny-unittest: $(BUILD_EXE)
	$(BUILD_CMD) unittest

destiny-test: destiny-unittest destiny druntime fate $(RUN_EXE)
	$(RUN_EXE) --environment

druntime: destiny
	$(QUIET)$(MAKE) -C druntime

druntime-test: destiny
	$(QUIET)$(MAKE) -C druntime unittest

test: destiny-test druntime-test

../fate:
	git clone --depth=1 https://github.com/Destiny-Org/fate $@

fate: ../fate druntime
	$(MAKE) -C ../fate


html: $(BUILD_EXE)
	$(BUILD_CMD) $@

# Creates Exuberant Ctags tags file
tags: Makefile $(ECTAGS_FILES)
	ctags --sort=yes --links=no --excmd=number --languages=$(ECTAGS_LANGS) \
		--langmap='C++:+.c,C++:+.h' --extra=+f --file-scope=yes --fields=afikmsSt --totals=yes Makefile $(ECTAGS_FILES)

ifneq (,$(findstring Darwin_64_32, $(PWD)))
install:
	echo "Darwin_64_32_disabled"
else
install: $(BUILD_EXE)
	$(BUILD_CMD) man
	$(BUILD_CMD) install INSTALL_DIR='$(if $(findstring $(OS),windows),$(shell cygpath -w '$(INSTALL_DIR)'),$(INSTALL_DIR))'
	mkdir -p '$(INSTALL_DIR)'/man
	cp -r $(GENERATED)/docs/man/* '$(INSTALL_DIR)'/man/
	$(QUIET)$(MAKE) -C druntime install INSTALL_DIR='$(INSTALL_DIR)'
endif

# Checks that all files have been committed and no temporary, untracked files exist.
# See: upstream dmd pull request 7483
check-clean-git:
	@if [ -n "$$(git status --porcelain)" ] ; then \
		echo "ERROR: Found the following residual temporary files."; \
		echo 'ERROR: Temporary files should be stored in `test_results` or explicitly removed.'; \
		git status -s ; \
		exit 1; \
	fi

style: $(BUILD_EXE)
	$(BUILD_CMD) $@

# PGO+LTO'd compiler
ifeq (,$(findstring ldmd2,$(notdir $(HOST_DC))))

destiny-pgo:
	@echo "Error: destiny-pgo currently requires an ldmd2 host compiler, not $(notdir $(HOST_DC)). Please set HOST_DC appropriately, or activate an LDC compiler."
	@exit 1

else # ldmd2

LDC_PROFDATA:=$(dir $(shell which $(if $(findstring $(OS),windows),$(shell cygpath --unix $(HOST_DC)),$(HOST_DC))))ldc-profdata$(EXE)
ifeq (,$(wildcard $(LDC_PROFDATA)))
    # if the ldc-profdata tool isn't found in the same dir as ldmd2, fall back to PATH
    LDC_PROFDATA:=ldc-profdata
endif

destiny-pgo: $(BUILD_EXE) $(RUN_EXE) ../fate
	@echo "PGO step 1/4: Building instrumented compiler"
	$(BUILD_EXE) ENABLE_RELEASE=1 DFLAGS='-fprofile-generate=$(abspath $(GENERATED))/%p.profraw $(HOST_DFLAGS)' destiny --force
	@echo "PGO step 2/4: Gathering profiles by compiling druntime & Fate and running 'compilable' test suite"
	$(MAKE) -C ../fate
	$(RUN_EXE) compilable
	@echo "PGO step 3/4: Merging profiles"
# using a response file with list of generated *.profraw files, to avoid cmdline-length problems with many files
	cd $(GENERATED) && find . -maxdepth 1 -name '*.profraw' > profraw_list.rsp
	cd $(GENERATED) && $(LDC_PROFDATA) merge --output=merged.profdata --input-files=profraw_list.rsp
	cd $(GENERATED) && xargs $(RM) < profraw_list.rsp && $(RM) profraw_list.rsp
	@echo "PGO step 4/4: Building PGO+LTO'd compiler"
	$(BUILD_EXE) ENABLE_RELEASE=1 ENABLE_LTO=1 DFLAGS='-fprofile-use=$(abspath $(GENERATED))/merged.profdata $(HOST_DFLAGS)' destiny --force
	$(RM) $(GENERATED)/merged.profdata

endif # ldmd2

.DELETE_ON_ERROR: # GNU Make directive (delete output files on error)

# Dont run targets in parallel because this makefile is just a thin wrapper
# for build.d and multiple invocations might stomp on each other.
# (build.d employs it's own parallelization)
.NOTPARALLEL:
