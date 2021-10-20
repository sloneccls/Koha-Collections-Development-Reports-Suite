SELECT *
FROM
  (SELECT (@branch := <<Homebranch|branches>> COLLATE utf8mb4_unicode_ci) AS 'Call Number',
          (@ncir := <<Number OF Years NOT Circulated>> COLLATE utf8mb4_unicode_ci) AS 'Author',
          (@lost := <<Should lost/missing items be included?|YES_NO>> COLLATE utf8mb4_unicode_ci) AS 'Title',
          (@wd := <<Should withdrawn items be included?|YES_NO>> COLLATE utf8mb4_unicode_ci) AS 'Collection Code',

          #If using custom authorized values you will need to change the three below to reflect them
          (@col := <<What Collection?|ccode>> COLLATE utf8mb4_unicode_ci) AS 'Barcode',
          (@audi := <<What Audience?|loc>> COLLATE utf8mb4_unicode_ci) AS 'Issues',
          ( @type := <<What Item Type?|itemtypes>> COLLATE utf8mb4_unicode_ci) AS 'Renewals',

          ' ' AS 'Location',
          ' ' AS 'Most Recent Activity',
          ' ' AS Date,
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
SELECT itemcallnumber AS 'Call Number',
       Author,
       Title,
       ccode AS 'Collection Code',
       Barcode,
       Issues,
       items.Renewals,
       LOCATION,
       IF(datelastborrowed IS NULL, 'Local Use Scan', 'Last Borrowed') AS 'Most Recent Activity',
       IF(datelastborrowed IS NULL, DATE_FORMAT(datelastseen, "%m" '/' "%d" '/' "%y"), DATE_FORMAT(datelastborrowed, "%m" '/' "%d" '/' "%y")) AS Date,
       IF(itemlost<>'0', v.lib, IF(onloan IS NOT NULL, CONCAT('Checked Out, Due ', DATE_FORMAT(onloan, "%m" '/' "%d" '/' "%y")), IF(waitingdate IS NOT NULL, CONCAT('Holdshelf - ', reserves.branchcode), IF(withdrawn=1, 'Withdrawn', 'Available')))) AS Status
FROM items
LEFT JOIN biblio USING (biblionumber)
LEFT JOIN authorised_values v ON (items.itemlost=v.authorised_value)
LEFT JOIN reserves USING (itemnumber)
WHERE homebranch = @branch
  AND YEAR(NOW())-YEAR(IFNULL(datelastborrowed, datelastseen)) > @ncir
  AND v.category='LOST'

#uncomment the below and edit to reflect your desired collections and locations if using custom Authorized Values
  #AND CASE
  #        WHEN @col='ALLPUBLIC' THEN ((ccode IN ('BIOGRAPHY',
  #                                               'etc...'
  #                                             ))
  #                                    OR (ccode IS NULL))
  #        ELSE ccode=@col
  #    END
#

#  AND CASE
#          WHEN @audi='ADULT' THEN LOCATION IN ('ADULT')
#          WHEN @audi='CHILDREN' THEN LOCATION IN ('CHILDREN')
#          WHEN @audi='YA' THEN LOCATION IN ('YA')
#          ELSE ((LOCATION IN ('ADULT',
#                              'CHILDREN',
#                              'YA'))
#                OR (LOCATION IS NULL))
#      END

  AND IF(@lost='0', itemlost IN ('0'), itemlost IS NOT NULL)
  AND IF(@wd='0', withdrawn IN ('0'), withdrawn IS NOT NULL)

#Uncomment and replicate as many times as needed for any common strings for records that you may use as dummy records
#  AND title NOT LIKE '[Member%'

#uncomment the below and edit to reflect your desired item types if using custom Authorized Values
#  AND
#  CASE
#   	WHEN @type='BOOK' THEN itype IN ('BOOK','etc...')
#	WHEN @type='DVD' THEN itype IN ('DVD','etc...')
#	WHEN @type='CD' THEN itype IN ('MUSICCD')
#	WHEN @type='AUDIOBK' THEN itype IN ('AUDIOBKCD')
#	ELSE ((itype IN ('AUDIOBKCD','etc...')) or (itype IS NULL))
#END

  AND barcode IS NOT NULL
GROUP BY itemnumber
ORDER BY LOCATION,
         1,
         author,
         title, Date
LIMIT 50000
