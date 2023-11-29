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

chmod +x /bin/dpkg*
chmod +x /bin/apt*
apt-get update
apt-get install nala -y
nala install build-essential dkms devscripts libelf-dev inxi usbutils -y

cp -r ${DRV_DIR} /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION} --force
dkms install -m ${DRV_NAME} -v ${DRV_VERSION} --force
RESULT=$?

echo "Finished running dkms install steps."

echo "Copy the dedicated udev rules file..."
install --group=root --owner=root --mode=0644 ./udev/rules.d/50-usb-realtek-net.rules /lib/udev/rules.d/
depmod -a

echo "Restarting udev..."
udevadm control --reload-rules

modinfo r8152

echo "Finished."

exit $RESULT
