-- Exported: 2026-06-21T21:55:41.442884+00:00
-- Schema:   dbo
-- Object:   BankTransactionCat
-- Type:     VIEW
-- Created:  2012-01-08 13:14:43.853000
-- Modified: 2017-05-28 15:41:58.370000

CREATE VIEW dbo.BankTransactionCat 
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
        ,csd.splitTransactionId
   FROM
     bankTransaction bt
     LEFT JOIN categorySplitDetails csd
       ON bt.transactionId = csd.parentTransactionId
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
                                 AND tte.splitTransactionId is null
                               ORDER BY e.taggedEventTag
                               FOR XML
                                 PATH ('')
                                ) c (x)
                GROUP BY
                  transactionId
                , x) tags
       ON bt.transactionId = tags.transactionId
   WHERE
     csd.parentTransactionId IS NULL
   UNION
   SELECT bt.transactionId
        , bt.transactionDate
        , bt.loadedDate
        , bt.description
        , bt.category
        , csd.splitAmount amount
        , a.accountId
        , a.accountName
        , csd.categoryId
        , origDescription
        , categoryStatus
        , bankOrigDescription
        , cat.categoryName
        , accountingDate
        , coalesce(tags.x,'') tags
        , coalesce(tags.tagCount,0) tagCount
        ,csd.splitTransactionId
   FROM
     bankTransaction bt
     INNER JOIN categorySplitDetails csd
       ON bt.transactionId = csd.parentTransactionId
     LEFT JOIN vSpendingCategories cat
       ON csd.categoryId = cat.categoryid
     LEFT JOIN account a
       ON bt.accountId = a.accountId
     LEFT JOIN (SELECT 
                    
                     tteOuter.splitTransactionId
                     , x
                     , count(*) tagCount
                FROM
                  transactionTaggedEvent tteOuter
                  CROSS APPLY (SELECT DISTINCT taggedEventTag + ';'
                               FROM
                                 transactionTaggedEvent tte
                                 INNER JOIN taggedEvent e
                                   ON e.taggedEventId = tte.taggedEventId
                               WHERE
                                 tte.splitTransactionId = tteOuter.splitTransactionId
                                 AND tte.splitTransactionId is NOT null
                               ORDER BY e.taggedEventTag + ';'
                                FOR XML
                                 PATH ('')) c (x)
                GROUP BY
                  tteOuter.splitTransactionId
                , x) tags
       ON csd.splitTransactionId = tags.splittransactionId
