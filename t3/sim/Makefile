#MAKEFILE FOR SIM
all: t3.net
	ngspice -b t3.net
	soffice --headless --convert-to pdf *.ps
	cp *.pdf ../doc
	@rm *.ps *.pdf





clean:
	@rm -f ngspice.log *.tex *.pdf *.ps *~ *.eps *.txt

.PHONY: all clean