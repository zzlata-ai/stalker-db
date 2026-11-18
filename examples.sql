select (select count(*) from stalker) as stalkers,
       (select count(*) from quest)   as quests,
       (select count(*) from weapon)  as weapons;


select name, weapontypeid, range,
       row_number() over (partition by weapontypeid order by range desc) as rn
from weapon;


select name, cost,
       rank()       over (order by cost desc) as rnk,
       dense_rank() over (order by cost desc) as dense_rnk
from artifact
order by cost desc;
