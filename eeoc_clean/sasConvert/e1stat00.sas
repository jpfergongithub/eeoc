libname mylib '/myPathHere/';
proc export data = mylib.e1stat00.sas7bdat
outfile = '/myPathHere/e1stat00.csv'
dbms = csv
replace
;
run;
