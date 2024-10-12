#!/bin/bash

# follow clean up
input_file1="follow.csv"

awk -F'$' '
NR == 1 { print $0; next }  # Print header
!seen[$1, $2]++  # Filter out duplicates based on the first two fields
' "$input_file1" > "$input_file1.temp" & # Run in the background

echo "Processing $input_file1 in the background..."


# comment_like clean up
input_file2="comment_like.csv"

awk -F'$' '
NR == 1 { print $0; next }  # Print header
!seen[$1, $2]++  # Filter out duplicates based on the first two fields
' "$input_file2" > "$input_file2.temp" & # Run in the background

echo "Processing $input_file2 in the background..."


# comment_parent clean up
input_file3="comment_parent.csv"

awk -F'$' '
NR == 1 { print $0; next }  # Print header
!seen[$1]++  # Filter out duplicates based on the first field
' "$input_file3" > "$input_file3.temp" & # Run in the background

echo "Processing $input_file3 in the background..."


# post_like clean up
input_file4="post_like.csv"

awk -F'$' '
NR == 1 { print $0; next }  # Print header
!seen[$1, $2]++  # Filter out duplicates based on the first two fields
' "$input_file4" > "$input_file4.temp" & # Run in the background

echo "Processing $input_file4 in the background..."



# post_tag clean up
input_file5="post_tag.csv"

awk -F'$' '
NR == 1 { print $0; next }  # Print header
!seen[$1, $2]++  # Filter out duplicates based on the first two fields
' "$input_file5" > "$input_file5.temp" & # Run in the background

echo "Processing $input_file5 in the background..."

# Wait background jobs to finish before exiting
wait

# Move the temporary file back to the original input file (overwrite it)
mv "$input_file1.temp" "$input_file1"
mv "$input_file2.temp" "$input_file2"
mv "$input_file3.temp" "$input_file3"
mv "$input_file4.temp" "$input_file4"
mv "$input_file5.temp" "$input_file5"

echo "All files are processed and cleaned."


