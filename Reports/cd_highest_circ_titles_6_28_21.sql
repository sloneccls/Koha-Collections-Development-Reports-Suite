SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS 'Category', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS 'First Added','' AS 'Biblio Number','' AS 'Title','' AS 'Author','' AS 'Circs'

UNION

SELECT @type := <<Circ Category|top_circ_category>> AS 'Category',DATE_FORMAT(min(dateaccessioned), "%m" '/' "%d" '/' "%y") AS 'First Added', b.Biblionumber, CONCAT(
IF(b.title LIKE 'BOOK CLUB IN A BAG%','BKCLB:', b.title),' ',
 ExtractValue((
   SELECT metadata
    FROM biblio_metadata b2
   WHERE b.biblionumber = b2.biblionumber), '//datafield[@tag="245"]/subfield[@code="b"]'),
 ExtractValue((
    SELECT metadata
    FROM biblio_metadata b2
    WHERE b.biblionumber = b2.biblionumber),
    '//datafield[@tag="245"]/subfield[@code="n"]'),
 ExtractValue((
    SELECT metadata
    FROM biblio_metadata b2
    WHERE b.biblionumber = b2.biblionumber),
    '//datafield[@tag="245"]/subfield[@code="p"]')) AS Title, Author, count(s.type) AS 'Circs'
FROM statistics s
LEFT JOIN
(SELECT location, itemcallnumber, itemnumber, biblionumber, dateaccessioned, itype, ccode FROM deleteditems as di
UNION
 SELECT location, itemcallnumber, itemnumber, biblionumber, dateaccessioned, itype, ccode FROM items as ai) as i USING (itemnumber)
LEFT JOIN biblio b ON (i.biblionumber=b.biblionumber)
WHERE s.type IN ('issue','renew') and DATE(datetime) BETWEEN <<Circulated between|date>> AND <<and|date>> AND

CASE
    WHEN @type='ALLPUBLIC' THEN ((s.location IN ('ADULT','CHILDREN','YA')) OR (s.location IS NULL))
    WHEN @type='DVD' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('DVD','DVDMULTI','GRABGODVD')))
	WHEN @type='CHDVD' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('DVD','DVDMULTI','GRABGODVD'))) AND ((i.location='CHILDREN') OR (i.location IS NULL))
	WHEN @type='CD' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('MUSICCD')))
	WHEN @type='AUDIOBK' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('AUDIOBKCD')))
	WHEN @type='MPASS' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('MUSEUMPASS')))
	WHEN @type='BOOKCLB' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('BOOKCLUBBG')))
	WHEN @type='INTLANG' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('INTLANGUAGE'))) OR i.ccode='INTLANG'
	WHEN @type='ADBOOKS' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('BOOK','LARGEPRINT','PAPERBACK','REFERENCE','GRABGOBK'))) AND ((i.location='ADULT') OR (i.location IS NULL)) AND ((i.ccode NOT IN ('NONFICTION','BIOGRAPHY')) OR (i.ccode IS NULL))
	WHEN @type='CHBOOKS' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('BOOK','LARGEPRINT','PAPERBACK','REFERENCE','GRABGOBK'))) AND ((i.location='CHILDREN') OR (i.location IS NULL)) AND ((i.ccode NOT IN ('NONFICTION','BIOGRAPHY')) OR (i.ccode IS NULL))
	WHEN @type='YABOOKS' THEN ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('BOOK','LARGEPRINT','PAPERBACK','REFERENCE','GRABGOBK'))) AND ((i.location='YA') OR (i.location IS NULL)) AND ((i.ccode NOT IN ('NONFICTION','BIOGRAPHY')) OR (i.ccode IS NULL))
	ELSE ((itype IS NULL) OR (itype='TEMPORDER') OR (itype IN ('BOOK','LARGEPRINT','PAPERBACK','REFERENCE','GRABGOBK'))) AND ((itemcallnumber REGEXP '^[^0-9]*') OR (itemcallnumber REGEXP 'B+[[:space:]]+.*')) AND itemcallnumber NOT LIKE '%F %' AND itemcallnumber NOT LIKE '%Fp %' AND itemcallnumber NOT LIKE '%SF %' AND itemcallnumber NOT LIKE '%M %' AND itemcallnumber NOT LIKE '%R %'  AND ((i.ccode IN ('NONFICTION','BIOGRAPHY','NEW')) or (i.ccode IS NULL)) AND i.ccode NOT IN ('FICTION','MYSTERY')

END

GROUP BY biblionumber
ORDER BY 6 DESC
LIMIT 4
