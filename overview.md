<span style="color: green;">**NOTE:&nbsp; This page has been revised for the 2024 version of the course, but there may be some additional edits.** &nbsp; <br>

# Course objectives #

The aim of this course is to review some of the developments in the visualization and analysis of Earth-System Science (ESS) data using the R language and data-analysis environment.  ESS data sets are generally large (in terms of both the number of attributes or variables and number of data points), and are therefore frequently used as examples of "big data".  They are often well organized, in the sense of being represented as raster "slices" or "bricks" with dimensions like longitude, latitude and time, but can also be instances of  traditional "rectangular" data sets, where the rows represent individual locations and the columns variables or attributes.

Concurrently with the development of such large data sets, the tools for analyzing them have proliferated.  These tools include special-purpose packages specifically designed for visualizing particular data sets (like NCL (the NCAR Command Language)for analyzing and mapping weather and climate data), individual programming languages and environments like Matlab, Python and R, as well as traditional programming languages like Fortran or C.  Among these options, R easily has the best developed set of data-analytical, visualization, and statistical tools (with thousands of individual packages available), and also has the necessary tools for reading and writing ESS data in their various "native" forms. R also has extensive geospatial analysis "built in".

The goal of this course is to describe the nature of the ESS data and data-set formats, the tools for reading and writing such data, and the procedures for visualizing and analyzing the data.  In addition, the general ideas of "reproducible research" will be discussed and put to use in developing individual projects that explore some particular data sets.

# Topics covered #

The specific topics that will be examined include:

- an introduction to Earth-System Science data in general
- a general review of R and RStudio
- Markdown, RMarkdown and reproducible research
- ESS data sources
- reading, writing and recasting ESS data
- key R packages for reading and writing data (e.g. `ncdf4` and `terra`)
- mapping and geospatial techniques in R
- basic visualization tools
- strategies for dealing with high-dimension, high-resolution data
- prediction and multivariate analysis

These topics implement and document a particular data-analysis "design pattern" that involves

1. data input (using, for example, `ncdf4`, `rhdf5`, `raster`, `terra`, or an ODBC relational database package)
2. recasting the raster brick input data into a rectangular data frame
3. analysis and visualization
4. recasting a "results" data frame back to a raster
5. data output, using the same packages as in step 1

# Schedule #
```
Topic                                              Tasks
   1:  Introduction and infrastructure               Install R, RStudio 
   2:  Using R for data visualization and analysis   Using R exercise
   3:  Earth-system science data                                     
   4:  netCDF, HDF, etc.                             Install netCDF and Panoply      
   5:  raster, terra & stars                         File transfer  
   6:  Plots (1)                                     Text editor  
   7:  Plots (2)                                     Project dataset selection
   8:  Maps (1)                                      Markdown and Markdown
   9:  Maps (2)                                      Pandoc  
  10:  Geospatial analysis in R                      GitHub and UO pages.uoregon.edu  
  11:  Correlation and regression                    Local web pages
  12:  Other predictive models  
  13:  Principal components analysis  
  14:  Singular value decomposition  
  15:  High-resolution and high-dimension data  
  16:  Multivariate methods  
  17:  Time-series analysis  
  18:  Other languages  
  19:  Project presentations  
  20:  Project presentations
```

Setting up an effective and efficient environment for data analysis (i.e. a "tool chain") can be as much of a time-waster as a time-saver.  We will describe and use a basic set of tools, including:  

- R itself, and R packages from CRAN
- RStudio, and related packages (e.g. `knitr`, `rmarkdown`)
- a GitHub account, and a Git client (e.g. Sourcetree)
- a Markdown editor (e.g. MarkdownPad (Windows) or Macdown (Mac), many others)
- a text editor (e.g. Sublime Text, Atom, Visual Studio Code)
- file-transfer approaches (SFTP (Filezilla) and Globus)
- netCDF utilities and apps (netCDF, CDO, NCO, Panoply)

# Project and Tasks#

Student effort in the course will involve: 

- the completion of several tasks, such as installing R, taking it for a spin, installing various other software packages, etc. 

- The visualization/analysis of a typical or interesting ESS data set using R, and the documentation of that analysis as an R Markdown Notebook, HTML web page, Word document, or some other useful format supported by RMarkdown.  
- Participating in a collaborative research environment, which involves both
	- asking questions and asking for help as issues arise, and
	- answering questions, as far as possible. 

Completion of the tasks should not be a major effort, and aren't really gradable (except for doneness). The project will require more effort, ranging from a project that involves getting data, doing some basic visualizations, and "publishing" the results (text and images) on a simple web page, to something more elaborate, involving some advanced statistical analyses, and a more involved publication such as the course web page, or some other RMarkdown product.

