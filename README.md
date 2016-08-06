# video-poster

video-poster is a shell script that quickly create poster images for the HTML video element.

## Installation

Download the [`video-poster` script](https://raw.githubusercontent.com/joeyhoer/video-poster/master/video-poster.sh) and make it available in your `PATH`.

    curl -o /usr/local/bin/video-poster -O https://raw.githubusercontent.com/joeyhoer/video-poster/master/video-poster.sh && \
    chmod +x /usr/local/bin/video-poster

## Dependencies

This script relies on `ffmpeg` and `imagemagick`:

    brew install ffmpeg imagemagick
