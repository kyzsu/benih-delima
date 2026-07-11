-- Enum types for Benih Delima Phase 1 (members, events, attendance).

create type membership_category as enum (
  'anggota_gki_delima',
  'anggota_gki_lain',
  'simpatisan'
);

create type event_type as enum (
  'ibadah_minggu_pemuda',
  'ibadah_minggu_gabung',
  'ktb',
  'ibadah_raya_klasis',
  'acara_khusus'
);

create type attendance_status as enum (
  'hadir',
  'izin',
  'absen'
);

create type check_in_method as enum (
  'self_geofence',
  'self_override_by_pic',
  'manual_by_pic'
);
