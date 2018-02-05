
#课耗清单
select 	i.tutor_record_id as '课程ID',
                o.pid as '订单ID',
                from_unixtime(o.update_time) as '成单日期',
                o.amount/100 as '订单金额',
                o.lesson_num as '课时数',
                (o.amount/100)/o.lesson_num as '课单价',
                o.planner_name as '咨询师姓名',
                t.teacher_user_id as '老师ID',
				u2.user_name as '老师姓名',
				o.teacher_level as'老师等级',
				u2.telephone_num as '老师手机',
				o.student_user_id as '学生ID',
				u1.user_name as '学生姓名',
				u1.telephone_num as '学生手机',
				o.grade as '学段',
				o.`subject` as '学科',
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
	AND date_format(from_unixtime(i.student_start_time), '%Y-%m-%d') between '2017-06-10' and '2017-11-26' #上课时间在这里更新
	AND o.student_user_id NOT IN (148811250,241286891,
	                          157648815,
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
                              247444506)
	order by from_unixtime(t.start_time)




select tutor_record_id,from_unixtime(confirm_time)
from  tutor_preorder_info
where tutor_record_id in ('177016484')


# 某特定大区 试听课成单
select  i.tutor_record_id as '课程ID',
                o.pid as '订单ID',
                from_unixtime(o.update_time) as '成单日期',
                o.amount/100 as '订单金额',
                o.lesson_num as '课时数',
                (o.amount/100)/o.lesson_num as '课单价',
                o.planner_name as '咨询师姓名',
                t.teacher_user_id as '老师ID',
                o.status as '支付状态',
        u2.user_name as '老师姓名',
        o.teacher_level as'老师等级',
        p.planner_name as '排课咨询师',
        r.role as '大区',
        u2.telephone_num as '老师手机',
        o.student_user_id as '学生ID',
        u1.user_name as '学生姓名',
        u1.telephone_num as '学生手机',
        o.grade as '学段',
        o.`subject` as '学科',
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
left join crm_personnel r on r.content = p.planner_name
where  o.status = 'SUCCESS'
  AND    r.role like '%雏鹰%'
  AND (o.note NOT LIKE '%zyb%')
  AND (o.name NOT LIKE '%测试%')
  AND (o.note NOT LIKE '%测试%')
  AND (o.name NOT LIKE '%test%')
  AND (o.planner_name not like '%学习吧%' )
  AND p.`status` = 'BOOK'
  AND t.tutor_status > 0
  AND i.period_confirm not like '%测试%'
  AND date_format(from_unixtime(i.student_start_time), '%Y-%m-%d') between '2017-12-11' and '2017-12-17' #上课时间在这里更新
  AND o.student_user_id NOT IN (148811250,241286891,
                            157648815,
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
                              247444506)
  order by from_unixtime(t.start_time)


# 某大区试听课未成单
select  i.tutor_record_id as '课程ID',
        u2.user_name as '老师姓名',
        o.teacher_level as'老师等级',
        p.planner_name as '排课咨询师',
        r.role as '大区',
        u2.telephone_num as '老师手机',
        o.student_user_id as '学生ID',
        u1.user_name as '学生姓名',
        u1.telephone_num as '学生手机',
        o.grade as '学段',
        o.`subject` as '学科',
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
left join crm_personnel r on r.content = p.planner_name
where  o.status not like  '%SUCCESS%'
  AND  r.role like '%雏鹰%'  # 大区填这里
  AND (o.note NOT LIKE '%zyb%')
  AND (o.name NOT LIKE '%测试%')
  AND (o.note NOT LIKE '%测试%')
  AND (o.name NOT LIKE '%test%')
  AND (o.planner_name not like '%学习吧%' )
  AND p.`status` = 'BOOK'
  AND t.tutor_status > 0
  AND i.period_confirm not like '%测试%'
  AND date_format(from_unixtime(i.student_start_time), '%Y-%m-%d') between '2017-12-11' and '2017-12-17' #上课时间在这里更新
  AND o.student_user_id NOT IN (148811250,241286891,
                            157648815,
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
                              247444506)
  order by from_unixtime(t.start_time)



  if(
            #(SELECT count(1)
             #FROM series_order s
             #WHERE s.student_user_id=p.student_user_id
               #AND s.teacher_user_id=p.teacher_user_id
               #AND s.status='SUCCESS'
               #AND (s.name NOT LIKE'%测试%'
                    #OR s.note NOT LIKE'%测试%'))>0,1,0) AS '是否成单',
                    #
select  i.tutor_record_id as '课程ID',
                o.pid as '订单ID',
                from_unixtime(o.update_time) as '成单日期',
                o.amount/100 as '订单金额',
                o.lesson_num as '课时数',
                (o.amount/100)/o.lesson_num as '课单价',
                o.planner_name as '咨询师姓名',
                t.teacher_user_id as '老师ID',
        u2.user_name as '老师姓名',
        o.teacher_level as'老师等级',
        u2.telephone_num as '老师手机',
        o.student_user_id as '学生ID',
        u1.user_name as '学生姓名',
        u1.telephone_num as '学生手机',
        o.grade as '学段',
        o.`subject` as '学科',
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
  AND date_format(from_unixtime(i.student_start_time), '%Y-%m-%d') between '2017-06-10' and '2017-11-26' #上课时间在这里更新
  AND o.student_user_id NOT IN (148811250,241286891,
                            157648815,
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
                              247444506)
  order by from_unixtime(t.start_time)



  正式课人均每周课耗
select  year(date(from_unixtime(r.start_time)))as '年份',
month(date(from_unixtime(r.start_time)))as '月份', 
WEEKOFYEAR(date(from_unixtime(r.start_time))) as '第X周',
count(distinct r.student_user_id) as'学生数' , 
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
and p.period_confirm not in (0)
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



