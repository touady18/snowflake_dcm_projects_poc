-- =============================================================================
-- DATABASE + SCHEMA : domaine e-commerce
-- =============================================================================
-- Objets créés par target :
--   PROD -> ECOM_DB + COMMERCE
--   DEV  -> ECOM_DB_DEV + COMMERCE_DEV
-- =============================================================================

define database ECOM_DB{{ env_suffix }};

define schema ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }};
