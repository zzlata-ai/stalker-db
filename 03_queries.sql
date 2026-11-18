--1
select * from weapon;

--2
select name, range, firerate
from weapon
order by name desc;

--3
select * from stalker where clanid = 3;

--4
select lastname, firstname, left(middlename, 1) as middleinitial
from stalker
where clanid is null or locationid is null or rankid is null
order by length(lastname), length(firstname), length(middlename);

--5
select * from rank where rankname ilike '%на%';

--6
select name, range, firerate, magazinesize
from weapon
where ammoid in (1, 3, 5, 4)
order by range desc, magazinesize asc;

--7
select * from clan where locationid between 3 and 10;

--8
select * from location where locationname not like '%!_%' escape '!';

--9
select distinct a.*
from artifact a
join artifactappearance aa on aa.artifactid = a.artifactid
where aa.appearancedate::date = (current_date - interval '1 year')::date;

--10
select *
from ammo
where type is null
  and description ~ '[[:alnum:]]+[^[:alnum:]]+[[:alnum:]]'
  and description !~* '\mи\M';

--11
select min(cost) as mincost, max(cost) as maxcost from artifact;

--12
select count(*) as stalkercount from stalker;

--13
select count(*) as doublesurnamecount from stalker where lastname like '%-%';

--14
select wt.typename, count(*) as weaponcount
from weapon w
join weapontype wt on wt.weapontypeid = w.weapontypeid
group by wt.typename;

--15
select c.clanid, c.clanname, count(s.stalkerid) as leadercount
from clan c
left join stalker s on s.stalkerid = c.leaderid and s.clanid = c.clanid
group by c.clanid, c.clanname
order by c.clanid;

--16
select c.clanid, c.clanname, count(s.stalkerid) as shortnicknamecount
from clan c
left join stalker s on s.clanid = c.clanid and length(s.nickname) < 5
group by c.clanid, c.clanname
order by c.clanid;

--17
select (array['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'])[extract(dow from appearancedate)::int + 1]
       || ', ' || extract(day from appearancedate)::int
       || ' ' || (array['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'])[extract(month from appearancedate)::int]
       || ' ' || extract(year from appearancedate)::int as appearanceday,
       case when extract(dow from appearancedate) in (0, 6) then 'выходной' else 'рабочий день' end as daytype
from artifactappearance;

--18
select clanid
from stalker
where clanid is not null
group by clanid
having count(*) > 5;

--19
select clanid, rankid, count(*) as stalkercount
from stalker
where clanid is not null
group by clanid, rankid
order by clanid, rankid;

--20
select s.clanid, count(*) filter (where s.stalkerid is distinct from c.leaderid) as nonleadercount
from stalker s
join clan c on c.clanid = s.clanid
group by s.clanid
having count(distinct s.rankid) = 1 and count(s.rankid) = count(*)
order by nonleadercount desc, s.clanid asc;

--21
select wt.typename, count(*) filter (where w.firerate > 100) as fastweaponcount
from weapontype wt
join weapon w on w.weapontypeid = wt.weapontypeid
group by wt.typename
having count(distinct w.weaponid) > 2;

--22
select c.clanname, s.lastname, s.firstname, s.middlename, s.nickname
from stalker s
left join clan c on c.clanid = s.clanid;

--23
select s.lastname, s.firstname, s.middlename,
       l.locationname, r.rankname,
       a.name as artifactname, w.name as weaponname
from stalker s
join clan c on c.clanid = s.clanid
left join location l on l.locationid = s.locationid
left join rank r on r.rankid = s.rankid
left join quest q on q.executorid = s.stalkerid
left join artifact a on a.artifactid = q.artifactid
left join weapon w on w.weaponid = q.weaponid
where c.clanname = 'Одиночки'
order by s.stalkerid;

