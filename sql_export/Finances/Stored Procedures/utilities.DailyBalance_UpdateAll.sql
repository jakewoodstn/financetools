-- Exported: 2026-06-21T21:55:41.467396+00:00
-- Schema:   utilities
-- Object:   DailyBalance_UpdateAll
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2013-03-13 12:09:38.383000
-- Modified: 2024-06-15 16:39:54.550000

-- =============================================
-- Author:		JW
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [utilities].[DailyBalance_UpdateAll]
  -- Add the parameters for the stored procedure here
  (@accountId INT)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  drop table if exists DailyBalance_backup
  select * into DailyBalance_backup from DailyBalance
  delete DailyBalance where accountId=0

  DECLARE @mindate DATE;
  DECLARE @maxDate DATE;

  declare @accts table (accountId int, used int DEFAULT 0)

  insert into @accts select accountId,0 from account a where importTransactions = 1
  if @accountId >0 delete @accts where accountId <> @accountId

  WHILE EXISTS (SELECT 1 from @accts where used =0)
  BEGIN
    SELECT
      @accountId = MIN(accountId)
    FROM @accts where used = 0

    select @mindate = min(da.MeasurementDate)
    from DailyBalance da
      LEFT join DailyBalance db 
          on da.accountId = db.accountId 
          and dateadd(day,1,da.MeasurementDate) = db.MeasurementDate
    where db.MeasurementDate is null and da.accountId = @accountId

    select @maxDate = dateadd(day, -1, min(measurementdate)) from DailyBalance where MeasurementDate>@mindate and accountId = @accountId

    select @maxDate = coalesce(@maxDate, max(accountingdate) ,cast(getdate() as date)) from bankTransaction where accountid = @accountId

    EXEC utilities.DailyBalance_Loop @accountId,
                            @mindate,
                            @maxDate,
                            1;
    
    update @accts set used = 1 where accountId=@accountId

  END;

  WITH 
  maxDates as (select accountId,max(measurementDate) maxDate from DailyBalance where accountId>0 group by accountId) ,
  balanceForward as (
      select db.accountId, db.Amount 
      from DailyBalance db
      inner join maxDates md on md.accountId = db.accountId and db.MeasurementDate = md.maxDate
  )
  , alldates as (select distinct measurementDate,allAccounts.accountId 
                from DailyBalance 
                cross apply (select distinct accountId from DailyBalance where accountId >= 0) allAccounts
                )
  insert into DailyBalance
  (accountId,MeasurementDate,amount)
  select 0, ad.MeasurementDate, sum(coalesce(db.amount,bf.Amount)) from alldates ad
      inner join balanceForward bf on ad.accountId = bf.accountId
      left join DailyBalance db on db.accountId = ad.accountId and db.MeasurementDate = ad.MeasurementDate
      group by ad.MeasurementDate
  
END
