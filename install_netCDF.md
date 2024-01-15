
# netCDF # 

[[http://www.unidata.ucar.edu/software/netcdf/docs/index.html]](http://www.unidata.ucar.edu/software/netcdf/docs/index.html)

netCDF includes libraries for implementing creating, reading and writing netCDF (.nc) files, as well as some handy command-line utilities.  One in particular `ncdump`, as its name implies, is able to display or dump the entire contents of a netCDF file as ascii, but its main utility is to display the headers of a netCDF file, including a description of the variables contained in the file, as well as the dimensions (latitude, longitude, time, etc.) of the data.  However, the same information is provided by Panoply (see below, so the installation of netCDF is more-or-less optional, and is described here for completeness.

In addition to `ncdump`, there are two sets of command line utilities, `CDO` and `NCO` (Climate Data Operators, and netCDF Operators, respectively), that can efficiently perfor many tasks, like regridding or concatenation individual `.nc` files:

- CDO:  https://code.zmaw.de/projects/cdo
- NCO:  http://nco.sourceforge.net/

## Windows ##

To set up the netCDF command-line utilities in Windows, 

1. download and install the netCDF-C library and utilites from  
[http://www.unidata.ucar.edu/software/netcdf/docs/winbin.html](http://www.unidata.ucar.edu/software/netcdf/docs/winbin.html)  (e.g. `netCDF4.9.2-NC4-DAP-64.exe`) 
2. Install as usual by clicking on the file; the destination folder will likely be `"c:/Program Files/netCDF 4.9.2/"` 
3. When prompted, select "Add netCDF to the system PATH for all users" 
4. Check to make sure the `PATH` environment variable has been set:
	Control Panel > All Control Panel Items > System > Advanced System Settings > Environment Variables > System Variables Pane, Click on Path, and add the following if not present:  `"c:/Program Files/netCDF 4.9.2/"`; `"c:/Program Files/netCDF 4.9.2/bin/"`; `"c:/Program Files/netCDF 4.9.2/lib/"`
3. create a `.bat` (batch) file named `ncd.bat` in the netCDF folder created in the second step, with the following contents: 
 
```
	"c:/Program Files/netCDF 4.9.2/bin/ncdump" -c %1
	rem netCDF_4.9.2
	pause
```

Then, double-clicking on a .nc file, or in a command window, typing `ncd ncfile.nc` (where `ncfile.nc` is a netCDF file), should produce a listing of the headers and dimension variables in a netCDF file.

On Windows, the CDO and NCO utilities can be installed in the "Windows Subsystem for Linux (WSL 2) [[https://learn.microsoft.com/en-us/windows/wsl/about]](https://learn.microsoft.com/en-us/windows/wsl/about)

## MacOS ##

netCDF, CDO and NCO (plus another useful utility, ncview) can most easily be installed via Homebrew:

Install Homebrew, if you don't have it already: [[http://brew.sh/index.html]](http://brew.sh/index.html)

If already installed, update Homebrew  (see [https://github.com/Homebrew/brew/blob/master/docs/FAQ.md](https://github.com/Homebrew/brew/blob/master/docs/FAQ.md)): 

```
	brew update
	brew upgrade
	brew cleanup
```

Then install netCDF by pasting the following into a terminal window

```
	brew install netcdf	
```

Make a text file simply named `ncd`, with following contents, and place in the folder `/usr/local/bin/`

```
	#! /bin/bash
	pwd
	/usr/local/Cellar/netcdf/4.9.2_1/bin/ncdump -c $1
```

(Note that the folder path may need to be adjusted; at the time of this writing the current version of netCDF on Homebrew was `4.9.2_1`.  The appropriate path can be found by typing `locate ncdump` at the command prompt, which should yield a reply like `/usr/local/Cellar/netcdf/4.9.2_1/bin/ncdump`)

Make the file executable by opening a Terminal window in `/usr/local/bin/` and typing:

```
	chmod +x ncd
```

Then opening a Terminal window in the folder with the netCDF file in it and typing `ncd ncfile.nc` (where "`ncfile.nc`" is the name of the netCDF file) should should produce a listing of the headers and dimension variables in a netCDF file.

Note that `ncdump` (as opposed to `ncd`) can also be used directly in a command/Terminal window. Typing `ncdump -ct ncfile.nc` produces a standard listing of the headers, but prints the Time variable in human-interpretable form.

Install the CDO and NCO utilities as follows:

See [https://code.mpimet.mpg.de/projects/cdo/wiki/MacOS_Platform](https://code.mpimet.mpg.de/projects/cdo/wiki/MacOS_Platform)

CDO can be installed by typing:
	
```	
	brew install cdo
```

Check the installation (note that there are two hyphens before "version"):
```
	cdo --version
```
	
Note the double hyphen.  CDO can be updated as follows:

```
	brew upgrade cdo
```

See:  [http://nco.sourceforge.net](http://nco.sourceforge.net)

NCO can be installed as follows:

```
	brew install nco
```

Check the installation (note that there are two hyphens before "version"):

```
	ncatted --version 
```

# Panoply #

The Panoply data viewer, developed by Robert Schmunk at NASA GISS can read and display (as maps and time series) netCDF, HDF and GRIB data sets.  The mapping capabilities of Panoply are pretty good for data exploration, and in addition, Panoply can reveal whether a netCDf dataset, for example, is well formed.

- Panoply:  [[http://www.giss.nasa.gov/tools/panoply/ ]](http://www.giss.nasa.gov/tools/panoply/ )

Panoply's help resources are not substantial (which is fine, because it is extraordinarily easy to use), but there is a short description of Panoply here:

- [[http://www.geo.uni-bremen.de/Interdynamik/images/stories/pdf/visualizing_netcdf_panoply.pdf]](http://www.geo.uni-bremen.de/Interdynamik/images/stories/pdf/visualizing_netcdf_panoply.pdf)
- and here is the Panoply help page [[https://www.giss.nasa.gov/tools/panoply/help/]](https://www.giss.nasa.gov/tools/panoply/help/)

Panoply is written in Java, and requires a Java runtime environment to be installed first.

## Windows ##

Here's a link to the Java installer for Windows [[https://www.java.com/download/ie_manual.jsp]](https://www.java.com/download/ie_manual.jsp). You can verify that Java has been installed by opening a CMD window (terminal) and typing `java -version`.

Here's a link to downloads page for Panoply: [[https://www.giss.nasa.gov/tools/panoply/download/]](https://www.giss.nasa.gov/tools/panoply/download/). Click on the "`Download Panoply 5.3.1 for Windows, 41 MB ZIP`" link. After the file is downloaded, browse to the download folder, and click on the file `PanoplyWin-5.3.1.zip` to uncompress it. Next, copy or move the `PanoplyWin` folder to `C:/Program Files/PanoplyWin/`. It would be handy to create a shortcut on the desktop or taskbar to the file `panoply.exe` in that folder.

## MacOS ##

Here's a link to the Java installer for MacOS [[https://www.java.com/en/download/]](https://www.java.com/en/download/). You can verify that Java has been installed by opening a terminal and typing `java -version`.

Here's a link to downloads page for Panoply: [[https://www.giss.nasa.gov/tools/panoply/download/]](https://www.giss.nasa.gov/tools/panoply/download/). There are three choices for Panoply for MacOS: 

- For older Intel-based Macs, choose `Download Panoply 5.3.1 for macOS, 44 MB DMG, uses native filechooser`, 
- or (if you have multiple monitors), choose `Download Panoply 5.3.1 for macOS, 44 MB DMG, uses Java filechooser`, 
- or (if you have a newer "Apple Silicon" Mac, choose `Download Panoply 5.3.1 for macOS, 44 MB DMG, requires Mx "Apple silicon" Mac with ARM64 Java`. 



