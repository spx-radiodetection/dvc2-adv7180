# record git revision so that it is kept in the module during development purposes
GIT_REVISION ?= $(shell git describe --dirty --long --all --always 2> /dev/null)
export GIT_REVISION

# under YOCTO kernel is built in a different directory to the actual source
# a link is placed called source to redirect to the actual source code
ifneq ("$(wildcard $(KERNEL_SRC)/source)","")
PREFIX_SRC := /source
endif

# modules to build
obj-m := adv7180_tvin.o
SRC := $(shell pwd)

# to see pr_debug messages add -DDEBUG to CFLAGS lines below (turns them into printk)
# `dmesg -n 8` will let you see them

ccflags-y := -DGIT_REVISION=\"$(GIT_REVISION)\"
#ccflags-y := -DGIT_REVISION=\"$(GIT_REVISION)\" -DDEBUG

# adv7180_tvin.ko (built from adv7180.c)
adv7180_tvin-objs := adv7180.o
CFLAGS_adv7180.o := -I$(KERNEL_SRC)$(PREFIX_SRC)/drivers/media/platform/mxc/capture


all:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC)

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(SRC) modules_install

scripts:
	$(MAKE) -C $(KERNEL_SRC) scripts

clean:
	rm -f *.o *~ core .depend .*.cmd *.ko *.mod.c
	rm -f Module.markers Module.symvers modules.order
	rm -rf .tmp_versions Modules.symvers

