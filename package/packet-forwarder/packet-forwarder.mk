###############################################################################
#
# packet-forwarder
#
###############################################################################

PACKET_FORWARDER_VERSION = v4.0.1
PACKET_FORWARDER_SITE = https://github.com/lora-net/packet_forwarder.git
PACKET_FORWARDER_SITE_METHOD = git
PACKET_FORWARDER_LICENSE = Semtech S.A.
PACKET_FORWARDER_LICENSE_FILES = LICENSE
PACKET_FORWARDER_INSTALL_STAGING = NO
PACKET_FORWARDER_INSTALL_TARGET = YES
PACKET_FORWARDER_DEPENDENCIES += lora-gateway

define PACKET_FORWARDER_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" LGW_PATH="$(STAGING_DIR)/usr/lib/libloragw" -C $(@D) all
endef

define PACKET_FORWARDER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(PACKET_FORWARDER_PKGDIR)/global_conf.json $(TARGET_DIR)/etc/packet_forwarder/global_conf.json
	$(INSTALL) -D -m 0755 $(@D)/lora_pkt_fwd/update_gwid.sh $(TARGET_DIR)/opt/packet_forwarder/update_gwid.sh
	$(INSTALL) -D -m 0755 $(@D)/lora_pkt_fwd/lora_pkt_fwd $(TARGET_DIR)/opt/packet_forwarder/lora_pkt_fwd
endef

$(eval $(generic-package))
