#MAKEFILE FOR SIM
all:circuito.net t2.net
	@ngspice -b circuito.net
	#@ngspice -b t2.net
	@soffice --headless --convert-to pdf *.ps
	@cp *.pdf ../doc
	@rm *.ps *.pdf