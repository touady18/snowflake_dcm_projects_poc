-- =============================================================================
-- PROCEDURES : DCM Projects (SQL uniquement)
-- =============================================================================
-- DCM Projects supporte uniquement les procedures LANGUAGE SQL.
-- Les procedures Python/JavaScript doivent etre gerees hors DCM (script manuel).
-- =============================================================================

define procedure ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_HEALTHCHECK()
  returns string
  language sql
  execute as owner
as
begin
  return 'HEALTHCHECK_OK';
end;
