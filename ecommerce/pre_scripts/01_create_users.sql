-- =============================================================================
-- PRÉ-DÉPLOIEMENT : Création des utilisateurs Snowflake
-- =============================================================================
-- Ce script est exécuté MANUELLEMENT après DCM DEPLOY.
-- Prérequis : warehouses et rôles doivent déjà exister (créés par DCM).
--
-- Pourquoi utiliser le warehouse DCM pour exécuter ce script ?
--   → Toutes les CREATE USER / GRANT apparaissent dans QUERY_HISTORY avec
--     le warehouse comme dimension → permet des audits par environnement.
--
-- Ordre d'exécution global :
--   1. EXECUTE DCM PROJECT ... DEPLOY ...     (crée WH + rôles)
--   2. Exécuter CE script                     (crée users + grants)
-- =============================================================================

-- ── Étape 0 : Choisir le warehouse de l'environnement cible ──────────────────
-- Décommenter UNE SEULE ligne selon l'environnement déployé.
-- Le warehouse utilisé apparaîtra dans QUERY_HISTORY pour l'audit.


-- USE WAREHOUSE ECOM_WH_DEV_CLN;   -- ← DEV_CLN
-- USE WAREHOUSE ECOM_WH_DEV;        -- ← DEV
-- USE WAREHOUSE ECOM_WH;            -- ← PROD


-- =============================================================================
-- COMPTES DE SERVICE  (TYPE = SERVICE)
-- Un compte de service par environnement — isolation des credentials par env.
-- Nommage : SVC_<FONCTION>_<ENV_SUFFIX>   (PROD : pas de suffixe)
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

-- ── CI/CD GitHub Actions (déploiement automatisé — compte unique partagé) ─────
-- Note : SVC_GITHUB_ACTIONS est partagé entre envs car GitHub Actions
--        s'authentifie via OIDC et change de rôle selon le target déployé.

CREATE USER IF NOT EXISTS SVC_GITHUB_ACTIONS
  EMAIL             = 'svc-github-actions@company.com'
  DISPLAY_NAME      = '[SVC] GitHub Actions CI/CD'
  LOGIN_NAME        = 'SVC_GITHUB_ACTIONS'
  DEFAULT_ROLE      = 'SYSADMIN'
  DEFAULT_WAREHOUSE = 'ECOM_WH_DEV_CLN'
  TYPE              = SERVICE;


-- =============================================================================
-- UTILISATEURS PERSONNES  (TYPE = PERSON)
-- Un seul compte Snowflake par personne — les accès multi-env sont gérés
-- par des GRANTs de rôles (voir section GRANTS ci-dessous).
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

-- Template générique — dupliquer pour chaque nouvelle personne :
-- CREATE USER IF NOT EXISTS <PRENOM_NOM>
--   EMAIL             = '<prenom.nom@company.com>'
--   DISPLAY_NAME      = '<Prénom Nom>'
--   FIRST_NAME        = '<Prénom>'
--   LAST_NAME         = '<Nom>'
--   LOGIN_NAME        = '<PRENOM_NOM>'
--   DEFAULT_ROLE      = 'ECOM_ANALYST_DEV_CLN'
--   DEFAULT_WAREHOUSE = 'ECOM_ANALYTICS_WH_DEV_CLN'
--   TYPE              = PERSON
--   MUST_CHANGE_PASSWORD = TRUE;


-- =============================================================================

-- =============================================================================
-- GRANTS SUR USERS :
-- Les GRANTs sur les users sont ici, car DCM échouerait si le user n'existe pas.
-- Les GRANTs sur les objets (warehouses, rôles, schémas...) sont dans grants.sql (DCM)
-- =============================================================================

-- Comptes de service DEV_CLN
GRANT ROLE ECOM_LOADER_DEV_CLN      TO USER SVC_ECOM_LOADER_DEV_CLN;
GRANT ROLE ECOM_TRANSFORMER_DEV_CLN TO USER SVC_ECOM_TRANSFORMER_DEV_CLN;

-- Ana Martin : accès analytique — ajouter les lignes au fur et à mesure des déploiements
GRANT ROLE ECOM_ANALYST_DEV_CLN TO USER ANA_MARTIN;
-- GRANT ROLE ECOM_ANALYST_DEV    TO USER ANA_MARTIN;   -- décommenter après deploy DEV
-- GRANT ROLE ECOM_ANALYST        TO USER ANA_MARTIN;   -- décommenter après deploy PROD
