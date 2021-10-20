SELECT *
FROM (
    SELECT
    ( @branch := <<Branch|branches>> COLLATE utf8mb4_unicode_ci) AS 'CallNumber',
    ( @pubd := <<Items Published Before This Year>> COLLATE utf8mb4_unicode_ci) AS 'Author',
  	( @lost := <<Should lost/missing items be included?|YES_NO>> COLLATE utf8mb4_unicode_ci) AS	'Title',
	'' AS 'Collection Code',
    '' AS 'Barcode',
    ( @stcall := <<Starting Call Number?>> COLLATE utf8mb4_unicode_ci) AS 'Status',
	( @ecall := <<Ending Call Number?>> COLLATE utf8mb4_unicode_ci)  AS 'Publication Date'
	    ) AS `set variables`
WHERE 0 = 1

UNION ALL


SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '', '', '', '', '',''

UNION


SELECT LTRIM(itemcallnumber) AS CallNumber, Author, Title, ccode as 'Collection Code', Barcode, IFNULL(v.lib, ' ') as 'Status', IF(
          Substring(ExtractValue(metadata,'//controlfield[@tag="008"]'), 8,4 ) LIKE '% %', IFNULL(ExtractValue(
              (SELECT metadata
               FROM biblio_metadata
               WHERE i.biblionumber = biblio_metadata.biblionumber),'//datafield[@tag="260"]/subfield[@code="c"]'), ExtractValue(
              (SELECT metadata
               FROM biblio_metadata
               WHERE i.biblionumber = biblio_metadata.biblionumber),'//datafield[@tag="264"]/subfield[@code="c"]')),
          Substring(ExtractValue(metadata,'//controlfield[@tag="008"]'), 8,4 )) as PubDate
FROM items i
LEFT JOIN biblio USING (biblionumber)
LEFT JOIN biblio_metadata USING (biblionumber)
LEFT JOIN authorised_values v ON (i.itemlost=v.authorised_value)
WHERE v.category='LOST' AND homebranch = @branch AND

#edit the below list so it comprises the collections you want
((ccode IN ('BIOGRAPHY','etc..')) OR (ccode IS NULL))

AND

#edit the below list so it comprises the item types you want
  IF(@lost='1', itemlost IS NOT NULL, itemlost IN ('0')) AND itype IN ('BOOK','etc..')

AND

#uncomment the below and edit to reflect your desired locations if using custom Authorized Values
# CASE
#    WHEN @audi='ADULT' THEN location IN ('ADULT')
#	WHEN @audi='CHILDREN' THEN location IN ('CHILDREN')
#	WHEN @audi='YA' THEN location IN ('YA')
#	ELSE location IN ('ADULT','CHILDREN','YA')
#  END
#AND

 substring( ExtractValue(metadata,'//controlfield[@tag="008"]'), 8,4 )< @pubd

#this is a list of potentials undersired call numbers string beginnings for non-fiction, yours may vary
AND
itemcallnumber NOT LIKE '%F %' AND
itemcallnumber NOT LIKE '%Mp %' AND
itemcallnumber NOT LIKE '%M %' AND
itemcallnumber NOT LIKE '%Fp %' AND
#itemcallnumber NOT LIKE '%E %' AND
#itemcallnumber NOT LIKE '%Ep %' AND
#itemcallnumber NOT LIKE '%ER %' AND
#itemcallnumber NOT LIKE '%J %' AND
#itemcallnumber NOT LIKE '%Jp %' AND
#itemcallnumber NOT LIKE '%Y %'  AND
#itemcallnumber NOT LIKE '%Yp %'  AND
#itemcallnumber NOT LIKE '%E %' AND
#itemcallnumber NOT LIKE '%Ep %' AND
#itemcallnumber NOT LIKE '%ER %' AND
#itemcallnumber NOT LIKE '%ERp %' AND
itemcallnumber NOT LIKE '%GRAPHIC NOVEL E %' AND
itemcallnumber NOT LIKE '%GRAPHIC NOVEL ER %' AND
itemcallnumber NOT LIKE '%GRAPHIC NOVEL J %' AND
itemcallnumber NOT LIKE '%GRAPHIC NOVEL Y %'
GROUP BY itemnumber
HAVING CASE
	WHEN @ecall='all' THEN CallNumber LIKE '%'
	WHEN @stcall='all' THEN CallNumber LIKE '%'

	ELSE CONCAT(IF(
        CallNumber REGEXP '^[^0-9]+[0-9]{3}[^0-9]+.*',
        LEFT(SUBSTR(CallNumber,LOCATE(' ',CallNumber)+1),2) ,
        LEFT(CallNumber,2)
    ),'0') BETWEEN LTRIM(RTRIM(@stcall)) AND LTRIM(RTRIM(@ecall))
  END

ORDER BY 1,7
LIMIT 50000
