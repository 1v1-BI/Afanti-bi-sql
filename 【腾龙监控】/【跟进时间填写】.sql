#跟进时间跨度查询
--已录
select a.username as 咨询师, a.region as 大区, c.created_by as 咨询师ID,c.id as 通话记录, (c.tianrun_info::json->>'status') as 沟通状态,
    date(c.created_time) as 创建时间,
     (date(c.start_time)-date(c.created_time)) as 间隔天数 ,extract(hour from (age(c.start_time,c.created_time))) as 间隔小时数
from comm_records c left join account_user a 
on a.id = c.created_by
where todo_category ='FLW'
  and date(created_time) between '2017-12-27' and '2017-12-28'
  and a.region not like '%学管师%'
  and a.region not like '%设备%'
  and a.region not like '%培训中%'
  and a.region not like '%离职%'
  and a.region not like '%Report%'
  and a.region not like '%排课中心%'
  and c.start_time is not null
order by a.username