It will be up to individual students how far or how deeply they want to go. A general principle that's worth following here is that a simpler story told well is better than a complicated story told in a half-assed fashion. Because the end product will be publicly available, it can readily contribute to a portfolio, and experience shows that including a URL to a nice-looking product on a resume or job application letter pays off.

Collaboration would be fine, with the development of an agree-upon "Author Responsibility" document ahead of time.

To summarize, the project will involve:

- identifying an interesting Earth-system science-type data set, most likely in the netCDF or HDF format
- downloading of transferring the appropriate file(s)
- reading the data into R
- exploring the data using maps, plot, descriptive statistics
- coming up with a "story" or outline that could involve visualizations or data analyses
- creating an RMarkdown-type document to tell that story
- rendering the .Rmd document to .html (or an alternative)
- copying the rendered document to the web
- making a quick (3-5 minute) presentation in class

# Grading #

As will become apparent (and see the examples below), there are various "levels" of Projects that can be attempted, ranging from a simple Markdown "Notebook" hosted on `pages.uoregon.edu` to a multi-page Markdown web site, with an accompanying GitHub code repository and web site, and a complete and tidy project at any level should be the goal to get "full marks" (e.g. an A- or B-level grade for the course). However, there is a difference in the minimum effort between the course levels:

**GEOG 490:** Completion of the Tasks in a timely fashion, and a Project consisting of an RMarkdown Notebook or web page hosted on `pages.uoregon.edu`.

**GEOG 590:** Completion of the Tasks in a timely fashion, and a Project consisting of an Markdown web page or web site, accompanied by a GitHub repository, hosted either on `pages.uoregon.edu` or GitHub.

# Examples#

Some examples of analyses and documentation follow:

Here's an example of two simple RMarkdown products:

