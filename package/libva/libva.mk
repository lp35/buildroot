################################################################################
#
# libva
#
################################################################################

ifeq ($(BR2_PACKAGE_LIBVA_INTEL_QSV),y)
LIBVA_VERSION = d6fd111e2062bb4732db8a05ed55fc01771087b4
LIBVA_SITE = git://github.com/intel/libva.git
LIBVA_SITEMETHOD = git
else
LIBVA_VERSION = 2.0.0
LIBVA_SOURCE = libva-$(LIBVA_VERSION).tar.bz2
LIBVA_SITE = https://github.com/01org/libva/releases/download/$(LIBVA_VERSION)
endif

LIBVA_LICENSE = MIT
LIBVA_LICENSE_FILES = COPYING
LIBVA_INSTALL_STAGING = YES
LIBVA_DEPENDENCIES = host-pkgconf libdrm

ifeq ($(BR2_PACKAGE_LIBVA_INTEL_QSV),y)
define LIBVA_PRE_CONFIGURE_FIXM4
	# Fix for m4 directory creation.
	mkdir -p $(@D)/m4
endef

LIBVA_PRE_CONFIGURE_HOOKS += LIBVA_PRE_CONFIGURE_FIXM4
LIBVA_AUTORECONF = YES
endif


# libdrm is a hard-dependency
LIBVA_CONF_OPTS = \
	--enable-drm \
	--with-drivers-path="/usr/lib/va"

ifeq ($(BR2_PACKAGE_XORG7),y)
LIBVA_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXfixes
LIBVA_CONF_OPTS += --enable-x11
ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
LIBVA_DEPENDENCIES += mesa3d
LIBVA_CONF_OPTS += --enable-glx
endif
else
LIBVA_CONF_OPTS += --disable-glx --disable-x11
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBVA_DEPENDENCIES += wayland
LIBVA_CONF_OPTS += --enable-wayland
else
LIBVA_CONF_OPTS += --disable-wayland
endif

$(eval $(autotools-package))
