-- 0. season_event_summary (used by the main list page) needs event_type exposed too,
-- so detail-link routing doesn't have to guess "regional" from the title text.
drop view if exists season_event_summary;

create view season_event_summary as
select
  e.id,
  s.slug as season_slug,
  s.name as season_name,
  st.name as store_name,
  e.event_type,
  e.title,
  e.date,
  e.date_tbd,
  e.status,
  e.visibility,
  coalesce(v.address, 'Location to be confirmed') as address,
  coalesce(v.state, st.region, 'TBC') as state,
  e.maps_url as google_maps_url,
  case
    when e.event_type = 'regional' then false
    when v.is_verified is not null then v.is_verified
    else true
  end as is_verified
from events e
join seasons s on s.id = e.season_id
join stores st on st.id = e.store_id
left join venues v on v.id = e.venue_id;

-- 1. Fix: store_detail_summary needs event_type so the frontend can distinguish
-- a store's own championship from a regional they're hosting (a store can have both
-- in the same season — Weatherlight and Vincent's Card Colosseum both do now).
drop view if exists store_detail_summary;

create view store_detail_summary as
select
  e.id,
  st.name as store_name,
  st.slug as store_slug,
  s.slug as season_slug,
  e.event_type,
  e.title,
  e.date,
  e.date_tbd,
  e.status,
  coalesce(v.address, 'Venue address to be confirmed') as address,
  coalesce(v.state, st.region, 'TBC') as state,
  coalesce(v.country, st.country, 'Malaysia') as country,
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
where e.event_type in ('store_championship', 'regional');

-- 2. Correct the KL Regional venue address with the fuller detail from the official poster
-- (adds the Maju Junction / Maju Tower landmark, keeps the more precise Chow Kit / WP detail).
update venues set
  address = 'Level 10, Multaqam Hall, Maju Junction (Maju Tower), 1001, Jalan Sultan Ismail, Chow Kit, 50250 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur'
where store_id = (select id from stores where slug = 'the-weatherlight-enterprise')
  and name = 'Golden Chersonese Media Hall — Level 10, Multaqam Hall';

-- 3. Fill in the KL Regional's real event details, confirmed against the official poster.
update events set
  entry_fee = 'RM 145',
  registration_window = '7:00 AM – 8:45 AM',
  round1_time = '9:15 AM',
  registration_url = 'https://forms.gle/EY2nYRs6ScfryHtDA',
  poster_url = '/regionals/The Weatherlight Enterprise/poster.jpg',
  prize_structure = '1st: 1 .asphodel/paradise Booster Case, 10 .asphodel/paradise Sapphire Packs, 16 .asphodel/paradise Event Packs, 1 PRD Regionals 2026 Champion Playmat
2nd: 1 .asphodel/paradise Booster Box, 8 .asphodel/paradise Event Packs
3rd to 4th: 12 .asphodel/paradise Booster Pack, 6 .asphodel/paradise Event Packs
5th to 8th: 8 .asphodel/paradise Booster Pack, 6 .asphodel/paradise Event Packs
9th to 16th: 4 .asphodel/paradise Booster Pack, 4 .asphodel/paradise Event Packs
17th to 32nd: 3 .asphodel/paradise Booster Pack, 2 .asphodel/paradise Event Packs
Top 8: Customized laser engraved Spirit of Fire/Water/Wind metal card proxy by Weatherlight
Top 32: .asphodel/paradise Enfeebling Orb Regional Invite and Finalist Playmat
Participation: 3 .asphodel/paradise Booster Pack, 1 .asphodel/paradise Sapphire Pack, 2 .asphodel/paradise Event Pack, 1 .asphodel/paradise Blind Pick Playmat (3 designs)
Lucky Draw: Metal spirits (non-signed), CSRs, Curio Foils, SP4 packs, Event Packs, and more',
  highlights = 'Weatherlight returns as host for PRD Season Regionals KL. Registration is open — secure your slot with payment via the Google Form below.'
where store_id = (select id from stores where slug = 'the-weatherlight-enterprise')
  and title = 'PRD Season Regional Championship — Kuala Lumpur (hosted by The Weatherlight Enterprise)';

select 'KL Regional detail data updated' as status;
