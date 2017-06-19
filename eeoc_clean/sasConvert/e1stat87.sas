libname mylib '/myPathHere/';
proc export data = mylib.e1stat87.sas7bdat
outfile = '/myPathHere/e1stat87.csv'
dbms = csv
replace
;
run;
