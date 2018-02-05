# 正式用户续费与课耗情况分析


# 正式课续费与课耗情况
# part1 首单与续费
select s1.student_user_id as student_user,
date(from_unixtime(s1.create_time)), # 订单创建时间，对公也不会排除
(s1.create_time-k.min_time)/86400 as min_days, #与首单间隔天数
s1.lesson_num,  #因为金额必须大于100，补单等课时包可能有小误差
s1.amount/100,
s1.planner_name
from series_order s1 join 
(select s.student_user_id,
  min(s.create_time) as min_time  # 首单时间
from series_order s
where s.status = 'SUCCESS'
   and s.note not like '%测试%'
   group by s.student_user_id) as k 
on k.student_user_id = s1.student_user_id
where s1.status = 'SUCCESS'
   and s1.amount/100 >100   # 金额大于100，筛选错单，补单等
   and s1.note not like '%测试%'
   and (s1.create_time-k.min_time)/86400 = 0  #等于0 为首次交费， 可不加限定，线下处理
  and s1.student_user_id not in (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969) #以上测试号
order by s1.student_user_id

简易版课耗数据
select p.student_user_id, count(p.series_order_id)
from tutor_preorder p 
where p.status not like 'CANCEL'
and p.student_user_id in ()


正式课续费情况
select s.student_user_id, from_unixtime(k.first_time_pay) , 
from_unixtime(k.last_time_pay), 
k.recharge_times,(k.total_lessons+k.total_free_lessons)as '总课时',
k.total_lessons as '课时包'
from series_order s 
right join 
(select s1.student_user_id , 
  min(s1.create_time) as first_time_pay, 
  max(s1.create_time) as last_time_pay,
  count(s1.pid) -1 as recharge_times,
  sum(lesson_num) as total_lessons, 
  sum(free_lesson_num) as total_free_lessons
from series_order s1 
where s1.status = 'SUCCESS'
and s1.amount/100 >100
and s1.note not like '%测试%'
and s1.amount/100>100
and s1.update_time
and s1.student_user_id not in (148811250,
                              241286891,
                              43744461,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                               248259226,
                               251804322,
                               251804626,
                                251804835,
                                251436121,
                                75462035,
                                88452392,
                                122839998,
                                247444506,247673969)
group by s1.student_user_id) as k on k.student_user_id = s.student_user_id
group by s.student_user_id



#之前的课耗判定方法
select t.student_user_id,  
t.series_order_id, # 正式课编号
count(t.pid),   # 课耗数
from_unixtime(floor(min(a.end_time)/1000)),  #本次订单最初正式课上课时间
from_unixtime(floor(max(a.end_time)/1000))   #本次订单最后正式课上课时间
from tutor_preorder t left join audio_record_info a on a.tutor_record_id = t.tutor_record_id
where t.student_user_id in (select distinct s.student_user_id
from series_order s 
where s.status = 'SUCCESS'
and  s.amount/100 >100
and s.note not like '%测试%'
and s.student_user_id not in (148811250,141321906, 141321906,43744461,250595181,
                              141321906,249450013,250595219, 248444058,248259226,
                              251804322,251804626,251804835,251436121,75462035,
                              88452392,122839998,247444506,247673969))#测试号
and t.status = 'BOOK'
and round((a.end_time-a.start_time)/60000) > 15  # 毫秒转分钟 大于15分钟视为完成上课
and from_unixtime(floor(a.start_time/1000)) IS NOT NULL # 毫秒级时间戳
and t.series_order_id not in (' ')  # 该字段default为space
group by t.student_user_id, t.series_order_id


#正式课消耗
#新判定课耗方法
select t.student_user_id , 
count(t.series_order_id), 
from_unixtime(floor(max(a.end_time)/1000))
from tutor_preorder t 
right join tutor_preorder_info p on t.tutor_record_id = p.tutor_record_id
left join audio_record_info a on p.tutor_record_id = a.tutor_record_id
where t.student_user_id in (select distinct s.student_user_id 
                                from series_order s 
                                where s.status = 'SUCCESS'
                                  and s.note not like '%测试%'
                                  and s.amount/100>100
                                  and  (s.note NOT LIKE '%zyb%')
                                  and  (s.name NOT LIKE '%测试%')
                                  and (s.note NOT LIKE '%测试%')
                                  AND (s.name NOT LIKE '%test%')
                                  and s.student_user_id not in (148811250,
                                                                141321906,
                                                                141321906,
                                                                43744461,
                                                                250595181,
                                                                141321906,
                                                                249450013,
                                                                250595219,
                                                                248444058,
                                                                248259226,
                                                                251804322,
                                                                251804626,
                                                                251804835,
                                                                251436121,
                                                                75462035,
                                                                88452392,
                                                                122839998,
                                                                247444506,247673969))
and p.period_confirm not in (0) # 不为0 则课程已消耗
and t.status = 'BOOK'
and t.category = 'SERIES'
group by t.student_user_id


