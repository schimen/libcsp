# If installing outside libcsp directory, please define LIBCSP_BUILD_DIR

# Default architecture
ARCH ?= x86
BUILD=build_$(ARCH)

PYTHON2 = python2

ROOT = $(abspath ..)

LIBCSP_DIR = $(ROOT)/libcsp

LIBCSP_CONFIG_COMMON =  --enable-crc32  --enable-if-can --enable-can-socketcan=socketcan --with-os=posix --with-padding=0 --install-csp --with-connection-so=64

ifeq ($(ARCH),arm) # ARM toolchain
	LIBCSP_CONFIG_PLATFORM =  --toolchain=arm-linux-gnueabihf-
endif

# Allow a custom build dir to be specified,
# along with extra configuration options LIBCSP_CONFIG_EXTRA
ifeq ($(LIBCSP_BUILD_DIR),)
	LIBCSP_CONFIG_BUILD =  --out=$(LIBCSP_DIR)/build_$(ARCH) --prefix=$(LIBCSP_DIR)/build_$(ARCH)
	LIBCSP_BUILD_DIR = $(BUILD)
else
	LIBCSP_CONFIG_BUILD =  --out=$(LIBCSP_BUILD_DIR) --prefix=$(LIBCSP_BUILD_DIR)
endif

LIBCSP_CONFIG_FULL = $(LIBCSP_CONFIG_COMMON) $(LIBCSP_CONFIG_PLATFORM) $(LIBCSP_CONFIG_BUILD) $(LIBCSP_CONFIG_EXTRA)

all:$(LIBCSP_BUILD_DIR)/libcsp.a

%/libcsp.a: $(shell find src -type f) $(shell find include -type f)
	cd $(LIBCSP_DIR) && \
	$(PYTHON2) waf configure --jobs=$(shell nproc) $(LIBCSP_CONFIG_FULL) build install

clean:
	cd $(LIBCSP_DIR) && \
	$(PYTHON2) waf configure $(LIBCSP_CONFIG) clean
