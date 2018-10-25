
PYTHON2=python2
ROOT_DIR=$(shell pwd)

# CSP
LIBCSP_DIR=$(ROOT_DIR)/libcsp
LIBCSP_BUILD_DIR=$(ROOT_DIR)/libcsp/build
LIBCSP_INSTALL_DIR=$(ROOT_DIR)/libcsp/install

LIBCSP_CONFIG_COMMON= --enable-crc32  --enable-if-can --enable-can-socketcan=socketcan --with-os=posix --install-csp --with-padding=0 --with-max-bind-port=63
ifeq ($(ARCH),x86)
	LIBCSP_CONFIG=$(LIBCSP_CONFIG_COMMON) --prefix=$(LIBCSP_INSTALL_DIR)_x86 --out=$(LIBCSP_BUILD_DIR)_x86
endif
ifeq ($(ARCH),arm)
	LIBCSP_CONFIG=$(LIBCSP_CONFIG_COMMON) --toolchain=arm-linux-gnueabihf- --includes=$(LIBCSP_ARM_I) --prefix=$(LIBCSP_INSTALL_DIR)_arm --out=$(LIBCSP_BUILD_DIR)_arm
endif

.PHONY: csp
csp_$(ARCH): $(LIBCSP_DIR)/install_$(ARCH)/lib/libcsp.a

$(LIBCSP_DIR)/install_$(ARCH)/lib/libcsp.a:
	cd $(LIBCSP_DIR) && \
	$(PYTHON2) waf configure --jobs=$(shell nproc) $(LIBCSP_CONFIG)  build install

.PHONY: csp_clean
csp_clean:
	cd $(LIBCSP_DIR) && \
	$(PYTHON2) waf configure $(LIBCSP_CONFIG) clean
	cd $(LIBCSP_DIR) && \
	rm install_arm install_$(ARCH) -rf
