-- =============================================================================
-- ROLES : E-commerce security — functional role hierarchy
-- =============================================================================
-- Note : DEFINE USER is not supported by DCM Projects.
--        Users are created outside the project (manually or via pre-deploy script).
--        Roles are created here.
--        GRANTs (role->role, object privileges) are centralised in 08_grants/grants.sql.
-- =============================================================================

-- E-commerce domain administrator role (full ownership)
define role ECOM_ADMIN{{ env_suffix }};

-- Role dedicated to the DATA team
define role ECOM_DATA{{ env_suffix }};

-- Role dedicated to analysts
define role ECOM_ANALYST{{ env_suffix }};
