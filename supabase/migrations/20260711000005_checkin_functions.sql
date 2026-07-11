-- Write paths for attendance. Both functions run as SECURITY DEFINER so they
-- can bypass the (intentionally write-less) RLS policies on `attendance`
-- while still enforcing who's allowed to do what and validating the geofence
-- server-side, where the client can't fake the result.

create function public.submit_check_in(
  p_event_id uuid,
  p_lat double precision,
  p_lng double precision
)
returns attendance
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member_id uuid;
  v_event events%rowtype;
  v_distance_meters double precision;
  v_passed boolean;
  v_status attendance_status;
  v_row attendance;
begin
  v_member_id := public.current_member_id();
  if v_member_id is null then
    raise exception 'no member linked to the current user';
  end if;

  select * into v_event from events where id = p_event_id;
  if not found then
    raise exception 'event not found';
  end if;

  if v_event.lat is null or v_event.lng is null then
    raise exception 'event has no location configured';
  end if;

  -- Haversine great-circle distance, in meters.
  v_distance_meters := 6371000 * acos(
    least(1, greatest(-1,
      cos(radians(p_lat)) * cos(radians(v_event.lat)) * cos(radians(v_event.lng) - radians(p_lng))
      + sin(radians(p_lat)) * sin(radians(v_event.lat))
    ))
  );

  v_passed := v_distance_meters <= v_event.radius_meter;
  v_status := case when v_passed then 'hadir'::attendance_status else null end;

  insert into attendance (member_id, event_id, status, check_in_time, check_in_method, geofence_passed)
  values (v_member_id, p_event_id, v_status, now(), 'self_geofence', v_passed)
  on conflict (member_id, event_id) do update
    set check_in_time = excluded.check_in_time,
        geofence_passed = excluded.geofence_passed,
        -- Don't let a re-check-in attempt clobber a status a PIC already resolved.
        status = case when attendance.status is null then excluded.status else attendance.status end,
        check_in_method = case when attendance.status is null then excluded.check_in_method else attendance.check_in_method end
  returning * into v_row;

  return v_row;
end;
$$;

grant execute on function public.submit_check_in(uuid, double precision, double precision) to authenticated;

-- Minimal Phase 1 override resolution: a PIC approves (-> hadir) or rejects
-- (-> izin/absen) a pending (status is null) attendance row. The full queue
-- UI and notifications are Phase 2; this is just the write path they'll call.
create function public.resolve_override(
  p_attendance_id uuid,
  p_status attendance_status,
  p_reason text
)
returns attendance
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pic_id uuid;
  v_method check_in_method;
  v_row attendance;
begin
  select id into v_pic_id from pics where auth_user_id = auth.uid();
  if v_pic_id is null then
    raise exception 'only a PIC can resolve an override';
  end if;

  v_method := case when p_status = 'hadir' then 'self_override_by_pic'::check_in_method
                   else 'manual_by_pic'::check_in_method end;

  update attendance
    set status = p_status,
        check_in_method = v_method,
        override_by = v_pic_id,
        override_reason = p_reason
    where id = p_attendance_id and status is null
    returning * into v_row;

  if v_row.id is null then
    raise exception 'attendance row not found or already resolved';
  end if;

  return v_row;
end;
$$;

grant execute on function public.resolve_override(uuid, attendance_status, text) to authenticated;
