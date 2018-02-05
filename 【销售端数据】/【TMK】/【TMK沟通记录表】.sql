
TMK沟通记录表
TMK 资源问题、
字段 日期，tmk姓名，状态，拨打电话数，接听电话数，确认转CC，试听邀约数，试听完成数
订单完成数，订单新签金额，订单续费金额，总金额
tmk 拨打数+接通数+名字 -新系统
select date(c.created_time),a.last_name, count(c.id)as 拨打数, 
sum( case when (c.tianrun_info->>'status')::int=28 then 1 else 0 end)as 接通数
from comm_records c left join account_user a on a.id = c.created_by
where c.creator_role = 'tmk'
  and date(c.created_time) between '2018-01-08' and '2018-01-18'
 
group by date(c.created_time),a.last_name
order by date(c.created_time)


   
--tmk转出数 新系统
select a.last_name, date(t.created_time),count(distinct t.student_id) as 转出数 
from tmk_confirm t join account_user a on a.id = t.tmk_id
where date(t.created_time) between '2018-01-08' and '2018-01-18'
group by a.last_name, date(t.created_time)
order by date(t.created_time)

--试听数 新系统
select a.last_name, date(d.created_time), count(d.id) as  试听数, 
sum(case when d.status='finished' then 1 else 0 end) as 试听完成数
from demo_course d left join tmk_confirm t on t.student_id = d.student_id
left join account_user a on t.tmk_id = a.id 
where date(d.created_time) between '2017-12-01' and '2018-01-30'
and a.last_name is not null
group by date(d.created_time),a.last_name
order by date(d.created_time)


--日常tmk沟通记录表成单部分
select a.last_name, date(o.created_time),o.amount/100,
floor(extract(epoch from (o.created_time - t.created_time))/86400) <45,e.phone,o.student_id
from course_order o left join tmk_confirm t on t.student_id = o.student_id
left join account_user a on a.id = t.tmk_id
left join ocean e on e.id = o.student_id 
where date(o.created_time) between '2018-01-31' and '2018-02-01'
   and a.last_name is not null
   and o.status = 'finished'
   and o.amount/100 >10
   
order by date(o.created_time)


转出手机号
select  date(t.created_time),a.last_name, o.phone
from tmk_confirm t  left join account_user a on a.id = t.tmk_id
left join ocean o on t.student_id = o.id
where date(t.created_time)>='2018-01-31'
order by date(t.created_time),a.last_name




老系统订单tmk转出
select date(from_unixtime(s.update_time)),t.tmk_name, count(s.pid),sum(amount/100)
from series_order s join crm_tmk_cc_lead t on s.student_user_id = t.user_id
where date(from_unixtime(s.create_time)) >= '2017-12-01'
   and s.status = 'SUCCESS'
group by date(from_unixtime(s.update_time)),t.tmk_name
order by date(from_unixtime(s.update_time))
