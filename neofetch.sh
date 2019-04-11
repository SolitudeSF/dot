print_info() {
    prin
    info title
    prin
    info OS distro
    info Host model
    info Kernel kernel
    info Uptime uptime
    info Packages packages
    info Shell shell
    info Resolution resolution
    info DE de
    info WM wm
    info Theme theme
    info Icons icons
    info Terminal term
    info 'Terminal Font' term_font
    info CPU cpu
    info GPU gpu
    info Memory memory
    prin
    info Song song
    info cols
}

kernel_shorthand=on
# on off tiny
distro_shorthand=off
os_arch=on
# on off tiny
uptime_shorthand=off
# on off tiny
package_managers=on
shell_path=off
shell_version=on

# scaling_cur_freq scaling_min_freq scaling_max_freq bios_limit.
speed_type=bios_limit
speed_shorthand=on
cpu_brand=on
cpu_speed=on
# logical physical off
cpu_cores=logical
# C F off
cpu_temp=off

gpu_brand=on
# all dedicated integrated
gpu_type=all
refresh_rate=off

gtk_shorthand=on
gtk2=on
gtk3=on

music_player=mpd
song_format="%artist% - %album% - %title%"
song_shorthand=on
mpc_args=()

colors=(distro)
bold=on
underline_enabled=on
underline_char=-
block_range=(0 15)
color_blocks=on
block_width=3
block_height=1

ascii_distro=auto
ascii_colors=(distro)
ascii_bold=on

image_backend=kitty
image_source=$(getmpdalbumart)
[ -z "$image_source" ] && image_source=$(randfile "$(xdg-user-dir PICTURES)/anzu")
image_loop=off
thumbnail_dir="${XDG_CACHE_HOME:-$HOME/.cache}/thumbnails/neofetch"
# none fit fill *
crop_mode=fill
# northwest north northeast west center
# east southwest south southeast
crop_offset=center
# auto 00px 00% none
image_size=auto
gap=6
yoffset=1
xoffset=3
