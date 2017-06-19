/* List all files in a folder into the "filenames" sas dataset found in the "Work" library */
%macro get_filenames(location);
filename _dir_ "%bquote(&location.)";
data filenames(keep=memname);
  handle=dopen( '_dir_' );
  if handle > 0 then do;
    count=dnum(handle);
    do i=1 to count;
      memname=dread(handle,i);
      output filenames;
    end;
  end;
  rc=dclose(handle);
run;
filename _dir_ clear;
%mend;
%get_filenames(C:\Users\Lenovo\Desktop\sasconvert);  

/* Eliminate any duplicate names of the file names stored in the SAS data set */
proc sort data=filenames nodupkey;
by memname;
run;

/* Eliminate the extension from the filenames */
data Filenames;
set Filenames;
index = index(memname, '.');
if index = 0 then memname_short = memname;
if index ^= 0 then memname_short = SUBSTR(memname, 1, index -1 );
drop memname;
drop index;
rename memname_short = memname;
run;

/* Run a DATA _NULL_ step to create 2 macro variables - one with the names of each SAS data set 
and the other with the final count of the number of SAS data sets */
data _null_;
  set filenames end=last;
  by memname;
  i+1;
  call symputx('name'||trim(left(put(i,8.))),memname);
  if last then call symputx('count',i);
run;

/* Macro containing the PROC EXPORT that executes for each file */
%macro combdsets;
	%do i=1 %to &count;
		proc export data = Lib.&&name&i
		outfile = "C:\Users\Lenovo\Desktop\sasconvert\&&name&i...csv"
		dbms = csv
		replace;
		run;
	%end;
%mend combdsets;
%combdsets
