-- Exported: 2026-06-21T21:55:41.299736+00:00
-- Schema:   dbo
-- Object:   bankTransactionLoad_Process
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2020-09-07 17:28:31.400000
-- Modified: 2025-09-22 23:47:38.170000


CREATE PROCEDURE [dbo].[bankTransactionLoad_Process] (@tfile VARCHAR(1000) = '', @rawImportId int = null)
/***********************************************

IF OBJECT_ID('bankTransactionLoad_Process','P') IS NOT NULL DROP PROCEDURE bankTransactionLoad_Process
------
EXEC bankTransactionLoad_Process;
***********************************************/

AS
BEGIN
  --declare @tfile varchar(1000) = 'testfile';
  DECLARE @dttm DATETIME = GETDATE();
  set @tfile =nullif(@tfile, '')
  if @tfile is null and @rawImportId is null 
    RETURN
  
  if @rawImportId is not NULL
  BEGIN
    select @tfile = filename from raw.imported where import_id=@rawImportId
  end


  BEGIN TRAN

  --Insert into spendingCategories (categoryName)
  --select distinct category 
  --from bankTransactionLoad btl 
  --	left join spendingCategories sc on btl.category = sc.categoryName 
  --where sc.categoryId is null;

  UPDATE b
  SET b.categoryId = a.categoryId
  FROM spendingCategories a
  INNER JOIN bankTransactionLoad b
    ON a.categoryName = b.category;

  --	declare @dttm datetime = getdate();	declare @tfile varchar(10) = 'test';
  INSERT INTO bankTransactionLoadHx
    SELECT
      @dttm
     ,@tfile
     ,*
    FROM bankTransactionLoad;

  DELETE bl
    --select *
    FROM bankTransactionLoad bl
    INNER JOIN (SELECT DISTINCT
        accountid
       ,transactiondate
       ,bankOrigDescription
       ,amount
      FROM bankTransaction) b
      ON b.accountid = bl.accountid
      AND b.transactionDate = bl.transactionDate
      AND b.amount = bl.amount
      AND b.bankorigDescription = bl.OrigDescription;

  --declare @dttm datetime = getdate();	
  INSERT INTO bankTransaction (transactionID
  , transactionDate
  , loadedDate
  , description
  , origDescription
  , bankOrigDescription
  , category
  , categoryId
  , amount
  , accountId)
    SELECT
      bankTransactionLoad.transactionID
     ,bankTransactionLoad.transactionDate
     ,@dttm
     ,CASE
        WHEN NULLIF(bankTransactionLoad.UserDescription, '') IS NULL THEN OrigDescription
        ELSE UserDescription
      END
     ,CASE
        WHEN NULLIF(bankTransactionLoad.UserDescription, '') IS NULL THEN OrigDescription
        ELSE UserDescription
      END
     ,bankTransactionLoad.OrigDescription
     ,category
     ,categoryId
     ,amount
     ,banktransactionload.accountid
    FROM bankTransactionLoad
    INNER JOIN (SELECT DISTINCT
        a.accountid
      FROM transactionAccount ta
      INNER JOIN account a
        ON ta.accountId = a.accountId
      WHERE a.importTransactions = 1) sq
      ON bankTransactionLoad.accountid = sq.accountId
    WHERE (ISNULL(banktransactionLoad.SplitType, '') = ''
    OR banktransactionLoad.splittype = 'Parent');

  --JW: commented out description note on 2013-09-02, bankOrigDescription met this need months ago.

  --	insert into Note(TransactionId,NoteDate,note) select transactionid,GETDATE(),origdescription from bankTransactionLoad inner join 
  --	(select distinct a.accountid from transactionAccount ta 
  --		inner join account a on ta.accountId=a.accountId
  --	where a.importTransactions=1) sq on bankTransactionLoad.accountid=sq.accountId
  --	where ( banktransactionLoad.splitType = '' or banktransactionLoad.splittype = 'Parent');

  DECLARE @sdate DATE;
  DECLARE @edate DATE;

  DECLARE @minMeas DATE;
  DECLARE @maxMeas DATE;

  SELECT
    @sdate = MIN(transactionDate)
  FROM bankTransactionLoad;
  SELECT
    @edate = MAX(transactionDate)
  FROM bankTransactionLoad;

  DELETE DailyBalance
  WHERE MeasurementDate BETWEEN @sdate AND @edate;

  SELECT
    @minMeas = MIN(measurementDate)
  FROM DailyBalance
  WHERE MeasurementDate > @edate;
  SELECT
    @maxMeas = MAX(measurementDate)
  FROM DailyBalance
  WHERE MeasurementDate < @sdate;

  /* need to edit daily balance code to use accountID
	if @maxMeas is not null 
		begin
			exec DailyBalance_Loop  'Bank of America - Bank - Interest Checking-8971',null, @edate,1
		end;
	else if @minMeas is not null
		begin
			exec DailyBalance_Loop  'Bank of America - Bank - Interest Checking-8971',@sdate, null,-1
		end;*/

  --DELETE bankTransactionLoad;
  UPDATE bankTransaction
  SET accountingDate = transactionDate
  WHERE accountingDate IS NULL;

  COMMIT TRAN;

END;
