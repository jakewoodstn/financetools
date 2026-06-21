-- Exported: 2026-06-21T21:55:41.301315+00:00
-- Schema:   dbo
-- Object:   changeTags
-- Type:     SQL_STORED_PROCEDURE
-- Created:  2014-08-05 18:46:08.240000
-- Modified: 2020-06-23 04:05:02.240000

CREATE PROCEDURE dbo.changeTags
(
  @tranId  BIGINT,
  @newTags VARCHAR(1000), 
  @splitId BIGINT = NULL
)
AS
BEGIN
  DECLARE @tagsIn TABLE(
    tagvalue VARCHAR(1000),
    tagId INT
  )
  DECLARE @pos INT;

  WHILE len(@newTags) > 0
  BEGIN
    --loop through delimited string and insert into temp table
    SET @pos = charindex(';', @newTags)

    IF @pos = 0
    BEGIN
      --force trailing delimiter
      SET @newTags = @newTags + ';'
      SET @pos = len(@newTags)
    END

    --record current value into temp table
    IF @pos > 1 --accounts for repeated delimiter
      INSERT INTO @tagsIn (tagvalue)
      SELECT left(@newTags, @pos - 1);


    IF @pos = len(@newTags)
      SET @newTags = '';
    ELSE
    BEGIN
      SET @newTags = right(@newTags, len(@newTags) - @pos)
    END
  END

  --create new tags

  INSERT INTO taggedEvent(taggedEventTag
                        , taggedEventDescription
                        , effectiveDate
                        , retiredDate)

  SELECT sq.tagValue
       , sq.tagValue
       , cast(getdate() AS DATE)
       , cast('12/31/9999' AS DATE)
  FROM
    (SELECT tagValue
     FROM
       @tagsIn EXCEPT
     SELECT taggedEventTag
     FROM
       taggedEvent e
     WHERE
       getdate() BETWEEN effectiveDate AND retiredDate) sq

  --record event ids on tags coming in from the application

  UPDATE t
  SET
    tagId = minid
  FROM
    (SELECT tagvalue
          , min(taggedEventId) minid
     FROM
       taggedEvent te
       INNER JOIN @tagsin t
         ON te.taggedEventTag = t.tagvalue
     WHERE
       getdate() BETWEEN effectiveDate AND retiredDate
     GROUP BY
       tagvalue) sq
    INNER JOIN @tagsIn t
      ON sq.tagvalue = t.tagvalue

  --fail any tags that somehow failed to get an id.

  DELETE @tagsIn
  WHERE
    tagId IS NULL;

  --update transaction to tag mapping
  --first remove mappings where tag is no longer on transaction
  DELETE tte
  FROM
    transactionTaggedEvent tte
    LEFT JOIN @tagsIn ti
      ON tte.taggedEventId = ti.tagId
  WHERE
    tte.transactionId = @tranId AND
    COALESCE(tte.splitTransactionId,0) = COALESCE(@splitId,0) AND
    ti.tagId IS NULL;


  --now remove retained mappings from incoming data
  DELETE ti
  FROM
    transactionTaggedEvent tte
    INNER JOIN @tagsIn ti
      ON tte.taggedEventId = ti.tagId
  WHERE
    tte.transactionId = @tranId
    and COALESCE(tte.splitTransactionId,0) = COALESCE(@splitId,0);

  --finally insert what remains into the transaction tagged event map
  IF @splitId is NULL
    BEGIN
        --if the split id is null but there are split lines, apply the tag to every split line.

  INSERT INTO transactionTaggedEvent(transactionId
                                      ,splitTransactionId
                                   , taggedEventId
                                   , taggedAt)
  SELECT @tranId
       ,sd.splitTransactionId
       , tagId
       , getdate()
  FROM
    @tagsIn
    left join (    SELECT parentTransactionId, splittransactionid FROM categorySplitDetails WHERE parentTransactionId = @tranId) sd 
      on sd.parentTransactionId = @tranId;
END
  ELSE
    BEGIN
      INSERT INTO transactionTaggedEvent(transactionId
                                      ,splitTransactionId
                                   , taggedEventId
                                   , taggedAt)
      SELECT @tranId, @splitId, tagid, GETDATE() FROM @tagsIn;
    END

  --cleanup data integrity errors - duplicates and tags on parent when splits are tagged.

  
DELETE te
  FROM transactionTaggedEvent te
  INNER JOIN (SELECT
    transactionId,
    te.splitTransactionId,
    te.taggedEventId,
    MAX(te.transactionTaggedEventId) maxid
  FROM transactionTaggedEvent te
  GROUP BY te.transactionId,
           te.splitTransactionId,
           te.taggedEventId
  HAVING COUNT(*) > 1) sq
    ON te.transactionTaggedEventId = maxid

DELETE te
  FROM transactionTaggedEvent te
WHERE te.splitTransactionId IS NULL
  AND te.transactionId IN (SELECT
    te1.transactionId
  FROM transactionTaggedEvent te1
  WHERE te1.splitTransactionId IS NOT NULL)

  --cleanup unused tags
  delete te FROM taggedEvent te LEFT JOIN transactionTaggedEvent tte ON te.taggedEventId = tte.taggedEventId WHERE tte.transactionTaggedEventId IS NULL

SELECT
  retval = @@rowcount;

END;
