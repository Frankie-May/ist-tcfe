# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS) octave ngspice
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex



ngspice: circuito.log t2.log
	$(eval NGSTABS=$(shell grep _TAB t2.log | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' t2.log | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/\@//g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	#$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	$(eval NGSFIGS=$(shell grep _FIG circuito.log | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(eval NGSTABS=$(shell grep _TAB circuito.log | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' circuito.log | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/\@//g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	



#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.ps
	@rm -rf *_tab.tex octave-workspace *.eps *tableinferior0.tex *tnat.tex *tcamp.tex

.PHONY: all clean ngspice octave


