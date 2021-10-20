SELECT
   IFNULL(x.ccode, CONCAT('(',x.itype,')')) AS collection,
   x.issues AS 'Circ ',
   (x.issues * 100)/(
     SELECT COUNT(s.datetime) AS 'total'
     FROM statistics s
     WHERE type = 'issue'
     AND s.datetime BETWEEN <<Circulated between|date>> AND <<and |date>>
   ) AS 'Percentage of total circ'#, COUNT(itemnumber)
FROM
   (SELECT IFNULL(i.ccode, i.itype) AS ccode, COUNT(s.datetime) AS 'issues', i.itype
   FROM statistics s
   JOIN items i USING (itemnumber)
   WHERE s.datetime BETWEEN <<Circulated between|date>> AND <<and |date>> AND s.type='issue' AND homebranch=<<Select branch|branches>>
   GROUP BY IFNULL(i.ccode,i.itype)) AS x
