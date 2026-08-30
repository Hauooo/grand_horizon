-- Extend events with optional per-store detail fields.
-- All nullable: only populate when a store organizer has actually supplied the info.
alter table events add column if not exists format text;
alter table events add column if not exists entry_fee text;
alter table events add column if not exists registration_window text;
alter table events add column if not exists round1_time text;
alter table events add column if not exists registration_url text;
alter table events add column if not exists poster_url text;
alter table events add column if not exists prize_structure text;
alter table events add column if not exists highlights text;

-- Detail-page view: one row per store championship, joined with venue + store slug.
drop view if exists store_detail_summary;

create view store_detail_summary as
select
  e.id,
  st.name as store_name,
  st.slug as store_slug,
  s.slug as season_slug,
  e.title,
  e.date,
  e.date_tbd,
  e.status,
  coalesce(v.address, 'Venue address to be confirmed') as address,
  coalesce(v.state, st.region, 'TBC') as state,
  e.maps_url as google_maps_url,
  e.format,
  e.entry_fee,
  e.registration_window,
  e.round1_time,
  e.registration_url,
  e.poster_url,
  e.prize_structure,
  e.highlights,
  e.external_url
from events e
join seasons s on s.id = e.season_id
join stores st on st.id = e.store_id
left join venues v on v.id = e.venue_id
where e.event_type = 'store_championship';

-- Migrate Weatherlight's real event details (from its existing static page) into the DB,
-- so it's driven by the same system as every other store from now on.
update events set
  format = 'Swiss BO3 + Top Cut',
  entry_fee = 'RM 50',
  registration_window = '8:00 AM – 9:40 AM',
  round1_time = '10:15 AM',
  registration_url = 'https://forms.gle/kRPQnzESLzN4KLh79',
  poster_url = '/stores/The Weatherlight Enterprise/poster.jpg',
  prize_structure = '1st: 1 Refracting Missile Nationals Qualifier card, 1 Banner Knight SC champion playmat, 8 PRD booster packs, 8 event packs
2nd: 6 PRD booster packs, 6 event packs
3rd and 4th: 5 PRD booster packs, 5 event packs
5th to 8th: 4 PRD booster packs, 4 event packs
Top 8: Spirit of Water / Fire / Wind proxy metal card
9th onwards: 2 PRD booster packs, 2 event packs
Top 32: Shieldroid promo',
  highlights = 'Register today for the PRD season store championship at The Weatherlight Enterprise.'
where store_id = (select id from stores where slug = 'the-weatherlight-enterprise')
  and title = 'The Weatherlight Enterprise Store Championship';

select 'Store detail schema ready' as status;
