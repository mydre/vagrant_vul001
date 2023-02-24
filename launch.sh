#/bin/bash
cd ./vul_psv-2020-0211_system-emu

if [ ! -f "./data/psv-2020-0211_system-emu.tar" ] && [ -f "Vagrantfile" ]; then
    cp ../psv-2020-0211_system-emu.tar ./data
fi
if [ ! -f "./data/load.sh" ] && [ -f "Vagrantfile" ]; then
    cp ../load.sh ./data
fi
if [ -f "Vagrantfile" ]; then
    vagrant up
fi
imgName=vul_psv-2020-0211_system-emu
vmid=`expr match $(vboxmanage list vms | grep $imgName | awk '{print $NF}') '{\(.*\)}'`

isrun=$(vboxmanage showvminfo "$vmid" | grep -c "running (since")
if [ ! $isrun -eq 0 ]; then
    read -r -p "is going to generate qcow2, need shutdown the vm, are you ready?" input
    case $input in
        [yY][eE][sS]|[yY])
    		echo "Yes"
            VBoxManage controlvm $vmid poweroff
            sleep 3 # sleep 3 seconds
    		;;
        [nN][oO]|[nN])
    		echo "No"
            exit 1
           	;;
        *)
    		echo "Invalid input..."
    		exit 1
    		;;
    esac
fi

imgpath=`vboxmanage list hdds | grep $imgName | awk -F '       ' '{print $2}'`
resultVdi=$(echo $imgpath | grep "\.vdi")
resultVmdk=$(echo $imgpath | grep "\.vmdk")
if [[ "$resultVdi" != "" ]]; then
    echo resultVdi:$resultVdi
else
    :
    # echo resultVdi: None
fi
if [[ "$resultVmdk" != "" ]]; then
    echo resultVmdk:$resultVmdk
else
    :
    # echo resultVmdk: None
fi
qcow2Path="$(pwd)/$imgName.qcow2"
if [[ "$resultVdi" != "" ]]; then # source is vdi format
    if [ -f $qcow2Path ]; then
        echo $qcow2Path is already existing!
    else
        echo is generating: $qcow2Path
        qemu-img convert -f vdi -O qcow2 "$imgpath" "$imgName.qcow2"
    fi
fi
if [[ "$resultVmdk" != "" ]]; then # source is vmdk format
    if [ -f $qcow2Path ]; then
        echo $qcow2Path is already existing!
    else
        echo is generating: $qcow2Path
        qemu-img convert -f vmdk -O qcow2 "$imgpath" "$imgName.qcow2"
    fi
fi

read -r -p "would you like to unregister the vm?" input
case $input in
    [yY][eE][sS]|[yY])
		echo "Yes"
        echo "we will execute cmd: vboxmanage unregistervm $vmid --delete"
        vboxmanage unregistervm $vmid --delete
		;;
    [nN][oO]|[nN])
		echo "No"
        exit 1
       	;;
    *)
		echo "Invalid input..."
		exit 1
		;;
esac
