#MAKEFILE FOR SIM
all:
	#mv ngspicecircuito.log poscircuito.log
	#mv ngspicet2.log post2.log
	soffice --headless --convert-to pdf *.ps
	cp *.pdf ../doc
	@rm *.ps *.pdf *.log

ngspicet3.log: t3.net
	@ngspice -b $< -o $@



clean:
	@rm -f ngspice.log *.tex *.pdf *.ps *~ *.eps *.txt

.PHONY: all clean