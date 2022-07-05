###############################################################################
#
# lora-gateway
#
###############################################################################

LORA_GATEWAY_VERSION = v5.0.1
LORA_GATEWAY_SITE = https://github.com/lora-net/lora_gateway.git
LORA_GATEWAY_SITE_METHOD = git
LORA_GATEWAY_LICENSE = Semtech S.A.
LORA_GATEWAY_LICENSE_FILES = LICENSE
LORA_GATEWAY_INSTALL_STAGING = YES
LORA_GATEWAY_INSTALL_TARGET = YES

define LORA_GATEWAY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) all
endef

define LORA_GATEWAY_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libloragw/libloragw.a $(STAGING_DIR)/usr/lib/libloragw/libloragw.a
	$(INSTALL) -D -m 0644 $(@D)/libloragw/library.cfg $(STAGING_DIR)/usr/lib/libloragw/library.cfg
	$(foreach f,$(notdir $(wildcard $(@D)/libloragw/inc/*)),
	$(INSTALL) -D -m 0644 $(@D)/libloragw/inc/$(f) $(STAGING_DIR)/usr/lib/libloragw/inc/$(f)
    	#$(INSTALL) -m 0644 -D $(@D)/libloragw/inc/$(f) $(STAGING_DIR)/usr/lib/libloragw/inc)
endef

define LORA_GATEWAY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/reset_lgw.sh $(TARGET_DIR)/opt/lora_gateway/reset_lgw.sh
endef

$(eval $(generic-package))
