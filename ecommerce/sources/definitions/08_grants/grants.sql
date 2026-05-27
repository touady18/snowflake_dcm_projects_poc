-- =============================================================================
-- GRANTS : Role and privilege assignments
-- =============================================================================
-- This file contains the GRANTs managed by DCM Projects :
--   1) Role hierarchy (ROLE -> ROLE)
--   2) Object privileges (WAREHOUSE, DATABASE, SCHEMA, TABLE, ...)
--
-- Important :
--   GRANT ROLE ... TO USER statements are NOT managed here in this POC,
--   because users are created manually outside DCM. If a user does not exist,
--   the DEPLOY will fail.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1) Role hierarchy
-- -----------------------------------------------------------------------------

-- DATA aggregates the technical ingestion + transformation roles
grant role ECOM_ANALYST{{ env_suffix }}      to role ECOM_DATA{{ env_suffix }};

-- ADMIN inherits the business/technical roles
grant role ECOM_DATA{{ env_suffix }}    to role ECOM_ADMIN{{ env_suffix }};
grant role ECOM_ANALYST{{ env_suffix }} to role ECOM_ADMIN{{ env_suffix }};

-- Domain hierarchy visibility under SYSADMIN
grant role ECOM_ADMIN{{ env_suffix }} to role SYSADMIN;


-- -----------------------------------------------------------------------------
-- 2) Object privileges
-- -----------------------------------------------------------------------------

-- One warehouse per environment
grant usage   on warehouse ECOM_WH{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
grant monitor on warehouse ECOM_WH{{ env_suffix }} to role ECOM_DATA{{ env_suffix }};
grant operate on warehouse ECOM_WH{{ env_suffix }} to role ECOM_ADMIN{{ env_suffix }};

-- Database / Schema e-commerce
grant usage on database ECOM_DB{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
grant usage on database ECOM_DB{{ env_suffix }} to role ECOM_DATA{{ env_suffix }};
grant usage on schema   ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
grant usage on schema   ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }} to role ECOM_DATA{{ env_suffix }};

-- -----------------------------------------------------------------------------
-- 3) Procedure / task privileges
-- -----------------------------------------------------------------------------

-- Procedures
grant usage on procedure ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_HEALTHCHECK() to role ECOM_ANALYST{{ env_suffix }};
grant usage on procedure ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_HEALTHCHECK() to role ECOM_DATA{{ env_suffix }};

-- Tasks
grant monitor on task ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CRON to role ECOM_ANALYST{{ env_suffix }};
grant operate on task ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CRON to role ECOM_DATA{{ env_suffix }};
grant monitor on task ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CHILD to role ECOM_ANALYST{{ env_suffix }};
grant operate on task ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.TASK_HEALTHCHECK_CHILD to role ECOM_DATA{{ env_suffix }};


-- MONITOR in the project
GRANT MONITOR ON DCM PROJECT DCM_DB_POC.PROJECTS.ECOM_PROJECT{{ env_suffix }} TO ROLE {{ owner }};
-- GRANT MONITOR ON DCM PROJECT DCM_DB_POC.PROJECTS.ECOM_PROJECT_PROD TO ROLE DCM_DEPLOYER_PROD;
-- Need to add some grants