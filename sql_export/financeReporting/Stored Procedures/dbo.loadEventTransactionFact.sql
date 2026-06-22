-- Exported: 2026-06-21T21:55:42.270106+00:00
-- Schema:   dbo
-- Object:   loadEventTransactionFact
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-06-27 23:20:05.677000
-- Modified: 2021-02-07 20:00:36.607000


CREATE PROC dbo.loadEventTransactionFact(@startdate DATE, @enddate DATE)
AS
BEGIN

  DELETE fet FROM factEventTransaction fet INNER JOIN (
  SELECT et.transactionId, et.eventId FROM factEventTransaction et
      INNER JOIN factTransaction t ON et.transactionId = t.transactionId
      INNER JOIN dimDate d ON t.dateSK = d.DateSK
      WHERE d.FullDate BETWEEN @startdate AND @enddate
  EXCEPT  
  SELECT t.transactionId,t.eventId FROM staging.eventTransaction t
     INNER JOIN vwDescriptionEvent de ON t.eventId = de.eventId
     WHERE de.eventDomainId IN (2,3)
)sq ON fet.transactionId=sq.transactionId AND fet.eventId = sq.eventId 
  
  
  INSERT INTO factEventTransaction (transactionId, eventId)
  SELECT t.transactionId,t.eventId FROM staging.eventTransaction t
     INNER JOIN vwDescriptionEvent de ON t.eventId = de.eventId
     WHERE de.eventDomainId IN (2,3)
  EXCEPT
  SELECT et.transactionId, et.eventId FROM factEventTransaction et
      INNER JOIN factTransaction t ON et.transactionId = t.transactionId
      INNER JOIN dimDate d ON t.dateSK = d.DateSK
      WHERE d.FullDate BETWEEN @startdate AND @enddate
  
END
