--autotags - Checks
DECLARE @startDate DATE ='1/1/2018';
  DECLARE @endDate DATE ='12/31/2018';

  WITH candidates AS (SELECT 'Check'+rs.Token tag, description, transactionId FROM bankTransaction t  
  cross apply dbo.RegexSplit(description,'Xx+','[0-9]+',0) rs  
    WHERE t.accountingDate BETWEEN @startDate AND @endDate AND IsValid=1 and dbo.RegexIsMatch(description, 'Check\s',0)=1
  )
    INSERT into taggedEvent(taggedEventTag,effectiveDate,retiredDate) 
      SELECT candidates.tag,DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()),0),'12/31/2199' FROM candidates
      where candidates.tag not in (SELECT taggedEventTag from taggedEvent);


  WITH candidates AS (SELECT 'Check'+rs.Token tag, description, transactionId FROM bankTransaction t  
  cross apply dbo.RegexSplit(description,'Xx+','[0-9]+',0) rs  
    WHERE t.accountingDate BETWEEN @startDate AND @endDate AND IsValid=1 and dbo.RegexIsMatch(description, 'Check\s',0)=1
  )
    INSERT into transactionTaggedEvent (transactionId, taggedEventId, taggedAt, splitTransactionId)
    SELECT transactionId,e.taggedEventId,SYSDATETIME(),null FROM candidates, taggedEvent e WHERE e.taggedEventTag = 'Check'
    AND transactionId NOT in (SELECT transactionId FROM transactionTaggedEvent te INNER JOIN taggedEvent e1 ON te.taggedEventId = e1.taggedEventId where e1.taggedEventTag = 'Check');

      WITH candidates AS (SELECT 'Check'+rs.Token tag, description, transactionId FROM bankTransaction t  
  cross apply dbo.RegexSplit(description,'Xx+','[0-9]+',0) rs  
    WHERE t.accountingDate BETWEEN @startDate AND @endDate AND IsValid=1 and dbo.RegexIsMatch(description, 'Check\s',0)=1
  )
    INSERT into transactionTaggedEvent (transactionId, taggedEventId, taggedAt, splitTransactionId)
    SELECT candidates.transactionId,e.taggedEventId,SYSDATETIME(),null FROM candidates INNER JOIN taggedEvent e ON  e.taggedEventTag = candidates.tag
        LEFT JOIN transactionTaggedEvent te ON e.taggedEventId = te.taggedEventId and candidates.transactionId = te.transactionId 
        WHERE te.transactionTaggedEventId is NULL;
    