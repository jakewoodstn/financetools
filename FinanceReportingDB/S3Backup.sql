EXEC msdb.dbo.rds_backup_database @source_db_name = 'finances'
                                 ,@s3_arn_to_backup_to = N'arn:aws:s3:::stuffandthings-abaskdflogksldk/sqlbackup/finances_20220912.bak'
                                 
                                 ,@overwrite_s3_backup_file = 0
                                 

EXEC msdb.dbo.rds_backup_database @source_db_name = 'financeReporting'
                                 ,@s3_arn_to_backup_to = N'arn:aws:s3:::stuffandthings-abaskdflogksldk/sqlbackup/financeReporting_20220912.bak'
                                 
                                 ,@overwrite_s3_backup_file = 0
                                 

exec msdb..rds_task_status