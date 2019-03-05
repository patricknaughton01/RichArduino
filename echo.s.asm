		la r31, -1;
		la r30, CHECK_READ;
		la r29, CHECK_WRITE;
CHECK_READ:	ld r1, -23(r31); loop until we can read
		brnz r30, r1;
		ld r1, -22(r30); read
CHECK_WRITE:	ld r2, -24(r30); loop until we can write
		brnz r29, r2;
		st r1, -22(r30);
		br r30;