-- =============================================================================
-- ROLES : Sécurité e-commerce — hiérarchie des rôles fonctionnels
-- =============================================================================
-- Note : DEFINE USER n'est pas supporté par DCM Projects.
--        Les users sont créés en dehors du projet (manuellement ou pre-deploy script).
--        Les rôles sont créés ici.
--        Les GRANTs (rôle->rôle, privilèges objets) sont centralisés dans 08_grants/grants.sql.
-- =============================================================================

-- Rôle administrateur du domaine e-commerce (ownership complet)
define role ECOM_ADMIN{{ env_suffix }};

-- Rôle dédié à l'équipe DATA
define role ECOM_DATA{{ env_suffix }};

-- Rôle dédié aux analysts
define role ECOM_ANALYST{{ env_suffix }};
