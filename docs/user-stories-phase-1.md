# Phase 1 User Stories — Benih Delima

Scope: `members` + `events` + `attendance` — self check-in with geofence + override, auto-generated `ibadah_minggu_pemuda` (including week-5 `ibadah_minggu_gabung` logic). Mobile-optimized. See `CLAUDE.md` for full domain context.

## Epic: Auth & Access

1. As an anggota pemuda, I want to log in via a magic link sent to my email (Supabase Auth), so that I can check in without managing a password.
2. As a PIC, I want to log in and be recognized with elevated permissions, so that I can manage member data and events.

## Epic: Member Data (`members`)

3. As a PIC, I want to add a new member's data (nama, kontak, tgl_lahir, kelompok_kecil, membership_category), so that they're tracked in the system before their first check-in.
4. As a PIC, I want to edit an existing member's data, so that I can keep records accurate as details change.
5. As a PIC, I want to assign/reassign a member to myself or another PIC (`pic_id`), so that follow-up ownership is clear.
6. As an anggota pemuda, I want to view my own profile, so that I can confirm my data is correct.
7. As a PIC, I want to see a member's computed activity status (e.g. "needs follow-up" after 3–4 consecutive absences), so that I know who to check on — without that status being a manually-maintained field.

## Epic: Events (`events`)

8. As the system, I want to auto-generate `ibadah_minggu_pemuda` every week at the default youth venue, so that PIC doesn't have to create routine services manually.
9. As the system, I want week 5 of a month (when it exists) to auto-generate as `ibadah_minggu_gabung` at the same venue, so that the combined-service weeks are correctly labeled without a venue change.
10. As a PIC, I want to edit or cancel an auto-generated event (e.g. skip a week for Christmas/New Year), so that the schedule reflects real-world exceptions.
11. As an anggota pemuda, I want to see today's/upcoming event with its check-in window, so that I know when and where to check in.

## Epic: Self Check-in & Geofence (`attendance`)

12. As an anggota pemuda, I want to tap "Hadir" and have my location checked against the event's geofence (100m default radius), so that my attendance is verified without manual entry.
13. As an anggota pemuda, I want to be marked `hadir` immediately (method `self_geofence`) when I'm inside the radius, so that check-in is fast and frictionless.
14. As an anggota pemuda, I want my check-in to go into a "pending" state when I'm outside the radius, so that I still have a path to be counted present.
15. As an anggota pemuda, I want to see the status of my pending check-in (pending/approved), so that I know whether I still need to follow up.

## Epic: Override Handling (minimal, non-dashboard)

16. As a PIC, I want to see the list of pending override requests, so that I can review and resolve them.
17. As a PIC, I want to approve a pending check-in with a short reason, so that it's recorded as `hadir` with method `self_override_by_pic`, `override_by`, and `override_reason` filled in.
18. As a PIC, I want to reject a pending check-in, so that it's recorded as `absen` or `izin` instead of left unresolved.

## Decisions (confirmed 2026-07-11)

- Auth: magic link (email) via Supabase Auth.
- Geofence radius: 100m default, same for all event_types.
- Override handling: stories 16–18 (minimal approve/reject) are confirmed **in scope for Phase 1** — the full approval queue UI + notifications remain Phase 2.

## Open Questions

- No `izin` (excused absence) self-report story is included, since the spec doesn't describe how `izin` gets set. Default assumption per `CLAUDE.md`: **PIC-only** (member cannot self-report `izin` in Phase 1) — confirm before building.
