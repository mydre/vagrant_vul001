#/bin/sh
_lines=`docker images | wc -l`
_image="./psv-2020-0211_system-emu.tar"
if [ $_lines -gt 1 ]; then
    _image_loaded=`docker images | head -n+2 | tail -n-1 | awk '{print $1}'`
else
    echo "it's going to loading image: $_image"
    docker load < $_image
    _image_loaded=`docker images | head -n+2 | tail -n-1 | awk '{print $1}'`
    rm $_image
fi
echo "image $_image_loaded loaded success!"
