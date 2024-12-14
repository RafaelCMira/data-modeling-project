import os
import pandas as pd


# Create the 'samples' directory if it doesn't exist
def create_samples_directory(input_dir: str):
    output_dir = os.path.join(input_dir, "samples for individual graphs")
    os.makedirs(output_dir, exist_ok=True)
    return output_dir


# Determine unique labels from default.csv
def find_label(input_dir: str):
    default_file = os.path.join(input_dir, "default.csv")
    if not os.path.exists(default_file):
        raise FileNotFoundError(f"'{default_file}' does not exist.")

    df_default = pd.read_csv(default_file)
    labels = df_default["label"].unique()
    return labels


def process_csv_files():
    # Define the relative path to the CSV files directory
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    input_dir = os.path.join(base_dir, "csv_results", "rafael", "postgres", "dataset 3")
    print("Resolved input directory:", input_dir)

    output_dir = create_samples_directory(input_dir)

    labels = find_label(input_dir)

    for label in labels:
        label_path = os.path.join(output_dir, f"{label}.csv")

        # Initialize an empty DataFrame with the required columns
        label_df = pd.DataFrame(
            columns=["experiment_index", "elapsed", "label", "experiment"]
        )

        files_to_process = ["default.csv", "1GB.csv", "2GB.csv", "4GB.csv", "8GB.csv"]

        for index, csv_file in enumerate(files_to_process, start=1):
            file_path = os.path.join(input_dir, csv_file)
            experiment_name = os.path.splitext(csv_file)[0]

            # Read the current CSV file and filter by label
            df = pd.read_csv(file_path)
            filtered_df = df[df["label"] == label]
            filtered_df = filtered_df[["elapsed", "label"]]
            filtered_df["experiment"] = experiment_name
            filtered_df["experiment_index"] = range(1, len(filtered_df) + 1)

            # Append to the label-specific DataFrame
            label_df = pd.concat([label_df, filtered_df], ignore_index=True)

        label_df.to_csv(label_path, index=False)


if __name__ == "__main__":
    process_csv_files()
