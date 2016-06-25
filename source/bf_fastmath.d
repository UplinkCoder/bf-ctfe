module bf_fastMath;

const(uint) fastLog10(const uint val) pure nothrow @nogc {
	return 
		(val < 10) ? 0 : 
		(val < 100) ? 1 : 
		(val < 1000) ? 2 : 
		(val < 10000) ? 3 :
		(val < 100000) ? 4 :
		(val < 1000000) ? 5 :
		(val < 10000000) ? 6 :
		(val < 100000000) ? 7 :
		(val < 1000000000) ? 8 : 9;
}

/*@unique*/ static immutable fastPow10tbl = [
	1,
	10,
	100,
	1000,
	10000,
	100000,
	1000000,
	10000000,
	100000000,
	1000000000,
] ;

const(uint) fastPow10(const uint val) pure nothrow @nogc {
	if (val < 10) {
		return fastPow10tbl[val];
	} else {
		assert(0, "values bigger then 10 ^ 9 are too big to fit into an uint");
	}
}