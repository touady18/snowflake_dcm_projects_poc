-- =============================================================================
-- FILE    : pre_scripts/create_github_svc.sql
-- PURPOSE : One-time Snowflake setup for the DCM Projects CI/CD pipeline.
--           Run this script as ACCOUNTADMIN before the first deployment.
-- =============================================================================


-- =============================================================================
-- SECTION 1 : Create the database and schema that host DCM project metadata
-- =============================================================================

CREATE DATABASE IF NOT EXISTS DCM_DB_POC;
CREATE SCHEMA  IF NOT EXISTS DCM_DB_POC.PROJECTS;


-- =============================================================================
-- SECTION 2 : Create the deployer roles
-- Each role is the project_owner for one environment (see ecommerce/manifest.yml).
-- =============================================================================

CREATE ROLE IF NOT EXISTS DCM_DEVELOPER_DEV;
CREATE ROLE IF NOT EXISTS DCM_DEPLOYER_PROD;


-- =============================================================================
-- SECTION 3 : Grant account-level privileges
-- Required by the DCM engine to create and manage Snowflake objects
-- (warehouses, databases, roles, tasks, etc.) during deployment.
-- =============================================================================

GRANT CREATE WAREHOUSE     ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
GRANT CREATE DATABASE      ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
GRANT CREATE ROLE          ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
GRANT MANAGE GRANTS        ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
GRANT EXECUTE TASK         ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
GRANT CREATE USER          ON ACCOUNT TO ROLE DCM_DEVELOPER_DEV;
--This on only if needed ->
-- GRANT CREATE SECRET ON SCHEMA DCM_DB_POC.PROJECTS TO ROLE DCM_DEVELOPER_DEV;

GRANT CREATE WAREHOUSE     ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
GRANT CREATE DATABASE      ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
GRANT CREATE ROLE          ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
GRANT MANAGE GRANTS        ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
GRANT EXECUTE TASK         ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
GRANT EXECUTE MANAGED TASK ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
GRANT CREATE USER          ON ACCOUNT TO ROLE DCM_DEPLOYER_PROD;
--This on only if needed ->
-- GRANT CREATE SECRET ON SCHEMA DCM_DB_POC.PROJECTS TO ROLE DCM_DEPLOYER_PROD;
-- =============================================================================
-- SECTION 4 : Grant access to the DCM metadata database and schema
--
-- DCM_DEVELOPER_DEV   → owns the database/schema (created above by ACCOUNTADMIN)
--                       so it can fully manage the DEV project.
-- DCM_DEPLOYER_PROD   → only needs USAGE + the ability to create DCM projects
--                       in the shared schema.
-- =============================================================================

-- Transfer ownership to DCM_DEVELOPER_DEV
GRANT OWNERSHIP ON DATABASE DCM_DB_POC
    TO ROLE DCM_DEVELOPER_DEV COPY CURRENT GRANTS;

GRANT OWNERSHIP ON SCHEMA DCM_DB_POC.PROJECTS
    TO ROLE DCM_DEVELOPER_DEV COPY CURRENT GRANTS;

-- DCM_DEVELOPER_DEV: full access
GRANT USAGE           ON DATABASE DCM_DB_POC           TO ROLE DCM_DEVELOPER_DEV;
GRANT USAGE           ON SCHEMA   DCM_DB_POC.PROJECTS  TO ROLE DCM_DEVELOPER_DEV;
GRANT CREATE DCM PROJECT ON SCHEMA DCM_DB_POC.PROJECTS TO ROLE DCM_DEVELOPER_DEV;

-- DCM_DEPLOYER_PROD: access to store PROD project metadata in the same schema
GRANT USAGE           ON DATABASE DCM_DB_POC           TO ROLE DCM_DEPLOYER_PROD;
GRANT USAGE           ON SCHEMA   DCM_DB_POC.PROJECTS  TO ROLE DCM_DEPLOYER_PROD;
GRANT CREATE DCM PROJECT ON SCHEMA DCM_DB_POC.PROJECTS TO ROLE DCM_DEPLOYER_PROD;