--24
select extract(year from appearancedate)::int as year,
       count(*) filter (where extract(month from appearancedate) in (12, 1, 2)) as winter,
       count(*) filter (where extract(month from appearancedate) in (3, 4, 5))  as spring,
       count(*) filter (where extract(month from appearancedate) in (6, 7, 8))  as summer,
       count(*) filter (where extract(month from appearancedate) in (9, 10, 11)) as autumn,
       count(*) as total
from artifactappearance
group by extract(year from appearancedate)
order by year;

--25
select wt.typename, count(w.weaponid) as weaponcount
from weapontype wt
left join weapon w on w.weapontypeid = wt.weapontypeid
group by wt.weapontypeid, wt.typename
order by wt.weapontypeid;

--26
select l.locationname, c.clanname, s.nickname
from location l
left join clan c on c.locationid = l.locationid
left join stalker s on s.clanid = c.clanid
order by l.locationid, s.stalkerid;

--27
select c.clanname,
       s1.lastname as lastname1, s1.firstname as firstname1, s1.middlename as middlename1, s1.nickname as nickname1,
       s2.lastname as lastname2, s2.firstname as firstname2, s2.middlename as middlename2, s2.nickname as nickname2
from stalker s1
join stalker s2 on s1.clanid = s2.clanid
               and s1.stalkerid < s2.stalkerid
               and left(s1.nickname, 1) = left(s2.nickname, 1)
join clan c on c.clanid = s1.clanid
order by c.clanname, s1.nickname, s2.nickname;

--28
select s.lastname, s.firstname, s.middlename, s.nickname
from stalker s
join quest q on q.executorid = s.stalkerid
join weapon w on w.weaponid = q.weaponid
group by s.stalkerid, s.lastname, s.firstname, s.middlename, s.nickname
having count(distinct w.weapontypeid) = (select count(distinct weapontypeid) from weapon);

--29
select distinct a.caliber
from ammo a
where not exists (
    select 1
    from weapon w
    join ammo a2 on a2.ammoid = w.ammoid
    where a2.caliber = a.caliber
);

--30
select r.*
from rank r
where not exists (select 1 from stalker s where s.rankid = r.rankid);

--31
select name, description, firerate, range
from weapon
where magazinesize = (select max(magazinesize) from weapon);

--32
select t.clanname, t.nickname, t.rankname
from (
    select c.clanname, s.nickname, r.rankname,
           rank() over (partition by c.clanid order by r.requiredkills asc) as rn
    from stalker s
    join clan c on c.clanid = s.clanid
    join rank r on r.rankid = s.rankid
) t
where t.rn = 1
order by t.clanname;

--33
with t as (
    select c.clanname, s.nickname, r.rankid, r.rankname, r.requiredkills,
           min(r.requiredkills) over (partition by c.clanid) as minkills,
           max(r.requiredkills) over (partition by c.clanid) as maxkills
    from stalker s
    join clan c on c.clanid = s.clanid
    join rank r on r.rankid = s.rankid
)
select clanname, nickname, rankid, rankname, requiredkills,
       case
           when minkills = maxkills then 'наименьший и наибольший'
           when requiredkills = minkills then 'наименьший'
           else 'наибольший'
       end as rankkind
from t
where t.requiredkills in (t.minkills, t.maxkills)
order by t.clanname, t.requiredkills;

--34
select t.locationname, t.stalkercount
from (
    select l.locationname, count(*) as stalkercount,
           rank() over (order by count(*) desc) as rn
    from stalker s
    join location l on l.locationid = s.locationid
    group by l.locationid, l.locationname
) t
where t.rn = 1;

--35
select t.clanname, t.stalkercount
from (
    select c.clanname, count(s.stalkerid) as stalkercount,
           rank() over (order by count(s.stalkerid) asc) as rn
    from clan c
    left join stalker s on s.clanid = c.clanid
    group by c.clanid, c.clanname
) t
where t.rn = 1;

