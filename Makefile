

.SUFFIXES : .tex .ltx .dvi .ps .pdf .eps

CLASS = leaflet

PDFLATEX = pdflatex

LATEX = latex

#ARCHNAME = $(CLASS)-$(shell date +"%y%m%d-%H%M")
ARCHNAME = $(CLASS)-$(shell date +"%y%m%d")

EXAMPLE = $(CLASS)-manual.tex

ARCHFILES = $(CLASS).ins $(CLASS).dtx  \
            # rotk.tex leaflet-test.tex

all : docpdf pdf

pdf : $(EXAMPLE:.tex=.pdf)

ps  : $(EXAMPLE:.tex=.ps)

doc : $(CLASS).ps 

docpdf : $(CLASS).pdf

%.dvi : %.tex $(CLASS).cls  
	$(LATEX) $<
        
%.pdf : %.tex $(CLASS).cls  
	$(PDFLATEX) $< 

$(CLASS).cls $(EXAMPLE): $(CLASS).ins $(CLASS).dtx
	tex $<
	mv $(basename $<).log $<.log

# $(EXAMPLE).pdf via ps2pdf:
# latex leaflet-manual.tex 
# dvips leaflet-manual 
# ps2pdf -dAutoRotatePages=/None leaflet-manual.ps
        
%.ps : %.dvi
	dvips -o $@ $<

$(CLASS).dvi : $(CLASS).dtx $(CLASS).cls
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(LATEX) $<
        
$(CLASS).pdf : $(CLASS).dtx $(CLASS).cls
	if ! test -f $(basename $<).glo ; then touch $(basename $<).glo; fi
	if ! test -f $(basename $<).idx ; then touch $(basename $<).idx; fi
	makeindex -s gglo.ist -t $(basename $<).glg -o $(basename $<).gls \
		$(basename $<).glo
	makeindex -s gind.ist -t $(basename $<).ilg -o $(basename $<).ind \
		$(basename $<).idx
	$(PDFLATEX) $<        

arch :
	zip $(ARCHNAME).zip $(ARCHFILES) Makefile
        
dist :
	zip $(ARCHNAME).zip $(ARCHFILES) leaflet-manual.pdf leaflet.pdf README  
