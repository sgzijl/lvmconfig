# lvmconfig_mounts.rb
#
# Provide information about mount/partition usage
mounts = [ ]
mntpoints=`mount -t ext2,ext3,ext4,reiserfs,xfs`
mntpoints.split(/\n/).each do |m|
  mount = m.split(/ /)[2]
  mounts << mount
end

Facter.add("mounts") do
  confine :kernel => :linux

  setcode do
    mounts.join(',')
  end
end

mounts.each do |mount|
  # POXIX readable format: avoid linebreaks
  output = %x{df -P -m #{mount}}
  output.each_line do |str|
    dsk_size = nil
    dsk_used = nil
    dsk_avail = nil
    if str =~ /^\S+\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+/
      dsk_size = $1
      dsk_used = $2
      dsk_avail = $3
      Facter.add("mount_size_#{mount}") do
        setcode do
          dsk_size
        end
      end
      Facter.add("mount_used_#{mount}") do
        setcode do
          dsk_used
        end
      end
      Facter.add("mount_avail_#{mount}") do
        setcode do
          dsk_avail
        end
      end
    end
  end
end
