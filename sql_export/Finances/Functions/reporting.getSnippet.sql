-- Exported: 2026-06-21T21:55:41.445783+00:00
-- Schema:   reporting
-- Object:   getSnippet
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:14.997000
-- Modified: 2014-12-10 15:57:14.997000

CREATE FUNCTION reporting.getSnippet(@snippetName varchar(255)) RETURNS NVARCHAR(MAX)
  AS
  BEGIN

  DECLARE @retval NVARCHAR(MAX);

  IF ISNUMERIC(@snippetname)=1
    SELECT @snippetName= d.domainField FROM reporting.domain d WHERE d.domainId=@snippetName

  SELECT @retval=snippetSQL FROM reporting.snippet s WHERE s.snippetName=@snippetName;
  IF @retval IS NULL
      SELECT @retval = reporting.domain.domainField FROM reporting.domain where reporting.domain.domainName=@snippetName;
  
  RETURN COALESCE(@retval,@snippetName);

  END;
