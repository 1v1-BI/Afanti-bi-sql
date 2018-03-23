--crm_stat_user
--tmk外呼过程数据
select a.a_time as 拨打日期, a.first_name as 咨询师名字, a.region as 大区, a.creator_role as 角色, a_id as 拨打电话数, a.a_stu_id as 拨打用户数,
a.a_sta as 接通电话数, b.dis_student_id as 接通用户数, 
case when b.duration>20 then 1 else 0 end as 是否出勤, b.duration as 通话时长, c.tmk_confirm as tmk确认转出数
from
(select date(cr.created_time) as a_time, au.first_name , au.region , cr.creator_role , cr.created_by,
       count(cr.id) as a_id,
       count(distinct cr.student_id) as a_stu_id,
       sum(case when (cr.tianrun_info->>'status')::int = 28 then 1 else 0 end) as a_sta
from  comm_records cr
left join account_user au on cr.created_by=au.id
where au.region like '%TMK%'
or cr.creator_role like '%tmk%'
group by date(cr.created_time), au.first_name,au.region, cr.creator_role,cr.created_by
) as a
left join 
(select date(cr1.created_time) as b_time, cr1.created_by, count(distinct cr1.student_id) as dis_student_id,
	    round(sum((cr1.tianrun_info->>'end_time')::int - (cr1.tianrun_info->>'bridge_time')::int)/60::numeric,3) as duration --通话时长分钟
from comm_records  cr1 
where (cr1.tianrun_info->>'status')::int = 28
group by date(cr1.created_time), cr1.created_by
) as b
on a.created_by=b.created_by and a.a_time=b.b_time
left join 
(select date(tc.created_time) as c_time,count(distinct tc.student_id) as tmk_confirm,tc.tmk_id
from tmk_confirm tc 
group by tc.tmk_id, date(tc.created_time)
) as c
on a.created_by=c.tmk_id and a.a_time=c.c_time
where date(a.a_time)='2018-03-20'--限定查询日期
--where date(a.a_time)>='2018-03-15' and date(a.a_time)<='2018-03-18'--限定查询日期







--crm_stat_user
--试听邀约数、试听完成数
select a.dc_created_time as 日期, a.first_name as 咨询师名字, a.tmk_demo as 试听邀约数, b.tmk_finish as 试听完成数
from
(select au.first_name, date(dc.created_time) as dc_created_time, count(distinct tc.student_id) as tmk_demo, tc.tmk_id
from tmk_confirm tc 
inner join demo_course dc on tc.student_id=dc.student_id
left join account_user au on tc.tmk_id=au.id
group by au.first_name, date(dc.created_time), tc.tmk_id
) as a
full outer join --也可能出现当天有完成试听，但没有邀约的情况 因此不用left join
(select date(dc1.start_time) as dc1_start_time, count(distinct tc1.student_id) as tmk_finish, tc1.tmk_id
from tmk_confirm tc1
inner join demo_course dc1 on tc1.student_id = dc1.student_id
where dc1.status='finished' 
group by date(dc1.start_time),tc1.tmk_id
) as b
on a.dc_created_time=dc1_start_time and a.tmk_id=b.tmk_id
where a.dc_created_time='2018-03-20'
--where a.dc_created_time>='2018-03-15' and a.dc_created_time<='2018-03-18'
order by a.dc_created_time,a.first_name






--crm_stat_user
--tmk转出资源成单情况
select a.co_order_time as 日期, au2.first_name as tmk_name, a.cc_num as 新签订单数, a.cc_money as 新签金额, b.num as 续费订单数, b.money as 续费金额, sum(cc_money+b.money)as 订单总金额
from
(select date(co.updated_time) as co_order_time, sum(co.amount/100) as cc_money, count(co.order_id) as cc_num, tc.tmk_id
from course_order co 
inner join tmk_confirm tc on co.student_id=tc.student_id
left join account_user au on co.created_by=au.id
where co.status='finished'
and co.amount/100>100
and au.region not like '%班主任%'
and au.region not like '%学管%'--tmk离职业绩则不再算
group by date(co.updated_time), tc.tmk_id
) as a
full outer join --可能出现当天未新签但续费或者未续费但有新签情况
(select date(co1.updated_time) as co1_order_time, sum(co1.amount/100) as money, count(co1.order_id) as num, tc1.tmk_id
from course_order co1 
inner join tmk_confirm tc1 on co1.student_id=tc1.student_id
left join account_user au1 on co1.created_by=au1.id
where co1.status='finished'
and co1.amount/100>100
and au1.region like '%班主任%'
or au1.region like '%学管%'
group by date(co1.updated_time), tc1.tmk_id
) as b
on a.co_order_time=b.co1_order_time and a.tmk_id=b.tmk_id
left join account_user au2 on a.tmk_id=au2.id
where a.co_order_time='2018-03-20'
--where a.co_order_time>='2018-03-15' and a.co_order_time<='2018-03-18'
group by  a.co_order_time , au2.first_name , a.cc_num , a.cc_money , b.num , b.money 
order by a.co_order_time




