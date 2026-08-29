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
  store_id uuid not null references stores(id) on delete cascade,
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

insert into venues (store_id, name, address, city, state, country, google_maps_url, address_status, is_verified, is_active)
select s.id, s.name, v.address, v.city, v.state, 'Malaysia', v.google_maps_url, 'confirmed', true, true
from (
  values
    ('Saikou Cards, Figurines, and Collectibles', '34-1A, Jalan Puteri 1/2, Bandar Puteri', 'Puchong', 'Selangor', 'https://maps.app.goo.gl/LV4vA9RZwsXTBBgi7'),
    ('The Collectors Hut', '1401, Level, Above Route 66, 1, Jalan Shell', 'Miri', 'Sarawak', 'https://maps.app.goo.gl/5JBdxsC1HZrRcJQ17'),
    ('The Weatherlight Enterprise', '1, Jalan USJ 10/1a, Usj 1', 'Subang Jaya', 'Selangor', 'https://maps.app.goo.gl/uz7zHJ25WSDusdBA9'),
    ('Aexern', '52A, Block M, Jalan Raja Uda, Pusat Perniagaan Raja Uda', 'Butterworth', 'Pulau Pinang', 'https://maps.app.goo.gl/QtHbWuniwdf3ojoeA'),
    ('Neko Neko Nyaa', 'Block 10, 1st Floor, Q3A, KCLD, Lot 2762', 'Kuching', 'Sarawak', 'https://maps.app.goo.gl/gU67j7zAEYpsL7XFA'),
    ('RoundTable Hobbies', 'B-264 , Tingkat, 1, Jalan Beserah, Taman Beserah', 'Kuantan', 'Pahang', 'https://maps.app.goo.gl/7ufLWujrUQpQDRYu6'),
    ('HOBBY MAKER', '4-22, Pragin Mall, Jalan Dr Lim Chwee Leong,Pulau Pinang!', 'George Town', 'Pulau Pinang', 'https://maps.app.goo.gl/mvi2uRjmMWVEG5eQ9'),
    ('Gaia Card Game Sanctuary', 'Endah Parade, Jalan 1/149e, Taman Sri Endah', 'Kuala Lumpur', 'Wilayah Persekutuan Kuala Lumpur', 'https://maps.app.goo.gl/XAsLrRXUp2syetqA8'),
    ('Favonia Hobbies', '12b, Persiaran Greentown 6, Greentown Business Centre', 'Ipoh', 'Perak', 'https://maps.app.goo.gl/pE9DTij4JHrN3PXy5'),
    ('Gathering Hub', 'Taman Masjaya', 'Kota Kinabalu', 'Sabah', 'https://maps.app.goo.gl/WuHGx1SyaHw63oYV8'),
    ('The Card Shop PLT', '54A, Jln 19/3, Seksyen 19', 'Petaling Jaya', 'Selangor', 'https://maps.app.goo.gl/xBTaJBugJwTKNgDg6'),
    ('Game and Glory Sdn Bhd', '1-42A, Jalan PJU 1/45, Aman Suria', 'Petaling Jaya', 'Selangor', 'https://maps.app.goo.gl/NCmMtD3DnxhT6VFH8'),
    ('YOLO TCG PARK', 'Parcel no.2 - level, 3 Of Bintulu, Parkcity Commerce Square', 'Bintulu', 'Sarawak', 'https://maps.app.goo.gl/8PsfUYHETu7fR5qC6'),
    ('Hobby Lords Malaysia', 'Seksyen U13, 31-1F, Persiaran Setia Utama, Setia Alam', 'Shah Alam', 'Selangor', 'https://maps.app.goo.gl/41TR3xyJEFfyxW9A6'),
    ('Games Haven BBK', '17, Lorong Tiara 1a, Bandar Baru Klang', 'Klang', 'Selangor', 'https://maps.app.goo.gl/HGkaty2GFwXCjRNe7'),
    ('Tabletop Arena', 'S-206, 2ND FLOOR, 1BORNEO HYPERMALL JALAN SULAMAN', 'Kota Kinabalu', 'Sabah', 'https://maps.app.goo.gl/bCguivVXrAWV9McJ7'),
    ('Spectre', 'NO.9-1, JALAN PJS 8/13, DATARAN MENTARI', 'Subang Jaya', 'Selangor', 'https://maps.app.goo.gl/9fKp1bpWTc6KZQR56'),
    ('Kado', 'A0331, Blok A, Eko Galleria Iskandar Puteri', 'Johor', 'Johor Darul Ta''zim', 'https://maps.app.goo.gl/5eKWPaTRdQMwktFX7'),
    ('MVP Hobbies & Collectibles Sdn Bhd', 'A-G-17, Zenopy Shoplex, Jln LP 7/4, Lestari Perdana', 'Seri Kembangan', 'Selangor', 'https://maps.app.goo.gl/S1iFnnbUK49kGa7p9'),
    ('SGC Card Cafe', '23-02, Jalan Suria 7, Bandar Baru Seri Alam', 'Masai', 'Johor', 'https://maps.app.goo.gl/1jhR4ybMUkqMsg4m7'),
    ('Astral Rift Tactics Shop', '8A, Medan Bercham Selatan 1, Medan Bercham Selatan', 'Ipoh', 'Perak', 'https://maps.app.goo.gl/UnRjdLaH6fkz5fZv6'),
    ('Monxter', '18-2, Jalan Menara Gading 1, Lebuhraya Hubungan Timur Barat', 'Kuala Lumpur', 'Wilayah Persekutuan Kuala Lumpur', 'https://maps.app.goo.gl/7SrETCZmbTK4YSZS9'),
    ('Kamenn Enterprise', '55a, Jalan Perwira 2, Taman Ungku Tun Aminah', 'Skudai', 'Johor Darul Ta''zim', 'https://maps.app.goo.gl/6d5b1d5APnPiP3Kt6'),
    ('Living Legends Enterprise', '32A, Jalan Pingai, Taman Pelangi', 'Johor Bahru', 'Johor Darul Ta''zim', 'https://maps.app.goo.gl/gumrMDMvTbxAU6se8'),
    ('Vincent''s Card Colosseum', 'Lot 2036 (1st Floor), Marina Commercial, Phase 1', 'Miri', 'Sarawak', 'https://maps.app.goo.gl/KhGLt53DAz1Vq7mY7'),
    ('Yugoco TCG & Games', 'no 5, 1, Jalan PNBBU 2, Pusat Niaga Bukit Baru Utama', 'Bukit Baru', 'Melaka', 'https://maps.app.goo.gl/NUD4PAGCMR2rntWh7'),
    ('CARDFIGHT BUDDY ENTERPRISE', '141B, Pusat Perniagaan Raja Uda, Jalan Raja Uda, RAJA UDA', 'Butterworth', 'Pulau Pinang', 'https://maps.app.goo.gl/jpjmRcuU7obgTf2C7'),
    ('KSL TCG ENTERPRISE', '39, Jalan Bukit Beruang Utama 2, Taman Bukit Beruang Utama', 'Ayer Keroh', 'Melaka', 'https://maps.app.goo.gl/xfnD3Hg3vxGyyj3n7'),
    ('Hobibear Gaming', '52a, Jalan Cerdas, Taman Connaught', 'Kuala Lumpur', 'Wilayah Persekutuan Kuala Lumpur', 'https://maps.app.goo.gl/8WmtPjtkVWaP1ky37'),
    ('Hans Arena', 'D 1-07 1st Floor Block D, NZX Commercial Centre, Jalan PJU 1A/41B, Ara Damansara', 'Petaling Jaya', 'Selangor', 'https://maps.app.goo.gl/Qa6HSvmAH93EQF2XA'),
    ('Yume Card Studio', '50b, Jalan Jati 1, Taman Nusa Bestari Jaya', 'Skudai', 'Johor Darul Ta''zim', 'https://maps.app.goo.gl/HrEdGpqaMETZ6eog9'),
    ('GUILDHALL PLT', 'UNIT D6-1-2 (2ND FLOOR), BLOCK D6, DANA 1, COMMERCIAL CENTRE, Jalan PJU 1a/46, Ara Damansara', 'Petaling Jaya', 'Selangor', 'https://maps.app.goo.gl/x8gBUoyXCYhRTucZA'),
    ('Shuffle by Snacks & Ladders', '337, Jln Perak, Jelutong', 'Jelutong', 'Pulau Pinang', 'https://maps.app.goo.gl/uwAxSfaaTb7aZ56D6'),
    ('SideDeck', '20-1, Jalan Impian Makmur 3/A, Saujana Impian', 'Kajang', 'Selangor', 'https://maps.app.goo.gl/VUik7NCcV1aUW6Rx9'),
    ('Shuffle the duel field', '10, Jalan Austin Perdana 2/24, Taman Austin Perdana', 'Johor Bahru', 'Johor Darul Ta''zim', 'https://maps.app.goo.gl/odYFNVsQZsCr5jVcA'),
    ('Gentoshi', '2nd Floor, Lot 10520, Block 16, KCLD, Jalan Tun Jugah', 'Kuching', 'Sarawak', 'https://maps.app.goo.gl/gmRqU5a1n1A9HmUq6'),
    ('DeckOutDen', '15, Jln Reko Sentral 9, Reko Sentral', 'Kajang', 'Selangor', 'https://maps.app.goo.gl/TcwPKRUuqp9cfjNv9'),
    ('Hobby Outpost Cheras', '1, Jalan C180/1, C180', 'Cheras', 'Selangor', 'https://maps.app.goo.gl/x2gCWibrTNRG6eG99'),
    ('Storm Gate Games', 'Unit R-01-23A Emporis, Persiaran Surian, Kota Damansara', 'Petaling Jaya', 'Selangor', 'https://maps.app.goo.gl/RjYHVZtYCmznAxL56'),
    ('Game On Boardgame Cafe', '199b, Jln PSK 5, Pekan Simpang Kuala', 'Alor Setar', 'Kedah', 'https://maps.app.goo.gl/GXjEHjfF34HNjjpo8'),
    ('ZergHive TCG', '100, Jalan Pasar', 'Taiping', 'Perak', 'https://maps.app.goo.gl/8dgexE5MZykPLQ2b9')
) as v(name, address, city, state, google_maps_url)
join stores s on s.name = v.name
on conflict (store_id, name) do update set
  address = excluded.address,
  city = excluded.city,
  state = excluded.state,
  country = excluded.country,
  google_maps_url = excluded.google_maps_url,
  address_status = excluded.address_status,
  is_verified = excluded.is_verified,
  is_active = excluded.is_active;

