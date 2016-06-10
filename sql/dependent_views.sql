create or replace view
newctmlmap.vds_view as
SELECT t.id,
    t.name,
    t.freeway_dir,
    t.lanes,
    t.length,
    t.cal_pm,
    t.abs_pm,
    t.latitude,
    t.longitude,
    t.last_modified,
    t.gid,
    t.geom,
    t.freeway_id,
    t.vdstype,
    t.district,
    vsg.refnum AS freeway,
    vsg.direction,
    vsg.seggeom AS seg_geom
   FROM newtbmap.tvd t
     LEFT JOIN newctmlmap.vds_segment_geometry vsg ON vsg.vds_id = t.id;

create or replace view
newctmlmap.vds_view_qgis as
 SELECT vds_view.id,
    vds_view.name,
    vds_view.freeway_dir,
    vds_view.lanes,
    vds_view.length,
    vds_view.cal_pm,
    vds_view.abs_pm,
    vds_view.latitude,
    vds_view.longitude,
    vds_view.last_modified,
    vds_view.gid,
    vds_view.geom,
    vds_view.freeway_id,
    vds_view.vdstype,
    vds_view.district,
    vds_view.freeway,
    vds_view.direction,
    vds_view.seg_geom
   FROM newctmlmap.vds_view
  WHERE geometrytype(vds_view.seg_geom) = 'LINESTRING'::text AND npoints(vds_view.seg_geom) > 1;

create or replace view
tempseg.tdetector as
 SELECT twim.freeway_id AS refnum,
    twim.direction,
    'wimid_'::text || twim.site_no AS detector_id,
    twim.geom
   FROM tempseg.twim
  WHERE twim.wim_type::text ~* 'data'::text
UNION
 SELECT tvd.freeway_id AS refnum,
    tvd.freeway_dir AS direction,
    'vdsid_'::text || tvd.id AS detector_id,
    tvd.geom
   FROM newtbmap.tvd
  WHERE tvd.vdstype::text = 'ML'::text
  ORDER BY 1, 2;
