-- =============================================================================
-- WAREHOUSES : Infrastructure de calcul Snowflake — Domaine E-commerce
-- =============================================================================
-- Jinja variables injectées depuis manifest.yml (section templating) :
--   {{ env_suffix }}        → "" (PROD) | "_DEV" (DEV)
--   {{ wh_size_loading }}   → "SMALL" (PROD) | "X-SMALL" (DEV)
--   {{ wh_size_transform }} → "SMALL" (PROD) | "X-SMALL" (DEV)
--   {{ wh_size_analytics }} → "MEDIUM" (PROD) | "X-SMALL" (DEV)
--
-- Objets créés par target :
--   PROD → ECOM_LOADING_WH     | ECOM_TRANSFORM_WH     | ECOM_ANALYTICS_WH
--   DEV  → ECOM_LOADING_WH_DEV | ECOM_TRANSFORM_WH_DEV | ECOM_ANALYTICS_WH_DEV
-- =============================================================================


-- Warehouse dédié à l'ingestion des données brutes
-- Utilisé par les connecteurs ELT (Fivetran, Airbyte) et les scripts COPY INTO
define warehouse ECOM_LOADING_WH{{ env_suffix }}
  with
    warehouse_size = '{{ wh_size_loading }}'
    auto_suspend   = 120
    auto_resume    = true
    comment        = '[ECOM{{ env_suffix }}] Ingestion données brutes — connecteurs ELT et COPY INTO';


-- Warehouse dédié aux transformations de données
-- Utilisé par les Stored Procedures et les Tasks (RAW → STAGING → MART)
define warehouse ECOM_TRANSFORM_WH{{ env_suffix }}
  with
    warehouse_size = '{{ wh_size_transform }}'
    auto_suspend   = 120
    auto_resume    = true
    comment        = '[ECOM{{ env_suffix }}] Transformations RAW → STAGING → MART — SPs et Tasks';


-- Warehouse dédié aux requêtes analytiques
-- Utilisé par les analystes, les dashboards BI et les requêtes ad-hoc
define warehouse ECOM_ANALYTICS_WH{{ env_suffix }}
  with
    warehouse_size = '{{ wh_size_analytics }}'
    auto_suspend   = 60
    auto_resume    = true
    comment        = '[ECOM{{ env_suffix }}] Requêtes analytiques — BI et dashboards';
