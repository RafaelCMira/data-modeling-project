import os
import pandas as pd
import matplotlib.pyplot as plt


files_to_process = [
    "default_parallel.csv",
    "1GB_parallel.csv",
    "2GB_parallel.csv",
    "4GB_parallel.csv",
    "8GB_parallel.csv",
]

colors = {
    "default_parallel.csv": "#287db7",
    "1GB_parallel.csv": "#ff993f",
    "2GB_parallel.csv": "#53b153",
    "4GB_parallel.csv": "#976bbf",
    "8GB_parallel.csv": "#d73031",
}

aggregation_interval = 1  # Aggregate results over this many minutes


def process_csv(file_path):
    df = pd.read_csv(file_path)

    # Normalize timestamps (start from 0 and convert to seconds)
    min_timestamp = df["timeStamp"].min()
    df["normalized_time"] = (
        df["timeStamp"] - min_timestamp
    ) / 1000  # Convert to seconds

    # Group by minute intervals and calculate throughput
    df["time_bucket"] = (df["normalized_time"] // (60 * aggregation_interval)).astype(
        int
    )

    throughput = df.groupby("time_bucket").size().reset_index(name="throughput")

    return throughput


def generate_graph(output_file: str, user: str, dbms: str, dataset: str, yMax: int):
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    input_dir = os.path.join(base_dir, "csv_results", user, dbms, f"dataset {dataset}")

    # Vsers by time
    vusers_by_time = {
        0: 4,  # 0-2 minutes: 4 vusers
        2: 8,  # 2-4 minutes: 8 vusers
        4: 16,  # 4-6 minutes: 16 vusers
        6: 32,  # 6-8 minutes: 32 vusers
        8: 48,  # 8-10 minutes: 48 vusers
        10: 64,  # 10+ minutes: 64 vusers
    }

    plt.figure(figsize=(10, 6))

    for file_name in files_to_process:
        file_path = os.path.join(input_dir, file_name)

        throughput = process_csv(file_path)

        plt.plot(
            throughput["time_bucket"],
            throughput["throughput"],
            label=file_name.replace("_parallel.csv", ""),
            color=colors[file_name],
        )

    # Add title and labels
    plt.title(f"{dbms.capitalize()} performance")
    plt.xlabel("Time (minutes)")
    plt.ylabel("Requests per minute")

    plt.legend(
        title="Configuration",
        loc="upper center",
        bbox_to_anchor=(0.5, -0.15),
        ncol=5,
        fancybox=True,
        shadow=True,
    )

    for time, vusers in vusers_by_time.items():
        if time != 0:
            plt.axvline(
                x=time,
                color="grey",
                linestyle="--",
                linewidth=1,
                alpha=0.8,  # Line transparency
            )

        padding = 0.5

        if time == 0:
            padding = 0.3
        elif time == 2:
            padding = 0.6
        elif time == 10:
            padding = 0.8

        plt.text(
            x=time + padding,
            y=yMax * 0.90,
            s=f"{vusers} vusers",
            color="black",
            fontsize=9,
            ha="left",
        )

    # Apply axis limits
    plt.ylim(0, yMax)

    # Add grid
    plt.grid(alpha=0)

    # Show the graph
    plt.tight_layout()
    # plt.show()

    plt.savefig(
        output_file,
        format="pdf",
    )


user = "jose"
dataset = "3"
dbms = "neo4j"
yMax = 4600

generate_graph(
    output_file=f"parallel - {dbms} - {dataset} - {user}.pdf",
    user=user,
    dbms=dbms,
    dataset=dataset,
    yMax=yMax,
)


dbms = "postgres"

generate_graph(
    output_file=f"parallel - {dbms} - {dataset} - {user}.pdf",
    user=user,
    dbms=dbms,
    dataset=dataset,
    yMax=yMax,
)
