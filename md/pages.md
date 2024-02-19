
`pages.uoregon.edu` is an `https` web server, which provides web page hosting for students, staff, and faculty. See [[Web hosting on pages.uoregon.edu]](https://service.uoregon.edu/TDClient/2030/Portal/KB/ArticleDet?ID=43068). 

## Copying files to the server ##

Individual users have 50 GB of web space, with files and folders stored in the `/public_html` folder in the user's space. There are multiple ways to copy files, but FileZilla is pretty easy. To copy files via FileZilla, create a new Site Manager entry (see the [[File transfer]](https://pjbartlein.github.io/REarthSysSci/transfer.html) topic), with the follwing on the General tab:

- New site name: `sftp.uoregon.edu` (or some other name, e.g. `UO pages`
- Protocol: `SFTP - SSH File Transfer Protocol`
- Host: `sftp.oregon.edu`
- Logon Type: `Normal`
- User: your DuckID user name (not your email address, e.g. `bartlein` as opposed to `bartlein@uoregon.edu`
- Password: your DuckID password.

Note that while the while the web pages will have URLs like `https://pages.uoregon.edu/DuckID/geog490project/` the server name is `sftp.uoregon.edu`

To copy, for example, the "Example 5" multi-page website files to `pages.uoregon.edu`, where the various source files are in the folder `/Users/username/Projects/geog490project/`, start FileZilla, and :

- browse to the `/doc` folder in the `/geog490project` folder on your computer (usually on the left-hand side of FileZilla);
- connect to `sftp.uoregon.edu` which usually appears on the right-hand side of FileZilla; 
- on the `sftp.uoregon.edu` side, browse to `/public_html`
- right-click in the file list in `/public_html` and click on `Create directory`;
- change the name from `New directory` to, for example, `geog490project`, and click on `OK`;
- click on the new folder/directory `geog490project`; and then
- copy the contents of the left-hand `/doc` folder on your machine to `geog490project` on `sftp.uoregon.edu` (select the files in the source window, right-click, and click on `Upload`.

(Note: you may see error messages, as directories on `sftp.uoregon.edu` are not found, but then created.)

## Browsing the web pages ##

The uploaded web site can then be browsed using the following URL:

- [[https://pages.uoregon.edu/DuckID/geog490project/]]()
- here's an example: [[https://pages.uoregon.edu/bartlein/geog490project/]](https://pages.uoregon.edu/bartlein/geog490project/)

(Similarly, any one of the single-page `*.html` files produced by the R Markdown, or R Markdown Notebook examples could be renamed to `index.html` copied to a folder in the `public_html` folder on `pages.uoregon.edu` as above, where it could be viewed by browsing to [[`https://pages.uoregon.edu/DuckID/geog490project/`]](). 

Or, the original name of the file could be retained (e.g. `alpha_plot_RNotebook.html`) in which case the URL would become [[`https://pages.uoregon.edu/DuckID/geog490project/alpha_plot_RNotebook.html`]]().


