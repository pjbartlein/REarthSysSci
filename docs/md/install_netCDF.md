<span style="color: green;">**NOTE:&nbsp; This page has been revised for the 2024 version of the course, but there may be some additional edits.** &nbsp; <br>

**Finish by Thursday, Jan. 25th**

# netCDF # 

[[http://www.unidata.ucar.edu/software/netcdf/docs/index.html]](http://www.unidata.ucar.edu/software/netcdf/docs/index.html)

netCDF includes libraries for implementing creating, reading and writing netCDF (.nc) files, as well as some handy command-line utilities.  One in particular `ncdump`, as its name implies, is able to display or dump the entire contents of a netCDF file as ascii, but its main utility is to display the headers of a netCDF file, including a description of the variables contained in the file, as well as the dimensions (latitude, longitude, time, etc.) of the data.  However, the same information is provided by Panoply (see below, so the installation of netCDF is more-or-less optional, and is described here for completeness.

In addition to `ncdump`, there are two sets of command line utilities, `CDO` and `NCO` (Climate Data Operators, and netCDF Operators, respectively), that can efficiently perfor many tasks, like regridding or concatenation individual `.nc` files:

- CDO:  https://code.zmaw.de/projects/cdo
- NCO:  http://nco.sourceforge.net/

## Example files ##

To test that you've installed netCDF and Panoply correctly, you'll want to look at some example files. There are a number of files in the SFTP server on `uoclimlab.uoregon.edu` (which can be retrieved via FileZilla, or from [[https://pages.uoregon.edu/bartlein/RESS/nc_files/]](https://pages.uoregon.edu/bartlein/RESS/nc_files/). 

Here's a link to a good one: [[cru10min30_tmp.nc]](https://pages.uoregon.edu/bartlein/RESS/nc_files/cru10min30_tmp.nc). Right-click or ctrl-click to download it to a convenient place.


## Windows ##

To set up the netCDF command-line utilities in Windows, 

1. download and install the netCDF-C library and utilites from  
[http://www.unidata.ucar.edu/software/netcdf/docs/winbin.html](http://www.unidata.ucar.edu/software/netcdf/docs/winbin.html)  (e.g. `netCDF4.9.2-NC4-DAP-64.exe`) 
2. Install as usual by clicking on the file; the destination folder will likely be `"c:/Program Files/netCDF 4.9.2/"` 
3. When prompted, select "Add netCDF to the system PATH for all users" 
4. Check to make sure the `PATH` environment variable has been set:
	Control Panel > All Control Panel Items > System > Advanced System Settings > Environment Variables > System Variables Pane, Click on Path, and add the following if not present:  `"c:/Program Files/netCDF 4.9.2/"`; `"c:/Program Files/netCDF 4.9.2/bin/"`; `"c:/Program Files/netCDF 4.9.2/lib/"`

You can check that the utilities have been installed by opening a Command (cmd) window and typing `ncdump`. This should produce a listing of the options.

To use `ncdump` to view the contents of netCDF files, open a new Command (cmd) window in the folder with the netCDF file. 

- browse to the folder with the netCDF file;
- type "`cmd`" (no quotes) in the address bar and hit enter,
- a cmd window should open up.

Then, in the Command window, typing: 

- `ncdump filename.nc` will show a brief listing of the dimensions variables and attributes;
- `ncdump -c filename.nc` will show the above, plus the explicit values of the dimension variables;
- `nccump -ct filename.nc` will show the above, with the time variable recoded into some kind of human-readable form.

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

You can check that the utilities have been installed by typing `ncdump` in a terminal window

To use `ncdump` to view the contents of netCDF files, open a new Terminal window in the folder with the netCDF file. In Finder, 

- browse to the folder with the netCDF file;
- Control-click or right click on the folder name in the path bar at the bottom of the file list in Finder;
- choose Open in Terminal.

(If you don't see the path bar in the bottom of the Finder window, click on View > Show Path Bar.)

Then, in the terminal window, typing: 

- `ncdump filename.nc` will show a brief listing of the dimensions variables and attributes;
- `ncdump -c filename.nc` will show the above, plus the explicit values of the dimension variables;
- `nccump -ct filename.nc` will show the above, with the time variable recoded into some kind of human-readable form.

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

Panoply is written in Java, and requires a current Java runtime environment to be installed first. It will prompt you to do so if it can't fine one, otherwise it should open as normal with a file-chooser window. But you can also check before attempting to install Panoply by opening a CMD/Terminal window and typing `java -version`. If you get a reply that looks like

		java version "21.0.2" 2024-01-16 LTS
		Java(TM) SE Runtime Environment (build 21.0.2+13-LTS-58)
		Java HotSpot(TM) 64-Bit Server VM (build 21.0.2+13-LTS-58, mixed mode, sharing)

you should be able to install Panoply and have it run.  If not, here's the Java download page: [[https://www.oracle.com/java/technologies/downloads/]](https://www.oracle.com/java/technologies/downloads/)


## Windows ##

Here's a link to the Java installer for Windows [[https://www.oracle.com/java/technologies/downloads/#jdk21-windows]](https://www.oracle.com/java/technologies/downloads/#jdk21-windows). You'll probably want to select the `x64 MSI Installer`. You can verify that Java has been installed by opening a CMD window (terminal) and typing `java -version`.

Here's a link to downloads page for Panoply: [[https://www.giss.nasa.gov/tools/panoply/download/]](https://www.giss.nasa.gov/tools/panoply/download/). Click on the "`Download Panoply 5.3.1 for Windows, 41 MB ZIP`" link. After the file is downloaded, browse to the download folder, and click on the file `PanoplyWin-5.3.1.zip` to uncompress it. Next, copy or move the `PanoplyWin` folder to `C:/Program Files/PanoplyWin/`. It would be handy to create a shortcut on the desktop or taskbar to the file `panoply.exe` in that folder.

## MacOS ##

Here's a link to the Java installer for MacOS [[https://www.oracle.com/java/technologies/downloads/#jdk21-mac]](https://www.java.com/en/download/). For a new Apple Silicon Mac, you'll want to select the `ARM64 DMG Installer` while for older Intel-based Macs, select `x64 DMG Installer`. You can verify that Java has been installed by opening a terminal and typing `java -version`. 

Here's a link to downloads page for Panoply: [[https://www.giss.nasa.gov/tools/panoply/download/]](https://www.giss.nasa.gov/tools/panoply/download/). There are three choices for Panoply for MacOS: 

- For older Intel-based Macs, choose `Download Panoply 5.3.1 for macOS, 44 MB DMG, uses native filechooser`, 
- or (if you have multiple monitors), choose `Download Panoply 5.3.1 for macOS, 44 MB DMG, uses Java filechooser`, 
- or (if you have a newer "Apple Silicon" Mac, choose `Download Panoply 5.3.1 for macOS, 44 MB DMG, requires Mx "Apple silicon" Mac with ARM64 Java`. 