--36
select s.*
from stalker s
join quest q on q.executorid = s.stalkerid
join weapon w on w.weaponid = q.weaponid
group by s.stalkerid
having count(distinct w.weapontypeid) = (select count(distinct weapontypeid) from weapon)
   and count(distinct q.artifactid)  < (select count(*) from artifact);

--37
select c.clanname, l.locationname,
       count(*) filter (where s.stalkerid is distinct from c.leaderid) as nonleadercount
from clan c
left join location l on l.locationid = c.locationid
join stalker s on s.clanid = c.clanid
group by c.clanid, c.clanname, l.locationname
having min((select count(*) from quest q where q.giverid = s.stalkerid or q.executorid = s.stalkerid)) >= 2;

--38
select c.clanname
from clan c
join stalker s on s.clanid = c.clanid
join rank r on r.rankid = s.rankid
where r.requiredkills = (select max(requiredkills) from rank)
group by c.clanid, c.clanname
having count(*) > 3
order by length(c.clanname)
fetch first 1 row with ties;

--39
select *
from stalker
where firstname in (select firstname from stalker group by firstname having count(*) > 1)
order by firstname, stalkerid;

--40
select lastname
from stalker
group by lastname
having count(*) = 3 and count(distinct clanid) = 3;

--41
select w.name
from weapon w
join weapontype wt on wt.typename = w.name;

--42
select w.name, count(distinct q.executorid) as stalkercount
from weapon w
join quest q on q.weaponid = w.weaponid
group by w.weaponid, w.name
having count(distinct q.executorid) = (
    select max(cnt) from (select count(distinct executorid) as cnt from quest group by weaponid) t
);

--43
select name from artifact
union
select name from weapon
order by name desc;

--44
select c.*, count(s.stalkerid) as stalkercount
from clan c
left join stalker s on s.clanid = c.clanid
group by c.clanid
order by stalkercount, c.clanid
limit 3;

--45
select w.*, count(distinct q.executorid) as stalkercount
from weapon w
join quest q on q.weaponid = w.weaponid
group by w.weaponid
order by stalkercount desc, w.weaponid
limit 3;

--46
with top_types as (
    select w.weapontypeid
    from quest q
    join weapon w on w.weaponid = q.weaponid
    group by w.weapontypeid
    order by count(distinct q.executorid) desc, w.weapontypeid
    limit 3
)
select s.nickname
from stalker s
join quest q on q.executorid = s.stalkerid
join weapon w on w.weaponid = q.weaponid
where w.weapontypeid in (select weapontypeid from top_types)
group by s.stalkerid, s.nickname
having count(distinct w.weapontypeid) = 3;

--47
with ls as (select distinct lastname, clanid from stalker where clanid is not null)
select a.lastname
from ls a
join ls b on b.lastname = a.lastname and b.clanid <> a.clanid
join clanrelation r on (r.clanid1 = a.clanid and r.clanid2 = b.clanid)
                    or (r.clanid1 = b.clanid and r.clanid2 = a.clanid)
where r.relationtype = 'Вражда'
intersect
select a.lastname
from ls a
join ls b on b.lastname = a.lastname and b.clanid <> a.clanid
join clanrelation r on (r.clanid1 = a.clanid and r.clanid2 = b.clanid)
                    or (r.clanid1 = b.clanid and r.clanid2 = a.clanid)
where r.relationtype = 'Дружба';

--48
select distinct c.*
from clan c
join stalker s1 on s1.clanid = c.clanid
join stalker s2 on s2.clanid = c.clanid
               and s2.stalkerid < s1.stalkerid
               and s2.firstname = s1.firstname
order by c.clanid;

--49
select round(avg(cnt), 2) as avgclansize
from (
    select count(s.stalkerid) as cnt
    from clan c
    left join stalker s on s.clanid = c.clanid
    group by c.clanid
) t;

--50
with recursive progression(n, a) as (
    select 1, 3
    union all
    select n + 1, a + 4 from progression where n < 10
)
select n, a from progression order by n;
