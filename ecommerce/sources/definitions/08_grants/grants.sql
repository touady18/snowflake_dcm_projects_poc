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

-- Exemple à activer quand DATABASE/SCHEMA seront définis dans le projet :
-- grant usage on database ECOM{{ env_suffix }} to role ECOM_ANALYST{{ env_suffix }};
-- grant usage on schema   ECOM{{ env_suffix }}.MART to role ECOM_ANALYST{{ env_suffix }};
-- grant select on all tables in schema ECOM{{ env_suffix }}.MART to role ECOM_ANALYST{{ env_suffix }};
