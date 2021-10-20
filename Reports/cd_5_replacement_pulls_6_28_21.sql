SELECT *
FROM (
    SELECT
    (@branch := <<Branch|branches>> COLLATE utf8mb4_unicode_ci) AS 'Call Number',
    '' AS 'Author',
  	'' AS 'Title',
	'' AS 'Collection Code',
    '' AS 'Itemnumber',
    '' AS 'Barcode',
	'' AS 'Send to'

    ) AS `set variables`
WHERE 0 = 1

UNION ALL


SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '', '', '', '', '', ''

UNION



SELECT IF(i.itemcallnumber IS NULL,' ', i.itemcallnumber) AS 'Call Number', IFNULL(author, IF(itype IN ('MUSICCD'), ExtractValue((
    SELECT metadata
    FROM biblio_metadata b2
    WHERE i.biblionumber = b2.biblionumber),
    '//datafield[@tag="245"]/subfield[@code="c"]'),' ')) as Author,  CONCAT(
        '<a href=\"/cgi-bin/koha/catalogue/detail.pl?biblionumber=',
        i.biblionumber,
        '\" target="_blank" >', IF(title LIKE 'BOOK CLUB IN A BAG%','BKCLB:', title),' ',
 ExtractValue((
   SELECT metadata
    FROM biblio_metadata b2
   WHERE i.biblionumber = b2.biblionumber), '//datafield[@tag="245"]/subfield[@code="b"]'),
 ExtractValue((
    SELECT metadata
    FROM biblio_metadata b2
    WHERE i.biblionumber = b2.biblionumber),
    '//datafield[@tag="245"]/subfield[@code="n"]'),
 ExtractValue((
    SELECT metadata
    FROM biblio_metadata b2
    WHERE i.biblionumber = b2.biblionumber),
    '//datafield[@tag="245"]/subfield[@code="p"]'),
        '</a>'
    ) AS Title, IF(
 itype='PAPERBACK', CONCAT(i.ccode, ' (pbk)'), i.ccode) AS 'Collection Code', itemnumber, CONCAT('<code>', i.Barcode, '</code>') as Barcode, v.lib AS 'Send To'
FROM items i
LEFT JOIN biblio USING (biblionumber)
LEFT JOIN authorised_values v ON (i.stack=v.authorised_value)
WHERE stack IS NOT NULL AND v.category='replacements' AND homebranch=@branch
ORDER BY 7, 4, 5, 2, 3
LIMIT 50000
