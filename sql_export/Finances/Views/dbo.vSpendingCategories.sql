-- Exported: 2026-06-21T21:55:41.443935+00:00
-- Schema:   dbo
-- Object:   vSpendingCategories
-- Type:     VIEW
-- Created:  2011-12-17 23:10:15.373000
-- Modified: 2012-01-08 21:57:11.763000


CREATE view [dbo].[vSpendingCategories] as
select categoryid, case when gp.groupid  in (-1,2) then '' else groupname + ' - ' end +categoryName as categoryName , gp.groupid from spendingCategories sc
inner join spendingCategoryGroup gp on sc.groupID = gp.groupID
