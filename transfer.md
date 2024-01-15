Downloading or transferring typical Earth-system science data sets used to be a big deal, with each "data provider" using a different approach for distributing files. Most data sets now have simple links on web pages, and can be downloaded with a click or two. In cases where there are a lot files, scripts can be generated that automate downloading, which at times can take several days. For even larger data sets, like the complete output of a climate simulation, FedEx-ing a bare hard drive works pretty well. An older, but still reliable way to move data is via FTP/SFTP, which we will use in this course to provide data for illustrating various topics

## Downloading from web pages (HTTPSever) ##

Many data sets are available through ordinary web pages. For example, the gridded climate data sets from the NOAA ESRL PSD [[https://www.esrl.noaa.gov/psd/data/gridded/]](https://www.esrl.noaa.gov/psd/data/gridded/) can be downloaded by clicking on a "download icon" recognizable as a downward pointing arrow aimed at an "inbox", or by simply right-clicking and saving. This approach uses a so-called HTTPServer on the data provider's web server. This approach is a one-file-at-a-time approach.

## Downloading via scripts ##

When there are multiple files, clicking or right-clicking quickly becomes tedious. Many data provider's web pages will feature the ability to select multiple files, and generate a script to download the files in an unattended fashion. A typical approach uses the `wget` utility, which is built into MacOS, and which is also available for download in Windows. For example, the CMIP5 data archive [[https://aims2.llnl.gov/search]](https://aims2.llnl.gov/search), has links to generate and download `wget` scripts.

## FedEx-ing hard drives ##

For really big, multiple Terabyte-size data sets, such as the output from a typical climate-model simulation, an efficient way to move data is to express-mail a bare hard drive, which can be popped into a "toaster" plugged into a computer or disk-array.


## FTP and SFTP ##

FTP (File Transfer Protocol) and SFTP (SSH File Transfer Protocol, also known as "Secure FTP") are built into most operating systems, and can be run at the command line.  However, it is much more convenient to use an FTP client to browse to and transfer data.  The most ubiquitous cross-platform (Windows and MacOS) client is likely FileZilla, which can be downloaded from [[https://filezilla-project.org]](https://filezilla-project.org) (download the FileZilla client).  FileZilla features a dual-pane file browser that shows both the local and remote file systems.

To configure FileZilla to transfer files from an SFTP server with data files for GEOG 4/590, click on File > Site manager (or click the Site Manager icon on he FileZilla toolbar), and then click on the `New Site` button.

Fill in the Site Manager fields as follows

- New site name:  `ESSData`  
- Protocol:  `SFTP - SSH File Transfer Protocol`
- Host:  `uoclimlab.uoregon.edu   Port:2222`
- Logon Type:  `Normal`
- User:  `ClimateLabRESS`
- Password:  <displayed in class>

Then click on `Connect`, and you should see the remote (i.e. `uoclimlab.uoregon.edu`) server's file structure.  Individual files can be dragged back and forth between the Remote and Local sites (but note: The SFTP server for the class data sets is set up as read only, to avoid clobbering the files).



