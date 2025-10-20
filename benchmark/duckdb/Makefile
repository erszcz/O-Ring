CSV_OUTPUTS := $(wildcard ../output/*.csv)

results.duckdb: compile-results.sql $(CSV_OUTPUTS)
	rm -f $@; \
	duckdb $@ ".read $<"

display.x-nodes:
	@echo; \
	for infile in `ls -1 uplot.x-nodes*`; do \
	  uplot -t "oring benchmark results [ms]" \
	    -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

display.x-trips:
	@echo; \
	for infile in `ls -1 uplot.x-trips*`; do \
	  uplot -t "oring benchmark results [ms]" \
	    -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

# vim: sw=4 ts=4 sts=4 noet
