#!/bin/sh
echo "will start build uboot for rock5c"
DEF_CONFIG=rock-5c-rk3588s_defconfig
DEF_DTS=rk3588s-rock-5c.dts
SOC_TYPE=3588
WORKDIR=$(cd $(dirname $0); pwd)

RKBIN_DIR=/home/sora/sora_samba/05_radxa/rkbin
RK_ELF=$RKBIN_DIR/bin/rk35/rk3588_bl31_v1.45.elf
DDR_BIN=$RKBIN_DIR/bin/rk35/rk3588_ddr_lp4_2112MHz_lp5_2400MHz_v1.16.bin
RK_MKIMAGE=$WORKDIR/tools/mkimage

echo "========================================="
echo "elf = $RK_ELF"
echo "ddr = $DDR_BIN"
echo "mkimage = $RK_MKIMAGE"
echo "SOC = $SOC_TYPE"
echo "uboot config = $DEF_CONFIG"
echo "uboot dts = $DEF_DTS"
echo "========================================="
export PATH=$PATH:/home/sora/sora_samba/05_radxa/tools/bin
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-


make clean
make distclean

#export BL31=./sora_add_github_bin/rk3568_bl31_v1.43.elf
#export ROCKCHIP_TPL=./sora_add_github_bin/rk3568_ddr_1560MHz_v1.18.bin
#make ${DEF_CONFIG}
# make CROSS_COMPILE=aarch64-linux-gnu- ${DEF_CONFIG}
# make CROSS_COMPILE=aarch64-linux-gnu- --jobs="$(nproc)" all

make CROSS_COMPILE=aarch64-linux-gnu- ${DEF_CONFIG}
make CROSS_COMPILE=aarch64-linux-gnu- --jobs="$(nproc)" all

#make ${DEF_CONFIG}
#make --jobs="$(nproc)" all

make BL31=$RK_ELF spl/u-boot-spl.bin u-boot.dtb u-boot.itb
$RK_MKIMAGE -n rk3588 -T rksd -d $DDR_BIN:spl/u-boot-spl.bin idbloader.img
