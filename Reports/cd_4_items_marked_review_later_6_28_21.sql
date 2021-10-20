SELECT IF(
	i.itemcallnumber IS NULL,' ', i.itemcallnumber) AS 'Call Number', IFNULL(
	author, IF(itype IN ('MUSICCD'), ExtractValue(( SELECT metadata FROM biblio_metadata b2 WHERE i.biblionumber = b2.biblionumber), '//datafield[@tag="245"]/subfield[@code="c"]'),' ')) as Author, CONCAT(
	'<a href=\"/cgi-bin/koha/catalogue/detail.pl?biblionumber=', i.biblionumber, '\" target="_blank" >', IF(title LIKE 'BOOK CLUB IN A BAG%','BKCLB:', title),' ', ExtractValue(( SELECT metadata FROM biblio_metadata b2 WHERE i.biblionumber = b2.biblionumber), '//datafield[@tag="245"]/subfield[@code="b"]'), ExtractValue(( SELECT metadata FROM biblio_metadata b2 WHERE i.biblionumber = b2.biblionumber), '//datafield[@tag="245"]/subfield[@code="n"]'), ExtractValue(( SELECT metadata FROM biblio_metadata b2 WHERE i.biblionumber = b2.biblionumber), '//datafield[@tag="245"]/subfield[@code="p"]'), '</a>' ) AS Title, IF(
	itype='PAPERBACK', CONCAT(
	i.ccode, ' (pbk)'), i.ccode) AS 'Collection Code',
	itemnumber, CONCAT(
	'<code>', i.Barcode, '</code>') as Barcode, v.lib
	AS 'Damaged Status',
	damaged_on
FROM items i
LEFT JOIN biblio USING (biblionumber)
LEFT JOIN authorised_values v ON (i.damaged=v.authorised_value)

#change i.damaged to the value you assign if different from 10

WHERE i.damaged='10' AND v.category='damaged' AND DATE(i.damaged_on)<(DATE_SUB(CURDATE(),INTERVAL 90 DAY))
LIMIT 500000

	UNION

SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS 'Call Number', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS 'Title','' AS 'iType','' AS 'Collection Code','' AS 'Itemnumber','' AS 'Barcode', '' AS 'Damaged Status','' AS 'Damaged on'
ORDER BY 7, 4, 5, 2, 3
