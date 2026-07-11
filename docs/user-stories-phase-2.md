# Phase 2 User Stories — Benih Delima

Scope: PIC dashboard — override approval queue, automatic notifications triggered for consecutive absences. Desktop-screen-optimized. See `CLAUDE.md` for full domain context.

## Epic: Override Approval Queue

1. As a PIC, I want to see all pending override check-ins in one queue, so that I can process them efficiently instead of one-by-one.
2. As a PIC, I want to filter/sort the queue (by event, date, member), so that I can prioritize which requests to review first.
3. As a PIC, I want to see the context of an override request (member's location vs. the geofence, distance, timestamp), so that I can make an informed approve/reject decision.
4. As a PIC, I want to approve or reject an override directly from the queue with a short reason, so that resolving requests doesn't require leaving the dashboard.

## Epic: Attendance Recap & Overview

5. As a PIC, I want to see a recap of all members' attendance across events, so that I can track engagement holistically rather than event-by-event.
6. As a PIC, I want to view a single member's attendance history/timeline, so that I understand their engagement pattern before deciding on follow-up.
7. As a PIC, I want the auto-computed "needs follow-up" flag surfaced prominently in the dashboard (e.g. a filtered list), so that I don't have to manually scan every member.

## Epic: Automatic Notifications

8. As a PIC, I want to receive an automatic notification when a member has missed 3–4 consecutive weeks, so that I can follow up promptly instead of noticing it late.
9. As a PIC, I want a notification to link directly to the flagged member's profile/history, so that I can act without extra navigation.
10. As a PIC, I want to not receive repeat notifications for the same ongoing absence streak, so that I'm not spammed with duplicate alerts.

## Epic: Event Management (Dashboard)

11. As a PIC, I want a dedicated view of upcoming and past events (auto-generated and manual), so that I can plan and adjust the schedule with the extra screen space desktop provides.

## Open Questions

- Notification channel/mechanism is not specified in the spec (in-app, WhatsApp, email, push) — needs a decision before implementation.
- The exact "consecutive absence" threshold/window that triggers a notification is described loosely ("3–4 weeks") — needs to be pinned to a precise rule.
- De-duplication logic for repeat notifications (story 10) has no defined rule yet for when a new notification should re-fire (e.g. after a follow-up is logged in Phase 3, or after a fixed cooldown).
