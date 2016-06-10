-- Verify tvd_view:twim_view on pg

BEGIN;

SELECT pg_catalog.has_table_privilege('newtbmap.twim','select');

ROLLBACK;
