
netCDF:  http://www.unidata.ucar.edu/software/netcdf/docs/index.html

netCDF includes libraries for implementing creating, reading and writing netCDF (.nc) files, as well as some handy command-line utilities.  One in particular `ncdump`, as its name implies, is able to display or dump the entire contents of a netCDF file as ascii, but its main utility is to display the headers of a netCDF file, including a description of the variables contained in the file, as well as the dimensions (latitude, longitude, time, etc.) of the data.  

In addition to `ncdump`, there are two sets of command line utilities, `CDO` and `NCO` (Climate Data Operators, and netCDF Operators, respectively), that can efficiently perfor many tasks, like regridding or concatenation individual `.nc` files:

- CDO:  https://code.zmaw.de/projects/cdo
- NCO:  http://nco.sourceforge.net/

## Windows ##

To set up the netCDF command-line utilities in Windows, 

1. download and install the netCDF-C library and utilites from  
[http://www.unidata.ucar.edu/software/netcdf/docs/winbin.html](http://www.unidata.ucar.edu/software/netcdf/docs/winbin.html)  (e.g. netCDF4.6.3-NC4-DAP-64.exe) 
2. Install as usual by clicking on the file; the destination folder  will likely be `c:\Program Files\netCDF 4.6.3\` 
3. When prompted, select "Add netCDF to the system PATH for all users" 
4. Check to make sure the `PATH` environment variable has been set:
	Control Panel > All Control Panel Items > System > Advanced System Settings > Environment Variables > System Variables Pane, Click on Path, and add the following if not present:  `c:\Program Files\netCDF 4.6.3\;c:\Program Files\netCDF 4.6.3\bin\;c:\Program Files\netCDF 4.6.3\lib\`
3. create a `.bat` (batch) file named `ncd.bat` in the netCDF folder created in the second step, with the following contents: 
 
   ```
	c:\Program Files\netCDF 4.6.3\bin\ncdump -c %1
	rem netCDF_4.6.3
	pause
```

Then, double-clicking on a .nc file, or in a command window, typing `ncd ncfile.nc` (where `ncfile.nc` is a netCDF file), should produce a listing of the headers and dimension variables in a netCDF file.

## Mac ##

netCDF, CDO and NCO (plus another useful utility, ncview) can most easily be installed via Homebrew:

1. Install Homebrew, if you don't have it already: ```http://brew.sh/index.html ```
2. Then install netCDF and the untilites by pasting the following into a terminal window
```	
	brew tap homebrew/science
	brew install netcdf
	brew install moffat/sciencebits/cdo
	brew install nco
```
3. Make a text file simply named `ncd`, with following contents, and place in the folder `/usr/local/bin/`

    ```
	#! /bin/bash
	pwd
	/usr/local/Cellar/netcdf/4.6.3/bin/ncdump -c $1
```
(Note that the folder path may need to be adjusted; at the time of this writing the current version of netCDF on Homebrew was `4.6.3`.  The approprate path can be found by typing `locate ncdump` at the command prompt, which should yield a reply like /`usr/local/Cellar/netcdf/4.6.3/bin/ncdump`)

4. Make the file executable by opening a Terminal window in `/usr/local/bin/` and typing:

	```
	chmod +x ncd
```

Then opening a Terminal window in the folder with the netCDF file in it and typing `ncd ncfile.nc` (where "`ncfile.nc`" is the name of the netCDF file) should should produce a listing of the headers and dimension variables in a netCDF file.

Note that `ncdump` (as opposed to `ncd`) can also be used directly in a command/Terminal window. Typing `ncdump -ct ncfile.nc` produces a standard listing of the headers, but prints the Time variable in human-interpretable form.
