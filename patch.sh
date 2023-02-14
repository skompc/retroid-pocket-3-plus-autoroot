#!/bin/bash
BOOT_IMG_SIZE={INSERT_ORIGINAL_SIZE_HERE}

echo "Extracting keys from vbmeta"
python3 VBMetaKeysExtractor.py vbmeta.img

echo "Creating custom key for boot"
python2 avbtool extract_public_key --key custom.pem --output custom.bin

echo "Creating custom vbmeta and signing"
python2 avbtool make_vbmeta_image --key custom.pem --algorithm SHA256_RSA4096 --flag 2 --chain_partition boot:1:custom.bin --chain_partition dtbo:6:dtbo_key.bin --chain_partition socko:13:socko_key.bin --chain_partition odmko:14:odmko_key.bin --chain_partition vbmeta_system:2:vbmeta_system_key.bin --chain_partition vbmeta_system_ext:3:vbmeta_system_ext_key.bin --chain_partition vbmeta_vendor:4:vbmeta_vendor_key.bin --chain_partition vbmeta_product:5:vbmeta_product_key.bin --chain_partition pm_sys:7:pm_sys_key.bin --chain_partition l_agdsp:8:l_agdsp_key.bin --chain_partition l_cdsp:9:l_cdsp_key.bin --padding_size 16384 --output vbmeta_custom.img
python2 vbmeta_pad.py

echo "Signing magisk.img"
python2 avbtool add_hash_footer --image magisk.img --partition_name boot --partition_size $BOOT_IMG_SIZE --key custom.pem --algorithm SHA256_RSA4096

echo "DONE!!!"
read -n 1 -s -r -p "Press any key to continue"
echo ""
