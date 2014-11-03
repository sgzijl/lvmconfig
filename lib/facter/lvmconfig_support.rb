# lvmconfig_support.rb
#
# This fact provides LVM volumes that are available and/or
# accessible on Linux systems.
#
Facter.add("lvm_support") do
  confine :kernel => :linux
  vgdisplay =  Facter::Util::Resolution.exec('which vgs')
  if $?.exitstatus
    vgs = %x[vgs -o name,size --units m --noheadings 2> /dev/null]
    setcode { 'yes'}
    if vgs.length > 0
      vg_num = 0
      # gives all Volume Groups
      vgs.each_line do |vg|
        vg.strip!
        Facter.add("lvm_vg_#{vg.split[0]}") { setcode { vg.split[1].gsub(/.00[m|M]/, "M") } }
        vg_num += 1
      end
      Facter.add("lvm_vgs") { setcode { vg_num } }
      # logical volumes
      lvs = %x[lvs -o name,size,vg_name --units m --noheadings 2> /dev/null]
        lv_num = 0
        # gives all Volume Groups
        lvs.each_line do |lv|
          Facter.add("lvm_lv_#{lv.split[2]}_#{lv.split[0]}") { setcode { lv.split[1].gsub(/.00[m|M]/, "M")}}
          lv_num += 1
        end
      Facter.add("lvm_lvs") { setcode { lv_num } }
      # gives all Physical Volumes
      pvs = %x[pvs -o name --noheadings 2> /dev/null]
      pv_num = 0
      pvs.each_line do |pv|
        pv.strip!
        Facter.add("lvm_pv_#{pv_num}") { setcode { pv } }
        pv_num += 1
      end
      Facter.add("lvm_pvs") { setcode { pv_num } }
    else
      Facter.add("lvm_vgs") { setcode { 0 } }
      Facter.add("lvm_pvs") { setcode { %x[pvs -o name --noheadings 2> /dev/null].length } }
    end
  else
    setcode { 'no' }
  end
end
