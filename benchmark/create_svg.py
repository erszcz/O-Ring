import csv
import sys
import glob

def generate_svg(data, nodes, trips, iterations):
    # SVG dimensions
    width = 800
    height = 600
    margin = {'top': 50, 'right': 20, 'bottom': 100, 'left': 60}
    chart_width = width - margin['left'] - margin['right']
    chart_height = height - margin['top'] - margin['bottom']

    # Find max value for scaling
    max_value = 0
    for lang_data in data.values():
        max_value = max(max_value, lang_data['median'], lang_data['p98'], lang_data['mean'], lang_data['rms'])

    # SVG header
    svg = f"""<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg">
<rect width="100%" height="100%" fill="white" />
<g transform="translate({margin["left"]}, {margin["top"]})">"""

    # Title
    svg += f'<text x="{chart_width / 2}" y="-20" text-anchor="middle" font-family="sans-serif" font-size="20">O-Ring Benchmark Results</text>\n'

    # Y-axis
    svg += f'<line x1="0" y1="0" x2="0" y2="{chart_height}" stroke="black" />\n'
    num_ticks = 5
    for i in range(num_ticks + 1):
        y = chart_height - (i / num_ticks) * chart_height
        value = (i / num_ticks) * max_value
        svg += f'<text x="-10" y="{y}" text-anchor="end" alignment-baseline="middle" font-family="sans-serif" font-size="10">{value/1000:.1f}s</text>\n'
        svg += f'<line x1="0" y1="{y}" x2="{chart_width}" y2="{y}" stroke="#eee" />\n'
    svg += f'<text x="-40" y="{chart_height/2}" transform="rotate(-90, -40, {chart_height/2})" text-anchor="middle" font-family="sans-serif" font-size="12">Time to Finish</text>\n'


    # X-axis and bars
    num_langs = len(data)
    bar_group_width = chart_width / num_langs
    bar_width = bar_group_width / 5

    sorted_data = sorted(data.items(), key=lambda item: item[1]['median'])

    for i, (lang, values) in enumerate(sorted_data):
        x = i * bar_group_width
        # Median bar
        median_height = (values['median'] / max_value) * chart_height
        svg += f'<rect x="{x + bar_width*0.5}" y="{chart_height - median_height}" width="{bar_width}" height="{median_height}" fill="#4e79a7" />\n'
        # 98th percentile bar
        p98_height = (values['p98'] / max_value) * chart_height
        svg += f'<rect x="{x + bar_width*1.5}" y="{chart_height - p98_height}" width="{bar_width}" height="{p98_height}" fill="#f28e2b" />\n'
        # Mean bar
        mean_height = (values['mean'] / max_value) * chart_height
        svg += f'<rect x="{x + bar_width*2.5}" y="{chart_height - mean_height}" width="{bar_width}" height="{mean_height}" fill="#59a14f" />\n'
        # RMS bar
        rms_height = (values['rms'] / max_value) * chart_height
        svg += f'<rect x="{x + bar_width*3.5}" y="{chart_height - rms_height}" width="{bar_width}" height="{rms_height}" fill="#e15759" />\n'
        # Language label
        svg += f'<text x="{x + bar_group_width / 2}" y="{chart_height + 20}" text-anchor="middle" font-family="sans-serif" font-size="12">{lang}</text>\n'

    # Legend
    legend_y = chart_height + 60
    svg += f'<rect x="{chart_width - 550}" y="{legend_y}" width="15" height="15" fill="#4e79a7" />\n'
    svg += f'<text x="{chart_width - 530}" y="{legend_y + 12}" font-family="sans-serif" font-size="12">Time to Finish Median</text>\n'
    svg += f'<rect x="{chart_width - 350}" y="{legend_y}" width="15" height="15" fill="#f28e2b" />\n'
    svg += f'<text x="{chart_width - 330}" y="{legend_y + 12}" font-family="sans-serif" font-size="12">Time to Finish 98th Percentile</text>\n'
    
    legend_y2 = chart_height + 80
    svg += f'<rect x="{chart_width - 550}" y="{legend_y2}" width="15" height="15" fill="#59a14f" />\n'
    svg += f'<text x="{chart_width - 530}" y="{legend_y2 + 12}" font-family="sans-serif" font-size="12">Time to Finish Mean</text>\n'
    svg += f'<rect x="{chart_width - 350}" y="{legend_y2}" width="15" height="15" fill="#e15759" />\n'
    svg += f'<text x="{chart_width - 330}" y="{legend_y2 + 12}" font-family="sans-serif" font-size="12">Time to Finish RMS</text>\n'

    legend_y_extra = chart_height + 100
    svg += f'<text x="{chart_width - 350}" y="{legend_y_extra}" font-family="sans-serif" font-size="12">#nodes: {nodes}, trips: {trips}, iterations: {iterations}</text>\n'


    svg += '</g>\n'
    svg += '</svg>\n'
    return svg

if __name__ == '__main__':
    csv_files = glob.glob('output/*.csv')
    
    data = {}
    nodes, trips, iterations = None, None, None
    
    # header names
    nodes_header = '#nodes'
    trips_header = 'trips'
    iterations_header = 'iterations'
    median_header = ' time to finish median[ms]'
    p98_header = ' time to finish 98th percentile[ms]'
    mean_header = 'time to finish mean[ms]'
    rms_header = 'time to finish RMS'

    for file_path in csv_files:
        with open(file_path, 'r') as f:
            reader = csv.reader(f)
            header = next(reader)
            values = next(reader)
            
            # Get metadata and check for consistency
            current_nodes = int(values[header.index(nodes_header)])
            current_trips = int(values[header.index(trips_header)])
            current_iterations = int(values[header.index(iterations_header)])
            
            if nodes is None:
                nodes, trips, iterations = current_nodes, current_trips, current_iterations
            elif (nodes, trips, iterations) != (current_nodes, current_trips, current_iterations):
                print("Error: Mismatched metadata in CSV files.")
                sys.exit(1)

            # Get benchmark data
            lang = file_path.replace('.csv', '').replace('output/', '').title()
            median = float(values[header.index(median_header)])
            p98 = float(values[header.index(p98_header)])
            mean = float(values[header.index(mean_header)])
            rms = float(values[header.index(rms_header)])
            data[lang] = {'median': median, 'p98': p98, 'mean': mean, 'rms': rms}

    if data:
        svg_content = generate_svg(data, nodes, trips, iterations)
        with open('output/o-ring.svg', 'w') as f:
            f.write(svg_content)
