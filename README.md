# GA_Horizon

GA_Horizon is a lightweight Grand Archive season companion focused on Malaysia. It helps try-hard players and organisers track weekly events, store championships, regional tournaments, and venue details in a clean, mobile-friendly dashboard.

## Website

Live site: https://grand-horizon-five.vercel.app/

## Purpose

The site is designed to keep event information easy to scan and quick to use in practice:

- weekly store events and championships
- season tracking across the active tournament window
- regional event listings with a separate visual treatment
- official venue data and Google Maps navigation links
- basic season status metadata, including the current season guide
- per-store championship detail pages with prize structure, entry fee, and registration links, where available

## Current status

The project is now database-backed: Supabase stores season, store, venue, and event data, with the front end reading from it directly. `supabase-config.js` also ships a static `fallbackEvents` array so the site still renders something reasonable if Supabase is ever unreachable.

Row Level Security is enabled on all tables (`seasons`, `stores`, `venues`, `events`), with `select`-only policies — the anon key embedded in `supabase-config.js` can read event data but cannot write to the database.

The main page displays:

- the active PRD season banner
- all seasonal events, filterable by search, state, and status (all / date TBD / needs address)
- TBD-date events shown until confirmed
- store cards with venue verification and map directions, linking through to each store's detail page
- separate styling for regional tournaments

**Known gap:** past events are not yet auto-hidden once their date has passed — the filter set currently covers search/state/status only, not date. Worth fixing before the season is further along.

## Store detail pages

Every store (41 total) has a detail page at `stores/<Store Name>/index.html`. Rather than 41 separate static files, each is a small wrapper that sets a `slug` and loads one shared template (`stores/_template/render.js` + `style.css`), which queries the `store_detail_summary` Supabase view for that store's data.

Optional per-event fields — `format`, `entry_fee`, `registration_window`, `round1_time`, `registration_url`, `poster_url`, `prize_structure`, `highlights` — are nullable. A store's page shows whatever's been filled in and falls back to a plain "details coming soon" note (linking to the PRD Season Guide) for whatever hasn't. This means updating a store's info is a database edit, not an HTML edit, and pages upgrade automatically as organisers share their poster/prize details.

The Weatherlight Enterprise is currently the only fully-populated example (real prize structure, entry fee, registration form, and poster image), migrated in from what was previously a one-off hardcoded page.

## Project structure

- `index.html` — the main GA_Horizon event dashboard
- `README.md` — project overview and usage notes
- `PRD Shore Champs Malaysia.csv` — original source event data for the PRD season board (now superseded by Supabase as the live source of truth)
- `favicon.jpg` — site icon used for the browser tab
- `supabase-config.js` — Supabase connection config and static fallback event data
- `migration.sql` — schema (seasons/stores/venues/events), RLS policies, and view definitions (`season_event_summary`, `store_detail_summary`)
- `stores/_template/` — shared `render.js` and `style.css` used by every store detail page
- `stores/<Store Name>/index.html` — one lightweight wrapper per store (41 total), pointing the shared template at that store's slug

## Notes for future expansion

The project is intentionally structured to support future features such as:

- auto-hiding past events once their date has passed (see Known gap above)
- more detailed season qualification tracking
- stronger venue validation workflows
- a separate life-counter or streaming overlay tool

A synced life counter would require a realtime backend or shared state service, since a static page alone cannot keep two separate devices synchronized.