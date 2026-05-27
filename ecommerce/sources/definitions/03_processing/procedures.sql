-- =============================================================================
-- PROCEDURES : templates pour DCM Projects
-- =============================================================================
-- DCM Projects supporte uniquement les procedures LANGUAGE SQL.
-- Les procedures Python/JavaScript doivent etre gerees hors DCM (script manuel).
--
-- Important:
-- 1) Definir d'abord DATABASE/SCHEMA cibles dans le projet.
-- 2) Pour Python/JavaScript: deploiement separe apres DCM DEPLOY.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exemple 1 : Procedure SQL
-- -----------------------------------------------------------------------------
-- create or replace procedure ECOM{{ env_suffix }}.MART.SP_HEALTHCHECK()
-- returns string
-- language sql
-- execute as owner
-- as
-- $$
-- begin
--   return 'OK';
-- end;
-- $$;

-- Les procedures non-SQL restent possibles dans Snowflake, mais hors DCM.
-- Exemple (script manuel post-deploy):
-- create or replace procedure ECOM{{ env_suffix }}.MART.SP_JS_HEALTHCHECK()
-- returns string
-- language javascript
-- execute as owner
-- as
-- $$
--   return 'OK_FROM_JS';
-- $$;


-- -----------------------------------------------------------------------------
-- Test explicite DCM : procedure Python (non supportee par DCM definitions)
-- -----------------------------------------------------------------------------
-- Cette definition est volontairement active pour verifier le comportement PLAN/DEPLOY.
define procedure ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_PY_DCM_PROBE()
	returns string
	language python
	runtime_version = '3.10'
	handler = 'run'
	packages = ('snowflake-snowpark-python')
	execute as owner
as
$$
def run(session):
		return 'PYTHON_PROCEDURE_DCM_PROBE'
$$;
