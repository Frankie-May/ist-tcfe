#Creates .net file to include in ngspice circuit
all: ../t2_datagen.py simplicity.m
	@echo "Insira o menor número de estudante no seu grupo"
	@python $< > data.log
	@octave simplicity.m
	@cp data.net ../sim
	@rm data.log
	@rm data.net
	
clean:
	@rm ../sim/data.net

.PHONY: all clean