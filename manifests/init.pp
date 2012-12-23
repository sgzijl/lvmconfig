# Class: lvmconfig
#
# This module manages LVM volumes, filesystems and mount points on
# Linux systems and provide useful facts about them.
#
# Parameters: hiera (see: hiera_example.yaml)
#
# Actions: setup LVM
#
# Requires: puppetlabs-lvm, puppetlabs-stdlib
#
# Sample Usage: add LVM data to hiera (see hiera_examples dir) and
# include lvmconfig
#
# [Remember: No empty lines between comments and class definition]
class lvmconfig {

  include stdlib

  # Volume Group Layout
  $vg_layout = hiera('vg_layout', {})
  validate_hash($vg_layout)
  create_resources('lvmconfig::vgconfig',$vg_layout)

  # Logical Volume Layout
  $lv_layout = hiera('lv_layout', {})
  validate_hash($lv_layout)
  create_resources('lvmconfig::lvconfig',$lv_layout)

}
