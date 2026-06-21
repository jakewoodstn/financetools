-- Exported: 2026-06-21T21:55:41.637229+00:00
-- Schema:   dbo
-- Table:    parameter

CREATE TABLE [dbo].[parameter] (
    [parameterId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [parameterName] varchar(255) NOT NULL,
    [TIMESTAMP] datetime2 NOT NULL DEFAULT (sysdatetime()),
    [parameterValue] varchar(max),
    CONSTRAINT [PK_parameter] PRIMARY KEY ([parameterId])
);

