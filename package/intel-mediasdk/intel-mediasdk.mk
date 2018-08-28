################################################################################
#
# intel-mediasdk
#
################################################################################

# Resources for building the MediaSDK:
# - https://github.com/Intel-Media-SDK/MediaSDK/releases/tag/MediaSDK-2018-Q2.2
# - https://software.intel.com/en-us/articles/build-and-debug-open-source-media-stack

INTEL_MEDIASDK_VERSION = MediaSDK-2018-Q2.1
INTEL_MEDIASDK_SITE = https://github.com/Intel-Media-SDK/MediaSDK.git
INTEL_MEDIASDK_SITE_METHOD = git
INTEL_MEDIASDK_LICENSE = MIT
INTEL_MEDIASDK_LICENSE_FILES = COPYING

INTEL_MEDIASDK_INSTALL_STAGING = YES
INTEL_MEDIASDK_INSTALL_TARGET = YES

INTEL_MEDIASDK_DEPENDENCIES += intel-mediadriver
INTEL_MEDIASDK_DEPENDENCIES += libdrm

define INTEL_MEDIASDK_PRE_CONFIGURE_FIXUP
	# We need to copy MFX headers into staging dir due to a bug into FindMFX.cmake.
	cp $(@D)/api/include/* $(STAGING_DIR)/usr/include
endef

define INTEL_MEDIASDK_POST_INSTALL_STAGING_HEADERFIX
	# Some programs need to have the MFX headers under usr/include/mfx folder (like FFMpeg).
	mkdir -p $(STAGING_DIR)/usr/include/mfx
	cp $(STAGING_DIR)/usr/include/mfx*.h $(STAGING_DIR)/usr/include/mfx/
endef

define INTEL_MEDIASDK_INSTALL_TARGET_CMDS
    # Copy runtimes.
    cp ${STAGING_DIR}/usr/lib/libmfxhw64-p.so.1.26 $(TARGET_DIR)/lib

	# Create a link so all application will be able to execute mfx code.
	ln -sf libmfxhw64-p.so.1.26 $(TARGET_DIR)/lib/libmfxhw64.so

	# Copy plugins.
	cp -r ${STAGING_DIR}/usr/plugins $(TARGET_DIR)/usr

	# Copy sample program.
	cp -r ${STAGING_DIR}/usr/samples $(TARGET_DIR)/usr

	# Set environment configuration.
	mkdir -p $(TARGET_DIR)/etc/profile.d
	cp package/intel-mediasdk/intel-mediasdk.sh $(TARGET_DIR)/etc/profile.d/
endef

INTEL_MEDIASDK_PRE_CONFIGURE_HOOKS += INTEL_MEDIASDK_PRE_CONFIGURE_FIXUP
INTEL_MEDIASDK_POST_INSTALL_STAGING_HOOKS += INTEL_MEDIASDK_POST_INSTALL_STAGING_HEADERFIX

$(eval $(cmake-package))
