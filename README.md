# MLSS
Dashboard of the MLSS survey

# Importing zip files from rounds
A zip file with the derived datasets of students, teachers, and schools.

[Uploads and downloads](https://mastering-shiny.org/action-transfer.html)


## Guide to Importing

* Create a zip file with the three datasets. The format of the datasets must be .dta
* The names of the .dta files should contain the words school, teacher, and students.


### Importing backend protocol

1. Check that the selected round has not been imported yet (if imported, error, import)
2. Check that the files contain three files and that they are named school, teacher, student
3. Check that the files contain the variables indicated in the guide
4. Save in data/imports/round


## things to review

a) error messages
b) stop if error
c) reactivity of datasets
