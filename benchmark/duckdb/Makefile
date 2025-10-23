BENCHMARK_RESULTS := $(wildcard ../output/*.csv)

results.duckdb: compile-results.sql $(BENCHMARK_RESULTS)
	rm -f $@; \
	duckdb $@ ".read $<"

plot-inputs: results.duckdb
	mkdir -p $@ && ./generate-plot-inputs.sh

uplot.x-nodes: plot-inputs
	@echo; \
	for infile in `find $< -name 'x-nodes*.csv' -type f | sort`; do \
	  uplot -t "oring benchmark results [ms]" -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

uplot.x-trips: plot-inputs
	@echo; \
	for infile in `find $< -name 'x-trips*.csv' -type f | sort`; do \
	  uplot -t "oring benchmark results [ms]" -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

gnuplot.x-nodes: plot-inputs
	mkdir -p plots ; \
	for infile in `find $< -name 'x-nodes*.csv' -type f | sort`; do \
	  export outfile=plots/`basename $$infile .csv`.png ; \
	  echo $$outfile ; \
	  gnuplot -e "infile='$$infile'; outfile='$$outfile'" plot.x-nodes.gp ; \
	done

gnuplot.x-trips: plot-inputs
	mkdir -p plots ; \
	for infile in `find $< -name 'x-trips*.csv' -type f | sort`; do \
	  export outfile=plots/`basename $$infile .csv`.png ; \
	  echo $$outfile ; \
	  gnuplot -e "infile='$$infile'; outfile='$$outfile'" plot.x-trips.gp ; \
	done

# vim: sw=4 ts=4 sts=4 noet
