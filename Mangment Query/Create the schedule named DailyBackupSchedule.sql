

USE msdb;

-- Create the schedule named DailyBackupSchedule
EXEC sp_add_schedule  
    @schedule_name = N'DailyBackupSchedule',  
    @freq_type = 4,  -- Daily
    @freq_interval = 1,  -- Every 1 day
    @active_start_time = 010000;  -- 01:00 AM

-- Create the job named Backup_Examination_System
EXEC msdb.dbo.sp_add_job @job_name = 'Backup_Examination_System',
    @enabled = 1,
    @description = 'Daily Backup Job';

-- Add a job step to execute the backup script
EXEC msdb.dbo.sp_add_jobstep @job_name = 'Backup_Examination_System',
    @step_name = 'PerformBackupStep',
    @subsystem = 'TSQL',
    @command = '
        USE Examinatin_System;

        DECLARE @BackupPath NVARCHAR(255);
        SET @BackupPath = ''F:\ITI_full stack 2023\'' + ''Examination_System_'' + CONVERT(NVARCHAR(8), GETDATE(), 112) + ''.bak'';

        BACKUP DATABASE Examinatin_System
        TO DISK = @BackupPath
        WITH FORMAT, INIT, NAME = ''Examination_System-Full Database Backup'', STATS = 10;';

-- Attach the schedule to the job Backup_Examination_System
EXEC msdb.dbo.sp_attach_schedule  
    @job_name = 'Backup_Examination_System',  
    @schedule_name = 'DailyBackupSchedule';