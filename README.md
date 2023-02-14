# Retroid Pocket 3 + Autoroot Patcher
A set of python scripts that will autosign modified vbmeta and boot images for RP3+  

# Dependancies
1. Linux OS
2. Python 3.11 or later (https://www.python.org/downloads/)
3. Python 2.7 (https://archive.archlinux.org/packages/p/python2/)

# Instructions:
1. Place vbmeta.img, boot.img, and magisk patched boot (magisk.img) into this directory
2. Run python2 avbtool info_image --image boot.img
3. Copy the number next to "Image size" and paste it into the 2nd line of patch.sh
4. Run patch.sh
5. Flash vbmeta_custom.img into vbmeta_a and vbmeta_b
6. Flash magisk.img into boot_a and boot_b
