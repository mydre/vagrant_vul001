#/bin/bash
files=`cat ./dockers.txt`
idx=0
for item in $files
do
    echo "$idx---> $vul_psv-2020-0211_system-emu..." 
    idx=`expr $idx + 1`
    if [ -f "./$vul_psv-2020-0211_system-emu" ]; then
        continue
    fi
    docker save $item > $vul_psv-2020-0211_system-emu
done

