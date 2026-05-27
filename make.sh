nasm -f bin "CesiumOS/programs/payload.asm" -o "CesiumOS/binaries/payload.com"
nasm -f bin "CesiumOS/kernel/kernel.asm" -o "CesiumOS/binaries/kernel.bin"
nasm -f bin "CesiumOS/bootloader/boot.asm" -o "CesiumOS/binaries/boot.bin"

cat CesiumOS/binaries/boot.bin CesiumOS/binaries/kernel.bin > CesiumOS.img