- a simple RMarkdown Notebook .html file: [[hhttps://pjbartlein.github.io/REarthSysSci/plot_alpha_RNotebook.html]](https://pjbartlein.github.io/REarthSysSci/plot_alpha_RNotebook.html)

Here's an example of an R Markdown HTML page describing the analysis of the Global Charcoal Database (GCD): 

- [https://pjbartlein.github.io/GCDv3Analysis/index.html](https://pjbartlein.github.io/GCDv3Analysis/index.html). 

and a simpler, one-HTML-document description of a particular analysis comparing two approaches for curve-fitting can be found at:

- [https://pjbartlein.github.io/GCDv3Analysis/locfit.html](https://pjbartlein.github.io/GCDv3Analysis/locfit.html).

Here's a link to a web page describing the development of a daily fire-start data set for the U.S. and Canada:

- [http://regclim.coas.oregonstate.edu/FireStarts/index.html](http://regclim.coas.oregonstate.edu/FireStarts/index.html).

This is a link to a "supplemental file" accompanying an article on biomass-burning contribution to climate-carbon cycle feedback, created as a Word document (and converted to a .pdf):

- [https://www.earth-syst-dynam.net/9/663/2018/esd-9-663-2018-supplement.pdf](https://www.earth-syst-dynam.net/9/663/2018/esd-9-663-2018-supplement.pdf)

… and here's a link to the article:

- [https://www.earth-syst-dynam.net/9/663/2018/](https://www.earth-syst-dynam.net/9/663/2018/).

Here are some links to a dissertation chapter published by a former student in this course, Adriana Uscanga, that illustrates the application of R for analyzing a geospatial data set, and shows another typical example of a publication "package", including:

- the published paper, in the journal *Ecosystems*, available at [https://doi.org/10.1007/s10021-023-00861-1](https://doi.org/10.1007/s10021-023-00861-1)
- "supplementary information" that further describes the methods: [[Supplementary file2 (DOCX 576 KB)]](https://static-content.springer.com/esm/art%3A10.1007%2Fs10021-023-00861-1/MediaObjects/10021_2023_861_MOESM2_ESM.docx)
- the R code used for the analysis, archived at *Zenodo* a data and code repository [https://zenodo.org/records/7272469](https://zenodo.org/records/7272469), a mirror (with a "permanent" DOI), of a GitHub repository at [[https://github.com/adrianauscanga/nmo_cloudforest_landscapes/tree/v1]](https://github.com/adrianauscanga/nmo_cloudforest_landscapes/tree/v1)


Publication packages like this, that combine a traditional paper with code and data are now the norm in scientific publication, because they allow a reader to reproduce the results presented in the paper. This encourages collaboration, accelerates the pace of research, and contributes to overall "quality assurance".

Also, this web page, as well as that for GEOG 4/595 Geographic Data Analysis provide examples of web pages created using R, RStudio and RMarkdown:

- [https://pjbartlein.github.io/GeogDataAnalysis/](https://pjbartlein.github.io/GeogDataAnalysis/).

# Getting help #

One thing that will become immediately apparent is that R produces cryptic error messages. Because it's hardly ever the case that you'll be typing new code into an empty document, many errors arise from simple editing mistakes or typos. Simply Googling the error message will quickly resolve an issue, and often will take you to one of the following links:

- StackExchange/CrossValidated Questions tagged [r]: [[https://stats.stackexchange.com/questions/tagged/r]](https://stats.stackexchange.com/questions/tagged/r)
- StackOverflow: [[https://stackoverflow.com/collectives/r-language]](https://stackoverflow.com/collectives/r-language)

ChatGPT is another option for getting some ideas on error messages, and for getting simple code fragments, but it can easily get off track (Garbage In -> Garbage Out).

# Other stuff #

**Text:**. No textbook; .pdfs and URLs will be posted on the course web page. See the `Other > Readings` tab .   

**Web pages:**  

- Course Canvas page:  [http://canvas.uoregon.edu/](http://canvas.uoregon.edu/) (Used only for Announcements, etc.)
- Course Weg page (this page): [[https://pjbartlein.github.io/REarthSysSci/index.html]](https://pjbartlein.github.io/REarthSysSci/index.html)

**Grading:**  See above.

**Incompletes:** There is a new, less flexible policy for Incompletes:  [[https://provost.uoregon.edu/grades-incompletes-policy]](https://provost.uoregon.edu/grades-incompletes-policy).  Do not use the possibility of an "automatic" incomplete as a time-management tool at the end of the term.

**Attendance (Student:** You really should attend class. The last half hour of class each day (3:20 - 3:50pm) will be devoted to debugging and other non-lecture-type activities.

**Attendance (Instructor):** UO has announced a pilot "Floating Holiday" for *employees* (not students, Ah-ha-ha--sorry) [[https://hr.uoregon.edu/floating-holiday-pilot-2023-24]](https://hr.uoregon.edu/floating-holiday-pilot-2023-24). I would generally claim the day of Perihelion  for its climatic and Earth-system science significance, but Perihelion occurred before classes started this year (Jan 2nd). Maybe Imbolc or St. Brigid's day--I'll let you know). 

**Communicating with instructors:**  Pat Bartlein, <bartlein@uoregon.edu>, OH at 2-3pm Wednesdays (via Zoom), or by email. GE  or by email.  
 
* If interest warrants, we will have an ongoing discussion area on Canvas on course mechanics and topics. You can post questions there.  If you have a question, others probably do too, and it would be a service to everyone to ask.  
* We will also communicate course information through Canvas announcements and emails.   Announcements and emails are archived there and automatically forwarded to your UO email, and can even reach you by text. Check and adjust your Canvas settings under Account > Notifications. 
* We understand you may have irregular or constrained schedules, and we are available to talk outside the scheduled office hours.  Email or call.  Voicemail messages will be sent to us as an email.  We may not be available all the time, and sowe may need to set an appointment to talk. 
* *Response time*:  The instructor and GE will check emails intermittently during weekdays.  Usually you will be able to get an answer from us on weekdays within six hours. In evenings and on weekends, response time will be much slower.  We want to answer your questions and help you succeed in this course.  Help us do that by starting on assignments early so you can identify questions early enough to get a response from us.   

**Technical Requirements:** You will need access to the internet, to UO's Canvas site, and to a browser at a minimum, and ideally a personal computer you have administrative rights on. 
If you have questions about accessing and using Canvas, visit the [Canvas Support for Students](https://service.uoregon.edu/TDClient/2030/Portal/KB/ArticleDet?ID=86662) page. Canvas and Technology Support also is available by phone or live chat,  Monday-Sunday 6 a.m. to 12 a.m.
541-346-4357 [livehelp.uoregon.edu](livehelp.uoregon.edu).
If you face Internet access challenges, computer labs are open for students on campus. To learn more about options visit Information Services' [Internet Access Resources](https://service.uoregon.edu/TDClient/2030/Portal/KB/ArticleDet?ID=101263).

**Other topics, including classroom behavior:**  Computers are welcome, for note taking, viewing course-related material, and trying out code. Using a computer, tablet, or phone during class for anything else would be unprofessional.

**Standard University Policies and Sources for Help:**  

The support provided by the following may be useful:  

* UO Division of student life:  [http://studentaffairs.uoregon.edu/](http://studentaffairs.uoregon.edu/)

* University Counseling and Testing Center:  [http://counseling.uoregon.edu](http://counseling.uoregon.edu)  
* UO Accessible Education Center [http://aec.uoregon.edu/](http://aec.uoregon.edu/)  
* UO Emergency and Safety Services:  [https://safety.uoregon.edu/emergency-and-safety-services](https://safety.uoregon.edu/emergency-and-safety-services)  

* *Accessible Education:*  Please let us know within the first two weeks of the term if you need assistance to fully participate in the course. Participation includes access to lectures, web-based information, in-class activities, and exams. The Accessible Education Center [http://aec.uoregon.edu/](http://aec.uoregon.edu/) works with students to provide an instructor notification letter that outlines accommodations and adjustments to class design that will enable better access. Contact the Accessible Education Center for assistance with access or disability-related questions or concerns.  
* *Conduct:* The University Student Conduct Code (available at [conduct.uoregon.edu](conduct.uoregon.edu) defines academic misconduct. Students are prohibited from committing or attempting to commit any act that constitutes academic misconduct. By way of example, students should not give or receive (or attempt to give or receive) unauthorized help on assignments or examinations without express permission from the instructor. *However, you do have permission to discuss and collaborate on the exercise tasks, providing answers are constructed independently.* Students should properly acknowledge and document all sources of information (e.g. quotations, paraphrases, ideas) and use only the sources and resources authorized by the instructor. If there is any question about whether an act constitutes academic misconduct, it is the students' obligation to clarify the question with the instructor before committing or attempting to commit the act. Additional information about a common form of academic misconduct, plagiarism, is available at:   
[https://researchguides.uoregon.edu/citing-plagiarism](https://researchguides.uoregon.edu/citing-plagiarism)  
* *Inclement Weather:* (Let's hope for a little...) It is generally expected that class will meet unless the University is officially closed for inclement weather. If it becomes necessary to cancel class while the University remains open, this will be announced on Canvas and by email. Updates on inclement weather and closure are also communicated in other ways described here: [https://hr.uoregon.edu/about-hr/campus-notifications/inclement-weather/inclement-weather-immediate-updates](https://hr.uoregon.edu/about-hr/campus-notifications/inclement-weather/inclement-weather-immediate-updates)  
* *We are designated reporters:* For information about my reporting obligations as an employee, please see Employee Reporting Obligations on the Office of Investigations and Civil Rights Compliance (OICRC) website. Students experiencing sex or gender-based discrimination, harassment or violence should call the 24-7 hotline 541-346-SAFE [7244] or visit [safe.uoregon.edu](safe.uoregon.edu) for help. Students experiencing all forms of prohibited discrimination or harassment may contact the Dean of Students Office at 5411-346-3216 or the non-confidential Title IX Coordinator/OICRC at 541-346-3123. Additional resources are available at investigations.uoregon.edu/how-get-support. We are also mandatory reporters of child abuse. Please find more information at Mandatory Reporting of Child Abuse and Neglect.  

* *Mental Health and Wellness:* Life at college can be very complicated. Students often feel overwhelmed or stressed, experience anxiety or depression, struggle with relationships, or just need help navigating challenges in their life. If you're facing such challenges, you don't need to handle them on your own--there's help and support on campus. As your instructor if I believe you may need additional support, I will express my concerns, the reasons for them, and refer you to resources that might be helpful. It is not my intention to know the details of what might be bothering you, but simply to let you know I care and that help is available. Getting help is a courageous thing to do—for yourself and those you care about. University Health Services help students cope with difficult emotions and life stressors. If you need general resources on coping with stress or want to talk with another student who has been in the same place as you, visit the Duck Nest (located in the EMU on the ground floor) and get help from one of the specially trained Peer Wellness Advocates. Find out more at [health.uoregon.edu/ducknest](health.uoregon.edu/ducknest). University Counseling Services (UCS) has a team of dedicated staff members to support you with your concerns, many of whom can provide identity-based support. All clinical services are free and confidential. Find out more at counseling.uoregon.edu or by calling 541-346-3227 (anytime UCS is closed, the After-Hours Support and Crisis Line is available by calling this same number).

* *Basic Needs:* Any student who has difficulty affording groceries or accessing sufficient food to eat every day, or who lacks a safe and stable place to live and believes this may affect their performance in the course is urged to contact the Dean of Students Office (346-3216, 164 Oregon Hall) for support. This UO webpage includes resources for food, housing, healthcare, childcare, transportation, technology, finances, and legal support: [https://blogs.uoregon.edu/basicneeds/food/](https://blogs.uoregon.edu/basicneeds/food/)

* *Accommodation for Religious Observances:* The university makes reasonable accommodations, upon request, for students who are unable to attend a class for religious obligations or observance reasons, in accordance with the university discrimination policy which says "Any student who, because of religious beliefs, is unable to attend classes on a particular day shall be excused from attendance requirements and from any examination or other assignment on that day. The student shall make up the examination or other assignment missed because of the absence."" To request accommodations for this course for religious observance, visit the Office of the Registrar's website and complete and submit to the instructor the "Student Religious Accommodation Request" form prior to the end of the second week of the term ([https://registrar.uoregon.edu/calendars/religious-observances](https://registrar.uoregon.edu/calendars/religious-observances))

**Covid Containment Plan*: [[https://provost.uoregon.edu/covid-containment-plan-classes]](https://provost.uoregon.edu/covid-containment-plan-classes)



