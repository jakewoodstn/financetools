-- Exported: 2026-06-21T21:55:41.418174+00:00
-- Schema:   dbo
-- Object:   saveSplit
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2012-12-31 22:30:00.767000
-- Modified: 2020-06-23 04:05:02.240000

CREATE procedure dbo.saveSplit(@splitid int=0, @tranid int = 0, @cat int=0, @amt money=0, @tags VARCHAR(MAX)='') as 

begin 

	Merge categorySplitDetails t
	using (select @splitid,@tranid,@cat,@amt) s(splitid,tranid,cat,amt)
	on splitTransactionId=splitid
	when matched and (tranid=0 or parenttransactionId=tranid) then 
		update set categoryid=cat , splitamount=amt
	when not matched and (@splitid=0 and @tranid<> 0) then 
		insert (parenttransactionid,categoryid,splitamount) values(tranid,cat,amt);

	if @tranid<> 0 update bankTransaction set categoryId=-1, category='Split' where transactionId=@tranid;

  IF @tranid<> 0
    EXEC changeTags @tranId ,
                     @tags,
                     @splitId
    

end;
