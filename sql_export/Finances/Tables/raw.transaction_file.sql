-- Exported: 2026-06-21T21:55:41.641531+00:00
-- Schema:   raw
-- Table:    transaction_file

CREATE TABLE [raw].[transaction_file] (
    [rn] int,
    [import_id] int,
    [DATE] date,
    [account] varchar(255),
    [description] varchar(max),
    [category] varchar(max),
    [tags] varchar(max),
    [amount] smallmoney
);

