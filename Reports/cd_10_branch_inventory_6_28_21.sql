SELECT *

FROM

  (SELECT (

  		  @branch := <<Run Inventory for which branch?|branches>> COLLATE utf8mb4_unicode_ci) AS 'Author',

          ' ' AS 'Title',

          ' ' AS 'Barcode',

          (@lost := <<Should lost/missing items be included?|YES_NO>> COLLATE utf8mb4_unicode_ci) AS 'Call Number',

          (@wd := <<Should withdrawn items be included?|YES_NO>> COLLATE utf8mb4_unicode_ci) AS 'Item Type',

          (@col := <<What Collection?|col_dev_itypes>> COLLATE utf8mb4_unicode_ci) AS 'Collection',

          (@audi := <<What Audience?|col_dev_locations>> COLLATE utf8mb4_unicode_ci) AS 'Shelving Location',

          ' ' AS 'Date Added',

          ' ' AS 'Last Checkout',

          ' ' AS 'Lifetime Checkouts',

          ' ' AS 'Status') AS `set variables`

WHERE 0 = 1

UNION ALL

SELECT '<link rel="stylesheet" type="text/css" href="https://***path/to/your/server/files/coll_development_reports.css">' AS '',

       '<script src="/intranet-tmpl/lib/jquery/jquery-2.2.3.min_18.1110000.js"></script><script type="text/javascript" src="https://***path/to/your/server/files/coll_dev.js"></script>' AS '',

       '',

       '',

       '',

       '',

       '',

       '',

       '',

       '',

       ''

UNION

SELECT IFNULL(author, IF(itype IN ('MUSICCD'), ExtractValue((
    SELECT metadata
    FROM biblio_metadata b2
    WHERE biblio.biblionumber = b2.biblionumber),
    '//datafield[@tag="245"]/subfield[@code="c"]'),' ')) as Author,

    CONCAT(title, ' ', ExtractValue(metadata, '//datafield[@tag="245"]/subfield[@code="b"]'), ExtractValue(metadata, '//datafield[@tag="245"]/subfield[@code="n"]'), ExtractValue(metadata, '//datafield[@tag="245"]/subfield[@code="p"]')) AS Title,

       Barcode,

       LTRIM(itemcallnumber) AS "Call Number",

       Itype,

       items.ccode AS Collection,

       items.location AS "Shelving Location",

       DATE_FORMAT(dateaccessioned, "%m" '/' "%d" '/' "%y") AS 'Date Added',

       DATE_FORMAT(datelastborrowed, "%m" '/' "%d" '/' "%y") AS "Last Checkout",

       IFNULL(issues, '0') AS "Lifetime Checkouts",

       IF(itemlost<>'0', v.lib, IF(onloan IS NOT NULL, CONCAT('Checked Out, Due ', DATE_FORMAT(onloan, "%m" '/' "%d" '/' "%y")), IF(waitingdate IS NOT NULL, CONCAT('Holdshelf - ', reserves.branchcode), IF(withdrawn=1, 'Withdrawn', 'Available')))) AS Status

FROM items

LEFT JOIN biblio USING (biblionumber)

LEFT JOIN biblio_metadata USING (biblionumber)

LEFT JOIN statistics USING (itemnumber)

LEFT JOIN reserves USING (itemnumber)

LEFT JOIN authorised_values v ON (items.itemlost=v.authorised_value)

WHERE homebranch = @branch

  AND notforloan<>'-1'

  AND v.category='LOST'

#uncomment the below and edit to reflect your desired collections if using custom Authorized Values
#  AND CASE
#          WHEN @col='ALLPUBLIC' THEN ((items.ccode IN (
#                                                 'BIOGRAPHY',
#                                                 'etc...'))
#                                      OR (items.ccode IS NULL))
#          ELSE items.ccode=@col

      END
#uncomment the below and edit to reflect your desired locations if using custom Authorized Values
#  AND CASE
#          WHEN @audi='ADULT' THEN items.LOCATION IN ('ADULT')
#          WHEN @audi='CHILDREN' THEN items.LOCATION IN ('CHILDREN')
#          WHEN @audi='YA' THEN items.LOCATION IN ('YA')
#          ELSE ((items.LOCATION IN ('ADULT',
#                              'CHILDREN',
#                              'YA'))
#                OR (items.LOCATION IS NULL))
#      END

  AND IF(@lost='0', itemlost IN ('0'), itemlost IS NOT NULL)

  AND IF(@wd='0', withdrawn IN ('0'), withdrawn IS NOT NULL)

GROUP BY itemnumber

ORDER BY 11,

         7,

         5,

         6,

         4,

         1
LIMIT 500000
