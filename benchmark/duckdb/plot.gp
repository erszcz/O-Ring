# Set the output file type and size. We'll use PNG.
set terminal pngcairo size 800,600 enhanced font 'Verdana,10'

# `outfile` is a variable that will be passed from the command line
set output outfile

# Set plot title and axis labels
set title "O-Ring Benchmark Results"
set xlabel "Number of Nodes"
set ylabel "Median Runtime (ms)"
set yrange [0:160000]

# Set data source options
set datafile separator ","

# Use the first row as column headers for the plot legend
set key top left

# Plot the data from the input file
# `infile` is a variable passed from the command line
# `using (strcol(1)+0):i` parses the number from the first column (e.g., "10000" from "10000-500") for the x-axis.
# The loop `for [i=2:8]` iterates through the language data columns.
# `with linespoints` creates a line plot with points at each data value.
# `title columnheader(i)` uses the header of the current column for the legend entry.
plot for [i=2:8] infile using (strcol(1)+0):i with linespoints title columnheader(i)
