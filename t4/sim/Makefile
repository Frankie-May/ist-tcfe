all: t4simb.log outimpb.log
	@cp *.ps *.tex ../doc
	@rm -f *.log *.ps *.tex
	
t4sima.log:t4.net
	@ngspice -b $< -o $@

t4simb.log:t4sima.log
	@$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	@$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/\,/\ + j*/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)

outimpa.log:outputimpedance.net
	@ngspice -b $< -o $@

outimpb.log:outimpa.log
	@$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	@$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/\,/\ + j*/g' | sed 's/$$/\\\\ \\hline/g' > $i_tab.tex;)
