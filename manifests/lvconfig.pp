# Create Logical Volume, Filesystem & Mountpoint
define lvmconfig::lvconfig ( $vg, $fs, $mnt_point, $size, $mnt_opts ) {

  # Readability
  $lv = $name

  # Do nothing if size is not defined in Megabytes
  if $size =~ /^\d+M$/ {
    logical_volume { $lv :
      ensure       => present,
      volume_group => $vg,
      size         => $size,
      require      => Volume_Group[$vg],
    }
    filesystem { "/dev/mapper/${vg}-${lv}":
      ensure  => present,
      fs_type => $fs,
      require => Logical_volume[$lv],
    }
    mount { $mnt_point :
      ensure  => 'mounted',
      atboot  => true,
      device  => "/dev/mapper/${vg}-${lv}",
      name    => $mnt_point,
      fstype  => $fs,
      options => $mnt_opts,
      dump    => '1',
      pass    => '2',
      require => [
        Filesystem["/dev/mapper/${vg}-${lv}"],
        Exec[$mnt_point],
      ],
    }
    # This is ugly, but make sure parent directories exist
    exec { $mnt_point :
      path    => '/bin',
      command => "mkdir -p ${mnt_point}",
      creates => $mnt_point,
    }
  } else {
    fail("Define size in megabytes, eg: 1024M (LV ${lv} has ${size})")
  }

}
