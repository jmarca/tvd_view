-- Deploy tvd_view:twim_view to pg

BEGIN;

create materialized view newtbmap.twim as
select ws.site_no, ws.loc, ws.wim_type, ws.cal_pm
 , ws.latitude, ws.longitude, ws.last_modified
 ,coalesce(wld.facility,freeway_id) as freeway_id
 ,wld.direction
 ,geom
from wim_stations ws
join wim_points_4326 wp ON (site_no = wp.wim_id)
join geom_points_4326 USING  (gid)
join wim_freeway wf on (site_no = wf.wim_id)
join (select distinct site_no, direction, facility from  wim_lane_dir) wld USING (site_no)
order by freeway_id,direction
,ws.site_no;


COMMIT;
