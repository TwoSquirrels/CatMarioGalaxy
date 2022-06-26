#!/bin/sh

if [ -n "$2" ]; then
    echo "invalid arguments"
    exit 1
fi

if [ "$1" = "help" ] || [ "$1" = "h" ] ||\
       [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo ""
    echo "build-web"
    echo ""
    echo "arguments:"
    echo ""
    echo "    help, h, --help, -h:"
    echo "        Show usage."
    echo ""
    echo "    debug, d, --debug, -d:"
    echo "        Build as debug mode."
    echo ""
    echo "    release, r, --release, -r:"
    echo "        Build as release mode. (default)"
    echo ""
    exit 0
fi

# build

cd "$(dirname "$0")"
dir="$(pwd)"

if [ "$1" = "debug" ] || [ "$1" = "d" ] ||\
       [ "$1" = "--debug" ] || [ "$1" = "-d" ]; then
    mode="debug"
    build_dir="$dir/Debug/Web"
elif [ -z "$1" ] || [ "$1" = "release" ] || [ "$1" = "r" ] ||\
         [ "$1" = "--release" ] || [ "$1" = "-r" ]; then
    mode="release"
    build_dir="$dir/Release/Web"
else
    echo "invalid arguments"
    exit 1
fi

project="$(basename "$dir")"
siv3d_template="$dir/Siv3DForWeb"
siv3d="$siv3d_template/OpenSiv3D"

echo ""
echo "[$project] Compiling..."

# reset build dir
mkdir -p "$build_dir"
rm -rf "$build_dir/"*

# compile
for source in $(find Src/ -type f -name '*.cpp' | sed -e 's/ /:/g'); do
    source=$(echo "$source" | sed -e 's/:/ /g')
    echo "[$project] Compiling $source"
    object=$(echo "$source" | sed -e 's/^Src\///g' | sed -e 's/\.cpp$/.o/g' |\
                 sed -e 's/ /-/g' | sed -e 's/\//--/g')
    em++ "$source" -c -o "$build_dir/$object"\
         $([ "$mode" = "debug" ] && echo "-O0 -g")\
         $([ "$mode" = "release" ] && echo "-O2")\
         -std=c++2a -D_XM_NO_INTRINSICS_\
         -I "$siv3d/include" -I "$siv3d/include/ThirdParty"
done

if [ "$?" -ne 0 ]; then
    echo "[$project] Compiling failed."
    echo ""
    exit "$?"
fi

echo ""
echo "[$project] Linking..."

# reset dist dir
mkdir -p "$build_dir/Dist"

# link
cd "$build_dir/"
em++ $(echo *.o) -o "$build_dir/Dist/index.html"\
     $([ "$mode" = "debug" ] &&\
           echo "-O0 -g -s EXCEPTION_CATCHING_ALLOWED=['InitSiv3D']")\
     $([ "$mode" = "release" ] && echo "-O2")\
     -L "$siv3d/lib"\
     -L "$siv3d/lib/freetype"\
     -L "$siv3d/lib/giflib"\
     -L "$siv3d/lib/harfbuzz"\
     -L "$siv3d/lib/opencv"\
     -L "$siv3d/lib/opus"\
     -L "$siv3d/lib/tiff"\
     -L "$siv3d/lib/turbojpeg"\
     -L "$siv3d/lib/webp"\
     -l Siv3D\
     -l freetype\
     -l gif\
     -l harfbuzz\
     -l opencv_core -l opencv_imgproc -l opencv_objdetect -l opencv_photo\
     -l turbojpeg\
     -l tiff\
     -l opusfile -l opus\
     -l webp\
     --emrun\
     -s FULL_ES3=1\
     -s MIN_WEBGL_VERSION=2\
     -s MAX_WEBGL_VERSION=2\
     -s USE_GLFW=3\
     -s USE_SDL=2\
     -s USE_LIBPNG=1\
     -s USE_OGG=1\
     -s USE_VORBIS=1\
     -s ALLOW_MEMORY_GROWTH=1\
     -s ERROR_ON_UNDEFINED_SYMBOLS=0\
     -Wl,--allow-undefined\
     -s ASYNCIFY=1\
     -s ASYNCIFY_IGNORE_INDIRECT=1\
     -s ASYNCIFY_IMPORTS="['siv3dRequestAnimationFrame','siv3dOpenDialog','siv3dDecodeAudioFromFile','siv3dGetClipboardText']"\
     -s ASYNCIFY_ADD="['main','Main()','s3d::System::Update()','s3d::AACDecoder::decode(*) const','s3d::MP3Decoder::decode(*) const','s3d::CAudioDecoder::decode(*)','s3d::AudioDecoder::Decode(*)','s3d::Wave::Wave(*)','s3d::Audio::Audio(*)','s3d::Clipboard::GetText(*)','s3d::Clipboard::getText(*)']"\
     -s MODULARIZE=1\
     --preload-file "$siv3d/example@/example"\
     --preload-file "$siv3d/resources@/resources"\
     --shell-file "$siv3d_template/template-web-player.html"\
     --pre-js "$siv3d/lib/Siv3D.pre.js"\
     --post-js "$siv3d_template/template-web-player.js"\
     --js-library "$siv3d/lib/Siv3D.js"

if [ "$?" -ne 0 ]; then
    echo "[$project] Linking failed."
    echo ""
    exit "$?"
fi

echo ""
echo "[$project] Building complete!"
echo ""
