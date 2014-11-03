# LVM config module #

This module gets LVM/mount/filesystem details from hiera and uses puppetlabs-lvm to setup LVM, filesystems and mount points.

Provides useful facts about LVM and mount point usage too.

Depends on:

 * puppetlabs/lvm
 * puppetlabs/stdlib
 * hiera

## Usage ##

    include lvmconfig

### Example input ###

See example directory

NB: define LV sizes in Megabytes.

## Supported Platforms ##

Tested on Red Hat EL5/EL6/EL7'ish with filesystems ext2, ext3, ext4 & xfs.

Offline resizing works for ext[34]. Online resizing works on ext[34] and xfs (xfs_growfs only works on mounted filesystems).

