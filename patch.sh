#!/bin/bash
BOOT_IMG_SIZE=67108864
PYTHON_LOC=./anaconda2/bin/python2

echo "Extracting keys from vbmeta"
$PYTHON_LOC VBMetaKeysExtractor.py vbmeta.img

echo "Creating custom key for boot"
$PYTHON_LOC avbtool extract_public_key --key custom.pem --output custom.bin

mkdir ./keys
cp *.bin ./keys/
rm -f *.bin

echo "Creating custom vbmeta and signing"
$PYTHON_LOC avbtool make_vbmeta_image --key custom.pem --algorithm SHA256_RSA4096 --flag 2 --chain_partition boot:1:keys/custom.bin --chain_partition dtbo:6:keys/dtbo_key.bin --chain_partition socko:13:keys/socko_key.bin --chain_partition odmko:14:keys/odmko_key.bin --chain_partition vbmeta_system:2:keys/vbmeta_system_key.bin --chain_partition vbmeta_system_ext:3:keys/vbmeta_system_ext_key.bin --chain_partition vbmeta_vendor:4:keys/vbmeta_vendor_key.bin --chain_partition vbmeta_product:5:keys/vbmeta_product_key.bin --chain_partition pm_sys:7:keys/pm_sys_key.bin --chain_partition l_agdsp:8:keys/l_agdsp_key.bin --chain_partition l_cdsp:9:keys/l_cdsp_key.bin --padding_size 16384 --output vbmeta_custom.img
$PYTHON_LOC vbmeta_pad.py

echo "Signing magisk.img"
$PYTHON_LOC avbtool add_hash_footer --image magisk.img --partition_name boot --partition_size $BOOT_IMG_SIZE --key custom.pem --algorithm SHA256_RSA4096

echo "DONE!!!"
read -n 1 -s -r -p "Press any key to continue"
echo ""
