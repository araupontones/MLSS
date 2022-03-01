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


**create_look_up_tables.R**
The idea is to create a collaborative environment in which the world bank can specify details of the indicators to be displayed in the dashboard. For this a [Google Sheet](https://docs.google.com/spreadsheets/d/1S2X-fXJ0hb5r0m5JUury7I7Yqg0IAPmISBec57RQYFU/edit#gid=1069976462) has been created. Thus, the idea is that everytime that a change in the specs of the variables is done in the cloud, the system will pull those changes into the lookup tables.

This script, reads the Google Sheets and creates lookup tables that are used in the dashboard. This lookup tables include: 

a) variables to include in the dropdown menu of indicators
b) all the variables that the protocol to upload the data checks for.
c) Divisions
d) District


The lookup tables are stored in `/data/reference/lookups`. There is a specific directory for each level (school, teacher, student)

# Guide to create a server

1. Create a droplet in Digital Ocean
2. Create a root password: @2022mlSS
3. Add a new user with sudo credentials: 

Password of rstudio: rstudio

```
adduser rstudio`
gpasswd -a rstudio sudo
```

4. Change to the created user
`su - rstudio`

5. Install nginx
```
sudo apt-get update
sudo apt-get -y install nginx
```

6. Install R
`sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list'`

add public keys
```
gpg --keyserver keyserver.ubuntu.com --recv-key E298A3A825C0D65DFD57CBB651716619E084DAB9
gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | sudo apt-key add -
```

and install
```
sudo apt-get update
sudo apt-get -y install r-base
```

Test that R is istalled by running `R` in the command line. Quit R `q()`



7. Install shiny-server 
[Steps to install shiny server](https://www.rstudio.com/products/shiny/download-server/ubuntu/)

8. Install R packages

`sudo su - -c "R -e \"install.packages('plyr', repos='http://cran.rstudio.com/')\""`

`sudo su - -c "R -e \"remotes::install_version('Rttf2pt1', version = '1.3.8')\""`
r

Dependencies to run the dashboard
```
library(shiny)
library(stringr)
library(glue)
library(shinyFeedback) #only if validate is used
library(rio)
library(dplyr)
library(tidyr)
library(shinymanager)
library(shinyccloaders)
library(plyr)
<<<<<<< HEAD
=======
library(reactable)
library(reactablefmtr)
library(scales)
>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c
```

9. Assign admin credentials to shiny user
The shiny apps are run by the shiny user. Thus, higher level credentials should be added to this user.

```
sudo groupadd shiny-apps
sudo usermod -aG shiny-apps rstudio
sudo usermod -aG shiny-apps shiny
cd /srv/shiny-server
sudo chown -R rstudio:shiny-apps .
sudo chmod g+w .
sudo chmod g+s .

```
10. move application to /srv/shiny-server/MLSS

11. **Install fonts in R** 
For the charts to read costumed fonts in the server, the fonts should be installed first. 

A [repositary](https://github.com/araupontones/fonts) that contains the fonts used in the dashbaord has been created. 

These are steps to follow:

a. In Linux: cd `/usr/share/fonts/`

b. Download a .zip with the fonts. From github, get the dowload link : `wget https://github.com/araupontones/fonts/raw/main/Noto_Sans.zip`

c. `mkdir` with the name of the font (e.g. Nano-Sans)
d. `cd` to the new dir (e.g. `cd Nano-Sans`)

e. `unzip file.zip` (e.g. `unzip Nano-Sans.zip`)

f. `cd ..`

g.  Copy the font into truetype `cp -R Name_font /usr/share/fonts/truetype`


Once the font is installed in the server, it has to be loeaded in R:

In the terminal, assign root credentials to `/usr/local/lib/R/site-library/extrafontdb` so the users root, rstudio, and shiny can access these fonts.

a. Access rstudio
b. Check the fonts available in R `extrafont::fonts()`
c. Import the new font `extrafont::font_import()`
d. Load the font into the session `extrafont::loadfonts()`



## collaborative design
To ease and motivate a collaborative environment in which different stakeholders, specifically the World Bank, a  [Google Sheet](https://docs.google.com/spreadsheets/d/1S2X-fXJ0hb5r0m5JUury7I7Yqg0IAPmISBec57RQYFU/edit#gid=1069976462) was created. The objective of this  [Google Sheet](https://docs.google.com/spreadsheets/d/1S2X-fXJ0hb5r0m5JUury7I7Yqg0IAPmISBec57RQYFU/edit#gid=1069976462) is to allow colleagues to provide information about the content of the dashboard. These sheets (school, teacher, and students) contain all the indicators to be displayed by the dashboard, a column to indicate the label to be used, and a description to be displayed when a user select that indicator in the dashboard. This sheet also includes a column to indicate the type of variable (binary, continuous, id). All these information is used in the dashboard. 

## Thigs to do


4. Check with WB for the derived Midline and Endline [pending answer]
5. Import the Midline and Endline and write a protocol to append the three rounds into a single panel data
6. Check with WB when more data is expected and how these rounds will be called.
7. Write a users' guide to upload the data (considering all the points in the [Importing Protocol](#importing-backend-protocol))
8. Customize log in page [shinymanager](https://datastorm-open.github.io/shinymanager/)


11. Ask WB for description of indicators


19. Confirm with WB which variables require % labels in Y axis (apart from binary)

20. Let the WB know that the teacher data does not have division_nam and district_nam

21. Change labels of fill variables using lookups


23. Ask world bank mail of administrator

<<<<<<< HEAD
=======
24. Change colors of bars in table

>>>>>>> a744f8fdd4c80e6cda7d0b34ac1792b0d300d27c



## things to review

a) error messages
b) stop if error
c) reactivity of datasets
d) reduce size of data (to csv maybe of json possible)
