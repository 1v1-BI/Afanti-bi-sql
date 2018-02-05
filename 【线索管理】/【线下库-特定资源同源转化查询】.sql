特定资源同源转化查询
select k.source as '渠道',count(k.telephone_number) as '用户数',count(k.user_id) as 'ID用户数',
sum(k.tels) as '拨打电话数',sum(if(tels>0,1,0))as '拨打用户数',sum(k.tel) as '接通电话数',sum(if(tel>0,1,0))as '接通用户数',
sum(k.st) as '完成试听数',sum(if(k.st>0,1,0)) as '试听用户数',sum(k.cd)as'成单数',sum(if(k.cd>0,1,0))as '成单用户数',sum(k.fee)as'成单金额',
sum(k.tels)/sum(if(tels>0,1,0)) as '平均拨打次数 3',
sum(k.tel)/sum(k.tels) as '拨打接通率 30%',
sum(if(tel>0,1,0))/sum(if(tels>0,1,0)) as'用户接通率 50%',
sum(k.st)/sum(if(tel>0,1,0)) as'接通用户-试听率 2%',
sum(k.cd)/sum(k.st) as'试听-成单率 10%',
sum(k.cd)/sum(if(tels>0,1,0)) as'拨打用户-成单率 0.05%',
sum(k.fee)/sum(if(tels>0,1,0)) as'ROI'
from 
(
select x.telephone_number,x.user_id,x.source,x.tels,x.tel,y.st,z.cd,z.fee
from 
(select a.telephone_number,c.user_id ,a.source,count(b.customer_number) as tels,sum(if(b.status=28,1,0)) as tel
from crm_form_record a left join crm_call_outcome_record b 
on a.telephone_number = b.customer_number
left join user_online c 
on a.telephone_number=c.telephone_num
where from_unixtime(a.create_time)>='2017-11-01' and from_unixtime(a.create_time)<'2017-12-01'#在这里可以更改线索创建或者首次呼出时间#
and a.source in ()
group by a.telephone_number) as x
left join
(select d.student_user_id,count(d.pid) as st
from tutor_preorder d left join audio_record_info e
on d.tutor_record_id = e.tutor_record_id
where d.status NOT LIKE 'CANCEL'
 AND d.category <> 'SERIES'
 AND d.name not like '题目%'
 AND d.content not like '内容%'
 AND d.name NOT LIKE '测试%'
 AND d.content NOT LIKE '测试%'
 AND d.tutor_record_id = e.tutor_record_id
 AND from_unixtime(floor(e.start_time/1000)) IS NOT NULL
 AND round((e.end_time-e.start_time)/60000) > 15
 AND d.student_user_id NOT IN (250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,247444506)
 group by d.student_user_id) as y
on x.user_id=y.student_user_id
left join
(SELECT f.student_user_id,count(f.pid) as cd,sum(f.amount/100) as fee
FROM series_order f
WHERE (f.note NOT LIKE '%zyb%')
  AND (f.name NOT LIKE '%测试%')
  AND (f.name NOT LIKE '%test%')
  and f.status ='SUCCESS'
  AND f.amount/100>100
  AND f.student_user_id NOT IN (148811250,141321906,141321906,43744461,250595181,141321906,249450013,250595219,248444058,248259226,251804322,251804626,251804835,251436121,75462035,88452392,122839998,247444506,247673969)
 group by f.student_user_id) as z 
on x.user_id=z.student_user_id ) as k
group by k.source
order by '渠道'
