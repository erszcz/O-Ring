import pandas as pd
import plotly.graph_objects as go

# Define column names for the raw.dat file
column_names = [
    'language',
    'nodes',
    'trips',
    'repetition_index',
    'timeToSetupRing',
    'timeFromFirstToLastMessage'
]

# Read the raw.dat file into a pandas DataFrame
try:
    df = pd.read_csv(
        'output/raw.dat',
        sep=' ',
        header=None,
        names=column_names,
        skipinitialspace=True
    )
except FileNotFoundError:
    print("Error: output/raw.dat not found. Make sure the file exists in the output directory.")
    exit()

metrics = ['timeFromFirstToLastMessage', 'timeToSetupRing']
unique_langs = sorted(df['language'].unique())

# --- Plot 1: x-axis = nodes ---
fig1 = go.Figure()
unique_trips = sorted(df['trips'].unique())

for metric in metrics:
    for trip_val in unique_trips:
        for lang in unique_langs:
            dff = df[(df['trips'] == trip_val) & (df['language'] == lang)]
            fig1.add_trace(
                go.Box(
                    x=dff['nodes'],
                    y=dff[metric],
                    name=lang,
                    visible=(metric == metrics[0] and trip_val == unique_trips[0])
                )
            )

updatemenus1 = [
    {
        'buttons': [],
        'direction': 'down',
        'showactive': True,
        'x': 0.05, 'xanchor': 'left', 'y': 1.15, 'yanchor': 'top'
    },
    {
        'buttons': [],
        'direction': 'down',
        'showactive': True,
        'x': 0.35, 'xanchor': 'left', 'y': 1.15, 'yanchor': 'top'
    }
]

for i, metric in enumerate(metrics):
    visibility = [False] * len(fig1.data)
    for j in range(len(unique_trips) * len(unique_langs)):
        visibility[i * len(unique_trips) * len(unique_langs) + j] = True
    updatemenus1[0]['buttons'].append({
        'label': metric,
        'method': 'update',
        'args': [{'visible': visibility}]
    })

for i, trip_val in enumerate(unique_trips):
    visibility = [False] * len(fig1.data)
    for j in range(len(metrics)):
        for k in range(len(unique_langs)):
            visibility[j * len(unique_trips) * len(unique_langs) + i * len(unique_langs) + k] = True
    updatemenus1[1]['buttons'].append({
        'label': f'trips={trip_val}',
        'method': 'update',
        'args': [{'visible': visibility}]
    })

fig1.update_layout(updatemenus=updatemenus1, title_text='View 1: X-Axis = Nodes', boxmode='group')

# --- Plot 2: x-axis = trips ---
fig2 = go.Figure()
unique_nodes = sorted(df['nodes'].unique())

for metric in metrics:
    for node_val in unique_nodes:
        for lang in unique_langs:
            dff = df[(df['nodes'] == node_val) & (df['language'] == lang)]
            fig2.add_trace(
                go.Box(
                    x=dff['trips'],
                    y=dff[metric],
                    name=lang,
                    visible=(metric == metrics[0] and node_val == unique_nodes[0])
                )
            )

updatemenus2 = [
    {
        'buttons': [],
        'direction': 'down',
        'showactive': True,
        'x': 0.05, 'xanchor': 'left', 'y': 1.15, 'yanchor': 'top'
    },
    {
        'buttons': [],
        'direction': 'down',
        'showactive': True,
        'x': 0.35, 'xanchor': 'left', 'y': 1.15, 'yanchor': 'top'
    }
]

for i, metric in enumerate(metrics):
    visibility = [False] * len(fig2.data)
    for j in range(len(unique_nodes) * len(unique_langs)):
        visibility[i * len(unique_nodes) * len(unique_langs) + j] = True
    updatemenus2[0]['buttons'].append({
        'label': metric,
        'method': 'update',
        'args': [{'visible': visibility}]
    })

for i, node_val in enumerate(unique_nodes):
    visibility = [False] * len(fig2.data)
    for j in range(len(metrics)):
        for k in range(len(unique_langs)):
            visibility[j * len(unique_nodes) * len(unique_langs) + i * len(unique_langs) + k] = True
    updatemenus2[1]['buttons'].append({
        'label': f'nodes={node_val}',
        'method': 'update',
        'args': [{'visible': visibility}]
    })

fig2.update_layout(updatemenus=updatemenus2, title_text='View 2: X-Axis = Trips', boxmode='group')

# --- Write to HTML ---
with open('interactive_report.html', 'w') as f:
    f.write("<h1>Interactive Benchmark Report</h1>")
    f.write(fig1.to_html(full_html=False, include_plotlyjs='cdn'))
    f.write(fig2.to_html(full_html=False, include_plotlyjs=False))

print("Successfully generated interactive_report.html")
