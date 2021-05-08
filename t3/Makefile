# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------

all:
	@make -C sim
	@make -C mat
	@make -C doc
	@cp doc/report.pdf .

clean:
	@make -C doc clean
	@make -C mat clean
.PHONY: all clean