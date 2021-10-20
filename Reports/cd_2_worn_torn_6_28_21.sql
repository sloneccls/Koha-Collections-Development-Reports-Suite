SELECT *
FROM (
    SELECT
    ( @branch := <<Branch|branches>> COLLATE utf8mb4_unicode_ci) AS 'Call Number',
    ( @wnum := <<Worn Threshold>> COLLATE utf8mb4_unicode_ci) AS 'Author',
  	( @lost := <<Should lost/missing items be included?|YES_NO>> COLLATE utf8mb4_unicode_ci) AS	'Title',
#If using custom authorized values you will need to change the three below to reflect them
	( @audi := <<What Audience?|loc>> COLLATE utf8mb4_unicode_ci) AS 'Collection Code',
    ( @type := <<What Item Type?|itemtypes>> COLLATE utf8mb4_unicode_ci) AS 'Barcode',
	( @col := <<What Collection?|ccode>> COLLATE utf8mb4_unicode_ci) AS 'Circs',

  ( @stcall := <<Starting Call Number?>> COLLATE utf8mb4_unicode_ci) AS 'Status',
	( @ecall := <<Ending Call Number?>> COLLATE utf8mb4_unicode_ci) AS 'Transfer Options'
    ) AS `set variables`
WHERE 0 = 1

UNION ALL


SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '', '', '', '', '', '', ''

UNION


SELECT worn.itemcallnumber AS 'Call Number', Author,  CONCAT('<a href="/cgi-bin/koha/catalogue/detail.pl?biblionumber=',b.biblionumber,'" target="_blank" >',Title,'</a>') as Title, worn.ccode AS 'Collection Code', CONCAT('<a href="/cgi-bin/koha/catalogue/moredetail.pl?biblionumber=',b.biblionumber,'&itemnumber=',worn.itemnumber,'" target="_blank" >',worn.barcode,'</a>') AS barcode, worn.Issues+worn.Renewals AS 'Circs', IF(
	 worn.itemlost<>'0',v.lib,IF(
	 worn.onloan IS NOT NULL, CONCAT(
	 'Checked Out, Due ', DATE_FORMAT(worn.onloan, "%m" '/' "%d" '/' "%y")), IF(
	 waitingdate IS NOT NULL, CONCAT(
	 'Holdshelf - ',reserves.branchcode),IF(worn.withdrawn=1,'Withdrawn','Available')))) as Status,

	 	 CONCAT('<a href="/cgi-bin/koha/reports/guided_reports.pl?reports=3&phase=Run+this+report&param_name=Bibnumber&sql_params=',b.biblionumber,'&param_name=Itemnumber&sql_params=',worn.itemnumber,'&param_name=Circ+Threshold&sql_params=',20,' " target="_blank" >', COUNT(DISTINCT(IF((IFNULL(i.issues,0)+IFNULL(i.renewals,0))<20 AND i.itemlost=0 AND i.withdrawn=0
AND i.homebranch NOT IN ('GRABNGO') AND i.notforloan=0 AND i.stack IS NULL AND DATEDIFF(NOW(), DATE(IFNULL(i.datelastborrowed,i.datelastseen)))>'365',i.itemnumber, NULL))),'&nbsp;&nbsp;&nbsp;<i class="fa fa-search"></a>') AS 'Transfer Options'

FROM biblio b
LEFT JOIN items i USING (biblionumber)
LEFT JOIN reserves USING (itemnumber)
	RIGHT JOIN (SELECT itemcallnumber, itemnumber, biblionumber, issues, renewals, location, datelastborrowed, datelastseen, ccode, barcode, itype, homebranch, itemlost, onloan, withdrawn, damaged FROM items WHERE
	            (IFNULL(issues,0)+IFNULL(renewals,0))>=@wnum  AND homebranch=@branch AND


#Uncomment below and modify as needed if using a customized list
#CASE
#   	WHEN @type='BOOK' THEN itype IN ('BOOK','etc...')
#	WHEN @type='DVD' THEN itype IN ('DVD','etc...')
#	WHEN @type='CD' THEN itype IN ('MUSICCD')
#	WHEN @type='AUDIOBK' THEN itype IN ('AUDIOBKCD')
#	ELSE ((itype IN ('AUDIOBKCD',,'etc...')) or (itype IS NULL))
#END



				LIMIT 5000000) AS worn
	ON (worn.biblionumber=b.biblionumber)

LEFT JOIN authorised_values v ON (worn.itemlost=v.authorised_value)

WHERE (worn.Issues+IFNULL(worn.renewals,0))>=@wnum AND

#Uncomment below and modify as needed if using a customized list
  #CASE
	#WHEN @col='ALLPUBLIC' THEN (worn.ccode IN 				('BIOGRAPHY','etc...') OR (worn.ccode IS NULL))
	#ELSE worn.ccode=@col
  #END
	#AND
  #CASE
  #    WHEN @audi='ADULT' THEN worn.location IN ('ADULT')
	#WHEN @audi='CHILDREN' THEN worn.location IN ('CHILDREN')
	#WHEN @audi='YA' THEN worn.location IN ('YA')
	#ELSE ((worn.location IN ('ADULT','etc...')) OR (worn.location IS NULL))
  #END
	# AND

  CASE
	WHEN @ecall='all' THEN worn.itemcallnumber LIKE '%'
	WHEN @stcall='all' THEN worn.itemcallnumber LIKE '%'
	ELSE worn.itemcallnumber BETWEEN LTRIM(RTRIM(@stcall)) AND LTRIM(RTRIM(@ecall))
  END
 	AND
  IF(@lost='1', worn.itemlost IS NOT NULL, worn.itemlost IN ('0')) AND worn.damaged<>'10'
GROUP BY worn.itemnumber
HAVING COUNT(DISTINCT(IF((IFNULL(i.issues,0)+IFNULL(i.renewals,0))<20 AND i.itemlost=0 AND i.withdrawn=0 AND i.homebranch NOT IN ('GRABNGO') AND i.notforloan=0 AND i.stack IS NULL AND DATEDIFF(NOW(), DATE(IFNULL(i.datelastborrowed,i.datelastseen)))>'365',i.itemnumber, NULL)))>0

ORDER BY 1, 2, 3

LIMIT 50000
