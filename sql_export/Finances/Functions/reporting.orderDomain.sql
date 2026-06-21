-- Exported: 2026-06-21T21:55:41.446162+00:00
-- Schema:   reporting
-- Object:   orderDomain
-- Type:     SQL_SCALAR_FUNCTION
-- Created:  2014-12-10 15:57:14.983000
-- Modified: 2014-12-10 15:57:14.983000

CREATE FUNCTION reporting.orderDomain (@fieldAlias NVARCHAR(MAX), @srcProbe NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN

  DECLARE @retval NVARCHAR(MAX);
  SELECT TOP 1
    @retval = COALESCE(orderingValue, @srcProbe)
  FROM reporting.domain d
  LEFT JOIN reporting.ordering o
  LEFT JOIN reporting.orderingDetail odet
    ON o.orderingId = odet.orderingId
    AND odet.sourceValue = @srcProbe
    ON d.domainId = o.domainId
  WHERE COALESCE(d.chartAlias, d.domainName) = @fieldAlias;
  RETURN @retval;
END;
