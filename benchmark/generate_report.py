#!/usr/bin/env python3

import csv
import sys
import glob

def generate_svg(data, nodes, iterations, title, y_axis_label, data_key):
    # SVG dimensions
    width = 800
    height = 600
    margin = {'top': 50, 'right': 20, 'bottom': 120, 'left': 60}
    chart_width = width - margin['left'] - margin['right']
    chart_height = height - margin['top'] - margin['bottom']

    # Find max value for scaling
    max_value = 0
    if not data:
        max_value = 1 # Avoid division by zero if no data
    else:
        for lang_data in data.values():
            max_value = max(max_value, lang_data[data_key]['median'], lang_data[data_key]['p98'], lang_data[data_key]['mean'], lang_data[data_key]['rms'])

    # SVG header
    svg = f"""<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
<rect width="100%" height="100%" fill="white" />
<g transform="translate({margin["left"]}, {margin["top"]})">"""

    # Title
    svg += f'<text x="{chart_width / 2}" y="-20" text-anchor="middle" font-family="sans-serif" font-size="20">{title}</text>\n'
    svg += f'<text x="{chart_width / 2}" y="-2" text-anchor="middle" font-family="sans-serif" font-size="12">#nodes: {nodes}, iterations: {iterations}</text>\n'

    # Y-axis
    svg += f'<line x1="0" y1="0" x2="0" y2="{chart_height}" stroke="black" />\n'
    num_ticks = 5
    for i in range(num_ticks + 1):
        y = chart_height - (i / num_ticks) * chart_height
        value = (i / num_ticks) * max_value
        svg += f'<text x="-10" y="{y}" text-anchor="end" alignment-baseline="middle" font-family="sans-serif" font-size="10">{value/1000:.1f}s</text>\n'
        svg += f'<line x1="0" y1="{y}" x2="{chart_width}" y2="{y}" stroke="#eee" />\n'
    svg += f'<text x="-40" y="{chart_height/2}" transform="rotate(-90, -40, {chart_height/2})" text-anchor="middle" font-family="sans-serif" font-size="12">{y_axis_label}</text>\n'


    # X-axis and bars
    num_items = len(data)
    bar_group_width = chart_width / num_items if num_items > 0 else 0
    bar_width = bar_group_width / 5

    def get_sort_key(item):
        label = item[0]
        values = item[1]

        # Extract trips from label like "Go trips=51"
        try:
            trips_str = label.split(' trips=')[1]
            trips = int(trips_str)
        except (IndexError, ValueError):
            trips = 0 # fallback

        median = values[data_key]['median']
        return (trips, median)

    sorted_data = sorted(data.items(), key=get_sort_key)

    for i, (label, values) in enumerate(sorted_data):
        x = i * bar_group_width
        # RMS bar
        rms_height = (values[data_key]['rms'] / max_value) * chart_height if max_value > 0 else 0
        svg += f'<rect x="{x + bar_width*0.5}" y="{chart_height - rms_height}" width="{bar_width}" height="{rms_height}" fill="#e15759" />\n'
        # Mean bar
        mean_height = (values[data_key]['mean'] / max_value) * chart_height if max_value > 0 else 0
        svg += f'<rect x="{x + bar_width*1.5}" y="{chart_height - mean_height}" width="{bar_width}" height="{mean_height}" fill="#59a14f" />\n'
        # Median bar
        median_height = (values[data_key]['median'] / max_value) * chart_height if max_value > 0 else 0
        svg += f'<rect x="{x + bar_width*2.5}" y="{chart_height - median_height}" width="{bar_width}" height="{median_height}" fill="#4e79a7" />\n'
        # 98th percentile bar
        p98_height = (values[data_key]['p98'] / max_value) * chart_height if max_value > 0 else 0
        svg += f'<rect x="{x + bar_width*3.5}" y="{chart_height - p98_height}" width="{bar_width}" height="{p98_height}" fill="#f28e2b" />\n'
        # Language label
        svg += f'<text x="{x + bar_group_width / 2}" y="{chart_height + 20}" text-anchor="end" font-family="sans-serif" font-size="12" transform="rotate(-45, {x + bar_group_width / 2}, {chart_height + 20})">{label}</text>\n'

    # Legend
    legend_y = chart_height + 80
    svg += f'<rect x="{chart_width - 550}" y="{legend_y}" width="15" height="15" fill="#e15759" />\n'
    svg += f'<text x="{chart_width - 530}" y="{legend_y + 12}" font-family="sans-serif" font-size="12">{y_axis_label} RMS</text>\n'
    svg += f'<rect x="{chart_width - 350}" y="{legend_y}" width="15" height="15" fill="#59a14f" />\n'
    svg += f'<text x="{chart_width - 330}" y="{legend_y + 12}" font-family="sans-serif" font-size="12">{y_axis_label} Mean</text>\n'

    legend_y2 = chart_height + 100
    svg += f'<rect x="{chart_width - 550}" y="{legend_y2}" width="15" height="15" fill="#4e79a7" />\n'
    svg += f'<text x="{chart_width - 530}" y="{legend_y2 + 12}" font-family="sans-serif" font-size="12">{y_axis_label} Median</text>\n'
    svg += f'<rect x="{chart_width - 350}" y="{legend_y2}" width="15" height="15" fill="#f28e2b" />\n'
    svg += f'<text x="{chart_width - 330}" y="{legend_y2 + 12}" font-family="sans-serif" font-size="12">{y_axis_label} 98th Percentile</text>\n'

    svg += '</g>\n'
    svg += '</svg>\n'
    return svg

