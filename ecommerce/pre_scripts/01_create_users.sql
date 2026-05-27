-- =============================================================================
-- PRE-DEPLOYMENT : Snowflake user creation
-- =============================================================================
-- This script is executed MANUALLY after DCM DEPLOY.
-- Prerequisites: warehouses and roles must already exist (created by DCM).
--
-- Why use the DCM warehouse to run this script?
--   → All CREATE USER / GRANT statements appear in QUERY_HISTORY with
--     the warehouse as a dimension → enables per-environment audits.
--
-- Global execution order:
--   1. EXECUTE DCM PROJECT ... DEPLOY ...     (creates WH + roles)
--   2. Run THIS script                        (creates users + grants)
-- =============================================================================

-- ── Step 0: Choose the target environment warehouse ──────────────────────────
-- Décommenter UNE SEULE ligne selon l'environnement déployé.
-- The warehouse used will appear in QUERY_HISTORY for auditing.


-- USE WAREHOUSE ECOM_WH_DEV_CLN;   -- ← DEV_CLN
-- USE WAREHOUSE ECOM_WH_DEV;        -- ← DEV
-- USE WAREHOUSE ECOM_WH;            -- ← PROD


-- =============================================================================
-- SERVICE ACCOUNTS  (TYPE = SERVICE)
-- One service account per environment — isolated credentials per env.
-- Naming: SVC_<FUNCTION>_<ENV_SUFFIX>   (PROD: no suffix)
-- =============================================================================

-- ── Ingestion des données brutes (Fivetran, Airbyte, COPY INTO) ───────────────

CREATE USER IF NOT EXISTS SVC_ECOM_LOADER_DEV_CLN    -- PROD → SVC_ECOM_LOADER
  EMAIL             = 'svc-ecom-loader-dev-cln@company.com'
  DISPLAY_NAME      = '[SVC] ECOM Loader DEV_CLN'
  LOGIN_NAME        = 'SVC_ECOM_LOADER_DEV_CLN'
  DEFAULT_ROLE      = 'ECOM_LOADER_DEV_CLN'
  DEFAULT_WAREHOUSE = 'ECOM_WH_DEV_CLN'
  TYPE              = SERVICE;

-- ── Transformations RAW → STAGING → MART (Stored Procedures, Tasks) ──────────

CREATE USER IF NOT EXISTS SVC_ECOM_TRANSFORMER_DEV_CLN  -- PROD → SVC_ECOM_TRANSFORMER
  EMAIL             = 'svc-ecom-transformer-dev-cln@company.com'
  DISPLAY_NAME      = '[SVC] ECOM Transformer DEV_CLN'
  LOGIN_NAME        = 'SVC_ECOM_TRANSFORMER_DEV_CLN'
  DEFAULT_ROLE      = 'ECOM_TRANSFORMER_DEV_CLN'
  DEFAULT_WAREHOUSE = 'ECOM_WH_DEV_CLN'
  TYPE              = SERVICE;

-- ── CI/CD GitHub Actions (automated deployment — single shared account) ──────────
-- Note : SVC_GITHUB_ACTIONS is shared across envs because GitHub Actions
--        authenticates via OIDC and switches roles based on the deployed target.

CREATE USER IF NOT EXISTS SVC_GITHUB_ACTIONS
  EMAIL             = 'svc-github-actions@company.com'
  DISPLAY_NAME      = '[SVC] GitHub Actions CI/CD'
  LOGIN_NAME        = 'SVC_GITHUB_ACTIONS'
  DEFAULT_ROLE      = 'SYSADMIN'
  DEFAULT_WAREHOUSE = 'ECOM_WH_DEV_CLN'
  TYPE              = SERVICE;


-- =============================================================================
-- PERSON USERS  (TYPE = PERSON)
-- One Snowflake account per person — multi-env access is managed
-- via role GRANTs (see GRANTS section below).
-- =============================================================================


CREATE USER IF NOT EXISTS ANA_MARTIN
  EMAIL             = 'ana.martin@company.com'
  DISPLAY_NAME      = 'Ana Martin'
  FIRST_NAME        = 'Ana'
  LAST_NAME         = 'Martin'
  LOGIN_NAME        = 'ANA_MARTIN'
  DEFAULT_ROLE      = 'ECOM_ANALYST_DEV_CLN'
  DEFAULT_WAREHOUSE = 'ECOM_WH_DEV_CLN'
  TYPE              = PERSON
  MUST_CHANGE_PASSWORD = TRUE;

-- Generic template — duplicate for each new person :
-- CREATE USER IF NOT EXISTS <FIRST_LAST>
--   EMAIL             = '<first.last@company.com>'
--   DISPLAY_NAME      = '<First Last>'
--   FIRST_NAME        = '<First>'
--   LAST_NAME         = '<Last>'
--   LOGIN_NAME        = '<PRENOM_NOM>'
--   DEFAULT_ROLE      = 'ECOM_ANALYST_DEV_CLN'
--   DEFAULT_WAREHOUSE = 'ECOM_ANALYTICS_WH_DEV_CLN'
--   TYPE              = PERSON
--   MUST_CHANGE_PASSWORD = TRUE;


-- =============================================================================

-- =============================================================================
-- GRANTS ON USERS :
-- User GRANTs are here because DCM would fail if the user does not exist.
-- Object GRANTs (warehouses, roles, schemas...) are in grants.sql (DCM)
-- =============================================================================

-- DEV_CLN service accounts
GRANT ROLE ECOM_LOADER_DEV_CLN      TO USER SVC_ECOM_LOADER_DEV_CLN;
GRANT ROLE ECOM_TRANSFORMER_DEV_CLN TO USER SVC_ECOM_TRANSFORMER_DEV_CLN;

-- Ana Martin: analytical access — add lines as deployments progress
GRANT ROLE ECOM_ANALYST_DEV_CLN TO USER ANA_MARTIN;
-- GRANT ROLE ECOM_ANALYST_DEV    TO USER ANA_MARTIN;   -- uncomment after DEV deploy
-- GRANT ROLE ECOM_ANALYST        TO USER ANA_MARTIN;   -- uncomment after PROD deploy
