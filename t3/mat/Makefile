#Creates .net file to include in ngspice circuit
all: t3.m
	@octave t3.m
	@cp *.tex ../doc
	@cp *.eps ../doc
	@rm *.eps *.tex
clean:
	@rm *.eps *.tex
.PHONY: all clean