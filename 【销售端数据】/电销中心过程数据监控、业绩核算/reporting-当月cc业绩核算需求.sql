#afanti_online
 第一步#report业绩核算订单查询
select 
    rt2.user_id as '学员id',
    rt2.tel_num as '学员电话',
    rt2.source as '资源渠道',
    rt2.source_time,
    rt2.order_time,
    rt2.planner_name as '咨询师',
    rt2.money as '实际成单金额',
    rt3.original_money as '原价',
    rt3.lesson_num as '购买课时',
    rt3.free_lesson_num as '赠送课时',
CASE
        WHEN rt3.subject=1 then '语文'
        WHEN rt3.subject=2 then '数学'
        WHEN rt3.subject=3 then '英语'
        WHEN rt3.subject=4 then '科学'
        WHEN rt3.subject=5 then '物理'
        WHEN rt3.subject=6 then '化学'
        WHEN rt3.subject=7 then '地理'
        WHEN rt3.subject=8 then '历史'
        WHEN rt3.subject=9 then '生物'
        WHEN rt3.subject=10 then '政治'
        WHEN rt3.subject=11 then '知心导师'
END as  '科目',
CASE 
       when rt3.grade =1 then '一年级'
       when rt3.grade  =2 then '二年级'
       when rt3.grade =3 then '三年级'
       when rt3.grade  =4 then '四年级'
       when rt3.grade  =5 then '五年级'
       when rt3.grade  =6 then '六年级'
       when rt3.grade  =7 then '初一'
       when rt3.grade  =8 then '初二'
       when rt3.grade  =9 then '初三'
       when rt3.grade  =10 then '小学'
       when rt3.grade  =11 then '高一'
       when rt3.grade  =12 then '高二'
       when rt3.grade  =13 then '高三'
       when rt3.grade  =101 then '一年级'
       when rt3.grade  =102 then '二年级'
       when rt3.grade  =103 then '三年级'
       when rt3.grade =104 then '四年级'
       when rt3.grade  =105 then '五年级'
       when rt3.grade  =106 then  '六年级'
       else '其他'
 END  as '年级',
 CASE 
       WHEN rt3.charge_type=-1 then '未选择'
       WHEN rt3.charge_type=1 then '微信'
       WHEN rt3.charge_type=2 then '支付宝'
       WHEN rt3.charge_type=3 then '银联'
       WHEN rt3.charge_type=4 then 'wpay'
       WHEN rt3.charge_type=5 then '充值卡'
       WHEN rt3.charge_type=6 then '系统赠送'
       WHEN rt3.charge_type=7 then 'App store'
       WHEN rt3.charge_type=8 then '招行支付'
       WHEN rt3.charge_type=11 then '支付宝'
       WHEN rt3.charge_type=12 then '支付宝'
       WHEN rt3.charge_type=13 then '微信'
       WHEN rt3.charge_type=14 then '微信'
       WHEN rt3.charge_type=15 then '百度分期'
       WHEN rt3.charge_type=16 then '广发信用卡分期'
       WHEN rt3.charge_type=17 then '蚂蚁花呗分期'
 END as  '是否分期',
    rt3.min_sop_update_time as '单笔定金支付时间',
    rt2.note as '订单备注信息',
 CASE
       when rt3.teacher_level=1 then '优秀老师'
       when rt3.teacher_level=2 then '专家老师'
 END as '老师级别'
from 
 (
  select 
       rt.user_id, rt.tel_num, rt.source, max(from_unixtime(rt.create_time)) as source_time,
       from_unixtime(rt.order_time) as order_time, rt.planner_name,
       rt.money, rt.note,rt.pid,rt.payment
  from 
   (select *
    from 
     (select uo.user_id, uo.telephone_num as tel_num, so.planner_name, 
             so.amount/100 as money, so.update_time as order_time, so.note, so.pid,so.payment#确定是否拆单
     from user_online uo
     left join series_order so
     on uo.user_id = so.student_user_id
     where so.status ='SUCCESS' 
     and  so.amount/100>100  
     and from_unixtime(so.update_time)  >= '2018-02-01'
     and from_unixtime(so.update_time)  < '2018-03-02' #成单时间
     ) as order_table
   left join crm_form_record cfr
   on order_table.tel_num = cfr.telephone_number and order_table.order_time > cfr.create_time
# where crm_form_record.`telephone_number` != 'NULL'
# group by crm_form_record.source, crm_form_record.create_time
   order by cfr.create_time desc  # 使用desc是最后一个渠道，不适用desc是第一个渠道
# order by order_table.order_time desc
   ) as rt
  group by rt.tel_num, rt.order_time
 ) as rt2
left join
 (
  select 
   s3.pid,
   s3.subject,
   s3.grade,
   s3.lesson_num,
   s3.free_lesson_num,
   min(s3.sop_update_time) as min_sop_update_time,#需要第一笔支付时间min
   s3.teacher_level,
   s3.original_money,
   s2.charge_type
  from
     (select 
   so1.pid,
   soc.subject,
   soc.grade,
   soc.lesson_num,
   soc.free_lesson_num,
   from_unixtime(sop.update_time,'%Y-%m-%d') as sop_update_time,#需要第一笔支付时间min
   soc.teacher_level,
   soc.original_amount/100 as original_money
   from series_order so1
   left join series_order_course soc on so1.pid=soc.series_order_id
   left join series_order_payment sop on so1.pid=sop.series_order_id
   where sop.status='SUCCESS'#success状态下才是支付时间
      ) as s3
   left join 
     (select sop1.series_order_id,cr.charge_type#确定是否分期，支付方式
      from series_order_payment sop1 
      left join charge_record cr 
      on sop1.out_trade_no=cr.charge_no
      )as s2 
  on s3.pid=s2.series_order_id
  group by s3.pid
 ) as rt3
on rt2.pid=rt3.pid
order by rt2.order_time desc



第二步#试听课上课时间
先取成单用户id,再查这些用户是否有试听记录
select tp.student_user_id as '学员id', from_unixtime(tpi.student_start_time) as '试听课学生进入课堂时间'
from tutor_preorder tp
left join tutor_preorder_info tpi
on tp.tutor_record_id=tpi.tutor_record_id
where tp.student_user_id in
   (select so.student_user_id
from series_order so 
where from_unixtime(so.update_time)>='2018-02-01'and  from_unixtime(so.update_time)<'2018-03-01'
and so.status ='SUCCESS' and  so.amount/100>100
    )
and from_unixtime(tpi.student_start_time)>='2018-01-27'#限定试听课时间
and tpi.teacher_start_time!=0
and tp.category ='DEMO'#只取试听课
order by tp.student_user_id,from_unixtime(tpi.student_start_time) desc



第三步#成单学员是否12小时进件，咨询师最大的update_time success 跟application 的create_time对比
  select r.student_id,o.phone,r.a_created_time
  from 
  (select 
  co.student_id, 
  date_trunc(a.created_time) as a_created_time
  from course_order co
  left join applications a on co.student_id=a.student_id
  where date(co.updated_time) between '2018-01-27' and '2018-03-01'--成单时间，没有限定订单状态
  ) as r
left join ocean o
on r.student_id=o.id
