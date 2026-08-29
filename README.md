# GA_Horizon

GA_Horizon is a lightweight Grand Archive season companion focused on Malaysia's current PRD season. It helps players and organizers track weekly events, store championships, regional tournaments, and venue details in a clean, mobile-friendly dashboard.

## Purpose

The site is designed to keep event information easy to scan and quick to use in practice:

- weekly store events and championships
- PRD season tracking across the active tournament window
- regional event listings with a separate visual treatment
- official venue data and Google Maps navigation links
- basic season status metadata, including the current season guide

## Current status

This project is currently a static front-end app rather than a database-backed platform. It is intentionally lightweight so it can be hosted easily on static hosting providers and updated quickly as the season changes.

The main page displays:

- the active PRD season banner
- visible seasonal events only
- hidden past events once they are no longer relevant
- TBD-date events still shown until confirmed
- store cards with venue verification and map directions
- separate styling for regional tournaments

## Project structure

- `index.html` — the main GA_Horizon event dashboard
- `README.md` — project overview and usage notes
- `PRD Shore Champs Malaysia.csv` — source event data for the PRD festival/season board
- `favicon.jpg` — site icon used for the browser tab
- `stores/` — store-specific detail pages (for example, Weatherlight Enterprise)

## Running locally

Because this is a static site, you can use either of the following:

1. Open `index.html` directly in a browser.
2. From this directory, serve it locally:

```bash
python -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

## Supabase integration

The site is prepared to load PRD season event data from Supabase when configured.

1. Create a Supabase project.
2. Run the SQL in `prd-season-supabase.sql` against your database.
3. Open `supabase-config.js` and replace the placeholder values:

```js
window.GA_HORIZON_CONFIG = {
  useSupabase: true,
  seasonSlug: 'prd-2026',
  supabaseUrl: 'https://YOUR_PROJECT_REF.supabase.co',
  supabaseAnonKey: 'YOUR_SUPABASE_ANON_KEY'
};
```

4. Refresh the page. If the values are valid, the site will load from the `season_event_summary` view instead of the local fallback data.

If `useSupabase` is `false`, or the values are not configured, the page falls back to a small built-in preview data set so the UI still works locally.

## Deployment

The site is compatible with static hosting such as Vercel. For deployment, the project folder can be published as the site root with no build step required.

## Notes for future expansion

The project is intentionally structured to support future features such as:

- more detailed season qualification tracking
- stronger venue validation workflows
- additional store/event pages
- a separate life-counter or streaming overlay tool

A synced life counter would require a realtime backend or shared state service, since a static page alone cannot keep two separate devices synchronized.
