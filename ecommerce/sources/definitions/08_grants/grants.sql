-- =============================================================================
-- GRANTS : Attributions de rôles et privilèges
-- =============================================================================
-- Ce fichier contient les GRANTs gérés par DCM Projects :
--   1) Hiérarchie des rôles (ROLE -> ROLE)
--   2) Privilèges sur objets (WAREHOUSE, DATABASE, SCHEMA, TABLE, ...)
--
-- Important :
--   Les GRANT ROLE ... TO USER ne sont PAS gérés ici dans ce POC,
--   car les users sont créés manuellement hors DCM. Si un user n'existe pas,
--   le DEPLOY échoue.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1) Hiérarchie des rôles
-- -----------------------------------------------------------------------------

-- DATA agrège les rôles techniques ingestion + transformation
grant role ECOM_ANALYST{{ env_suffix }}      to role ECOM_DATA{{ env_suffix }};

-- ADMIN hérite des rôles métier/techniques
grant role ECOM_DATA{{ env_suffix }}    to role ECOM_ADMIN{{ env_suffix }};
grant role ECOM_ANALYST{{ env_suffix }} to role ECOM_ADMIN{{ env_suffix }};

-- Visibilité de la hiérarchie domaine sous SYSADMIN
grant role ECOM_ADMIN{{ env_suffix }} to role SYSADMIN;


-- -----------------------------------------------------------------------------
-- 2) Privilèges sur objets
-- -----------------------------------------------------------------------------

-- Warehouse unique par environnement
grant usage   on warehouse ECOM_WH{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
grant monitor on warehouse ECOM_WH{{ env_suffix }} to role ECOM_DATA{{ env_suffix }};
grant operate on warehouse ECOM_WH{{ env_suffix }} to role ECOM_ADMIN{{ env_suffix }};

-- Database / Schema e-commerce
grant usage on database ECOM_DB{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
grant usage on database ECOM_DB{{ env_suffix }} to role ECOM_DATA{{ env_suffix }};
grant usage on schema   ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
grant usage on schema   ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }} to role ECOM_DATA{{ env_suffix }};

-- -----------------------------------------------------------------------------
-- 3) Privilèges procedures / tasks
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
GRANT MONITOR ON DCM PROJECT DCM_DB_POC.PROJECTS.ECOM_PROJECT_DEV TO ROLE DCM_DEVELOPER_DEV;
GRANT MONITOR ON DCM PROJECT DCM_DB_POC.PROJECTS.ECOM_PROJECT_PROD TO ROLE DCM_DEPLOYER_PROD;