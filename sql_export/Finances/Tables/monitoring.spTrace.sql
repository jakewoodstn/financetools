-- Exported: 2026-06-21T21:55:41.640986+00:00
-- Schema:   monitoring
-- Table:    spTrace

CREATE TABLE [monitoring].[spTrace] (
    [RowNumber] int IDENTITY(b'\x00\x00\x00\x00',b'\x01\x00\x00\x00') NOT NULL,
    [EventClass] int,
    [TextData] ntext,
    [DatabaseID] int,
    [DatabaseName] nvarchar(128),
    [ObjectID] int,
    [ObjectName] nvarchar(128),
    [ServerName] nvarchar(128),
    [BinaryData] image,
    [SPID] int,
    [StartTime] datetime,
    [ApplicationName] nvarchar(128),
    [Duration] bigint,
    CONSTRAINT [PK_spTrace] PRIMARY KEY ([RowNumber])
);

