-- Verify tvd_view:tvd_view on pg

BEGIN;

SELECT pg_catalog.has_table_privilege('newtbmap.tvd','select');


ROLLBACK;
