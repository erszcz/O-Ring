BEGIN {
    print "<!DOCTYPE html>"
    print "<html>"
    print "<head>"
    print "  <title>o-ring benchmark</title>"
    print "  <script src=\"https://cdn.plot.ly/plotly-3.2.0.min.js\" charset=\"utf-8\"></script>"
    print "  <style type='text/css'>"
    print "    body { font-family: sans-serif; }"
    print "    div#content {"
    print "        width: 40%;"
    print "        margin: 0 auto;"
    print "    }"
    print "  </style>"
    print "</head>"
    print "<body>"
    print "  <div id='content'>"
    print "    <h1>o-ring benchmark</h1>"
    print "    <p>"
    print "    Taken from \"Programming Erlang\", second edition, by Joe Armstrong:"
    print "    </p>"
    print "    <blockquote>Write a ring benchmark. Create N processes in a ring. Send a message "
    print "    round the ring M times so that a total of N * M messages get sent. Time "
    print "    how long this takes for different values of N and M. "
    print "    Write a similar program in some other programming language you are "
    print "    familiar with. Compare the results. Write a blog, and publish the results "
    print "    on the Internet!</blockquote>"
    print "    <div id=\"plot\"></div>"
    print "  </div>"
    print "  <script>"
}
NR==1 {
    # Process header to get subtitle and series names
    subtitle = $1
    split(subtitle, ntrips, " ")
    for (i = 2; i <= NF; i++) {
        # Remove potential carriage returns from series names
        gsub(/\r$/, "", $i)
        series_names[i-1] = $i
    }
}
NR > 1 {
    # Process data rows
    # Split the first column (e.g., "10000-4500") to get the X value
    split($1, x_parts, "-")
    x_values[NR-1] = x_parts[1]

    # Store Y values for each series
    for (i = 2; i <= NF; i++) {
        y_values[i-1, NR-1] = $i
    }
}
END {
    print "var traces = [];"
    num_series = length(series_names)
    num_points = length(x_values)

    # Create a trace for each series
    for (i = 1; i <= num_series; i++) {
        print "traces.push({"
        print "  name: \"" series_names[i] "\","
        print "  x: ["
        for (j = 2; j <= num_points + 1; j++) {
            printf "%s%s", x_values[j], (j < num_points + 1 ? "," : "")
        }
        print "],"
        print "  y: ["
        for (j = 2; j <= num_points + 1; j++) {
            printf "%s%s", y_values[i, j], (j < num_points + 1 ? "," : "")
        }
        print "],"
        print "  mode: 'lines+markers'"
        print "});"
    }

    # Define the plot layout
    print "var layout = {"
    print "  title: {text: '", subtitle, "'},"
    print "  xaxis: {title: {text: \"nodes,", ntrips[2], "\"} },"
    print "  yaxis: {title: {text: \"runtime (ms)\"} },"
    print "  width: 1400,"
    print "  height: 900"
    print "};"

    # Create the plot
    print "Plotly.newPlot(\"plot\", {\"data\": traces, \"layout\": layout});"
    print "  </script>"
    print "</body>"
    print "</html>"
}
