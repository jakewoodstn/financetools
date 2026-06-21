-- Exported: 2026-06-21T21:55:41.634639+00:00
-- Schema:   dbo
-- Table:    autoParserNameExceptions

CREATE TABLE [dbo].[autoParserNameExceptions] (
    [autoParserNameExceptionId] int IDENTITY(b'\x01\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [pattern] varchar(255) NOT NULL,
    [accountFilter] int,
    [isActive] int NOT NULL DEFAULT ((1)),
    CONSTRAINT [PK_autoParserNameExceptions] PRIMARY KEY ([autoParserNameExceptionId])
);

