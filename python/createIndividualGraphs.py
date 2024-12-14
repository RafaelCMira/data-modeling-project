import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.lines as mlines

visible_experiments = [
    "default",
    "1GB",
    "2GB",
    "4GB",
    "8GB",
]

colors = {
    "default": "#287db7",
    "1GB": "#ff993f",
    "2GB": "#53b153",
    "4GB": "#976bbf",
    "8GB": "#d73031",
}


def get_file_path(user: str, dbms: str, dataset: str, file_name: str):
    if user not in ["rafael", "jose"]:
        raise ValueError(f"Invalid user '{user}'")

    if dbms not in ["postgres", "neo4j"]:
        raise ValueError(f"Invalid DBMS '{dbms}'")

    if dataset not in ["0.3", "1", "3"]:
        raise ValueError(f"Invalid dataset '{dataset}'")

    # Define the path to the samples directory
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    samples_dir = os.path.join(
        base_dir,
        "csv_results",
        user,
        dbms,
        f"dataset {dataset}",
        "samples for individual graphs",
    )

    # Define the file to process
    file_path = os.path.join(samples_dir, file_name)

    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File '{file_name}' does not exist in '{samples_dir}'")

    return file_path


def generate_graph():
    file_name = "1 - Transitive friends - step 3.csv"
    dbms = "neo4j"
    dataset = "0.3"
    user = "jose"
    file_path = get_file_path(user, dbms, dataset, file_name)

    df = pd.read_csv(file_path)

    df_filtered = df[df["experiment"].isin(visible_experiments)]

    # Define optional axis limits
    y_axis_min = 0  # Set to None for auto-scaling
    y_axis_max = 190  # Set to None for auto-scaling

    # Generate the graph
    plt.figure(figsize=(10, 6))

    # specific_value = 100  # The Y value where the line and marker are added
    # plt.axhline(
    #     y=specific_value, color="green", linestyle=(0, (5, 5)), linewidth=1, alpha=0.7
    # )  # Horizontal line

    # # Add a horizontal marker on the Y-axis
    # plt.text(
    #     x=-0.17,  # Slightly to the left of the Y-axis
    #     y=specific_value,  # Align with the horizontal line
    #     s=specific_value,
    #     color="black",
    #     ha="center",  # Horizontal alignment
    #     va="center",  # Vertical alignment
    #     fontsize=10,  # Size of the value
    # )

    for experiment in visible_experiments:
        experiment_df = df_filtered[df_filtered["experiment"] == experiment]

        x_axis = experiment_df["experiment_index"]
        y_axis = experiment_df["elapsed"]

        # Plot dots
        plt.scatter(
            x_axis,
            y_axis,
            label=experiment,
            color=colors.get(experiment, "black"),
            marker="o",
        )

        # Connect dots in groups of 4
        for i in range(0, len(x_axis), 4):
            plt.plot(
                x_axis[i : i + 4],
                y_axis.iloc[i : i + 4],
                color=colors.get(experiment, "black"),
            )

    # Add a title and labels
    plt.title("Response Time by Experiment")

    # Add axis labels
    plt.xlabel("Experiments")
    plt.ylabel("Response time (ms)")

    plt.legend(
        title="Configuration",
        loc="upper center",
        bbox_to_anchor=(0.5, -0.15),
        ncol=5,
        fancybox=True,
        shadow=True,
    )

    # Add a grid
    plt.xticks(range(1, 17))

    # Apply axis limits
    plt.ylim(y_axis_min, y_axis_max)

    # Show the graph as a window
    plt.tight_layout()
    # plt.show()
    # plt.savefig("output_graph.pdf", format="pdf")
    plt.savefig(
        file_name.replace(".csv", "") + f" - {dbms} - dataset {dataset} - {user}.pdf",
        format="pdf",
    )


# Example usage
if __name__ == "__main__":
    generate_graph()
