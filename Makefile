THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

TWEAK_NAME = PullToPong
PullToPong_FILES = Tweak.xm BOZPongRefreshControl.m
PullToPong_FRAMEWORKS = UIKit QuartzCore
PullToPong_PRIVATE_FRAMEWORKS = CoreGraphics
PullToPong_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-after-install::
	install.exec "killall -9 backboardd"