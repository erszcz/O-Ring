CSV_OUTPUTS := $(wildcard ../output/*.csv)

results.duckdb: compile-results.sql $(CSV_OUTPUTS)
	rm -f $@; \
	duckdb $@ ".read $<"

uplot.x-nodes:
	@echo; \
	for infile in `ls -1 uplot.x-nodes*`; do \
	  uplot -t "oring benchmark results [ms]" \
	    -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

uplot.x-trips:
	@echo; \
	for infile in `ls -1 uplot.x-trips*`; do \
	  uplot -t "oring benchmark results [ms]" \
	    -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

gnuplot.x-nodes:
	for infile in `ls -1 uplot.x-nodes*.csv`; do \
	  export outfile=`basename $$infile .csv`.png ; \
	  echo $$outfile ; \
	  gnuplot -e "infile='$$infile'; outfile='$$outfile'" plot.gp ; \
	done

feedgnuplot:
	cat gnuplot.x-nodes.csv | feedgnuplot --3d --title "oring benchmark results [ms]" --domain --with boxes

# vim: sw=4 ts=4 sts=4 noet
