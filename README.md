WanderSafe, by The Data Surgeons
@govhack2017
__________________________________

How to set up:

A WKT file containing mesh block ID needs to be generated, if not already. Once
this is done, run set_up_wandersafe_meshblock_database.sql to set up the appropriate
tables, credentials, and load the data in. Please note this requires a working 
MySQL installation.

To use:

This is built using R Shiny, and the files needed for this are:

- ui.r
- server.r
- geo_functions.r

There are several dependencies which may need to be installed before you can run the
application.  This was tested using RStudio Server on a Linux host, and the web app
was tested on Apple, Android and desktop browsers.
