################################################################################
#
# erlang
#
################################################################################

# See note below when updating Erlang
ERLANG_21_0_VERSION = 21.0
ERLANG_21_0_SITE = http://www.erlang.org/download
ERLANG_21_0_SOURCE = otp_src_$(ERLANG_21_0_VERSION).tar.gz
ERLANG_21_0_DEPENDENCIES = host-erlang

ERLANG_21_0_LICENSE = Apache-2.0
ERLANG_21_0_LICENSE_FILES = LICENSE.txt
ERLANG_21_0_INSTALL_STAGING = YES

# Patched erts/aclocal.m4
ERLANG_21_0_AUTORECONF = YES

# Whenever updating Erlang, this value should be updated as well, to the
# value of EI_VSN in the file lib/erl_interface/vsn.mk
ERLANG_21_0_EI_VSN = 3.10.3

# The configure checks for these functions fail incorrectly
ERLANG_21_0_CONF_ENV = ac_cv_func_isnan=yes ac_cv_func_isinf=yes

# Set erl_xcomp variables. See xcomp/erl-xcomp.conf.template
# for documentation.
ERLANG_21_0_CONF_ENV += erl_xcomp_sysroot=$(STAGING_DIR)

ERLANG_21_0_CONF_OPTS = --without-javac

# Force ERL_TOP to the downloaded source directory. This prevents
# Erlang's configure script from inadvertantly using files from
# a version of Erlang installed on the host.
ERLANG_21_0_CONF_ENV += ERL_TOP=$(@D)
HOST_ERLANG_CONF_ENV += ERL_TOP=$(@D)

# erlang uses openssl for all things crypto. Since the host tools (such as
# rebar) uses crypto, we need to build host-erlang with support for openssl.
HOST_ERLANG_DEPENDENCIES = host-openssl
HOST_ERLANG_CONF_OPTS = --without-javac --with-ssl=$(HOST_DIR)

HOST_ERLANG_CONF_OPTS += --without-termcap

ifeq ($(BR2_PACKAGE_NCURSES),y)
ERLANG_21_0_CONF_OPTS += --with-termcap
ERLANG_21_0_DEPENDENCIES += ncurses
else
ERLANG_21_0_CONF_OPTS += --without-termcap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
ERLANG_21_0_CONF_OPTS += --with-ssl
ERLANG_21_0_DEPENDENCIES += openssl
else
ERLANG_21_0_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_UNIXODBC),y)
ERLANG_21_0_DEPENDENCIES += unixodbc
ERLANG_21_0_CONF_OPTS += --with-odbc
else
ERLANG_21_0_CONF_OPTS += --without-odbc
endif

# Always use Buildroot's zlib
ERLANG_21_0_CONF_OPTS += --enable-shared-zlib
ERLANG_21_0_DEPENDENCIES += zlib

# Remove source, example, gs and wx files from staging and target.
ERLANG_21_0_REMOVE_PACKAGES = gs wx

ifneq ($(BR2_PACKAGE_ERLANG_21_0_MEGACO),y)
ERLANG_21_0_REMOVE_PACKAGES += megaco
endif

define ERLANG_21_0_REMOVE_STAGING_UNUSED
	for package in $(ERLANG_REMOVE_PACKAGES); do \
		rm -rf $(STAGING_DIR)/usr/lib/erlang/lib/$${package}-*; \
	done
endef

define ERLANG_21_0_REMOVE_TARGET_UNUSED
	find $(TARGET_DIR)/usr/lib/erlang -type d -name src -prune -exec rm -rf {} \;
	find $(TARGET_DIR)/usr/lib/erlang -type d -name examples -prune -exec rm -rf {} \;
	for package in $(ERLANG_REMOVE_PACKAGES); do \
		rm -rf $(TARGET_DIR)/usr/lib/erlang/lib/$${package}-*; \
	done
endef

ERLANG_21_0_POST_INSTALL_STAGING_HOOKS += ERLANG_21_0_REMOVE_STAGING_UNUSED
ERLANG_21_0_POST_INSTALL_TARGET_HOOKS += ERLANG_21_0_REMOVE_TARGET_UNUSED

$(eval $(autotools-package))
$(eval $(host-autotools-package))