正式课人均每周课耗
select  year(date(from_unixtime(r.start_time)))as '年份',month(date(from_unixtime(r.start_time)))as '月份', 
WEEKOFYEAR(date(from_unixtime(r.start_time))) as '第X周',count(distinct r.student_user_id) as'学生数' , 
count(r.tutor_record_id)as '上课数'
from tutor_preorder t right join tutor_preorder_info p on t.tutor_record_id = p.tutor_record_id
join tutor_record r on r.tutor_record_id = p.tutor_record_id 
where t.student_user_id in (select distinct s.student_user_id 
                                from series_order s 
                                where s.status = 'SUCCESS'
                                  and s.note not like '%测试%'
                                  and s.amount/100>100
                                  and  (s.note NOT LIKE '%zyb%')
                                  and  (s.name NOT LIKE '%测试%')
                                  and (s.note NOT LIKE '%测试%')
                                  AND (s.name NOT LIKE '%test%')
                                  and s.student_user_id not in (148811250,
                                                                141321906,
                                                                141321906,
                                                                43744461,
                                                                250595181,
                                                                141321906,
                                                                249450013,
                                                                250595219,
                                                                248444058,
                                                                248259226,
                                                                251804322,
                                                                251804626,
                                                                251804835,
                                                                251436121,
                                                                75462035,
                                                                88452392,
                                                                122839998,
                                                                247444506,247673969))
and p.period_confirm not in (0) --上课确认为0 则缺席
and t.status = 'BOOK'
and t.category = 'SERIES'
and t.name not like '%测试%'
and date(from_unixtime(r.start_time)) between '2017-10-01' and '2018-01-31'
group by  year(date(from_unixtime(r.start_time))),month(date(from_unixtime(r.start_time))), 
WEEKOFYEAR(date(from_unixtime(r.start_time)))
order by  year(date(from_unixtime(r.start_time))),month(date(from_unixtime(r.start_time))), 
WEEKOFYEAR(date(from_unixtime(r.start_time)))


验证课耗
select  distinct t.student_user_id , count(t.series_order_id)
from tutor_preorder t join tutor_preorder_info p on p.tutor_record_id = t.tutor_record_id
where p.period_confirm not in (0)

课程消耗明细
select  
       o.planner_name as '咨询师姓名',
        u1.user_name as '学生姓名',
        o.student_user_id as '学生ID',
        u1.telephone_num as '学生手机',
        p.tutor_apply_id as '试听课id',
        p.series_order_id as '正式课id',
        p.name,
        p.content,
        CASE
          WHEN p.grade=1 then '一年级'
          WHEN p.grade=2 then '二年级'
          WHEN p.grade=3 then '三年级'
          WHEN p.grade=4 then '四年级'
          WHEN p.grade=5 then '五年级'
          WHEN p.grade=6 then '六年级'  
          WHEN p.grade=7 then '七年级'
          WHEN p.grade=8 then '八年级'  
          WHEN p.grade=9 then '九年级'
          WHEN p.grade=10 then '小学'  
          WHEN p.grade=11 then '高一'
          WHEN p.grade=12 then '高二'   
          WHEN p.grade=13 then '高三' 
          when p.grade = 101 then '一年级'
          when p.grade =102 then '二年级'
          when p.grade =103 then '三年级'
          when p.grade =104 then '四年级'
          when p.grade = 105 then '五年级'
          when p.grade = 106 then '六年级'
          Else '其他'      
      END as '年级',
 CASE
          WHEN p.subject=1 then '语文'
          WHEN p.subject=2 then '数学'
          WHEN p.subject=3 then '英语'
          WHEN p.subject=4 then '科学'
          WHEN p.subject=5 then '物理'
          WHEN p.subject=6 then '化学'
          WHEN p.subject=7 then '地理'
          WHEN p.subject=8 then '历史'
          WHEN p.subject=9 then '生物'
          WHEN p.subject=10 then '政治'
          WHEN p.subject=11 then '知心导师'
       END as  '学科',
       p.parents_name as '家长姓名',
        p.category as '课程分类',
        p.status as '状态',
        from_unixtime(t.start_time) as '上课时间',
        from_unixtime(t.end_time) as '下课时间',
        CASE
            WHEN i.period_confirm = 0 THEN '缺席课堂'
          WHEN i.period_confirm = 1 THEN '有效课时'
          WHEN i.period_confirm = 2 THEN '出现异常'
          WHEN i.period_confirm = 3 THEN '不足40分钟'
        END AS '课程结果'
from tutor_record t 
left join tutor_preorder_info i on t.tutor_record_id = i.tutor_record_id
left join tutor_preorder p on t.tutor_record_id = p.tutor_record_id
left join series_order o on p.series_order_id = o.pid
left join user_online u1 on o.student_user_id = u1.user_id
left join user_online u2 on t.teacher_user_id = u2.user_id
where o.status = 'SUCCESS'
  AND (o.note NOT LIKE '%zyb%')
  AND (o.name NOT LIKE '%测试%')
  AND (o.note NOT LIKE '%测试%')
  AND (o.name NOT LIKE '%test%')
  AND (o.planner_name not like '%学习吧%' )
  AND p.`status` = 'BOOK'
  AND t.tutor_status > 0
  AND i.period_confirm not like '%测试%'
  and WEEKOFYEAR(date(from_unixtime(p.create_time))) in (45,46,47)
  AND o.student_user_id IN ()#加入学生id
  order by from_unixtime(t.start_time)



