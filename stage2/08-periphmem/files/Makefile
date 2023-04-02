
ifneq ($(KERNELRELEASE),)

obj-m += periphmem.o

else

KERNEL_DIR ?= "/lib/modules/$(shell uname -r)/build"

all:
	$(MAKE) -C "$(KERNEL_DIR)" M="$(CURDIR)" modules

install:
	$(MAKE) -C "$(KERNEL_DIR)" M="$(CURDIR)" modules_install
	depmod -A

clean:
	$(MAKE) -C "$(KERNEL_DIR)" M="$(CURDIR)" clean

endif