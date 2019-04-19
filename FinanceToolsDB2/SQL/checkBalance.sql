SELECT * FROM vwCurrentBalances cb

  SELECT TOP 30 * FROM DailyBalance db WHERE db.accountId = 1 ORDER by db.MeasurementDate DESC

    SELECT * FROM bankTransaction t WHERE t.accountId = 1 and t.accountingDate = '1/11/2019'