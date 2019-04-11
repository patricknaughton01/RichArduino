la r31, 0xFFFFFFE7; TXE
la r30, 0xFFFFFFE9; USB
la r29, CHECKWRITE;
la r28, 33; character to write (!)
CHECKWRITE: ld r0, (r31);
brnz r29, r0; Test TXE until low
st r28, (r30); write ! to usb
br r29; loopback to write again