#Creates .net file to include in ngspice circuit
all: ../t2_datagen.py octave.m
	@echo "Insira o menor número de estudante no seu grupo"
	@python $< > data.log
	@octave octave.m > octave.log
	@cp data.net ../sim
	@rm data.log
	@rm data.net
	
clean:

	@rm ../sim/data.net
	@rm ../doc/tableinferior0.tex
	@rm ../doc/tnat.tex
	@rm ../doc/tcamp.tex
	@rm ../doc/graf_nat.pdf

.PHONY: all clean