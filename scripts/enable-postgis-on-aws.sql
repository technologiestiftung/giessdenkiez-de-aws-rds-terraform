-- this is taken from the AWS docs
-- it can be used to enable postgis on an AWS RDS database
 -- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS
 create extension postgis;
 create extension fuzzystrmatch;
 create extension postgis_tiger_geocoder;
 create extension postgis_topology;

--  alter schema tiger owner to rds_superuser;
--  alter schema tiger_data owner to rds_superuser;
--  alter schema topology owner to rds_superuser;
 alter schema tiger owner to rds_superuser;
 alter schema tiger_data owner to rds_superuser;
 alter schema topology owner to rds_superuser;
 CREATE FUNCTION exec(text) returns text language plpgsql volatile AS $f$ BEGIN EXECUTE $1; RETURN $1; END; $f$;

 SELECT exec('ALTER TABLE ' || quote_ident(s.nspname) || '.' || quote_ident(s.relname) || ' OWNER TO rds_superuser;')
   FROM (
     SELECT nspname, relname
     FROM pg_class c JOIN pg_namespace n ON (c.relnamespace = n.oid)
     WHERE nspname in ('tiger','topology') AND
     relkind IN ('r','S','v') ORDER BY relkind = 'S')
 s;