## FTP and SFTP ##

FTP (File Transfer Protocol) and SFTP (SSH File Transfer Protocol, also known as "Secure FTP") are built into most operating systems, and can be run at the command line.  However, it is much more convenient to use an FTP  client to browse to and transfer data.  The most ubiquitous cross-platform (Windows and MacOS) client is likely Filezilla, which can be downloaded from [[https://filezilla-project.org]](https://filezilla-project.org) (download the Filezilla client).  Filezilla features a dual-pane file browser that shows both the local and remote file systems.

To configure Filezilla to transfer files from an FTP server with data files for GEOG 4/595, click on File > Site manager (or click the Site Manager icon on he Filezilla toolbar), and then click on the New Site button.

Fill in the Site Manager fields as follows

- New site name:  `ESSData`  
- Protocol:  `SFTP - SSH File Transfer Protocol`
- Host:  `ClimateLab.uoregon.edu   Port:2222`
- Logon Type:  `Normal`
- User:  `RESS`
- Password:  <displayed in class>

Then click on Connect, and you should see the remote (i.e. the FTP server) server's file structure.  Individual files can be dragged back and forth between the Local and Remote sites.

## Globus ##

Globus [[https://www.globus.org]](https://www.globus.org) is a file-transfer system that runs in a browser.  Globus transfers files between "Endpoints"— folders on individual machines.  To transfer files from `ClimateLab.uoregon.edu` you will need to set up an account, and install Globus Connect Personal, and create an endpoint:

- Setting up an account is explained on the page [[How to Log In and Transfer Files with Globus]](https://docs.globus.org/how-to/get-started/) 
- Installation of Globus Connect Personal and creation of an Endpoint:  [[Mac]](https://docs.globus.org/how-to/globus-connect-personal-mac/)  [[Windows]](https://docs.globus.org/how-to/globus-connect-personal-windows/)


Then to browse the files on the Globus Endpoint at ClimateLab.uoregon.edu, paste the following into the address bar in a browser:  

`https://app.globus.org/file-manager?origin_id=d74454ce-e6b4-11e7-80f5-0a208f818180&origin_path=%2FESSData%2F`

This wiil open the endpoint on `ClimateLab.uoregon.edu`.  Then, see Section 4 of [[How to Log In and Transfer Files with Globus]](https://docs.globus.org/how-to/get-started/), for instructions on how to transfer files.

