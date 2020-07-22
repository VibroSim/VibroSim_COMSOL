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
VibroSim_COMSOL.pdf:
	dblatex --output=VibroSim_COMSOL.pdf ./UserGuide/VibroSim.dbk

# Rules for developer reference generation:
VibroSim_COMSOL_Reference.pdf:
	doxygen ./ProgramRef/ReferenceGenerationPDFDoxfile
	$(MAKE) -C ./ProgramRef/latexout/
	mv ./ProgramRef/latexout/refman.pdf ./VibroSim_COMSOL_Reference.pdf
	rm -rf ./ProgramRef/latexout

ReferenceHTML:
	doxygen ./ProgramRef/ReferenceGenerationHTMLDoxfile
	mv ./ProgramRef/htmlout ./VibroSim_COMSOL_ReferenceHTML
	rm -rf ./ProgramRef/htmlout
