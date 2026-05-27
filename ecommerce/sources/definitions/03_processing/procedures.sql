-- =============================================================================
-- PROCEDURES : DCM Projects (SQL only)
-- =============================================================================
-- DCM Projects supports only LANGUAGE SQL procedures.
-- Python/JavaScript procedures must be managed outside DCM (manual script).
-- =============================================================================

define procedure ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.SP_HEALTHCHECK()
  returns string
  language sql
  execute as owner
as
begin
  return 'HEALTHCHECK_OK';
end;
