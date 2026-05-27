-- =============================================================================
-- WAREHOUSES : Snowflake compute infrastructure — E-commerce domain
-- =============================================================================
-- Jinja variables injected from manifest.yml (templating section) :
--   {{ env_suffix }}        → "" (PROD) | "_DEV" (DEV)
--   {{ wh_size}}   → "SMALL" (PROD) | "X-SMALL" (DEV)
--
-- Objects created per target :
--   PROD → ECOM_WH     
--   DEV  → ECOM_WH_DEV
-- =============================================================================


-- Warehouse dedicated to raw data ingestion
-- Used by ELT connectors (Fivetran, Airbyte) and COPY INTO scripts
define warehouse ECOM_WH{{ env_suffix }}
  with
    warehouse_size = '{{ wh_size}}'
    auto_suspend   = 120
    auto_resume    = true
    comment        = '[ECOM{{ env_suffix }}] Data ingestion';
