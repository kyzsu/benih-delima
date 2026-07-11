-- Computed activity status (spec: "not a stored column"). A member needs
-- follow-up if they weren't `hadir` at any of their 3 most recent weekly
-- services. Only ibadah_minggu_pemuda / ibadah_minggu_gabung count toward
-- this — ad hoc events (ktb, ibadah_raya_klasis, acara_khusus) don't affect
-- the streak, since they aren't on a regular weekly cadence.
create view member_followup_status as
with weekly_events as (
  select id, tanggal
  from events
  where event_type in ('ibadah_minggu_pemuda', 'ibadah_minggu_gabung')
),
ranked as (
  select
    m.id as member_id,
    we.id as event_id,
    we.tanggal,
    row_number() over (partition by m.id order by we.tanggal desc) as recency_rank,
    -- coalesce to false: a NULL here (no attendance row, i.e. no-show) must
    -- count as "not present", not be silently dropped by bool_or() below.
    coalesce(a.status = 'hadir', false) as was_present
  from members m
  cross join weekly_events we
  left join attendance a on a.member_id = m.id and a.event_id = we.id
),
recent as (
  select member_id, bool_or(was_present) as present_in_last_3
  from ranked
  where recency_rank <= 3
  group by member_id
)
select
  m.id as member_id,
  m.nama,
  coalesce(not r.present_in_last_3, false) as needs_follow_up
from members m
left join recent r on r.member_id = m.id;

grant select on member_followup_status to authenticated;
