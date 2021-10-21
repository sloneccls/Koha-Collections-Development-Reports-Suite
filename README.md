# Koha Collections Development Reports Suite

(or How to Use Koha’s Report Module to Do Just About Anything)

An Overview

  Koha’s report module is one of the things that makes the system so versatile. Not only does it let you write rather complicated SQL queries, but it will interpret html markup too. The latter allows you to put hyperlinks to records directly in a report, apply formatting and styling (especially by adding custom CSS) to the results, and even pull custom scripts in from another location. This module is really just a collection of reports, some of them indeed quite complicated, that have used CSS and jQuery to transform the results into something that is more user friendly to most staff.

  Some of these reports started as modifications of queries sent to the ByWater Partners lists, others were more or less written whole cloth as a way to replicate what our then-current software package for collections development did. The centerpiece of this is the Worn and Torn Items process, which comprises four reports. With this process it’s possible to identify items that are likely in need of replacement but that have a potential replacement copy at another location, allowing the staff to transfer an underused item to replace the worn copy, rather than buying a new replacement.

  Because we share our catalog with our county college’s library, some extra modifications were needed to weed out some of the extra collection codes, branches, and item types for staff. This required some custom authorized values and additional clauses in the SQL that wouldn’t otherwise be necessary. The styling with CSS and jQuery is not really necessary for the reports to function either, however when developing this our goal was to come up something that was more user friendly to staff that otherwise would not be running reports. So a way to hide extra options on some reports, adding column sorting, adding a box to display the settings used on a report, and creating a dashboard were all figured out in order to make this seem more like a full-fledged module than a report.

  As such, a fair amount also went into facilitating the workflow, so that button clicks took staff as directly to the next step as possible.

  Hiding the options on the report parameters screens had to be done through clunky wording and jQuery; the code targets the specific wording in order to hide them unless the options button is clicked.

  The JS for sorting the report columns was not written by me, it was found below and adapted to work on Koha’s report results.


  There were changes to the marc / bib record in order to add a custom field for indicating that an item was requested for transfer to another branch (part of the Worn and Torn process).

  NOTE: Many of these reports reference other reports by number (see especially the Worn and Torn report and the Dashboard), you will need to modify them to match what your actually report numbers will be if you use something like Atom you can replace all of these throughout the entire folder and subfolders without hunting around for them (see info below).

First Steps

  1.	Create new reports for the following (I found it helpful to place all of these in a category called Collections Development), cutting and pasting the SQL as provided for each.
    a.	Collections Development (dashboard)
    b.	Worn and Torn Items
    c.	Replacement Candidates for Worn Items
    d.	Items Marked Review Condition Later Three Months Ago
    e.	Replacement Pulls
    f.	Highest Circulating Titles (in development)
    g.	High Use Collections (in development)
    h.	Dead on Arrival Items
    i.	Dusty Items Check
    j.	Branch Inventory Report
    k.	Over Stocked / Under Stocked (in development)
    l.	Outdated Non-Fiction
  2.	Add the custom CSS and jQuery to the system settings intranetusercss and intranetuserjs, respectively.
  3.	Save copies of scripts and images to a publicly accessible server.

Configuration

  NOTE: We share our ILS with our county college library, and as such dropdowns for collection codes, locations, and item types contain a lot of extra options we don’t want. To address this I created new authorized values to use for dropdowns that only included the options we wanted. The other advantage this gave us was the ability to run a report on either one of these choices or all of them. The drawback here is that it required inserting a lot of extra CASES statements into the SQL reports, which can be unwieldy to update. I’ve tried to revise the included reports to work without these custom AVs, but left in the blocks of code and comments so that they can be used if needed.

  1.	Optional: add new authorized values for collection codes, item types, and/or locations
  2.	Change the marc field 952i to and map to ‘stack’
    a.	We wanted a way to mark items as replacements for another branch, but for various reasons did not think that placeing holds on the items was correct for our workflow
    b.	For us the ‘stack’ field of our item records was unused, so we added a an “I” tag to our 952 field and then mapped that to items.stack
      i.	add new ‘i’ tag for marc field 952 to marc framework
      ii.	link items.stack to 952$i
      iii.	set 952$i to be managed in tab 10
      iv.	create a new authorized value category with your branches corresponding to each value (i.e. 1=Main Library)
      v.	set 952$i to use an authorized value category that has numbers for the values
      vi.	you will need to have ByWater run a database update
  3.	Add a new damaged status of “Check again later”
    a.	We assigned this to value 10, you may need to change in report #4 if you use something different
  4.	Modify the reports for your system
    a.	Change references to other reports to your corresponding report numbers
      i.	Your report numbers will obviously vary depending on the number they are assigned when created on your Koha server. For simplicity’s sake, I’ve replaced the report numbers referenced as follows:
        1.	Collections Development
        2.	Worn and Torn Items
        3.	Replacement Candidates for Worn Items
        4.	Items Marked Review Condition Later Three Months Ago
        5.	Replacement Pulls
        6.	Highest Circulating Titles (in development)
        7.	High Use Collections (in development)
        8.	Dead on Arrival Items
        9.	Dusty Items Check
        10.	Branch Inventory Report
        11.	Over Stocked / Under Stocked (in development)
        12.	Outdated Non-Fiction
    b.	Change reference to scripts and images to your server
      i.	All references to files you need to add to a server are indicated with “***path/to/your/server/files/”
      ii.	All references to your Koha server are indicated with “***your-koha-server/”
    c.	Modify reports as needed
      i.	Sections of these reports using custom Authorized Values have been commented out, if using you will need to change to reflect yours values
      ii.	Pay attention to other comments in the reports as they indicate other things that likely need to be tweaked for your setup
  5.	Test

Usage

  1.	Set up a schedule with staff to run the Worn and Torn items and to clear the check again later report


The Reports

  Worn and Torn Items

  Replacement Candidates for Worn and Torn Items

  Replacement Pulls

  Items Marked Review Condition Later


  Dead on Arrival Items

  Dusty Items Check

  Outdated Non-Fiction


  Still in development
    Highest Circulating Titles

    High Use Collections

    Overstocked/Understocked

System Changes
  Custom Bib Field

Authorized Values

Bells and Whistles

  JS and CSS

  Making a dashboard
