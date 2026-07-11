-- Core tables: pics, members, events, attendance.
--
-- `email` is added on `pics` and `members` beyond the original spec fields —
-- it's required to link a row to its Supabase Auth user for magic-link login
-- (see 20260711000003_auth_linking.sql). `kontak` remains the free-text
-- WA/email contact field from the spec.

create table pics (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique references auth.users (id) on delete set null,
  nama text not null,
  email text not null unique,
  kontak text,
  created_at timestamptz not null default now()
);

create table members (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique references auth.users (id) on delete set null,
  nama text not null,
  email text not null unique,
  kontak text,
  tgl_lahir date,
  kelompok_kecil text,
  membership_category membership_category not null default 'anggota_gki_delima',
  pic_id uuid references pics (id) on delete set null,
  created_at timestamptz not null default now()
);

create index members_pic_id_idx on members (pic_id);

create table events (
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  event_type event_type not null,
  tanggal date not null,
  waktu_mulai time not null,
  -- also holds the host church name for ibadah_raya_klasis, per spec
  lokasi_nama text,
  lat double precision,
  lng double precision,
  -- Phase 1 default: 100m, same for every event_type (confirmed 2026-07-11)
  radius_meter integer not null default 100,
  is_auto_generated boolean not null default false,
  created_by uuid references pics (id) on delete set null,
  created_at timestamptz not null default now()
);

create index events_tanggal_idx on events (tanggal);
create index events_event_type_idx on events (event_type);

-- `status` is nullable: the spec's check-in flow describes a "pending" state
-- for out-of-geofence self check-ins awaiting PIC review, but attendance_status
-- only enumerates the three final outcomes (hadir/izin/absen). NULL represents
-- "pending"; a PIC resolving it via resolve_override() sets it to a real value.
create table attendance (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references members (id) on delete cascade,
  event_id uuid not null references events (id) on delete cascade,
  status attendance_status,
  check_in_time timestamptz,
  check_in_method check_in_method,
  geofence_passed boolean,
  override_by uuid references pics (id) on delete set null,
  override_reason text,
  created_at timestamptz not null default now(),
  unique (member_id, event_id)
);

create index attendance_event_id_idx on attendance (event_id);
create index attendance_member_id_idx on attendance (member_id);
create index attendance_pending_idx on attendance (event_id) where status is null;
