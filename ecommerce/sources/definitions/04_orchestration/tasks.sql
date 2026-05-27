-- =============================================================================
-- TASKS : Snowflake orchestration via DCM Projects
-- =============================================================================
-- DCM Projects supports tasks via standard SQL DDL.
--
-- Tasks are defined as SUSPENDED for controlled startup.
-- =============================================================================

define task ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CRON
	warehouse = 'ECOM_WH{{ env_suffix }}'
	schedule = 'USING CRON 0 * * * * UTC'
	suspended
as
	call ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_HEALTHCHECK();

define task ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CHILD
	warehouse = 'ECOM_WH{{ env_suffix }}'
	after ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CRON
	suspended
as
	call ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_HEALTHCHECK();
