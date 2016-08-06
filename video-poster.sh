#!/usr/bin/env bash

# Set global variables
PROGNAME=$(basename "$0")
VERSION='1.0.0'

##
# Check for a dependancy
#
# @param 1 Command to check
##
dependancy() {
  hash "$1" &>/dev/null || error "$1 must be installed"
}

##
# Print help menu
#
# @param 1 exit code
##
function printHelpAndExit {
cat <<EOF
Usage:     $PROGNAME [options] input-file
Version:   $VERSION
Options: (all optional)
  -b value  Gaussian blur to apply to the image (in pixels)
  -f value  The frame (in seconds) to use as the poster image
  -o value  The output file
  -s value  Scale the output, e.g. 320x240
  -v        Print version
Example:
  $PROGNAME -b 8 -s 360x sample.mp4
EOF
exit $1
}

################################################################################

# Check dependacies
dependancy ffmpeg

# Initialize variables
blur=
frame=0
scale=

# Get options
while getopts "b:f:o:s:hv" opt; do
  case $opt in
    b) blur=$OPTARG;;
    f) frame=$OPTARG;;
    h) printHelpAndExit 0;;
    o) outfile=$OPTARG;;
    s) scale=$OPTARG;;
    v)
      echo "$VERSION"
      exit 0
      ;;
    *) printHelpAndExit 1;;
  esac
done

shift $(( OPTIND - 1 ))

infile="$1"
if [ -z "$outfile" ]; then
  outfile="$2"
fi

if [ -z "$outfile" ]; then
  # Strip off extension and add new extension
  ext="${infile##*.}"
  path=$(dirname "$infile")
  outfile="$path/$(basename "$infile" ".$ext")-poster.jpg"
fi

if [ -z "$infile" ]; then printHelpAndExit 1; fi

# Add scale filter
if [ $scale ]; then
  scale="-scale ${scale}"
fi

# Add blur filter
if [ $blur ]; then
  blur="-blur 0x${blur}"
fi

ffmpeg -loglevel panic -i "$infile" -vframes 1 -ss $frame -f image2pipe - | convert $scale $blur - "$outfile"
