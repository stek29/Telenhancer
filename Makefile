PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Telenhancer
Telenhancer_FILES = \
										SharedSettings.mm\
										SettingsHook.xm\
										NeverExplicit.xm\
										InternalSettings.xm\
										TGAppDelegateInstance.mm\

include $(THEOS_MAKE_PATH)/tweak.mk


