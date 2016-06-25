module bf_analyzer;

import bf_parser : RepeatedToken, BFTokenEnum;

//struct AnalyserResult {
//	uint numberOfCells;
//}
/+ TODO fix the code below to actually return sane numbers
  AKA make it loop-aware
uint countCells(const RepeatedToken[] programm) {
	int numberOfCells = 1;

	foreach(rt;programm) with(BFTokenEnum) {
		if (rt.token == IncPtr) {
			numberOfCells += rt.count;
		} else if (rt.token == DecPtr) {
			numberOfCells -= rt.count;
		}
	}

	assert(numberOfCells > 0);
	return numberOfCells;
}
+/

const(int) maxNestingLevel(const RepeatedToken[] programm) {
	int max;
	int currentNestingLevel;

	foreach(rt;programm) with(BFTokenEnum) {
		if (rt.token == LoopBegin) {
			currentNestingLevel += rt.count;
			if (currentNestingLevel > max) {
				max = currentNestingLevel;
			}
		} else if (rt.token == LoopEnd) {
			currentNestingLevel -= rt.count;
		}
	}

	return max;
}

const(bool) usesInput(const RepeatedToken[] programm) {
	foreach(rt;programm) with(BFTokenEnum) {
		if (rt.token == InputVal) {
			return true;
		}
	}

	return false;
}