def generate_html(setup_svg, runtime_svg):
    return f"""
<!DOCTYPE html>
<html>
<head>
<title>O-Ring Benchmark Results</title>
</head>
<body>
<h1>O-Ring Benchmark Results</h1>
{setup_svg}
{runtime_svg}
</body>
</html>
"""

def main(args):
    csv_files = args[1:]
    if len(csv_files) == 0:
        csv_files = glob.glob('output/*.csv')

    outfile = 'output/report.html'
    if len(csv_files) == 1:
        infile = csv_files[0]
        outfile = infile.replace('.csv', '.html')

    all_rows = []

    # header names
    nodes_header = '#nodes'
    trips_header = 'trips'
    iterations_header = 'iterations'

    runtime_median_header = 'time to finish median[ms]'
    runtime_p98_header = 'time to finish 98th percentile[ms]'
    runtime_mean_header = 'time to finish mean[ms]'
    runtime_rms_header = 'time to finish RMS'

    setup_median_header = 'setup median[ms]'
    setup_p98_header = 'setup 98th percentile[ms]'
    setup_mean_header = 'setup mean[ms]'
    setup_rms_header = 'setup RMS'

    for file_path in csv_files:
        lang = file_path.replace('.csv', '').replace('output/', '').title()
        try:
            with open(file_path, 'r') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    # Strip whitespace from header keys
                    row = {k.strip(): v for k, v in row.items()}
                    row['lang'] = lang
                    all_rows.append(row)
        except FileNotFoundError:
            print(f"Warning: file not found {file_path}")
            continue

    if not all_rows:
        print("No data found in CSV files.")
        sys.exit(0)

    # Check for metadata consistency (nodes, iterations)
    nodes, iterations = None, None
    for row in all_rows:
        current_nodes = int(row[nodes_header])
        current_iterations = int(row[iterations_header])
        if nodes is None:
            nodes, iterations = current_nodes, current_iterations
        elif (nodes, iterations) != (current_nodes, current_iterations):
            print("Error: Mismatched #nodes or iterations in CSV files.")
            sys.exit(1)

    plot_data = {}
    for row in all_rows:
        lang = row['lang']
        trips = int(row[trips_header])
        label = f"{lang} trips={trips}"

        runtime_median = float(row[runtime_median_header])
        runtime_p98 = float(row[runtime_p98_header])
        runtime_mean = float(row[runtime_mean_header])
        runtime_rms = float(row[runtime_rms_header])

        setup_median = float(row[setup_median_header])
        setup_p98 = float(row[setup_p98_header])
        setup_mean = float(row[setup_mean_header])
        setup_rms = float(row[setup_rms_header])

        plot_data[label] = {
            'runtime': {
                'median': runtime_median, 
                'p98': runtime_p98, 
                'mean': runtime_mean, 
                'rms': runtime_rms
            },
            'setup': {
                'median': setup_median,
                'p98': setup_p98,
                'mean': setup_mean,
                'rms': setup_rms
            }
        }

    if plot_data:
        setup_svg = generate_svg(plot_data, nodes, iterations, "O-Ring Benchmark Setup Times", "Setup Time", "setup")
        runtime_svg = generate_svg(plot_data, nodes, iterations, "O-Ring Benchmark Runtime Results", "Time to Finish", "runtime")

        html_content = generate_html(setup_svg, runtime_svg)
        with open(outfile, 'w') as f:
            f.write(html_content)

if __name__ == '__main__':
    main(sys.argv)
