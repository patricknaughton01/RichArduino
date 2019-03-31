la r31, 0xFFFFFFE8; RXF
la r30, 0xFFFFFFE9; USB
la r29, 0xFFFFFFEA; D0
la r28, CHECKREAD
la r2, 3; write DO as output and high
la r3, 0;
st r3, (r29); 0 out D0 initially
CHECKREAD: ld r0, (r31);
brnz r28, r0; loop until we see RXF=0
ld r1, (r30); Read from USB
st r2, (r29)