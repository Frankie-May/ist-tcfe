#MAKEFILE FOR SIM
all:circuito.net t2.net
	@ngspice -b circuito.net -o ../doc/circuito.log
	@ngspice -b t2.net -o ../doc/t2.log
	@soffice --headless --convert-to pdf *.ps
	@cp *.pdf ../doc
	@rm *.ps *.pdf