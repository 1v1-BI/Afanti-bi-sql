--crm_stat_user
--日期	咨询师姓名	大区	组别（主管）	出勤人次	呼出电话数	呼出用户数	接通电话数	接通用户数	通话总时长
select a.a_time as 拨打日期, a.first_name as 咨询师名字, a.region as 大区, a.creator_role as 角色, a_id as 拨打电话数, a.a_stu_id as 拨打用户数,
a.a_sta as 接通电话数, b.dis_student_id as 接通用户数, 
case when b.duration>20 then 1 else 0 end as 是否出勤, b.duration as 通话时长
from
(select date(cr.created_time) as a_time, au.first_name , au.region , cr.creator_role , cr.created_by,
       count(cr.id) as a_id,
       count(distinct cr.student_id) as a_stu_id,
       sum(case when (cr.tianrun_info->>'status')::int = 28 then 1 else 0 end) as a_sta
from  comm_records cr
left join account_user au on cr.created_by=au.id
where au.region not like '%TMK%'
or cr.creator_role not like '%tmk%'
group by date(cr.created_time), au.first_name,au.region, cr.creator_role,cr.created_by
) as a
left join 
(select date(cr1.created_time) as b_time, cr1.created_by, count(distinct cr1.student_id) as dis_student_id,
	    round(sum((cr1.tianrun_info->>'end_time')::int - (cr1.tianrun_info->>'bridge_time')::int)/60::numeric,3) as duration --通话时长分钟
from comm_records  cr1 
where (cr1.tianrun_info->>'status')::int = 28
group by date(cr1.created_time), cr1.created_by
) as b
on a.created_by=b.created_by and date(a.a_time)=date(b.b_time)
where date(a.a_time)='2018-03-20'--限定查询日期
--where date(a.a_time)>='2017-12-01' and date(a.a_time)<='2018-01-31'


--crm_stat_user
--日期	咨询师	确定试听数	今日预计试听数	完成试听数	试听课库存
select a.a_created_time as 日期, a.first_name as 咨询师, a.confirm as 确定试听人数, b.today_demo as 今日预计试听数, c.today_finish_demo as 今日完成试听人数,
d.unfinished_demo as 试听课库存人数
from
(select date(dc.created_time) as a_created_time, dc.created_by, au.first_name, count(distinct dc.student_id) as confirm
	from demo_course dc
	left join account_user au
	on dc.created_by=au.id
	group by date(dc.created_time), dc.created_by, au.first_name
	) as a
full outer join
(select date(dc1.start_time) as b_start_time, dc1.created_by, count(distinct dc1.student_id) as today_demo
from demo_course dc1
group by date(dc1.start_time), dc1.created_by) as b
on a.a_created_time=b.b_start_time and a.created_by=b.created_by
full outer join 
(select date(dc2.start_time) as c_start_time, dc2.created_by, count(distinct dc2.student_id) as today_finish_demo
from demo_course dc2
where dc2.status ='finished'
group by date(dc2.start_time), dc2.created_by) as c
on a.a_created_time=c.c_start_time and a.created_by=c.created_by
full outer join
(select date(dc3.created_time)  as d_created_time, dc3.created_by, count(distinct dc3.student_id) as unfinished_demo
from demo_course dc3
where date(dc3.created_time)<date(dc3.start_time)
and dc3.status ='preparin'
or dc3.status ='prepared'
group by date(dc3.created_time), dc3.created_by) as d
on a.a_created_time=d.d_created_time and a.created_by=d.created_by
where a.a_created_time='2018-03-21'--限定查询日期
--where a.a_created_time>='2017-12-01' and a.a_created_time<='2018-01-31'--限定查询日期




#日期	咨询师	成单数：当天完成全额支付订单数	成单金额：当天成单总金额
#线下库afanti_online
select from_unixtime(so.update_time,'%Y-%m-%d') as '日期', so.planner_name as '咨询师',count(so.pid) as '全额支付订单数',sum(so.amount/100) as '成单总金额'
from series_order so
where so.status='SUCCESS'
and from_unixtime(so.update_time,'%Y-%m-%d')='2018-03-20'
# and from_unixtime(so.update_time,'%Y-%m-%d')>='2017-12-01' and from_unixtime(so.update_time,'%Y-%m-%d')<='2018-01-31'#限定查询日期
and so.planner_name not like '%刘玲玲%' #测试人员
and so.planner_name not like '%lingling.liu02@lejent.com%'
and so.planner_name not like '%艳秋%'
and so.planner_name not like '%学习吧%'
group by from_unixtime(so.update_time,'%Y-%m-%d'), so.planner_name
order by from_unixtime(so.update_time,'%Y-%m-%d'), so.planner_name



