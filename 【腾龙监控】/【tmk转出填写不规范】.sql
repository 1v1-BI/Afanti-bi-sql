# tmk转出资源填写不规范,
select k.created_by as TMK_ID, k.username as TMK姓名, k.created_time as 创建时间, 
      case 
      when k.status = 28 then '接通'
      else '未接通'
      end as 拨打状态,
      k.content as 沟通记录
from 
(select c.created_by,a.username, c.created_time,c.student_id,(c.tianrun_info::json->>'status')::bigint as status ,c.content
from comm_records c left join account_user a  on a.id = c.created_by
where c.todo_category = 'TCF'
  and a.region like '%TMK%'
  and c.content not like '%【%'
  and date(c.created_time)>='2017-11-16') as k
order by k.created_by