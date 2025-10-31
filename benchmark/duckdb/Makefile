BENCHMARK_RESULTS := $(wildcard ../output/*.csv)
DUCKDB_DATABASE := results.duckdb

.PHONY: duckdb.import
duckdb.import:
	@if [ ! -z "$$lang" ]; then \
	  echo "make $@: Importing ../output/$$lang.csv into $(DUCKDB_DATABASE)" ; \
	  ./duckdb-import.sh "$$lang" "../output/$$lang.csv" | duckdb $(DUCKDB_DATABASE) ; \
	else \
	  echo "make $@: Env var 'lang' not defined. What to import?" ; \
	  exit 1 ; \
	fi

.PHONY: duckdb.replace-view
duckdb.replace-view: results.duckdb

.PHONY: serve.plotly
serve.plotly: plot-inputs plot-inputs/.depfile
	python3 -m http.server

results.duckdb: replace-view.sql
	duckdb results.duckdb ".read $<" && rm -f plot-inputs/.depfile

plot-inputs:
	mkdir -p $@

plot-inputs/.depfile: results.duckdb generate-plot-inputs.sh
	./generate-plot-inputs.sh && touch plot-inputs/.depfile

uplot.x-nodes: plot-inputs plot-inputs/.depfile
	@echo; \
	for infile in `find $< -name 'x-nodes*.csv' -type f | sort`; do \
	  uplot -t "oring benchmark results [ms]" -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

uplot.x-trips: plot-inputs plot-inputs/.depfile
	@echo; \
	for infile in `find $< -name 'x-trips*.csv' -type f | sort`; do \
	  uplot -t "oring benchmark results [ms]" -w 60 -h 24 -d, -H lines $$infile; \
	  echo; echo; \
	done

gnuplot.x-nodes: plot-inputs plot-inputs/.depfile
	mkdir -p plots ; \
	for infile in `find $< -name 'x-nodes*.csv' -type f | sort`; do \
	  export outfile=plots/`basename $$infile .csv`.png ; \
	  echo $$outfile ; \
	  gnuplot -e "infile='$$infile'; outfile='$$outfile'" plot.x-nodes.gp ; \
	done

gnuplot.x-trips: plot-inputs plot-inputs/.depfile
	mkdir -p plots ; \
	for infile in `find $< -name 'x-trips*.csv' -type f | sort`; do \
	  export outfile=plots/`basename $$infile .csv`.png ; \
	  echo $$outfile ; \
	  gnuplot -e "infile='$$infile'; outfile='$$outfile'" plot.x-trips.gp ; \
	done

# vim: sw=4 ts=4 sts=4 noet
