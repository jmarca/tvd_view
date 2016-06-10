-- Deploy tvd_view:tvd_view to pg

BEGIN;

CREATE MATERIALIZED VIEW -- if not exists
newtbmap.tvd
as
select  id, name, freeway_dir, lanes , length, cal_pm, abs_pm,
latitude, longitude, version as last_modified , gid, geom, freeway_id, vdstype, district
from (
 SELECT v.*,
        vv.lanes,  vv.segment_length as length, vv.version,
 	vf.freeway_id ,
        vf.freeway_dir,
        vt.type_id as vdstype,
        vd.district_id as district,
	g.gid as gid,
        g.geom as geom
 FROM vds_id_all v
 JOIN vds_versioned vv using (id)
 JOIN vds_points_4326 on (id=vds_id)
 JOIN vds_vdstype vt using (vds_id)
 JOIN vds_district vd USING (vds_id)
 JOIN vds_freeway vf USING (vds_id)
 JOIN geom_points_4326 g using (gid)
 JOIN ( SELECT vvv.id, max(vvv.version) as version
        FROM vds_versioned vvv
        GROUP BY vvv.id) maxvv on (maxvv.version=vv.version
                                  and maxvv.id=vv.id)
) a;


COMMIT;
