The users's guide is written in DocBook 5.0 with LaTEX equations and built into a PDF with dbLaTEX. The Docbook file VibroSim.dbk is read from the UserGuide directory in $PROJECTHOME/doc. The make target for the user's guide is VibroSim.pdf and is made by default.

The Programming Reference is generated with doxygen by processing the .m files through perl with the m2cpp.pl script written by Fabrice and retrived form MatlabCentral File Excahnge on 3/31/2015 further licence information is aviable in the licence file acomplaning the perl script in the ProgramRef directory of $PROJECTHOME/doc. The make targets for the programming reference are Reference.pdf for the PDF and ReferenceHTML for HTML. Only the PDF is built by default.

Information about in-source documentation can be found in the documentation from the m2cpp project in the ProgramRef directory.