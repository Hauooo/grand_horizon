# GA_Horizon

GA_Horizon is a lightweight Grand Archive season companion focused on Malaysia. It helps try-hard players and organisers track weekly events, store championships, regional tournaments, and venue details in a clean, mobile-friendly dashboard.

## Purpose

The site is designed to keep event information easy to scan and quick to use in practice:

- weekly store events and championships
- season tracking across the active tournament window
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


## Notes for future expansion

The project is intentionally structured to support future features such as:

- more detailed season qualification tracking
- stronger venue validation workflows
- additional store/event pages
- a separate life-counter or streaming overlay tool

A synced life counter would require a realtime backend or shared state service, since a static page alone cannot keep two separate devices synchronized.
