#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-install.sh\"" 2>&1
  exit 1
else
  echo "About to run dkms install steps..."
fi

DRV_DIR="$(pwd)"
DRV_NAME=r8152
DRV_VERSION=2.17.1
RULEDIR=/lib/udev/rules.d/
RULEFILE=udev/rules.d/50-usb-realtek-net.rules

cp -r ${DRV_DIR} /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
dkms install -m ${DRV_NAME} -v ${DRV_VERSION} --force
RESULT=$?

echo "Finished running dkms install steps."

echo "Copy the dedicated udev rules file..."
install --group=root --owner=root --mode=0644 $(RULEFILE) $(RULEDIR)
depmod -a

echo "Restarting udev..."
udevadm control --reload-rules

modinfo r8152
modprobe r8152
depmod -a
update-initramfs -u

echo "Finished."

exit $RESULT
