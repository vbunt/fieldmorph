.DEFAULT_GOAL := andi.analizer.hfst

andi.analizer.hfst: andi.generator.hfst
	hfst-invert $< -o $@
	
andi.generator.hfst: andi.lexd
	lexd $< | hfst-txt2fst -o $@

test.pass.txt: tests.csv
	awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@

check: andi.generator.hfst test.pass.txt
	bash compare.sh $< test.pass.txt

clean: check
	rm test.*
