-- Exported: 2026-06-21T21:55:41.282528+00:00
-- Schema:   dbo
-- Object:   approveCat
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-11-22 10:13:56.827000
-- Modified: 2020-06-23 03:49:32.510000

CREATE procedure approveCat(@transarray varchar(max)) as
begin

declare @Split varchar(1)=',';
declare @X xml;

SELECT @X = CONVERT(xml,'<root><s>' + REPLACE(@transarray,@Split,'</s><s>') + '</s></root>')

create table #trans(transactionId bigint);

insert into #trans
SELECT [Value] = T.c.value('.','varchar(20)')
FROM @X.nodes('/root/s') T(c)

update bankTransaction set categoryStatus=-1
from bankTransaction inner join #trans on bankTransaction.transactionId=#trans.transactionId;

end;
