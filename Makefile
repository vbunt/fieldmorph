andi.analyzer.hfst: andi.generator.hfst
	hfst-invert andi.generator.hfst -o andi.analyzer.hfst

andi.generator.hfst: andi.lexd
	lexd andi.lexd | hfst-txt2fst -o andi.generator.hfst
