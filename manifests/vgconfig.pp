# Setup LVM VolumeGroup
define lvmconfig::vgconfig ( $pvs ) {

  # Readability
  $vg = $name

  physical_volume { $pvs :
      ensure => present,
  }

  volume_group { $vg :
    ensure           => present,
    physical_volumes => $pvs,
  }

}
