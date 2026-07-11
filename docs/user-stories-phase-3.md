# Phase 3 User Stories — Benih Delima

Scope: `followups` (LKKJ) — PIC's follow-up records with members, periodic reporting to commission/majelis. Both mobile and desktop. See `CLAUDE.md` for full domain context — note the LKKJ schema is **not yet designed**, so these stories describe intent rather than confirmed fields/flows.

## Epic: Follow-up Recording

1. As a PIC, I want to record a follow-up entry for a flagged member (date, notes, action taken), so that there's a documented history of pastoral care.
2. As a PIC, I want to mark a follow-up as resolved or still ongoing, so that I can track whether further action is needed.
3. As a PIC, I want a follow-up to be linked to the absence period/flag that triggered it, so that the reasoning behind it stays traceable.
4. As a PIC, I want to log a quick follow-up note from my phone right after speaking with a member, so that I don't lose details before I'm back at a desktop.

## Epic: Follow-up History

5. As a PIC, I want to view a member's full follow-up history, so that I understand what's already been tried before deciding on next steps.
6. As a PIC, I want to see who recorded each follow-up, so that ownership and continuity are clear when a member's `pic_id` changes.

## Epic: Periodic Reporting (LKKJ)

7. As a PIC, I want to generate a periodic report summarizing attendance and follow-up activity, so that it can be submitted to the commission/majelis.
8. As a PIC, I want to review and compile a report on a desktop screen, so that I have enough room to check the data before submission.
9. As a PIC, I want to export or share the finished report, so that it can be delivered outside the app.

## Open Questions

- The `followups`/LKKJ table schema is completely undecided per the spec — these stories describe intended capability, not confirmed fields. Needs a dedicated design pass before Phase 3 work starts.
- Report format/export mechanism (PDF, spreadsheet, shareable link, etc.) is unspecified.
- Report cadence ("berkala") isn't defined — weekly, monthly, per-quarter?
- Whether commission/majelis reviewers get any direct app access, or only receive an exported report, is undecided — no such role exists in the spec today.
