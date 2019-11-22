TOP = ../../extensions/master
include $(TOP)/configure/CONFIG
ACTIONS += uninstall distclean

# list directories that need building
DIRS =

include $(TOP)/configure/RULES_DIRS
