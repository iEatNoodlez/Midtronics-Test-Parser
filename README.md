# Midtronics-Test-Parser
A powershell based battery test parser for Franklin Grid's Celltron Ultra (Also refered to as a modtronics)

Input CSV: The input file is expected to have the first line as the schema (headers), followed by rows containing battery test data.
Separation by Strings: The script extracts the Site, Plant, and String from each row and groups the data accordingly.
Output CSV: For each unique combination of Site, Plant, and String, the script creates a separate CSV file named [Site] - [Plant] - [String].csv.
Output Folder: A subfolder named with the current date and time (e.g., 2024-10-12_14-30-45) is created in the script's directory, where the output files are saved.
Handling Missing Data: If any of the Site, Plant, or String fields are missing or null, they are replaced with the value UNKNOWN in the output file names and content.

Prerequisites

    Windows PowerShell
    A CSV file in the expected format (with schema as the first line)

Usage Instructions
1. Drag and Drop the CSV File

    Run the script by right-clicking on it and selecting Run with PowerShell.
    When prompted, drag and drop the Midtronics CSV file into the PowerShell console window and press Enter.

2. Output Files

    The script will create a new subfolder in the same directory as the script. The folder will be named based on the current date and time of execution (e.g., 2024-10-12_14-30-45).
    Inside this folder, you will find CSV files for each unique combination of Site, Plant, and String.

3. Example

If the input CSV contains the following data:

Site,Plant,String,Jar,Date,Time,...
ANAKTUVUK,ANAK,A,JAR1,...
ANAKTUVUK,ANAK,B,JAR1,...
CHALKYITSIK UUI CO,GNB 90A-09,STRING 1,JAR1,...

The script will generate files like:

ANAKTUVUK - ANAK - A.csv
ANAKTUVUK - ANAK - B.csv
CHALKYITSIK UUI CO - GNB 90A-09 - STRING 1.csv

Each CSV file will include the schema (header row) followed by the relevant data for that particular string.


Error Handling

    If a row is missing values for Site, Plant, or String, those fields will be replaced with 'UNKNOWN' in the output files.
    Ensure that the input CSV is formatted correctly, with the schema (headers) in the first row.
