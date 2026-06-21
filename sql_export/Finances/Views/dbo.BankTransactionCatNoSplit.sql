-- Exported: 2026-06-21T21:55:41.443588+00:00
-- Schema:   dbo
-- Object:   BankTransactionCatNoSplit
-- Type:     VIEW
-- Created:  2012-12-30 18:30:01.587000
-- Modified: 2014-08-05 18:46:08.280000

CREATE VIEW dbo.BankTransactionCatNoSplit 
AS SELECT bt.transactionId
        , bt.transactionDate
        , bt.loadedDate
        , bt.description
        , bt.category
        , amount
        , a.accountId
        , a.accountName
        , bt.categoryId
        , origDescription
        , categoryStatus
        , bankOrigDescription
        , cat.categoryName
        , accountingDate
        , coalesce(tags.x,'') tags
        , coalesce(tags.tagCount,0) tagCount
   FROM
     bankTransaction bt
     LEFT JOIN vSpendingCategories cat
       ON bt.categoryId = cat.categoryid
     LEFT JOIN account a
       ON bt.accountId = a.accountId
     LEFT JOIN (SELECT transactionId
                     , x
                     , count(*) tagCount
                FROM
                  transactionTaggedEvent tteOuter
                  CROSS APPLY (SELECT taggedEventTag + ';'
                               FROM
                                 transactionTaggedEvent tte
                                 INNER JOIN taggedEvent e
                                   ON e.taggedEventId = tte.taggedEventId
                               WHERE
                                 tte.transactionId = tteOuter.transactionId
                               ORDER BY e.taggedEventTag
                                FOR XML
                                 PATH ('')) c (x)
                GROUP BY
                  transactionId
                , x) tags
       ON bt.transactionId = tags.transactionId
