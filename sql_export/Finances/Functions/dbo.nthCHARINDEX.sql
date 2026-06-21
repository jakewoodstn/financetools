-- Exported: 2026-06-21T21:55:41.281349+00:00
-- Schema:   dbo
-- Object:   nthCHARINDEX
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:16.410000
-- Modified: 2014-12-10 15:57:16.410000

CREATE FUNCTION dbo.nthCHARINDEX(@strtofind VARCHAR(MAX),@str VARCHAR(MAX),@start INT, @n int) RETURNS int AS 
  BEGIN
    
     DECLARE @keeplooking int =1;
     DECLARE @found INT=0;
     DECLARE @netFound INT = 0;
     DECLARE @ctr INT =0;
     
     SET @str=right(@str,len(@str)-@start+1);
     
     WHILE @keeplooking=1
      BEGIN
        SET @found=CHARINDEX(@strtofind,@str)
          IF @found>0
            begin
            SET @str=RIGHT(@str,LEN(@str)-@found-LEN(@strtofind)+1)
            SET @netFound=@netFound+@found
            SET @ctr=@ctr+1
            SET @keeplooking = IIF(@ctr=@n,0,1)
            IF @keeplooking = 1 SET @netFound=@netFound + LEN(@strtofind)-1
            END
          ELSE
            BEGIN
            SET @keeplooking=0;
            SET @netFound = 0;
            END;
      END;
     
    RETURN @netFound;

  END;
