

ALTER PROCEDURE dbo.typicalPayeeMapping (@testid BIGINT = 0, @debug INT = 0)
AS
BEGIN
  DECLARE @workSurface TABLE (
    transactionId BIGINT,
    accountId INT,
    token NVARCHAR(255),
    UNIQUE NONCLUSTERED (transactionId, token)
  );


  INSERT INTO @workSurface
    SELECT DISTINCT
      transactionId,
      sq.accountId,
      LEFT(s.token, 255)
    FROM (SELECT
      transactionId,
      t.accountId,
      COALESCE(t.bankOrigDescription, t.origDescription, t.description) description
    FROM bankTransaction t
    WHERE transactionId = @testid) sq
    CROSS APPLY dbo.Split(REPLACE(description,':',' : ') , ' ', 1, DEFAULT, 0) s


  DECLARE @reference TABLE (
    transactionId BIGINT,
    accountId INT,
    token NVARCHAR(255),
    UNIQUE NONCLUSTERED (transactionId, token)
  );


  INSERT INTO @reference
    SELECT DISTINCT
      transactionId,
      sq.accountId,
      LEFT(s.token, 255)
    FROM (SELECT
      transactionId,
      t.accountId,
      COALESCE(t.bankOrigDescription, t.origDescription, t.description) description
    FROM bankTransaction t
    WHERE 
      COALESCE(t.bankOrigDescription, t.origDescription, '') <> t.description
    AND transactionDate >= DATEADD(YEAR, -2, GETDATE())) sq
    CROSS APPLY dbo.Split(replace(description,':',' : '), ' ', 1, DEFAULT, 0) s


  DECLARE @results TABLE (
    transIdw BIGINT,
    transidr BIGINT,
    PRIMARY KEY (transIdw, transidr)
  );




  INSERT INTO @results
    SELECT
      transIdw,
      transidr
    FROM (SELECT
      sq.transIdw,
      sq.transidr,
      COUNT(DISTINCT testToken) tests,
      SUM(CASE WHEN testToken = matchToken THEN 1 ELSE 0 END) matches
    FROM (SELECT DISTINCT
      transIdw,
      x.transidr,
      w.token testToken,
      r.token matchToken
    FROM (SELECT
      [@workSurface].*
    FROM @workSurface
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@workSurface].accountId) = [@workSurface].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) w

    INNER JOIN (SELECT
      w.transactionId transIdw,
      r.transactionId transIdr
    FROM (SELECT
      [@workSurface].*
    FROM @workSurface
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@workSurface].accountId) = [@workSurface].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) w
    INNER JOIN (SELECT
      [@reference].*
    FROM @reference
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@reference].accountId) = [@reference].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) r
      ON w.token = r.token
    GROUP BY r.transactionId,
             w.transactionId) x
      ON w.transactionId = x.transIdw

    INNER JOIN (SELECT
      [@reference].*
    FROM @reference
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@reference].accountId) = [@reference].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) r
      ON r.transactionId = x.transidr) sq
    GROUP BY sq.transIdw,
             sq.transidr) sq2
    WHERE tests - matches = 0


  IF NOT EXISTS (SELECT TOP 1
      *
    FROM @results)
  BEGIN



    INSERT INTO @results
      SELECT
        transIdw,
        transidr
      FROM (SELECT
        sq.transIdw,
        sq.transidr,
        COUNT(DISTINCT testToken) tests,
        SUM(CASE WHEN testToken = matchToken THEN 1 ELSE 0 END) matches
      FROM (SELECT DISTINCT
        transIdw,
        x.transidr,
        w.token testToken,
        r.token matchToken
      FROM (SELECT
        [@workSurface].*
      FROM @workSurface
      LEFT JOIN autoParserNameExceptions apne
        ON token LIKE apne.pattern
        AND apne.isActive = 1
        AND COALESCE(apne.accountFilter, [@workSurface].accountId) = [@workSurface].accountId
      WHERE apne.autoParserNameExceptionId IS NULL) w

      INNER JOIN (SELECT
        w.transactionId transIdw,
        r.transactionId transIdr
      FROM (SELECT
        [@workSurface].*
      FROM @workSurface
      LEFT JOIN autoParserNameExceptions apne
        ON token LIKE apne.pattern
        AND apne.isActive = 1
        AND COALESCE(apne.accountFilter, [@workSurface].accountId) = [@workSurface].accountId
      WHERE apne.autoParserNameExceptionId IS NULL) w
      INNER JOIN (SELECT
        [@reference].*
      FROM @reference
      LEFT JOIN autoParserNameExceptions apne
        ON token LIKE apne.pattern
        AND apne.isActive = 1
        AND COALESCE(apne.accountFilter, [@reference].accountId) = [@reference].accountId
      WHERE apne.autoParserNameExceptionId IS NULL) r
        ON w.token = r.token
      GROUP BY r.transactionId,
               w.transactionId) x
        ON w.transactionId = x.transIdw

      INNER JOIN (SELECT
        [@reference].*
      FROM @reference
      LEFT JOIN autoParserNameExceptions apne
        ON token LIKE apne.pattern
        AND apne.isActive = 1
        AND COALESCE(apne.accountFilter, [@reference].accountId) = [@reference].accountId
      WHERE apne.autoParserNameExceptionId IS NULL) r
        ON r.transactionId = x.transidr) sq
      GROUP BY sq.transIdw,
               sq.transidr) sq2
      WHERE tests - matches = 1

  END


  IF @debug = 1
  BEGIN
    
    SELECT
      *
    FROM (SELECT
      [@workSurface].*,
      bt.origDescription,
      bt.description
    FROM @workSurface
    INNER JOIN bankTransaction bt
      ON [@workSurface].transactionId = bt.transactionId
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@workSurface].accountId) = [@workSurface].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) w


    SELECT
      *
    FROM (SELECT
      [@reference].*,
      bt.origDescription,
      bt.description
    FROM @reference
    INNER JOIN bankTransaction bt
      ON [@reference].transactionId = bt.transactionId
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@reference].accountId) = [@reference].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) r
    
    SELECT
      x.*,t1.origDescription wOrigDescription, t1.description wDescription, t2.origDescription rOrigDescription, t2.description rDescription
    FROM (SELECT
      w.transactionId transIdw,
      r.transactionId transIdr
    FROM (SELECT
      [@workSurface].*
    FROM @workSurface
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@workSurface].accountId) = [@workSurface].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) w
    INNER JOIN (SELECT
      [@reference].*
    FROM @reference
    LEFT JOIN autoParserNameExceptions apne
      ON token LIKE apne.pattern
      AND apne.isActive = 1
      AND COALESCE(apne.accountFilter, [@reference].accountId) = [@reference].accountId
    WHERE apne.autoParserNameExceptionId IS NULL) r
      ON w.token = r.token
    GROUP BY r.transactionId,
             w.transactionId) x
    INNER JOIN bankTransaction t1
      ON t1.transactionId = x.transIdw
    INNER JOIN bankTransaction t2
      ON t2.transactionId = x.transIdr

          
    SELECT
      [@results].*,t1.origDescription wOrigDescription , t2.origDescription rOrigDescription , t2.description rDescription
    FROM @results
      INNER JOIN bankTransaction t1 ON transIdw=t1.transactionId
      INNER JOIN bankTransaction t2 ON transidr=t2.transactionId

  END


  IF NOT EXISTS (SELECT TOP 1
      *
    FROM @results)
  BEGIN
    SELECT
      '{"transactionId":0,"typicalMap":"Not Found","obsCt":0}' ret
  END
  ELSE
  BEGIN
    SELECT
      '{"transactionId":' + CAST(res.transIdw AS VARCHAR(255)) + ',"typicalMap":"' + description + '","obsCt":' + CAST(COUNT(*) AS VARCHAR(255)) + '}' ret
    FROM @results res
    INNER JOIN bankTransaction t
      ON res.transidr = t.transactionId
    GROUP BY res.transIdw,
             description
    ORDER BY COUNT(*) DESC
  END

END

GO

EXEC typicalPayeeMapping 100110692,1
Go
