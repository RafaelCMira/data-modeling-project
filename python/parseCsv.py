import pandas as pd


def calculate_metrics(csv_file, ignore_labels=None):
    # Load the data from the CSV file
    df = pd.read_csv(csv_file)

    # Convert timestamp to datetime for throughput calculation
    df["timeStamp"] = pd.to_datetime(df["timeStamp"], unit="ms")

    # Exclude specified labels if provided
    if ignore_labels:
        df = df[~df["label"].isin(ignore_labels)]

    # Group by label and calculate metrics
    metrics = (
        df.groupby("label")
        .agg(
            avg_response_time=("elapsed", "mean"),
            min_response_time=("elapsed", "min"),
            max_response_time=("elapsed", "max"),
            std_dev=("elapsed", "std"),
            throughput=(
                "timeStamp",
                lambda x: len(x) / ((x.max() - x.min()).total_seconds() or 1),
            ),
            p95=("elapsed", lambda x: x.quantile(0.95)),
            p99=("elapsed", lambda x: x.quantile(0.99)),
        )
        .reset_index()
    )

    # Round results at the end for readability
    metrics["avg_response_time"] = metrics["avg_response_time"].round(2)
    metrics["min_response_time"] = metrics["min_response_time"].round(2)
    metrics["max_response_time"] = metrics["max_response_time"].round(2)
    metrics["std_dev"] = metrics["std_dev"].round(
        2
    )  # Same unit as elapsed (milliseconds)
    metrics["throughput"] = metrics["throughput"].round(
        4
    )  # Higher precision for throughput
    metrics["p95"] = metrics["p95"].round(2)
    metrics["p99"] = metrics["p99"].round(2)

    return metrics


# Example usage
if __name__ == "__main__":
    input_file = "report.csv"  # Replace with your CSV file path
    labels_to_ignore = [
        "6.0 - K shortest paths - Create graph",
        "6.2 - K Shortest paths - Drop graph",
    ]  # Replace with labels to ignore
    metrics = calculate_metrics(input_file, ignore_labels=labels_to_ignore)
    print(metrics)
