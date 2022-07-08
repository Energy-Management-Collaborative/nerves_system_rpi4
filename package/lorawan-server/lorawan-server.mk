###############################################################################
#
# lorawan-server
#
###############################################################################

LORAWAN_SERVER_VERSION = e6fdccfd3f1cb5e55bbe23fdc975cd2dac5ea6ea
LORAWAN_SERVER_SITE = https://github.com/gotthardp/lorawan-server.git
LORAWAN_SERVER_SITE_METHOD = git
LORAWAN_SERVER_LICENSE = MIT
LORAWAN_SERVER_LICENSE_FILES = LICENSE
LORAWAN_SERVER_DEPENDENCIES = erlang-21.0
LORAWAN_SERVER_INSTALL_STAGING = NO
LORAWAN_SERVER_INSTALL_TARGET = YES

define LORAWAN_SERVER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) upgrade
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) build
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) release
endef

define LORAWAN_SERVER_INSTALL_TARGET_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
