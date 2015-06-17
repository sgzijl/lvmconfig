# Create Logical Volume, Filesystem & Mountpoint
define lvmconfig::lvconfig ( $vg, $fs, $mnt_point, $size, $mnt_opts ) {

  # Readability
  $lv = $name

  # Make sure the size argument is valid for lvcreate
  if $size =~ /^\d+[bBsSkKmMgGtTpPeE]?$/ {
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
    fail("Define size in megabytes, eg: 1024 or specify a valid suffix [BSKMGTPE] - (LV ${lv} has ${size})")
  }

}
