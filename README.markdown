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

Tested on Red Hat EL5 & EL6 with filesystems ext2, ext3, ext4 & xfs.

NB: online resizing works for ext3 and ext4 (see: puppetlabs-lvm)
