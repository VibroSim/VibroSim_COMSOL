
all:

clean:
	rm -f core.* *.swp *~ COMSOL.sublime-project COMSOL.sublime-workspace .databrowse *.unison* .bak*

distclean: clean
	rm -f *.pdf
	rm -rf ./ReferenceHTML

commit: clean
	hg addrem
	hg commit

# Rules for user guide generation:
VibroSim.pdf:
	dblatex --output=VibroSim.pdf ./UserGuide/VibroSim.dbk

# Rules for developer reference generation:
Reference.pdf:
	doxygen ./ProgramRef/ReferenceGenerationPDFDoxfile
	$(MAKE) -C ./ProgramRef/latexout/
	mv ./ProgramRef/latexout/refman.pdf ./Reference.pdf
	rm -rf ./ProgramRef/latexout

ReferenceHTML:
	doxygen ./ProgramRef/ReferenceGenerationHTMLDoxfile
	mv ./ProgramRef/htmlout ./ReferenceHTML
	rm -rf ./ProgramRef/htmlout
