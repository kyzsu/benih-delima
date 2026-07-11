# Benih Delima — Project Context

> Working name: **Benih Delima** (matches this repo's name). Per the original spec, the app name is **not finalized** — other candidates under consideration: Denyut Delima, Delima Bertumbuh, Akar Delima, Ranting Delima. ("Delima Muda" was considered and dropped.) Decide before/during the naming settles for real; don't treat "Benih Delima" as locked in.

A separate app for the **Program Pemeliharaan Umat, Komisi Pemuda GKI Delima**. Core focus: geofence-based attendance (presensi) + member data maintenance, as the foundation for future follow-up/pastoral-care reporting (LKKJ).

This repo is **pre-implementation** — no code exists yet. This file is the reference doc for the domain, data model, and business rules so a session can start building without the spec being re-pasted.

## Roles & Auth

- **PIC/Pengurus** — manage member data, record follow-ups (LKKJ — schema not yet designed), view & approve attendance overrides, view recap across all members.
- **Anggota Pemuda** (youth member) — lightweight login (magic link/OTP — method not yet decided), self-check-in for attendance, view own profile.

## Tech Stack (assumed, carried over from prior GKI Delima projects — not yet set up in this repo)

- React 19 + Vite + TypeScript
- Tailwind CSS
- Supabase (Postgres + Auth + Realtime)

## Data Model

### `members`

| Field | Notes |
|---|---|
| id | PK |
| nama | |
| kontak | WA/email |
| tgl_lahir | |
| kelompok_kecil | |
| membership_category | enum: `anggota_gki_delima` / `anggota_gki_lain` / `simpatisan` — purely demographic, does not affect any other logic currently |
| pic_id | FK → pics |
| created_at | |

Activity status is **not a stored column** — it's computed (view/derived) from `attendance` history (e.g. absent 3–4 consecutive weeks → flag "needs follow-up").

### `pics`

| Field | Notes |
|---|---|
| id | PK |
| nama | |
| kontak | |

### `events`

| Field | Notes |
|---|---|
| id | PK |
| nama | auto-generated for recurring events, manual for others |
| event_type | enum: `ibadah_minggu_pemuda` / `ibadah_minggu_gabung` / `ktb` / `ibadah_raya_klasis` / `acara_khusus` |
| tanggal | |
| waktu_mulai | |
| lokasi_nama | free text — also used for the host church name on `ibadah_raya_klasis` |
| lat, lng, radius_meter | for geofence validation |
| is_auto_generated | boolean |
| created_by | FK → pic_id |
| created_at | |

### `attendance`

| Field | Notes |
|---|---|
| id | PK |
| member_id | FK |
| event_id | FK |
| status | enum: `hadir` / `izin` / `absen` |
| check_in_time | |
| check_in_method | enum: `self_geofence` / `self_override_by_pic` / `manual_by_pic` |
| geofence_passed | boolean |
| override_by | FK → pic_id, nullable |
| override_reason | text, nullable |
| created_at | |

## Business Logic

### Check-in flow

1. Member taps "Hadir" → app validates location against the event's `lat/lng/radius_meter`.
2. Within radius → recorded immediately as `hadir`, method `self_geofence`.
3. Outside radius → status "pending", queued for PIC approval.
4. PIC manually approves with a short reason → recorded as `hadir`, method `self_override_by_pic`, with `override_by` + `override_reason` filled in.

### Auto-generating `ibadah_minggu_pemuda`

- Generated automatically every week (cron/job mechanism — technical details not yet decided).
- Weeks 1–4 of the month → `event_type: ibadah_minggu_pemuda`, default youth venue.
- **Week 5** (if it exists) → still generated, but as `event_type: ibadah_minggu_gabung` — **same venue** as the regular youth service (one building, just a combined session with the general congregation service).
- All auto-generated events are flagged `is_auto_generated: true` so PIC can edit/cancel manually (e.g. Christmas/New Year breaks).

### `ibadah_raya_klasis`

- Combined youth service for all GKI churches in the klasis; location varies (rotates among member churches).
- **Manually created** by PIC each time (not auto-generated — schedule isn't regular).
- Host church name goes in `lokasi_nama` — no separate field needed.

### `ktb` and `acara_khusus`

- Manual/ad hoc, created by PIC as needed.

## MVP Phasing

1. **Fase 1** — `members` + `events` + `attendance`: self check-in geofence + override, auto-generated `ibadah_minggu_pemuda` (including week-5 logic). **Mobile-optimized** — this is the day-to-day surface for anggota pemuda on their phones.
2. **Fase 2** — PIC dashboard: override approval queue, automatic notifications triggered for consecutive absences. **Desktop-screen-optimized** — PIC/pengurus workflows assume a larger screen.
3. **Fase 3** — `followups` (LKKJ): PIC's follow-up records with members, periodic reports to commission/majelis (schema not yet discussed). **Both mobile and desktop** — follow-up recording needs to work for PIC in the field (mobile) and during reporting sessions (desktop).

## Open Items / Not Yet Decided

- Final app name
- Auth method (magic link vs. WA OTP vs. Google)
- Technical mechanism for weekly event auto-generation (cron job, scheduled function, etc.)
- Default geofence radius per event_type
- `followups`/LKKJ table schema — structure & fields not discussed at all yet

Treat everything in this section as **undecided** — don't assume an implementation for these without checking with the user first.
