all:
	@make -C sim
	@make -C mat
	@make -C doc
	@cp doc/report.pdf

clean: 
	@rm -f *.pdf
	@make -C doc clean
#	@make -C mat clean
	@make -C sim clean

.PHONY: all clean