-- =============================================================================
-- TASKS : templates pour orchestration Snowflake
-- =============================================================================
-- Oui, DCM Projects supporte les tasks via SQL DDL classique.
--
-- Recommandation:
-- - Creer les tasks en SUSPENDED
-- - Les RESUME manuellement quand les dependances sont pretes
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exemple 1 : task planifiee (cron)
-- -----------------------------------------------------------------------------
-- create or replace task ECOM{{ env_suffix }}.MART.TASK_HEALTHCHECK_CRON
--   warehouse = ECOM_WH{{ env_suffix }}
--   schedule = 'USING CRON 0 * * * * UTC'
-- as
--   call ECOM{{ env_suffix }}.MART.SP_HEALTHCHECK();

-- alter task ECOM{{ env_suffix }}.MART.TASK_HEALTHCHECK_CRON suspend;
-- alter task ECOM{{ env_suffix }}.MART.TASK_HEALTHCHECK_CRON resume;


-- -----------------------------------------------------------------------------
-- Exemple 2 : task declenchee apres une task parent
-- -----------------------------------------------------------------------------
-- create or replace task ECOM{{ env_suffix }}.MART.TASK_HEALTHCHECK_CHILD
--   warehouse = ECOM_WH{{ env_suffix }}
--   after ECOM{{ env_suffix }}.MART.TASK_HEALTHCHECK_CRON
-- as
--   call ECOM{{ env_suffix }}.MART.SP_HEALTHCHECK();
