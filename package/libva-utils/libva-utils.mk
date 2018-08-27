################################################################################
#
# libva-utils
#
################################################################################

ifeq ($(BR2_PACKAGE_LIBVA_INTEL_QSV),y)
LIBVA_UTILS_VERSION = 8a6ef9ed905c0d9d5463c17c76609dba5dfb9c15
LIBVA_UTILS_SITE = git://github.com/intel/libva-utils.git
else
LIBVA_UTILS_VERSION = 2.0.0
LIBVA_UTILS_SOURCE = libva-utils-$(LIBVA_UTILS_VERSION).tar.bz2
LIBVA_UTILS_SITE = https://github.com/01org/libva-utils/releases/download/$(LIBVA_UTILS_VERSION)
endif

LIBVA_UTILS_LICENSE = MIT
LIBVA_UTILS_LICENSE_FILES = COPYING
LIBVA_UTILS_DEPENDENCIES = host-pkgconf libva


ifeq ($(BR2_PACKAGE_LIBVA_INTEL_QSV),y)
define LIBVA_UTILS_PRE_CONFIGURE_FIXM4
	# Fix for m4 directory creation.
	mkdir -p $(@D)/m4
endef
LIBVA_UTILS_PRE_CONFIGURE_HOOKS += LIBVA_UTILS_PRE_CONFIGURE_FIXM4
LIBVA_UTILS_AUTORECONF = YES
endif

$(eval $(autotools-package))
