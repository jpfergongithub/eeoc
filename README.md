# eeoc
Code and supplementary files for working with EEOC data

A lot of us who work with the Equal Employment Opportunity Commission's data do so through Intergovernmental Personnel Act agreements. We get access to the data for a limited time; later, to work on it again, we have to re-request it. Each time, we have to start with the SAS7BDAT files that the EEOC exports. I've had headaches trying to convert and clean up these data, and I figure I'm not alone.

In principle, you can convert SAS files into something like R or Stata using software like Stat/Transfer. In practice, several of these files' fields are compressed, using an old SAS binary format that S/T has serious trouble with. These files throw a lot of conversion errors, more the older they are. In my experience, S/T craps out before about 1982.

My eventual solution was to write some short SAS code that, if you have a copy of SAS, can read in these files and write CSVs. (I have a shell script that loops over each file.) Then I have Stata code to clean up each annual file and glom them together. The result is a 4GB longitudinal dataset.

Obviously I can't host the EEOC's raw data here--that would violate my agreement, and the law! But I can host the code for cleaning their files; and given that I think everyone starts with the same raw files, this code will probably be useful to someone.
