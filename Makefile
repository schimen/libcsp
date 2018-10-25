# If installing outside libcsp directory, please define LIBCSP_INSTALL_DIR

ifeq ($(ARCH),)
	ARCH=x86
endif
PYTHON2=python2
ROOT=..

LIBCSP_DIR=$(ROOT)/libcsp

LIBCSP_CONFIG_COMMON= --enable-crc32  --enable-if-can --enable-can-socketcan=socketcan --with-os=posix --install-csp --with-padding=0 --out=$(LIBCSP_DIR)/build_$(ARCH)

ifeq ($(ARCH),arm) # ARM toolchain
	LIBCSP_CONFIG_PLATFORM= --toolchain=arm-linux-gnueabihf-
endif

ifeq ($(LIBCSP_INSTALL_DIR),)
	LIBCSP_CONFIG_INSTALL= --prefix=$(LIBCSP_DIR)/install_$(ARCH) # Default
else
	LIBCSP_CONFIG_INSTALL= --prefix=$(LIBCSP_INSTALL_DIR)
endif

LIBCSP_CONFIG_FULL=$(LIBCSP_CONFIG_COMMON) $(LIBCSP_CONFIG_PLATFORM) $(LIBCSP_CONFIG_INSTALL) $(LIBCSP_CONFIG_EXTRA)

.PHONY: csp_$(ARCH)
csp_$(ARCH): $(LIBCSP_DIR)/install_$(ARCH)/lib/libcsp.a

%/libcsp.a: $(shell find src -type f) $(shell find include -type f)
	cd $(LIBCSP_DIR) && \
	$(PYTHON2) waf configure --jobs=$(shell nproc) $(LIBCSP_CONFIG_FULL) build install

clean:
	cd $(LIBCSP_DIR) && \
	$(PYTHON2) waf configure $(LIBCSP_CONFIG) clean
	cd $(LIBCSP_DIR) && \
	rm install_arm install_$(ARCH) -rf
