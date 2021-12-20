.DEFAULT_GOAL := andi.analizer.hfst

# generate analizer and generator
andi.analizer.hfst: andi.generator.hfst
	hfst-invert $< -o $@
andi.generator.hfst: andi.morphotactics.hfst andi.twol.hfst
	hfst-compose-intersect $^ -o $@
andi.morphotactics.hfst: andi.lexd.hfst andi.morphotactics.twol.hfst
	hfst-invert $< | hfst-compose-intersect - andi.morphotactics.twol.hfst | hfst-invert -o $@
andi.lexd.hfst: andi.lexd
	lexd $< | hfst-txt2fst -o $@
andi.twol.hfst: andi.twol
	hfst-twolc $< -o $@
andi.morphotactics.twol.hfst: andi.morphotactics.twol
	hfst-twolc $< -o $@

# generate transliteraters
cy2la.transliterater.hfst: la2cy.transliterater.hfst
	hfst-invert $< -o $@
la2cy.transliterater.hfst: correspondence.hfst
	hfst-repeat -f 1 $< -o $@
correspondence.hfst: correspondence
	hfst-strings2fst -j correspondence -o $@

# generate analizer and generator for transcription
andi.analizer.tr.hfst: andi.generator.tr.hfst
	hfst-invert $< -o $@
andi.generator.tr.hfst: andi.generator.hfst cy2la.transliterater.hfst
	hfst-compose $^ -o $@

# creat and apply tests
test.pass.txt: tests.csv
	awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: andi.generator.hfst test.pass.txt
	bash compare.sh $< test.pass.txt

# cleans files created during the check
test.clean: check
	rm test.*

# remove all hfst files
clean:
	rm *.hfst