-- Allow ACCOUNTADMIN to act as DCM_DEPLOYER_PROD when needed (e.g. troubleshooting)
GRANT ROLE DCM_DEPLOYER_PROD TO ROLE ACCOUNTADMIN;
-- Allow ACCOUNTADMIN to act as DCM_DEVELOPER_DEV when needed (e.g. troubleshooting)
GRANT ROLE DCM_DEVELOPER_DEV TO ROLE ACCOUNTADMIN;

-- =============================================================================
-- SECTION 5 : Create GitHub Actions service users (OIDC authentication)
--
-- These are SERVICE users — no password, no MFA. They authenticate exclusively
-- via GitHub's built-in OIDC token (Workload Identity Federation).
--
-- The SUBJECT must match the GitHub Environment name EXACTLY (case-sensitive):
--   format → repo:<owner>/<repo>:environment:<environment_name>
-- =============================================================================

CREATE USER IF NOT EXISTS SVC_GITHUB_ACTIONS_DEV
    TYPE         = SERVICE
    DEFAULT_ROLE = 'PUBLIC'
    COMMENT      = 'GitHub Actions service user — CI/CD via OIDC — DEV environment'
    WORKLOAD_IDENTITY = (
        TYPE    = OIDC
        ISSUER  = 'https://token.actions.githubusercontent.com'
        SUBJECT = 'repo:touady18/snowflake_dcm_projects_poc:environment:DCM_DEV'
    );

CREATE USER IF NOT EXISTS SVC_GITHUB_ACTIONS_PROD
    TYPE         = SERVICE
    DEFAULT_ROLE = 'PUBLIC'
    COMMENT      = 'GitHub Actions service user — CI/CD via OIDC — PROD environment'
    WORKLOAD_IDENTITY = (
        TYPE    = OIDC
        ISSUER  = 'https://token.actions.githubusercontent.com'
        SUBJECT = 'repo:touady18/snowflake_dcm_projects_poc:environment:DCM_PROD'
    );


-- =============================================================================
-- SECTION 6 : Grant deployer roles to service users
-- =============================================================================

GRANT ROLE DCM_DEVELOPER_DEV TO USER SVC_GITHUB_ACTIONS_DEV;
GRANT ROLE DCM_DEPLOYER_PROD TO USER SVC_GITHUB_ACTIONS_PROD;


-- =============================================================================
-- SECTION 7 : Disable secondary roles on service users
--
-- Ensures deployments use only the primary role (project_owner), regardless
-- of which secondary roles may be assigned to the user. This guarantees
-- consistent deployment behavior across environments, as recommended in the
-- Snowflake DCM Projects documentation.
-- =============================================================================

ALTER USER SVC_GITHUB_ACTIONS_DEV  SET DEFAULT_SECONDARY_ROLES = ('');
ALTER USER SVC_GITHUB_ACTIONS_PROD SET DEFAULT_SECONDARY_ROLES = ('');


-- =============================================================================
-- SECTION 8 : Post-deployment — MONITOR grants on DCM projects
--
-- NOTE: Run these statements ONLY AFTER the first successful deployment.
--       The DCM project objects (ECOM_PROJECT_DEV, ECOM_PROJECT_PROD) are
--       created by "snow dcm deploy" and do not exist before that.
--       To run only in case you encountered errors related to missing privileges on DCM projects.
-- =============================================================================

-- Allow DCM_DEVELOPER_DEV to monitor the DEV project
GRANT MONITOR ON DCM PROJECT DCM_DB_POC.PROJECTS.ECOM_PROJECT_DEV  TO ROLE DCM_DEVELOPER_DEV;

-- Allow DCM_DEPLOYER_PROD to monitor the PROD project
GRANT MONITOR ON DCM PROJECT DCM_DB_POC.PROJECTS.ECOM_PROJECT_PROD TO ROLE DCM_DEPLOYER_PROD;
