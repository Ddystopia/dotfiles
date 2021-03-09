#!/bin/bash
# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Success. Display stdout as preview
# 1    | no preview | Failure. Display no preview at all
# 2    | plain text | Display the plain content of the file
# 3    | fix width  | Success. Don't reload when width changes
# 4    | fix height | Success. Don't reload when height changes
# 5    | fix both   | Success. Don't ever reload
# 6    | image      | Success. Display the image $cache points to as an image preview
# 7    | image      | Display the file directly as an image

path=$1  width=$2
cache=$4 image=${5/False}

ext=${path##*.}
mime=$(file -Lb --mime-type "$path")

mkdir -p ${cache%/*}

mediainfo(){
    command mediainfo "$@" | sed 's/\s*:\s*/| /' | column -ts \| -o :
}

################################################################################

case $path in
    */Mail/*) frm -Sq "$path" | fmt -w $width && exit 5;;
esac

################################################################################

[[ $image ]] && case ${ext,,} in
    ttf|otf|bmp|svg) convert "$path" $cache && exit 6;;

      xcf) xcf2png  "$path" -o $cache && exit 6;;
      kra) unzip -p "$path" preview.png > $cache && exit 6;;
    blend) blender-thumbnailer.py "$path" $cache && exit 6;;

    swf) gnash-thumbnailer "$path"  $cache 512 && exit 6;;
    pdf) pdftoppm -singlefile -jpeg "$path" > $cache && exit 6;;
esac

case ${ext,,} in
     odt) odt2txt "$path" && exit 5;;
    json) jq -C . "$path" && exit 5;;
    mbox) frm -Sn "$path" | tac && exit 5;;
     svg) highlight -O ansi "$path" && exit 5; exit 2;;
      db) sqlite3 "$path" .schema | highlight -O ansi -WS sql && exit 5;;

     gpg|asc) gpg -d "$path" && exit 5; exit 1;;
     torrent) transmission-show "$path" && exit 5;;
     cfg|cnf) highlight -O ansi -S conf "$path" && exit 5; exit 2;;
    opml|dae) highlight -O ansi -S xml  "$path" && exit 5; exit 2;;

    godot|import|tres|tscn) highlight -O ansi -S ini "$path" && exit 5; exit 2;;
esac

################################################################################

[[ $image ]] && case $mime in
    image/*) exit 7;;
    video/*) ffmpegthumbnailer -i "$path" -o $cache -s 0 && exit 6;;
esac

case $mime in
    image/*)
        LANG= exiv2 "$path" && exit 5
        mediainfo   "$path" && exit 5
    ;;
    audio/*|video/*)      mediainfo "$path" && exit 5;;
    text/*|*/xml) highlight -O ansi "$path" && exit 5; exit 2;;
esac

################################################################################

exit 1
