PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Telenhancer
Telenhancer_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

