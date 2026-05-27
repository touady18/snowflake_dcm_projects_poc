-- =============================================================================
-- TASKS : orchestration Snowflake via DCM Projects
-- =============================================================================
-- Oui, DCM Projects supporte les tasks via SQL DDL classique.
--
-- Les tasks sont definies en SUSPENDED pour un demarrage controle.
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
