-- Optional, run using an ADMINISTRATOR account after MFMS database is created.
-- Replace the placeholder with a unique strong secret before executing.
-- Keep secrets out of C# source files and version control.
CREATE USER IF NOT EXISTS 'mfms_app'@'localhost'
  IDENTIFIED BY 'REPLACE_THIS_WITH_A_LONG_UNIQUE_PASSWORD';
GRANT SELECT, INSERT, UPDATE, DELETE ON MFMS.* TO 'mfms_app'@'localhost';
-- Do not grant CREATE/DROP/ALTER to the application user.
-- To change its password later: ALTER USER 'mfms_app'@'localhost' IDENTIFIED BY '...';
