-- Row-level security. Two helper functions identify the caller as a PIC or
-- resolve their linked member row; policies below build on those.

create function public.is_pic()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.pics where auth_user_id = auth.uid());
$$;

create function public.current_member_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.members where auth_user_id = auth.uid();
$$;

alter table pics enable row level security;
alter table members enable row level security;
alter table events enable row level security;
alter table attendance enable row level security;

grant select on pics to authenticated;
grant select, insert, update, delete on members to authenticated;
grant select, insert, update, delete on events to authenticated;
grant select on attendance to authenticated;

-- pics: read-only for the PIC themself; rows are provisioned by an admin
-- (Supabase Studio / service role), not through client-facing CRUD.
create policy pics_select_self on pics
  for select using (auth_user_id = auth.uid());

-- members: anggota pemuda can read their own row; PIC has full CRUD on all
-- members (per spec: PIC views recap across all members, not just their own).
create policy members_select_self on members
  for select using (auth_user_id = auth.uid());

create policy members_select_for_pic on members
  for select using (public.is_pic());

create policy members_insert_for_pic on members
  for insert with check (public.is_pic());

create policy members_update_for_pic on members
  for update using (public.is_pic());

create policy members_delete_for_pic on members
  for delete using (public.is_pic());

-- events: any authenticated user (member or PIC) can view the schedule;
-- only PIC can create/edit/cancel events.
create policy events_select_all on events
  for select using (auth.uid() is not null);

create policy events_insert_for_pic on events
  for insert with check (public.is_pic());

create policy events_update_for_pic on events
  for update using (public.is_pic());

create policy events_delete_for_pic on events
  for delete using (public.is_pic());

-- attendance: readable by the owning member and by any PIC. No insert/update/
-- delete policies are defined here on purpose — all writes must go through
-- submit_check_in() and resolve_override() (see next migration), which are
-- SECURITY DEFINER functions that validate the geofence server-side and
-- authorize the caller as the acting member/PIC. This prevents a client from
-- forging geofence_passed or an override directly via table access.
create policy attendance_select_self on attendance
  for select using (member_id = public.current_member_id());

create policy attendance_select_for_pic on attendance
  for select using (public.is_pic());
