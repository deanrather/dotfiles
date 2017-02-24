#!/bin/bash
# http://unix.stackexchange.com/questions/113695/gif-screencasting-the-unix-way

# https://github.com/lolilolicon/FFcast
if ! which ffcast >> /dev/null
then
  echo "Installing ffcast"
  tmpdir="$(mktemp -d)"
  git clone --recursive https://github.com/lolilolicon/FFcast.git "$tmpdir"
  cd $tmpdir
  ./bootstrap  # generates ./configure
  ./configure --prefix /usr --libexecdir /usr/lib --sysconfdir /etc
  make
  sudo make DESTDIR="$dir" install  # $dir must be an absolute path
fi

# Install xclip
which xclip  >> /dev/null || sudo apt-get install -y xclip

# Get output file path
output_dir=~/Pictures
mkdir -p "$output_dir"
default_filename="recording__$(date +%Y-%m-%d_%H-%M-%S)"
read -p "Filename [$default_filename].gif: " filename
test "$filename" || filename="$default_filename"
output_file_path="$output_dir/$filename".gif

echo "default_filename: $default_filename"
echo "filename: $filename"
echo "output_file_path: $output_file_path"

# Display instructions
echo -en "\n\n\tSelect area to begin recording\n\tTo stop, highlight this window and press: q\n\n"


TMP_AVI=$(mktemp /tmp/outXXXXXXXXXX.avi)
ffcast -s % ffmpeg -y -f x11grab -show_region 1 -framerate 15 \
    -video_size %s -i %D+%c -codec:v huffyuv                  \
    -vf crop="iw-mod(iw\\,2):ih-mod(ih\\,2)" $TMP_AVI         \
&& convert -set delay 10 -layers Optimize $TMP_AVI $output_file_path

echo -n "Gif recorded to $output_file_path"

# Copy path to clipboard
echo -n "$output_file_path" | xclip -selection clipboard
echo " and path copied to clipboard"
