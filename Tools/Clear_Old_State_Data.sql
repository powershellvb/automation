DECLARE
    @MaxDataAgeDays INT,
    @DataSetName NVARCHAR(150)
 SET @DataSetName = 'Event'
 SELECT @MaxDataAgeDays = MAX(MaxDataAgeDays)
 FROM StandardDatasetAggregation
 WHERE DatasetId = (
    SELECT DatasetId
    FROM StandardDataset
    WHERE SchemaName = @DataSetName
 )
 DELETE EventCategory
 WHERE LastReceivedDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)
 DELETE EventChannel
 WHERE LastReceivedDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)
 DELETE EventLoggingComputer
 WHERE LastReceivedDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)
 DELETE EventPublisher
 WHERE LastReceivedDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)
 DELETE EventUserName
 WHERE LastReceivedDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)
 DELETE ManagedEntityProperty
 WHERE ToDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)
 DELETE RelationshipProperty
 WHERE ToDateTime < DATEADD(DAY, -@MaxDataAgeDays, GETUTCDATE())
 OPTION(RECOMPILE)