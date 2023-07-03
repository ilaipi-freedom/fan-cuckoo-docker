## Start

```shell
./start.sh
```

sudo password: `YN02ZLX27eeeRmxQ`


```shell

cuckoo web runserver 0.0.0.0:8000

# remove \r of start.sh
sed -i 's/\r$//' start.sh

qemu-img create -f qcow2 ubuntu.img 20G
sudo qemu-system-x86_64 -m 4096 -enable-kvm ubuntu.img -cdrom ./ubuntu-20.04.6-desktop-amd64.iso
```
