SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_home.css">' AS '','<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS ''

UNION

SELECT '<div class="reporttype"><p>Worn Items</p></div>' AS '', '<p class="reportcol">When to Run</p>' AS '', '<p class="reportcol">What It Does</p>' AS ''

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=2&amp;phase=Run%20this%20report" target="_blank_window"><img alt="worn" src="https://***path/to/your/server/files/images/cd_worn.svg"></img>Worn and Torn Items</a></div>', '<div class="reportfreq"><p>Once at the beginning of every month</p></div>','<div class="reportdesc"><p>This report identifies items in your collection that have circulated a lot and whether or not there is an eligible replacement that can be transferred from another branch.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=5&phase=Run%20this%20report" target="_blank_window"><img alt="pulls" src="https://***path/to/your/server/files/images/cd_transfer.svg"></img>Replacement Pulls</a></div>', '<div class="reportfreq"><p>Once in the middle of every month</p></div>','<div class="reportdesc"><p>This report identifies low-circulating items in your collection that another branch has requested to use as a replacement for one of their worn items.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=4&phase=Run%20this%20report" target="_blank_window">Items Marked for Later Review</a></div>', '<div class="reportfreq"><p>Once at beginning of the month, before beginning the Worn and Torn Items Process</p></div>','<div class="reportdesc"><p>This report lists items that were previously flagged as worn, but marked for later review. They should have the damaged status removed before running the Worn and Torn Items report.</p></div>'

UNION

SELECT '<div class="reporttype"><p>Good Performers</p></div>', '', ''

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=6&phase=Run%20this%20report" target="_blank_window"><img alt="top circ" src="https://***path/to/your/server/files/images/cd_top_circ.svg"></img>Highest Circulating Titles</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>This creates a list of the top three titles in the category you choose.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=7&phase=Run%20this%20report" target="_blank_window"><img alt="Top Collections" src="https://***path/to/your/server/files/images/cd_top_col.svg"></img>High Use Collections</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>This report will detail how well your various collections are performing.</p></div>'

UNION

SELECT '<div class="reporttype"><p>Poor Performers</p></div>', '', ''

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=8&phase=Run%20this%20report" target="_blank_window"><img alt="Dead on Arrival" src="https://***path/to/your/server/files/images/cd_doa.svg"></img>Dead on Arrival Items</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>This report identifies items that have been in your collection for at least a year, but have never circulated.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=9&phase=Run%20this%20report" target="_blank_window"><img alt="Dusty Items" src="https://***path/to/your/server/files/images/cd_dead.svg"></img>Dusty Item Check</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>This report identifies items in your collection that have not circulated for at least as long as the amount of time you specify.</p></div>'

UNION

SELECT '<div class="tools reporttype"><p>Tools</p></div>', '', ''

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/tools/batchMod.pl" target="_blank_window">Batch Item Modification</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>Use this tool to make changes to a group of items.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=10&phase=Run%20this%20report" target="_blank_window">Inventory</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>Generate a report of items at your branch.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=11&phase=Run%20this%20report" target="_blank_window">Over/Under-stocked</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>Identify where you may have too many or too few items.</p></div>'

UNION

SELECT '<div class="reportname"><a href="https://***your-koha-server/cgi-bin/koha/reports/guided_reports.pl?reports=12&phase=Run%20this%20report" target="_blank_window">Outdated Non-Fiction</a></div>', '<div class="reportfreq"><p>As needed</p></div>','<div class="reportdesc"><p>Identify where you may have non-fiction titles that are past their prime.</p></div>'
