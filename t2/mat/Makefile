#Creates .net file to include in ngspice circuit
all: ../t2_datagen.py octave.m
	@echo "Insira o menor número de estudante no seu grupo"
	@python $< > data.log
	@octave octave.m > octave.log
	@cp data.net ../sim
	@rm data.log
	@rm data.net
	
clean:
	@rm ../sim/data.net ../sim/*.ps

.PHONY: all clean