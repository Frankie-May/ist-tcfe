#Creates .net file to include in ngspice circuit
all: t3.m
	@octave t3.m
	@cp envldetc.eps ../doc
	@cp octave_results.tex ../doc
	@cp volregd.eps ../doc
	@rm *.eps *.tex
clean:
	@rm *.eps *.tex
.PHONY: all clean