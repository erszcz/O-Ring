import pandas as pd
import plotly.graph_objects as go

# Define column names for the raw.dat file
column_names = ["language", "nodes", "trips", "run", "setup time", "run time"]

# Read the raw.dat file into a pandas DataFrame
try:
    df = pd.read_csv(
        "output/raw.dat",
        sep=" ",
        header=None,
        names=column_names,
        skipinitialspace=True,
    )
except FileNotFoundError:
    print(
        "Error: output/raw.dat not found. Make sure the file exists in the output directory."
    )
    exit()

metrics = ["run time", "setup time"]
unique_langs = sorted(df["language"].unique())

# --- Plot 1: x-axis = nodes ---
fig1 = go.Figure()
unique_trips = sorted(df["trips"].unique())

for metric in metrics:
    for trip_val in unique_trips:
        medians = {
            lang: df[(df["trips"] == trip_val) & (df["language"] == lang)][
                metric
            ].median()
            for lang in unique_langs
        }
        sorted_langs = sorted(unique_langs, key=lambda lang: medians[lang])
        for lang in sorted_langs:
            dff = df[(df["trips"] == trip_val) & (df["language"] == lang)]
            fig1.add_trace(
                go.Box(
                    x=dff["nodes"],
                    y=dff[metric],
                    name=lang,
                    visible=(metric == metrics[0] and trip_val == unique_trips[0]),
                )
            )

updatemenus1 = [
    {
        "buttons": [],
        "direction": "down",
        "showactive": True,
        "x": 0.05,
        "xanchor": "left",
        "y": 1.15,
        "yanchor": "top",
    },
    {
        "buttons": [],
        "direction": "down",
        "showactive": True,
        "x": 0.35,
        "xanchor": "left",
        "y": 1.15,
        "yanchor": "top",
    },
]

N_langs1 = len(unique_langs)
N_trips1 = len(unique_trips)

for i, metric in enumerate(metrics):
    buttons = []
    for j, trip_val in enumerate(unique_trips):
        visibility = [False] * len(fig1.data)
        start_idx = i * N_trips1 * N_langs1 + j * N_langs1
        for k in range(N_langs1):
            visibility[start_idx + k] = True
        buttons.append(
            {
                "label": f"trips={trip_val}",
                "method": "update",
                "args": [{"visible": visibility}],
            }
        )

    updatemenus1[0]["buttons"].append(
        {
            "label": f"{metric} (ms)",
            "method": "update",
            "args": [
                {"visible": [False] * len(fig1.data)},
                {"updatemenus[1].buttons": buttons},
            ],
        }
    )
    if i == 0:
        updatemenus1[0]["buttons"][0]["args"][0]["visible"] = [
            True if l < N_langs1 else False for l in range(len(fig1.data))
        ]

# Initial buttons for the second dropdown
initial_buttons1 = []
for i, trip_val in enumerate(unique_trips):
    visibility = [False] * len(fig1.data)
    for k in range(N_langs1):
        visibility[i * N_langs1 + k] = True
    initial_buttons1.append(
        {
            "label": f"trips={trip_val}",
            "method": "update",
            "args": [{"visible": visibility}],
        }
    )
updatemenus1[1]["buttons"] = initial_buttons1

fig1.update_layout(
    updatemenus=updatemenus1,
    title_text="View 1: X-Axis = Nodes",
    boxmode="group",
    yaxis_title=f"{metrics[0]} (ms)",
)

# --- Plot 2: x-axis = trips ---
fig2 = go.Figure()
unique_nodes = sorted(df["nodes"].unique())

for metric in metrics:
    for node_val in unique_nodes:
        medians = {
            lang: df[(df["nodes"] == node_val) & (df["language"] == lang)][
                metric
            ].median()
            for lang in unique_langs
        }
        sorted_langs = sorted(unique_langs, key=lambda lang: medians[lang])
        for lang in sorted_langs:
            dff = df[(df["nodes"] == node_val) & (df["language"] == lang)]
            fig2.add_trace(
                go.Box(
                    x=dff["trips"],
                    y=dff[metric],
                    name=lang,
                    visible=(metric == metrics[0] and node_val == unique_nodes[0]),
                )
            )

updatemenus2 = [
    {
        "buttons": [],
        "direction": "down",
        "showactive": True,
        "x": 0.05,
        "xanchor": "left",
        "y": 1.15,
        "yanchor": "top",
    },
    {
        "buttons": [],
        "direction": "down",
        "showactive": True,
        "x": 0.35,
        "xanchor": "left",
        "y": 1.15,
        "yanchor": "top",
    },
]

N_langs2 = len(unique_langs)
N_nodes2 = len(unique_nodes)

for i, metric in enumerate(metrics):
    buttons = []
    for j, node_val in enumerate(unique_nodes):
        visibility = [False] * len(fig2.data)
        start_idx = i * N_nodes2 * N_langs2 + j * N_langs2
        for k in range(N_langs2):
            visibility[start_idx + k] = True
        buttons.append(
            {
                "label": f"nodes={node_val}",
                "method": "update",
                "args": [{"visible": visibility}],
            }
        )

    updatemenus2[0]["buttons"].append(
        {
            "label": f"{metric} (ms)",
            "method": "update",
            "args": [
                {"visible": [False] * len(fig2.data)},
                {"updatemenus[1].buttons": buttons},
            ],
        }
    )
    if i == 0:
        updatemenus2[0]["buttons"][0]["args"][0]["visible"] = [
            True if l < N_langs2 else False for l in range(len(fig2.data))
        ]

# Initial buttons for the second dropdown
initial_buttons2 = []
for i, node_val in enumerate(unique_nodes):
    visibility = [False] * len(fig2.data)
    for k in range(N_langs2):
        visibility[i * N_langs2 + k] = True
    initial_buttons2.append(
        {
            "label": f"nodes={node_val}",
            "method": "update",
            "args": [{"visible": visibility}],
        }
    )
updatemenus2[1]["buttons"] = initial_buttons2

fig2.update_layout(
    updatemenus=updatemenus2,
    title_text="View 2: X-Axis = Trips",
    boxmode="group",
    yaxis_title=f"{metrics[0]} (ms)",
)

# --- Write to HTML ---
with open("output/interactive_report.html", "w") as f:
    f.write("<h1>Interactive Benchmark Report</h1>")
    f.write(fig1.to_html(full_html=False, include_plotlyjs="cdn"))
    f.write(fig2.to_html(full_html=False, include_plotlyjs=False))

print("Successfully generated interactive_report.html")
