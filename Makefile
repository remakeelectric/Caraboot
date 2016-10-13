export BUILD_TOPDIR=$(PWD)
export STAGING_DIR=$(BUILD_TOPDIR)/tmp
export TOPDIR=$(PWD)
export UBOOTDIR=$(TOPDIR)/u-boot

### Toolchain config ###
#buildroot
#CONFIG_TOOLCHAIN_PREFIX=/opt/build/toolchain-mipsbe-4.7.3/bin/mips-linux-

#openwrt NOT YET
CONFIG_TOOLCHAIN_PREFIX=mips-openwrt-linux-
# lede fail
#export PATH:=/home/karlp/src/lede-source/staging_dir/toolchain-mips_24kc_gcc-5.4.0_musl-1.1.15/bin:$(PATH)
export PATH:=/home/karlp/src/smartgate_firmware/openwrt-cc/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin:$(PATH)

########################

export CROSS_COMPILE=$(CONFIG_TOOLCHAIN_PREFIX)
export MAKECMD=make ARCH=mips

export UBOOT_GCC_4_3_3_EXTRA_CFLAGS=-fPIC
export BUILD_TYPE=squashfs

export COMPRESSED_UBOOT=0
export FLASH_SIZE=16
export NEW_DDR_TAP_CAL=1
export CONFIG_HORNET_XTAL=40
export CONFIG_HORNET_1_1_WAR=1
export CARABOOT_RELEASE=v2.6-dev
ifeq ($(BOARD_TYPE),lima)
	export ETH_CONFIG=_s27
endif

IMAGEPATH=$(BUILD_TOPDIR)/bin
UBOOT_BINARY=u-boot.bin
UBOOTFILE=$(BOARD_TYPE)_u-boot.bin

TARGETS=lima carambola2

all:
ifeq (,$(filter $(BOARD_TYPE), $(TARGETS)))
	@echo "Run 'make BOARD_TYPE=<target_name>'"
	@echo "Available targets: $(TARGETS)"
else
	cd $(UBOOTDIR) && $(MAKECMD) distclean
	cd $(UBOOTDIR) && $(MAKECMD) $(BOARD_TYPE)_config
	cd $(UBOOTDIR) && $(MAKECMD) all
	@echo Copy binaries to $(IMAGEPATH)/$(UBOOTFILE)
	mkdir -p $(IMAGEPATH)
	cp -f $(UBOOTDIR)/$(UBOOT_BINARY) $(IMAGEPATH)/$(UBOOTFILE)

	@echo Done
endif
	
clean:
	cd $(UBOOTDIR) && $(MAKECMD) distclean
