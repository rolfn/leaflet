# Rolf Niepraschk, 2017-03-17, Rolf.Niepraschk@gmx.de

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

CLASS = leaflet

PDFLATEX = pdflatex
TEX = tex
LATEX = latex

VERSION = $(shell awk -F"[{}]" '/fileversion/ {print $$2}' leaflet.dtx)

DIST_DIR = leaflet
DIST_FILES = leaflet.dtx leaflet.ins leaflet.pdf leaflet-manual.pdf README.md
ARCHNAME = $(CLASS)-$(VERSION).zip

all : leaflet.cls leaflet.pdf leaflet-manual.pdf

leaflet.cls leaflet-manual.tex: leaflet.dtx
	$(TEX) $(basename $<).ins

leaflet-manual.pdf : leaflet-manual.tex leaflet.cls
	$(PDFLATEX) $<

leaflet.pdf : leaflet.dtx
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<
	$(PDFLATEX) $<

README : README.md
	cat $< | awk '/^```/ {$$0=""} \
     /is also/ {exit} \
     {print}' > $@

dist : $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log *.glg *.glo *.gls *.idx *.ilg *.ind *.toc

veryclean : clean
	$(RM) leaflet.pdf leaflet-manual.pdf leaflet.cls README $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
