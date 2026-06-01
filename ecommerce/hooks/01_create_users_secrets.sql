-- Créer un utilisateur de service
CREATE USER IF NOT EXISTS my_service_user
  DEFAULT_ROLE = ACCOUNTADMIN
  COMMENT = 'Service user for pipeline';

-- Créer un secret (ex: token d'API)
CREATE SECRET IF NOT EXISTS ECOM_DB{{ env_suffix }}.COMMERCE{{ env_suffix }}.MY_API_SECRET
  TYPE = GENERIC_STRING
  SECRET_STRING = 'justToTest123';