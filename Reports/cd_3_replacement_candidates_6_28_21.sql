SELECT *
FROM (
    SELECT
  	 @bib := <<Bibnumber>> AS '',
    (@item  := <<Itemnumber>> COLLATE utf8mb4_unicode_ci) AS  'Barcode',
    (@worn := <<Circ Threshold>> COLLATE utf8mb4_unicode_ci) AS 'Title', ' ' AS 'Author', 'Date Last Active', 'Issues', 'Renewals', 'Branch'
    ) AS `set variables`
WHERE 0 = 1

#The above select statement is used to set the variables

UNION

SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '', '', '', '', '', '', ''

UNION

(SELECT 'Worn Copy', CONCAT('<a href="/cgi-bin/koha/catalogue/moredetail.pl?biblionumber=',biblionumber,'&itemnumber=',itemnumber,'" target="_blank" >',barcode,'</a>') AS barcode, CONCAT('<a href="/cgi-bin/koha/catalogue/detail.pl?biblionumber=',biblionumber,'" target=_"blank" >',title,'</a>'), author, IF(datelastborrowed IS NULL, DATE_FORMAT(
    datelastseen, "%m" '/' "%d" '/' "%y"), DATE_FORMAT(
    datelastborrowed, "%m" '/' "%d" '/' "%y") ) AS Date, issues, renewals, homebranch
FROM items
LEFT JOIN biblio USING (biblionumber)
WHERE biblionumber=@bib AND itemnumber=@item
LIMIT 1
  )


UNION

(SELECT CONCAT('<a class="btn btn-default btn-xs" href="/cgi-bin/koha/cataloguing/additem.pl?op=edititem&biblionumber=',i.biblionumber,'&itemnumber=',i.itemnumber,'#edititem">','Select','</a>') AS Barcodes, barcode AS Barcodes, '', '', IF(datelastborrowed IS NULL, DATE_FORMAT(
    datelastseen, "%m" '/' "%d" '/' "%y"), DATE_FORMAT(
    datelastborrowed, "%m" '/' "%d" '/' "%y") ) AS Date, i.issues AS Issues, i.renewals AS Renewals, i.homebranch
FROM items AS i
WHERE biblionumber=@bib AND
     IFNULL(i.issues,0)+IFNULL(i.renewals,0)<@worn AND
DATEDIFF(NOW(), DATE(IFNULL(i.datelastborrowed,i.datelastseen)))>'365' AND
     i.itemlost=0 AND
     i.withdrawn=0 AND

     #Uncomment and edit the below if there's a branch you'd like to exclude
     #i.homebranch NOT IN ('GRABNGO') AND

     i.notforloan=0 AND
	 i.stack IS NULL
GROUP BY itemnumber
LIMIT 50
  )
