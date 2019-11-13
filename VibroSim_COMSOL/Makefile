SUBDIRS=doc


all:
	@for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i ; fi done


clean:
	rm -f core.* *.swp *~ COMSOL.sublime-project COMSOL.sublime-workspace .databrowse *.unison* .bak* .hgignore~ .hgignore.bak
	rm -f */core.* */*.swp */*~ */COMSOL.sublime-project */COMSOL.sublime-workspace */.databrowse */*.unison* */.bak*
	@for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i clean ; fi done

distclean:
	@for i in $(SUBDIRS) ; do if [ -d $$i ] && [ -f $$i/Makefile ] ; then $(MAKE) $(MFLAGS) -C $$i distclean ; fi done


commit: distclean
	hg addrem
	hg commit
