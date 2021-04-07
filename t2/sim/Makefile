#MAKEFILE FOR SIM
all: tablecircuito.log tablet2.log 
	mv ngspicecircuito.log poscircuito.log
	mv ngspicet2.log post2.log
	soffice --headless --convert-to pdf *.ps
	cp *.pdf ../doc
	cp *.tex ../doc
	@rm *.ps *.pdf *.tex *.txt *.log

ngspicecircuito.log: circuito.net
	@ngspice -b $< -o $@

tablecircuito.log: ngspicecircuito.log
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' > $i_data.txt;)

ngspicet2.log: t2.net
	@ngspice -b $< -o $@

tablet2.log: ngspicet2.log
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' > $i_data.txt;)

