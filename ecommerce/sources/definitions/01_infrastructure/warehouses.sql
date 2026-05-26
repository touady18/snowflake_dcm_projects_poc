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
--   PROD → ECOM_RAW_WH     | ECOM_TRANSFORM_WH     | ECOM_ANALYTICS_WH
--   DEV  → ECOM_RAW_WH_DEV | ECOM_TRANSFORM_WH_DEV | ECOM_ANALYTICS_WH_DEV
-- =============================================================================


-- Warehouse dédié à l'ingestion des données brutes
-- Utilisé par les connecteurs ELT (Fivetran, Airbyte) et les scripts COPY INTO
define warehouse ECOM_WH{{ env_suffix }}
  with
    warehouse_size = '{{ wh_size}}'
    auto_suspend   = 120
    auto_resume    = true
    comment        = '[ECOM{{ env_suffix }}] Ingestion des données';
