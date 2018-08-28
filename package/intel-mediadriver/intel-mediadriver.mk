################################################################################
#
# intel-mediadriver
#
################################################################################

INTEL_MEDIADRIVER_VERSION = ab264dd51f20ea83d6c40a886fb685ce372c47ba
INTEL_MEDIADRIVER_SITE = git://github.com/intel/media-driver.git
INTEL_MEDIADRIVER_LICENSE = MIT BSD-3-Clause
INTEL_MEDIADRIVER_LICENSE_FILES = LICENSE.md

INTEL_MEDIADRIVER_DEPENDENCIES += intel-gmmlib
INTEL_MEDIADRIVER_DEPENDENCIES += libva
INTEL_MEDIADRIVER_DEPENDENCIES += libva-utils
INTEL_MEDIADRIVER_DEPENDENCIES += libpciaccess

# based on https://software.intel.com/en-us/articles/build-and-debug-open-source-media-stack

INTEL_MEDIADRIVER_SUBDIR = media_driver
INTEL_MEDIADRIVER_SUPPORTS_IN_SOURCE_BUILD = NO

INTEL_MEDIADRIVER_CONF_OPTS += -DMEDIA_VERSION="2.0.0"\
	-DBUILD_ALONG_WITH_CMRTLIB=1 \
	-DBS_DIR_GMMLIB=$(INTEL_GMMLIB_DIR)/Source/GmmLib/ \
	-DBS_DIR_COMMON=$(INTEL_GMMLIB_DIR)/Source/Common/ \
	-DBS_DIR_INC=$(INTEL_GMMLIB_DIR)/Source/inc/ \
	-DBS_DIR_MEDIA=$(@D) \
	-DINSTALL_DRIVERS_SYSCONF=OFF \
	-DLIBVA_DRIVERS_PATH=$(STAGING_DIR)/lib/dri

define INTEL_MEDIADRIVER_INSTALL_TARGET_CMDS
	cp "$(INTEL_MEDIADRIVER_BUILDDIR)/iHD_drv_video.so" "$(TARGET_DIR)/lib/dri"
endef

$(eval $(cmake-package))
