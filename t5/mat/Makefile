all: t5.m
	@octave t5.m
	@cp *.tex ../doc
	@cp *.eps ../doc
	@rm *.eps *.tex

clean: 
	@rm -f *.tex *.eps

.PHONY: all clean