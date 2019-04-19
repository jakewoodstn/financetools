--autotags - paypal

INSERT into transactionTaggedEvent (transactionId, taggedEventId, taggedAt)
  SELECT transactionId,1219,SYSDATETIME() FROM bankTransaction t WHERE t.accountingDate BETWEEN '11/1/2018' AND '12/31/2018' AND t.description= 'Paypal'
  AND transactionId NOT IN (select transactionId FROM transactionTaggedEvent te WHERE taggedEventId = 1219)


  