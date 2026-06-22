-- Exported: 2026-06-21T21:55:42.269437+00:00
-- Schema:   dbo
-- Object:   loadDimensions
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2019-07-12 14:30:04.140000
-- Modified: 2019-07-12 14:30:30.957000


CREATE PROCEDURE loadDimensions
AS
BEGIN

  SET NOCOUNT ON

  EXEC loadAccount
  EXEC loadBudget
  EXEC loadSubbudget
  EXEC loadPayee
  EXEC loadCategoryGroup
  EXEC loadCategory
  EXEC loadSubcategory
  EXEC loadEvent

END
