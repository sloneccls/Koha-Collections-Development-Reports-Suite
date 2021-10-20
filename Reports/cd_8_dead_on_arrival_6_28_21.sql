SELECT *
FROM (
    SELECT
    ( @branch := <<Homebranch|branches>> COLLATE utf8mb4_unicode_ci) AS 'Barcode',

#If using custom authorized values you will need to change the below to reflect it
    ( @col := <<Collection|ccode>> COLLATE utf8mb4_unicode_ci) AS 'Call Number',

  	' ' AS 'Title',
	' ' AS 'Collection Code',
    ' ' AS 'Copyright Date',
    ' ' AS 'Date Added',
    ' ' AS 'Item Type',
	' ' AS 'Issues',
	' ' AS 'Renewals',
    ' ' AS 'Total Circs',
	' ' AS 'Date Last Borrowed',
    ' ' AS 'Lost Status',
	' ' AS 'Processing Status',
	' ' AS 'Damaged Status',
    ' ' AS 'Notes',
  	' ' AS 'Withdrawn',
    ' ' AS 'Homebranch'
    ) AS `set variables`
WHERE 0 = 1

UNION ALL


SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '', '', '', '', '', '', '', '', '', '', '', '', '', '','', ''

UNION


SELECT IFNULL(items.barcode, CONCAT('itm#', items.itemnumber)) AS 'Barcode', items.itemcallnumber,biblio.title AS 'TITLE', items.ccode AS 'COLLECTION',biblio.copyrightdate AS 'Copyright', items.dateaccessioned AS 'Accessioned', items.itype, items.issues, items.renewals, (IFNULL(items.issues, 0)+IFNULL(items.renewals, 0)) AS Total_Circ, items.datelastborrowed, items.itemlost, items.onloan, items.damaged, items.itemnotes, items.withdrawn, homebranch
FROM items
LEFT JOIN biblioitems ON (items.biblioitemnumber=biblioitems.biblioitemnumber)
LEFT JOIN biblio ON (biblioitems.biblionumber=biblio.biblionumber)
WHERE
#uncomment the below and edit to reflect your desired collections if using custom Authorized Values
#CASE
#	WHEN @col='ALLPUBLIC' THEN (ccode IN
#('BIOGRAPHY','etc...')
#OR (ccode IS NULL))
#ELSE ccode=@col END

  AND items.holdingbranch=@branch AND
 items.dateaccessioned <= LAST_DAY(now() - interval 1 year) AND items.issues = 0 AND  items.itemlost = 0 AND  items.withdrawn = 0 AND items.notforloan = 0

#uncomment and edit below if there are branches, item types, or specific bibs you want to exclude
 #AND homebranch NOT IN ('COLLEGEBLK','CECONTENT','ECONTENT')
 #AND itemtype NOT IN ('PERIODICAL','EBOOK','CHARGER','REFERENCE') AND items.biblionumber NOT IN ('293256')
ORDER BY 2
LIMIT 100
