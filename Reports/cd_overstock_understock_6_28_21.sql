SELECT *
FROM ( SELECT
 (@over := <<Overstock Threshold>> COLLATE utf8mb4_unicode_ci) AS 'Item Type',
 (@under := <<Understock Threshold>> COLLATE utf8mb4_unicode_ci) AS 'Collection Code',
#(@over := .8 COLLATE utf8mb4_unicode_ci) AS 'Item Type',
#(@under := .3 COLLATE utf8mb4_unicode_ci) AS 'Collection Code',
 (@branch := <<Branch|branches>> COLLATE utf8mb4_unicode_ci) AS 'Total Items', 'Inactive Items ', '% Inactive', 'Status') AS `set variables`
WHERE 0 = 1

UNION ALL


SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '', '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '','','','',''

UNION



SELECT itype, ' ', SUM(active_count) AS 'Total Items', SUM(inactive_count) AS
'Inactive Items', ROUND(SUM(inactive_count)/SUM(active_count),2) AS 'Perc Inactive', IF( ROUND(SUM(inactive_count)/SUM(active_count),2) >=@over, 'Overstocked', IF( ROUND(SUM(inactive_count)/SUM(active_count),2)<=@under, 'Understocked','OK')) AS
Stockage
FROM ( SELECT itype, ccode, CASE
WHEN notforloan<>'-1' THEN 1 ELSE 0 END active_count, CASE
WHEN notforloan<>'-1' AND ((datelastborrowed <= <<Active if borrowed after|date>>) OR (datelastborrowed IS NULL)) THEN 1 ELSE 0 END inactive_count
FROM items
WHERE itype IN ('AUDIOBKCD','BOOK','PAPERBACK','BOOKCLUBBG','DVD','DVDMULTI','GRABGOBK','GRABGODVD','INTLANG','LARGEPRINT') AND homebranch=@branch
#AND homebranch NOT IN ('COLLEGEBLK','CECONTENT','ECONTENT','CORRECTIONAL')
LIMIT 1000000) AS i
GROUP BY 1

ORDER BY 1, 2 
