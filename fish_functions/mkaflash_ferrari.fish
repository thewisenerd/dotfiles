set CUR_DIR ( pwd )

if test -e {$CUR_DIR}/arch/arm64/boot/Image
  echo "no zImage found!";
  exit;
end

if ! test -d {$CUR_DIR}/releases/
  echo "no working folder found!";
  exit;
end

set G_IDX ( git rev-parse --verify --short HEAD )

if git status --porcelain
	set G_DRT "-dirty"
else
	set G_DRT ""
end

dtbToolCM --force-v2 -o {$CUR_DIR}/releases/unpack/dt.img -s 2048 -p scripts/dtc/ arch/arm64/boot/

cp {$CUR_DIR}/arch/arm64/boot/Image {$CUR_DIR}/releases/unpack/kernel

set d ( date +%d%b%Y )

mkboot {$CUR_DIR}/releases/unpack {$CUR_DIR}/releases/boot_{$d}_{$G_IDX}{$G_DRT}.img

echo OUTPUT: releases/boot_{$d}_{$G_IDX}{$G_DRT}.img
