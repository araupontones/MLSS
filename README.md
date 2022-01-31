# MLSS
Dashboard of the MLSS survey

# Importing zip files from rounds
A zip file with the derived datasets of students, teachers, and schools.

[Uploads and downloads](https://mastering-shiny.org/action-transfer.html)


## Guide to Importing

* Create a zip file with the three datasets (school, teacher, and students). The format of the datasets must be .dta (stata files)
* The names of the .dta files should contain the words school, teacher, and students.
* The files must include the all variables specified by the World Bank (see guide, and data/reference/(...)_vars.csv)


### Importing backend protocol

1. Check that the selected round has not been imported yet (if imported, error, import)
2. Check that the files contain three files and that they are named school, teacher, student
3. Check that the files contain the variables indicated in the guide
4. Save in data/imports/round
5. Append rounds into a panel format


## R files to prepare the data

**save_reference_var_names.R**
It takes the reference files stored in data/reference/raw and filters only the targeted variables (For_Dashboard == TRUE, which was created manually from *varNamesPupuls RG.xlsx*).
The output of this script are 3 files in csv format (school_vars.csv, teacher_vars.csv, student_vars.csv) stored in data/reference
that serve as a look up tables in the dashboard to:

a) Check that the files uploaded by the user contain all the target variables
b) Identify the variables that work as filters



## Thigs to do
1. Add a column to the data/reference/raw that includes a detailed description of each indicator (this will be used when the indicator is displayed)
2. Create a module for uploading the data (ui and server)
3. Protect the section to upload the data with a password
4. Check with WB for the derived Midline and Endline
5. Import the Midline and Endline and write a protocol to append the three rounds into a single panel data
6. Check with WB when more data is expected and how these rounds will be called.
7. Write a users' guide to upload the data (considering all the points in the [Importing Protocol](#importing-backend-protocol))

## things to review

a) error messages
b) stop if error
c) reactivity of datasets
d) reduce size of data (to csv maybe of json possible)