insert into events (season_id, store_id, venue_id, event_type, title, date, date_tbd, status, visibility, notes, maps_url, external_url, is_active)
select
  (select id from seasons where slug = 'prd-2026'),
  s.id,
  v.id,
  'store_championship',
  s.name || ' Store Championship',
  case when e.date_raw = 'TBD' then null else to_date(e.date_raw, 'DD-Mon-YYYY') end,
  (e.date_raw = 'TBD'),
  case when e.date_raw = 'TBD' then 'tbd' else 'scheduled' end,
  'visible',
  case when e.date_raw = 'TBD' then 'Date still TBD for PRD season' else 'PRD season store championship' end,
  e.maps_url,
  null,
  true
from (
  values
    ('Saikou Cards, Figurines, and Collectibles', '26-Sep-2026', 'https://maps.app.goo.gl/LV4vA9RZwsXTBBgi7'),
    ('The Collectors Hut', '26-Sep-2026', 'https://maps.app.goo.gl/5JBdxsC1HZrRcJQ17'),
    ('The Weatherlight Enterprise', '27-Sep-2026', 'https://maps.app.goo.gl/uz7zHJ25WSDusdBA9'),
    ('Aexern', '27-Sep-2026', 'https://maps.app.goo.gl/QtHbWuniwdf3ojoeA'),
    ('Neko Neko Nyaa', '27-Sep-2026', 'https://maps.app.goo.gl/gU67j7zAEYpsL7XFA'),
    ('RoundTable Hobbies', '27-Sep-2026', 'https://maps.app.goo.gl/7ufLWujrUQpQDRYu6'),
    ('HOBBY MAKER', '03-Oct-2026', 'https://maps.app.goo.gl/mvi2uRjmMWVEG5eQ9'),
    ('Gaia Card Game Sanctuary', '03-Oct-2026', 'https://maps.app.goo.gl/XAsLrRXUp2syetqA8'),
    ('Favonia Hobbies', '04-Oct-2026', 'https://maps.app.goo.gl/pE9DTij4JHrN3PXy5'),
    ('Gathering Hub', '04-Oct-2026', 'https://maps.app.goo.gl/WuHGx1SyaHw63oYV8'),
    ('The Card Shop PLT', '04-Oct-2026', 'https://maps.app.goo.gl/xBTaJBugJwTKNgDg6'),
    ('Game and Glory Sdn Bhd', '10-Oct-2026', 'https://maps.app.goo.gl/NCmMtD3DnxhT6VFH8'),
    ('YOLO TCG PARK', '10-Oct-2026', 'https://maps.app.goo.gl/8PsfUYHETu7fR5qC6'),
    ('Hobby Lords Malaysia', '10-Oct-2026', 'https://maps.app.goo.gl/41TR3xyJEFfyxW9A6'),
    ('Games Haven BBK', '10-Oct-2026', 'https://maps.app.goo.gl/HGkaty2GFwXCjRNe7'),
    ('Tabletop Arena', '11-Oct-2026', 'https://maps.app.goo.gl/bCguivVXrAWV9McJ7'),
    ('Spectre', '11-Oct-2026', 'https://maps.app.goo.gl/9fKp1bpWTc6KZQR56'),
    ('Kado', '17-Oct-2026', 'https://maps.app.goo.gl/5eKWPaTRdQMwktFX7'),
    ('MVP Hobbies & Collectibles Sdn Bhd', '17-Oct-2026', 'https://maps.app.goo.gl/S1iFnnbUK49kGa7p9'),
    ('SGC Card Cafe', '18-Oct-2026', 'https://maps.app.goo.gl/1jhR4ybMUkqMsg4m7'),
    ('Astral Rift Tactics Shop', '24-Oct-2026', 'https://maps.app.goo.gl/UnRjdLaH6fkz5fZv6'),
    ('Monxter', '24-Oct-2026', 'https://maps.app.goo.gl/7SrETCZmbTK4YSZS9'),
    ('Kamenn Enterprise', '24-Oct-2026', 'https://maps.app.goo.gl/6d5b1d5APnPiP3Kt6'),
    ('Living Legends Enterprise', '25-Oct-2026', 'https://maps.app.goo.gl/gumrMDMvTbxAU6se8'),
    ('Vincent''s Card Colosseum', '25-Oct-2026', 'https://maps.app.goo.gl/KhGLt53DAz1Vq7mY7'),
    ('Yugoco TCG & Games', '25-Oct-2026', 'https://maps.app.goo.gl/NUD4PAGCMR2rntWh7'),
    ('CARDFIGHT BUDDY ENTERPRISE', '31-Oct-2026', 'https://maps.app.goo.gl/jpjmRcuU7obgTf2C7'),
    ('KSL TCG ENTERPRISE', '31-Oct-2026', 'https://maps.app.goo.gl/xfnD3Hg3vxGyyj3n7'),
    ('Hobibear Gaming', '31-Oct-2026', 'https://maps.app.goo.gl/8WmtPjtkVWaP1ky37'),
    ('Hans Arena', '01-Nov-2026', 'https://maps.app.goo.gl/Qa6HSvmAH93EQF2XA'),
    ('Yume Card Studio', '01-Nov-2026', 'https://maps.app.goo.gl/HrEdGpqaMETZ6eog9'),
    ('GUILDHALL PLT', '07-Nov-2026', 'https://maps.app.goo.gl/x8gBUoyXCYhRTucZA'),
    ('Shuffle by Snacks & Ladders', '07-Nov-2026', 'https://maps.app.goo.gl/uwAxSfaaTb7aZ56D6'),
    ('SideDeck', '08-Nov-2026', 'https://maps.app.goo.gl/VUik7NCcV1aUW6Rx9'),
    ('Shuffle the duel field', '08-Nov-2026', 'https://maps.app.goo.gl/odYFNVsQZsCr5jVcA'),
    ('Gentoshi', '08-Nov-2026', 'https://maps.app.goo.gl/gmRqU5a1n1A9HmUq6'),
    ('DeckOutDen', '15-Nov-2026', 'https://maps.app.goo.gl/TcwPKRUuqp9cfjNv9'),
    ('Hobby Outpost Cheras', '15-Nov-2026', 'https://maps.app.goo.gl/x2gCWibrTNRG6eG99'),
    ('Storm Gate Games', '22-Nov-2026', 'https://maps.app.goo.gl/RjYHVZtYCmznAxL56'),
    ('Game On Boardgame Cafe', 'TBD', 'https://maps.app.goo.gl/GXjEHjfF34HNjjpo8'),
    ('ZergHive TCG', 'TBD', 'https://maps.app.goo.gl/8dgexE5MZykPLQ2b9')
) as e(name, date_raw, maps_url)
join stores s on s.name = e.name
join venues v on v.store_id = s.id and v.name = s.name
on conflict (season_id, store_id, title) do update set
  venue_id = excluded.venue_id,
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

create or replace view season_event_summary as
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
  v.address_status,
  v.is_verified,
  v.google_maps_url
from events e
join seasons s on s.id = e.season_id
join stores st on st.id = e.store_id
left join venues v on v.id = e.venue_id;

select 'PRD season data corrected and ready' as status;
