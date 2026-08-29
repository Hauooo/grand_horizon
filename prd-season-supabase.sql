create extension if not exists pgcrypto;

create table if not exists seasons (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  start_date date not null,
  end_date date not null,
  status text not null default 'active',
  guide_url text,
  logo_url text,
  created_at timestamptz not null default now()
);

create table if not exists stores (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  region text,
  country text not null default 'Malaysia',
  website_url text,
  created_at timestamptz not null default now()
);

create table if not exists venues (
  id uuid primary key default gen_random_uuid(),
  store_id uuid references stores(id) on delete cascade,
  name text not null,
  address text,
  city text,
  state text,
  country text not null default 'Malaysia',
  google_maps_url text,
  address_status text not null default 'confirmed',
  is_verified boolean not null default true,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists events (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references seasons(id) on delete cascade,
  store_id uuid not null references stores(id) on delete cascade,
  venue_id uuid references venues(id) on delete set null,
  event_type text not null default 'store_championship',
  title text not null,
  date date,
  date_tbd boolean not null default false,
  status text not null default 'scheduled',
  visibility text not null default 'visible',
  notes text,
  maps_url text,
  external_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists seasons_slug_idx on seasons(slug);
create unique index if not exists stores_slug_idx on stores(slug);
create unique index if not exists venues_store_name_idx on venues(store_id, name);
create unique index if not exists events_season_store_title_idx on events(season_id, store_id, title);

insert into seasons (slug, name, start_date, end_date, status, guide_url, logo_url)
values (
  'prd-2026',
  'PRD Season 2026',
  '2026-08-28',
  '2026-12-11',
  'active',
  'https://storage.googleapis.com/omnidex/seasons/PRD%20Season%20Guide.pdf',
  'https://storage.googleapis.com/omnidex/seasons/prd-logo.png'
)
on conflict (slug) do update set
  name = excluded.name,
  start_date = excluded.start_date,
  end_date = excluded.end_date,
  status = excluded.status,
  guide_url = excluded.guide_url,
  logo_url = excluded.logo_url;

insert into stores (name, slug, region, country, website_url) values
  ('Malaysia Regional 1', 'malaysia-regional-1', 'TBC', 'Malaysia', null),
  ('Malaysia Regional 2', 'malaysia-regional-2', 'TBC', 'Malaysia', null),
  ('Saikou Cards, Figurines, and Collectibles', 'saikou-cards-figurines-and-collectibles', 'Selangor', 'Malaysia', null),
  ('The Collectors Hut', 'the-collectors-hut', 'Sarawak', 'Malaysia', null),
  ('The Weatherlight Enterprise', 'the-weatherlight-enterprise', 'Selangor', 'Malaysia', null),
  ('Aexern', 'aexern', 'Pulau Pinang', 'Malaysia', null),
  ('Neko Neko Nyaa', 'neko-neko-nyaa', 'Sarawak', 'Malaysia', null),
  ('RoundTable Hobbies', 'roundtable-hobbies', 'Pahang', 'Malaysia', null),
  ('HOBBY MAKER', 'hobby-maker', 'Pulau Pinang', 'Malaysia', null),
  ('Gaia Card Game Sanctuary', 'gaia-card-game-sanctuary', 'Wilayah Persekutuan Kuala Lumpur', 'Malaysia', null),
  ('Favonia Hobbies', 'favonia-hobbies', 'Perak', 'Malaysia', null),
  ('Gathering Hub', 'gathering-hub', 'Sabah', 'Malaysia', null),
  ('The Card Shop PLT', 'the-card-shop-plt', 'Selangor', 'Malaysia', null),
  ('Game and Glory Sdn Bhd', 'game-and-glory-sdn-bhd', 'Selangor', 'Malaysia', null),
  ('YOLO TCG PARK', 'yolo-tcg-park', 'Sarawak', 'Malaysia', null),
  ('Hobby Lords Malaysia', 'hobby-lords-malaysia', 'Selangor', 'Malaysia', null),
  ('Games Haven BBK', 'games-haven-bbk', 'Selangor', 'Malaysia', null),
  ('Tabletop Arena', 'tabletop-arena', 'Sabah', 'Malaysia', null),
  ('Spectre', 'spectre', 'Selangor', 'Malaysia', null),
  ('Kado', 'kado', 'Johor', 'Malaysia', null),
  ('MVP Hobbies & Collectibles Sdn Bhd', 'mvp-hobbies-collectibles-sdn-bhd', 'Selangor', 'Malaysia', null),
  ('SGC Card Cafe', 'sgc-card-cafe', 'Johor', 'Malaysia', null),
  ('Astral Rift Tactics Shop', 'astral-rift-tactics-shop', 'Perak', 'Malaysia', null),
  ('Monxter', 'monxter', 'Wilayah Persekutuan Kuala Lumpur', 'Malaysia', null),
  ('Kamenn Enterprise', 'kamenn-enterprise', 'Johor', 'Malaysia', null),
  ('Living Legends Enterprise', 'living-legends-enterprise', 'Johor', 'Malaysia', null),
  ('Vincent''s Card Colosseum', 'vincents-card-colosseum', 'Sarawak', 'Malaysia', null),
  ('Yugoco TCG & Games', 'yugoco-tcg-games', 'Melaka', 'Malaysia', null),
  ('CARDFIGHT BUDDY ENTERPRISE', 'cardfight-buddy-enterprise', 'Pulau Pinang', 'Malaysia', null),
  ('KSL TCG ENTERPRISE', 'ksl-tcg-enterprise', 'Melaka', 'Malaysia', null),
  ('Hobibear Gaming', 'hobibear-gaming', 'Wilayah Persekutuan Kuala Lumpur', 'Malaysia', null),
  ('Hans Arena', 'hans-arena', 'Selangor', 'Malaysia', null),
  ('Yume Card Studio', 'yume-card-studio', 'Johor', 'Malaysia', null),
  ('GUILDHALL PLT', 'guildhall-plt', 'Selangor', 'Malaysia', null),
  ('Shuffle by Snacks & Ladders', 'shuffle-by-snacks-ladders', 'Pulau Pinang', 'Malaysia', null),
  ('SideDeck', 'sidedeck', 'Selangor', 'Malaysia', null),
  ('Shuffle the duel field', 'shuffle-the-duel-field', 'Johor', 'Malaysia', null),
  ('Gentoshi', 'gentoshi', 'Sarawak', 'Malaysia', null),
  ('DeckOutDen', 'deckoutden', 'Selangor', 'Malaysia', null),
  ('Hobby Outpost Cheras', 'hobby-outpost-cheras', 'Selangor', 'Malaysia', null),
  ('Storm Gate Games', 'storm-gate-games', 'Selangor', 'Malaysia', null),
  ('Game On Boardgame Cafe', 'game-on-boardgame-cafe', 'Kedah', 'Malaysia', null),
  ('ZergHive TCG', 'zerghive-tcg', 'Perak', 'Malaysia', null)
on conflict (slug) do update set
  name = excluded.name,
  region = excluded.region,
  country = excluded.country,
  website_url = excluded.website_url;

insert into events (
  season_id,
  store_id,
  event_type,
  title,
  date,
  date_tbd,
  status,
  visibility,
  notes,
  maps_url,
  external_url,
  is_active
)
values
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'malaysia-regional-1'), 'regional', 'Malaysia Regional 1', '2026-09-26', false, 'scheduled', 'visible', 'Regional tournament - location TBC', 'https://www.google.com/maps', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'malaysia-regional-2'), 'regional', 'Malaysia Regional 2', '2026-10-03', false, 'scheduled', 'visible', 'Regional tournament - location TBC', 'https://www.google.com/maps', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'saikou-cards-figurines-and-collectibles'), 'store_championship', 'Saikou Cards, Figurines, and Collectibles Store Championship', '2026-09-26', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/LV4vA9RZwsXTBBgi7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'the-collectors-hut'), 'store_championship', 'The Collectors Hut Store Championship', '2026-09-26', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/5JBdxsC1HZrRcJQ17', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'the-weatherlight-enterprise'), 'store_championship', 'The Weatherlight Enterprise Store Championship', '2026-09-27', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/uz7zHJ25WSDusdBA9', '/stores/the-weatherlight-enterprise', true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'aexern'), 'store_championship', 'Aexern Store Championship', '2026-09-27', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/QtHbWuniwdf3ojoeA', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'neko-neko-nyaa'), 'store_championship', 'Neko Neko Nyaa Store Championship', '2026-09-27', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/gU67j7zAEYpsL7XFA', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'roundtable-hobbies'), 'store_championship', 'RoundTable Hobbies Store Championship', '2026-09-27', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/7ufLWujrUQpQDRYu6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'hobby-maker'), 'store_championship', 'HOBBY MAKER Store Championship', '2026-10-03', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/mvi2uRjmMWVEG5eQ9', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'gaia-card-game-sanctuary'), 'store_championship', 'Gaia Card Game Sanctuary Store Championship', '2026-10-03', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/XAsLrRXUp2syetqA8', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'favonia-hobbies'), 'store_championship', 'Favonia Hobbies Store Championship', '2026-10-04', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/pE9DTij4JHrN3PXy5', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'gathering-hub'), 'store_championship', 'Gathering Hub Store Championship', '2026-10-04', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/WuHGx1SyaHw63oYV8', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'the-card-shop-plt'), 'store_championship', 'The Card Shop PLT Store Championship', '2026-10-04', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/xBTaJBugJwTKNgDg6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'game-and-glory-sdn-bhd'), 'store_championship', 'Game and Glory Sdn Bhd Store Championship', '2026-10-10', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/NCmMtD3DnxhT6VFH8', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'yolo-tcg-park'), 'store_championship', 'YOLO TCG PARK Store Championship', '2026-10-10', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/8PsfUYHETu7fR5qC6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'hobby-lords-malaysia'), 'store_championship', 'Hobby Lords Malaysia Store Championship', '2026-10-10', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/41TR3xyJEFfyxW9A6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'games-haven-bbk'), 'store_championship', 'Games Haven BBK Store Championship', '2026-10-10', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/HGkaty2GFwXCjRNe7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'tabletop-arena'), 'store_championship', 'Tabletop Arena Store Championship', '2026-10-11', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/bCguivVXrAWV9McJ7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'spectre'), 'store_championship', 'Spectre Store Championship', '2026-10-11', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/9fKp1bpWTc6KZQR56', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'kado'), 'store_championship', 'Kado Store Championship', '2026-10-17', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/5eKWPaTRdQMwktFX7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'mvp-hobbies-collectibles-sdn-bhd'), 'store_championship', 'MVP Hobbies & Collectibles Sdn Bhd Store Championship', '2026-10-17', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/S1iFnnbUK49kGa7p9', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'sgc-card-cafe'), 'store_championship', 'SGC Card Cafe Store Championship', '2026-10-18', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/1jhR4ybMUkqMsg4m7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'astral-rift-tactics-shop'), 'store_championship', 'Astral Rift Tactics Shop Store Championship', '2026-10-24', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/UnRjdLaH6fkz5fZv6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'monxter'), 'store_championship', 'Monxter Store Championship', '2026-10-24', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/7SrETCZmbTK4YSZS9', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'kamenn-enterprise'), 'store_championship', 'Kamenn Enterprise Store Championship', '2026-10-24', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/6d5b1d5APnPiP3Kt6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'living-legends-enterprise'), 'store_championship', 'Living Legends Enterprise Store Championship', '2026-10-25', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/gumrMDMvTbxAU6se8', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'vincents-card-colosseum'), 'store_championship', 'Vincent''s Card Colosseum Store Championship', '2026-10-25', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/KhGLt53DAz1Vq7mY7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'yugoco-tcg-games'), 'store_championship', 'Yugoco TCG & Games Store Championship', '2026-10-25', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/NUD4PAGCMR2rntWh7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'cardfight-buddy-enterprise'), 'store_championship', 'CARDFIGHT BUDDY ENTERPRISE Store Championship', '2026-10-31', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/jpjmRcuU7obgTf2C7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'ksl-tcg-enterprise'), 'store_championship', 'KSL TCG ENTERPRISE Store Championship', '2026-10-31', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/xfnD3Hg3vxGyyj3n7', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'hobibear-gaming'), 'store_championship', 'Hobibear Gaming Store Championship', '2026-10-31', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/8WmtPjtkVWaP1ky37', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'hans-arena'), 'store_championship', 'Hans Arena Store Championship', '2026-11-01', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/Qa6HSvmAH93EQF2XA', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'yume-card-studio'), 'store_championship', 'Yume Card Studio Store Championship', '2026-11-01', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/HrEdGpqaMETZ6eog9', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'guildhall-plt'), 'store_championship', 'GUILDHALL PLT Store Championship', '2026-11-07', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/x8gBUoyXCYhRTucZA', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'shuffle-by-snacks-ladders'), 'store_championship', 'Shuffle by Snacks & Ladders Store Championship', '2026-11-07', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/uwAxSfaaTb7aZ56D6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'sidedeck'), 'store_championship', 'SideDeck Store Championship', '2026-11-08', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/VUik7NCcV1aUW6Rx9', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'shuffle-the-duel-field'), 'store_championship', 'Shuffle the duel field Store Championship', '2026-11-08', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/odYFNVsQZsCr5jVcA', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'gentoshi'), 'store_championship', 'Gentoshi Store Championship', '2026-11-08', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/gmRqU5a1n1A9HmUq6', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'deckoutden'), 'store_championship', 'DeckOutDen Store Championship', '2026-11-15', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/TcwPKRUuqp9cfjNv9', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'hobby-outpost-cheras'), 'store_championship', 'Hobby Outpost Cheras Store Championship', '2026-11-15', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/x2gCWibrTNRG6eG99', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'storm-gate-games'), 'store_championship', 'Storm Gate Games Store Championship', '2026-11-22', false, 'scheduled', 'visible', 'PRD season store championship', 'https://maps.app.goo.gl/RjYHVZtYCmznAxL56', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'game-on-boardgame-cafe'), 'store_championship', 'Game On Boardgame Cafe Store Championship', null, true, 'tbd', 'visible', 'Date still TBD for PRD season', 'https://maps.app.goo.gl/GXjEHjfF34HNjjpo8', null, true),
  ((select id from seasons where slug = 'prd-2026'), (select id from stores where slug = 'zerghive-tcg'), 'store_championship', 'ZergHive TCG Store Championship', null, true, 'tbd', 'visible', 'Date still TBD for PRD season', 'https://maps.app.goo.gl/8dgexE5MZykPLQ2b9', null, true)
on conflict (season_id, store_id, title) do update set
  event_type = excluded.event_type,
  date = excluded.date,
  date_tbd = excluded.date_tbd,
  status = excluded.status,
  visibility = excluded.visibility,
  notes = excluded.notes,
  maps_url = excluded.maps_url,
  external_url = excluded.external_url,
  is_active = excluded.is_active,
  updated_at = now();

drop view if exists season_event_summary;

create view season_event_summary as
select
  e.id,
  s.slug as season_slug,
  s.name as season_name,
  st.name as store_name,
  e.title,
  e.date,
  e.date_tbd,
  e.status,
  e.visibility,
  coalesce(st.region, v.state, 'TBC') as state,
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

select 'PRD season data ready' as status;
