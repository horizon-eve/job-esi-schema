-- EVE Swagger Interface v1.11
-- An OpenAPI for EVE Online
--
DROP ROLE IF EXISTS esi_v1_11;
CREATE ROLE esi_v1_11;
CREATE SCHEMA AUTHORIZATION esi_v1_11;
GRANT esi_v1_11 TO esi;
GRANT USAGE ON SCHEMA esi_v1_11 TO authenticated;
DROP ROLE IF EXISTS Station_Manager,Accountant,Director,CEO,Factory_Manager,Trader,Junior_Accountant;
CREATE ROLE Station_Manager;
GRANT authenticated to Station_Manager;
CREATE ROLE Accountant;
GRANT authenticated to Accountant;
CREATE ROLE Director;
GRANT authenticated to Director;
CREATE ROLE CEO;
GRANT authenticated to CEO;
CREATE ROLE Factory_Manager;
GRANT authenticated to Factory_Manager;
CREATE ROLE Trader;
GRANT authenticated to Trader;
CREATE ROLE Junior_Accountant;
GRANT authenticated to Junior_Accountant;
--
SET SEARCH_PATH TO esi_v1_11;
--
-- List all alliances
-- operation id: get_alliances
CREATE TABLE alliances
(
  alliances_id integer
);
ALTER TABLE alliances OWNER TO esi_v1_11;

-- Get alliance information
-- operation id: get_alliances_alliance_id
CREATE TABLE alliance
(
  alliance_id integer PRIMARY KEY,
  creator_corporation_id integer NOT NULL,
  creator_id integer NOT NULL,
  date_founded timestamp NOT NULL,
  executor_corporation_id integer,
  faction_id integer,
  name varchar(4000) NOT NULL,
  ticker varchar(4000) NOT NULL
);
ALTER TABLE alliance OWNER TO esi_v1_11;

-- Get alliance contacts
-- operation id: get_alliances_alliance_id_contacts
CREATE TABLE ali_contact
(
  alliance_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  contact_id integer NOT NULL,
  contact_type varchar(4000) NOT NULL,
  label_ids json,
  standing float NOT NULL
);
ALTER TABLE ali_contact OWNER TO esi_v1_11;
GRANT SELECT ON TABLE ali_contact TO authenticated;
GRANT INSERT ON TABLE ali_contact TO authenticated;
GRANT DELETE ON TABLE ali_contact TO authenticated;
ALTER TABLE ali_contact ENABLE ROW LEVEL SECURITY;
CREATE POLICY ali_contact ON ali_contact TO authenticated USING (user_id = current_user);

-- Get alliance contact labels
-- operation id: get_alliances_alliance_id_contacts_labels
CREATE TABLE ali_contact_label
(
  alliance_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  label_id bigint NOT NULL,
  label_name varchar(4000) NOT NULL
);
ALTER TABLE ali_contact_label OWNER TO esi_v1_11;
GRANT SELECT ON TABLE ali_contact_label TO authenticated;
GRANT INSERT ON TABLE ali_contact_label TO authenticated;
GRANT DELETE ON TABLE ali_contact_label TO authenticated;
ALTER TABLE ali_contact_label ENABLE ROW LEVEL SECURITY;
CREATE POLICY ali_contact_label ON ali_contact_label TO authenticated USING (user_id = current_user);

-- List alliance's corporations
-- operation id: get_alliances_alliance_id_corporations
CREATE TABLE ali_corporation
(
  alliance_id integer NOT NULL,
  corporation_id integer
);
ALTER TABLE ali_corporation OWNER TO esi_v1_11;

-- Get alliance icon
-- operation id: get_alliances_alliance_id_icons
CREATE TABLE ali_icon
(
  alliance_id integer PRIMARY KEY,
  px128x128 varchar(4000),
  px64x64 varchar(4000)
);
ALTER TABLE ali_icon OWNER TO esi_v1_11;

-- Get character's public information
-- operation id: get_characters_character_id
CREATE TABLE character
(
  character_id integer PRIMARY KEY,
  alliance_id integer,
  birthday timestamp NOT NULL,
  bloodline_id integer NOT NULL,
  corporation_id integer NOT NULL,
  description varchar(4000),
  faction_id integer,
  gender varchar(4000) NOT NULL,
  name varchar(4000) NOT NULL,
  race_id integer NOT NULL,
  security_status float,
  title varchar(4000)
);
ALTER TABLE character OWNER TO esi_v1_11;

-- Get agents research
-- operation id: get_characters_character_id_agents_research
CREATE TABLE chr_agents_research
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  agent_id integer NOT NULL,
  points_per_day float NOT NULL,
  remainder_points float NOT NULL,
  skill_type_id integer NOT NULL,
  started_at timestamp NOT NULL
);
ALTER TABLE chr_agents_research OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_agents_research TO authenticated;
GRANT INSERT ON TABLE chr_agents_research TO authenticated;
GRANT DELETE ON TABLE chr_agents_research TO authenticated;
ALTER TABLE chr_agents_research ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_agents_research ON chr_agents_research TO authenticated USING (user_id = current_user);

-- Get character assets
-- operation id: get_characters_character_id_assets
CREATE TABLE chr_asset
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  is_blueprint_copy boolean,
  is_singleton boolean NOT NULL,
  item_id bigint NOT NULL,
  location_flag varchar(4000) NOT NULL,
  location_id bigint NOT NULL,
  location_type varchar(4000) NOT NULL,
  quantity integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE chr_asset OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_asset TO authenticated;
GRANT INSERT ON TABLE chr_asset TO authenticated;
GRANT DELETE ON TABLE chr_asset TO authenticated;
ALTER TABLE chr_asset ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_asset ON chr_asset TO authenticated USING (user_id = current_user);

-- Get character attributes
-- operation id: get_characters_character_id_attributes
CREATE TABLE chr_attribute
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  accrued_remap_cooldown_date timestamp,
  bonus_remaps integer,
  charisma integer NOT NULL,
  intelligence integer NOT NULL,
  last_remap_date timestamp,
  memory integer NOT NULL,
  perception integer NOT NULL,
  willpower integer NOT NULL
);
ALTER TABLE chr_attribute OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_attribute TO authenticated;
GRANT INSERT ON TABLE chr_attribute TO authenticated;
GRANT DELETE ON TABLE chr_attribute TO authenticated;
ALTER TABLE chr_attribute ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_attribute ON chr_attribute TO authenticated USING (user_id = current_user);

-- Get blueprints
-- operation id: get_characters_character_id_blueprints
CREATE TABLE chr_blueprint
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  item_id bigint NOT NULL,
  location_flag varchar(4000) NOT NULL,
  location_id bigint NOT NULL,
  material_efficiency integer NOT NULL,
  quantity integer NOT NULL,
  runs integer NOT NULL,
  time_efficiency integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE chr_blueprint OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_blueprint TO authenticated;
GRANT INSERT ON TABLE chr_blueprint TO authenticated;
GRANT DELETE ON TABLE chr_blueprint TO authenticated;
ALTER TABLE chr_blueprint ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_blueprint ON chr_blueprint TO authenticated USING (user_id = current_user);

-- List bookmarks
-- operation id: get_characters_character_id_bookmarks
CREATE TABLE chr_bookmark
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  bookmark_id integer NOT NULL,
  coordinates json NOT NULL,
  created timestamp NOT NULL,
  creator_id integer NOT NULL,
  folder_id integer,
  item json NOT NULL,
  label varchar(4000) NOT NULL,
  location_id integer NOT NULL,
  notes varchar(4000) NOT NULL
);
ALTER TABLE chr_bookmark OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_bookmark TO authenticated;
GRANT INSERT ON TABLE chr_bookmark TO authenticated;
GRANT DELETE ON TABLE chr_bookmark TO authenticated;
ALTER TABLE chr_bookmark ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_bookmark ON chr_bookmark TO authenticated USING (user_id = current_user);

-- List bookmark folders
-- operation id: get_characters_character_id_bookmarks_folders
CREATE TABLE chr_bookmark_folder
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  folder_id integer NOT NULL,
  name varchar(4000) NOT NULL
);
ALTER TABLE chr_bookmark_folder OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_bookmark_folder TO authenticated;
GRANT INSERT ON TABLE chr_bookmark_folder TO authenticated;
GRANT DELETE ON TABLE chr_bookmark_folder TO authenticated;
ALTER TABLE chr_bookmark_folder ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_bookmark_folder ON chr_bookmark_folder TO authenticated USING (user_id = current_user);

-- List calendar event summaries
-- operation id: get_characters_character_id_calendar
CREATE TABLE chr_calendar
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  event_date timestamp,
  event_id integer,
  event_response varchar(4000),
  importance integer,
  title varchar(4000)
);
ALTER TABLE chr_calendar OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_calendar TO authenticated;
GRANT INSERT ON TABLE chr_calendar TO authenticated;
GRANT DELETE ON TABLE chr_calendar TO authenticated;
ALTER TABLE chr_calendar ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_calendar ON chr_calendar TO authenticated USING (user_id = current_user);

-- Get an event
-- operation id: get_characters_character_id_calendar_event_id
CREATE TABLE chr_calendar_event
(
  character_id integer NOT NULL,
  event_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  date timestamp NOT NULL,
  duration integer NOT NULL,
  importance integer NOT NULL,
  owner_id integer NOT NULL,
  owner_name varchar(4000) NOT NULL,
  owner_type varchar(4000) NOT NULL,
  response varchar(4000) NOT NULL,
  text varchar(4000) NOT NULL,
  title varchar(4000) NOT NULL
);
ALTER TABLE chr_calendar_event OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_calendar_event TO authenticated;
GRANT INSERT ON TABLE chr_calendar_event TO authenticated;
GRANT DELETE ON TABLE chr_calendar_event TO authenticated;
ALTER TABLE chr_calendar_event ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_calendar_event ON chr_calendar_event TO authenticated USING (user_id = current_user);

-- Get attendees
-- operation id: get_characters_character_id_calendar_event_id_attendees
CREATE TABLE chr_calendar_event_attendee
(
  character_id integer NOT NULL,
  event_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  event_response varchar(4000)
);
ALTER TABLE chr_calendar_event_attendee OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_calendar_event_attendee TO authenticated;
GRANT INSERT ON TABLE chr_calendar_event_attendee TO authenticated;
GRANT DELETE ON TABLE chr_calendar_event_attendee TO authenticated;
ALTER TABLE chr_calendar_event_attendee ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_calendar_event_attendee ON chr_calendar_event_attendee TO authenticated USING (user_id = current_user);

-- Get clones
-- operation id: get_characters_character_id_clones
CREATE TABLE chr_clone
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  home_location json,
  jump_clones json NOT NULL,
  last_clone_jump_date timestamp,
  last_station_change_date timestamp
);
ALTER TABLE chr_clone OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_clone TO authenticated;
GRANT INSERT ON TABLE chr_clone TO authenticated;
GRANT DELETE ON TABLE chr_clone TO authenticated;
ALTER TABLE chr_clone ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_clone ON chr_clone TO authenticated USING (user_id = current_user);

-- Get contacts
-- operation id: get_characters_character_id_contacts
CREATE TABLE chr_contact
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  contact_id integer NOT NULL,
  contact_type varchar(4000) NOT NULL,
  is_blocked boolean,
  is_watched boolean,
  label_ids json,
  standing float NOT NULL
);
ALTER TABLE chr_contact OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_contact TO authenticated;
GRANT INSERT ON TABLE chr_contact TO authenticated;
GRANT DELETE ON TABLE chr_contact TO authenticated;
ALTER TABLE chr_contact ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_contact ON chr_contact TO authenticated USING (user_id = current_user);

-- Get contact labels
-- operation id: get_characters_character_id_contacts_labels
CREATE TABLE chr_contact_label
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  label_id bigint NOT NULL,
  label_name varchar(4000) NOT NULL
);
ALTER TABLE chr_contact_label OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_contact_label TO authenticated;
GRANT INSERT ON TABLE chr_contact_label TO authenticated;
GRANT DELETE ON TABLE chr_contact_label TO authenticated;
ALTER TABLE chr_contact_label ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_contact_label ON chr_contact_label TO authenticated USING (user_id = current_user);

-- Get contracts
-- operation id: get_characters_character_id_contracts
CREATE TABLE chr_contract
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  acceptor_id integer NOT NULL,
  assignee_id integer NOT NULL,
  availability varchar(4000) NOT NULL,
  buyout double precision,
  collateral double precision,
  contract_id integer NOT NULL,
  date_accepted timestamp,
  date_completed timestamp,
  date_expired timestamp NOT NULL,
  date_issued timestamp NOT NULL,
  days_to_complete integer,
  end_location_id bigint,
  for_corporation boolean NOT NULL,
  issuer_corporation_id integer NOT NULL,
  issuer_id integer NOT NULL,
  price double precision,
  reward double precision,
  start_location_id bigint,
  status varchar(4000) NOT NULL,
  title varchar(4000),
  type varchar(4000) NOT NULL,
  volume double precision
);
ALTER TABLE chr_contract OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_contract TO authenticated;
GRANT INSERT ON TABLE chr_contract TO authenticated;
GRANT DELETE ON TABLE chr_contract TO authenticated;
ALTER TABLE chr_contract ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_contract ON chr_contract TO authenticated USING (user_id = current_user);

-- Get contract bids
-- operation id: get_characters_character_id_contracts_contract_id_bids
CREATE TABLE chr_contract_bid
(
  character_id integer NOT NULL,
  contract_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  amount float NOT NULL,
  bid_id integer NOT NULL,
  bidder_id integer NOT NULL,
  date_bid timestamp NOT NULL
);
ALTER TABLE chr_contract_bid OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_contract_bid TO authenticated;
GRANT INSERT ON TABLE chr_contract_bid TO authenticated;
GRANT DELETE ON TABLE chr_contract_bid TO authenticated;
ALTER TABLE chr_contract_bid ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_contract_bid ON chr_contract_bid TO authenticated USING (user_id = current_user);

-- Get contract items
-- operation id: get_characters_character_id_contracts_contract_id_items
CREATE TABLE chr_contract_item
(
  character_id integer NOT NULL,
  contract_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  is_included boolean NOT NULL,
  is_singleton boolean NOT NULL,
  quantity integer NOT NULL,
  raw_quantity integer,
  record_id bigint NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE chr_contract_item OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_contract_item TO authenticated;
GRANT INSERT ON TABLE chr_contract_item TO authenticated;
GRANT DELETE ON TABLE chr_contract_item TO authenticated;
ALTER TABLE chr_contract_item ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_contract_item ON chr_contract_item TO authenticated USING (user_id = current_user);

-- Get corporation history
-- operation id: get_characters_character_id_corporationhistory
CREATE TABLE chr_corporationhistory
(
  character_id integer NOT NULL,
  corporation_id integer NOT NULL,
  is_deleted boolean,
  record_id integer NOT NULL,
  start_date timestamp NOT NULL
);
ALTER TABLE chr_corporationhistory OWNER TO esi_v1_11;

-- Get jump fatigue
-- operation id: get_characters_character_id_fatigue
CREATE TABLE chr_fatigue
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  jump_fatigue_expire_date timestamp,
  last_jump_date timestamp,
  last_update_date timestamp
);
ALTER TABLE chr_fatigue OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_fatigue TO authenticated;
GRANT INSERT ON TABLE chr_fatigue TO authenticated;
GRANT DELETE ON TABLE chr_fatigue TO authenticated;
ALTER TABLE chr_fatigue ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_fatigue ON chr_fatigue TO authenticated USING (user_id = current_user);

-- Get fittings
-- operation id: get_characters_character_id_fittings
CREATE TABLE chr_fitting
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  description varchar(4000) NOT NULL,
  fitting_id integer NOT NULL,
  items json NOT NULL,
  name varchar(4000) NOT NULL,
  ship_type_id integer NOT NULL
);
ALTER TABLE chr_fitting OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_fitting TO authenticated;
GRANT INSERT ON TABLE chr_fitting TO authenticated;
GRANT DELETE ON TABLE chr_fitting TO authenticated;
ALTER TABLE chr_fitting ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_fitting ON chr_fitting TO authenticated USING (user_id = current_user);

-- Get character fleet info
-- operation id: get_characters_character_id_fleet
CREATE TABLE chr_fleet
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  fleet_id bigint NOT NULL,
  role varchar(4000) NOT NULL,
  squad_id bigint NOT NULL,
  wing_id bigint NOT NULL
);
ALTER TABLE chr_fleet OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_fleet TO authenticated;
GRANT INSERT ON TABLE chr_fleet TO authenticated;
GRANT DELETE ON TABLE chr_fleet TO authenticated;
ALTER TABLE chr_fleet ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_fleet ON chr_fleet TO authenticated USING (user_id = current_user);

-- Overview of a character involved in faction warfare
-- operation id: get_characters_character_id_fw_stats
CREATE TABLE chr_fw_stat
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  current_rank integer,
  enlisted_on timestamp,
  faction_id integer,
  highest_rank integer,
  kills json NOT NULL,
  victory_points json NOT NULL
);
ALTER TABLE chr_fw_stat OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_fw_stat TO authenticated;
GRANT INSERT ON TABLE chr_fw_stat TO authenticated;
GRANT DELETE ON TABLE chr_fw_stat TO authenticated;
ALTER TABLE chr_fw_stat ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_fw_stat ON chr_fw_stat TO authenticated USING (user_id = current_user);

-- Get active implants
-- operation id: get_characters_character_id_implants
CREATE TABLE chr_implant
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  implant_id integer
);
ALTER TABLE chr_implant OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_implant TO authenticated;
GRANT INSERT ON TABLE chr_implant TO authenticated;
GRANT DELETE ON TABLE chr_implant TO authenticated;
ALTER TABLE chr_implant ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_implant ON chr_implant TO authenticated USING (user_id = current_user);

-- List character industry jobs
-- operation id: get_characters_character_id_industry_jobs
CREATE TABLE chr_industry_job
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  activity_id integer NOT NULL,
  blueprint_id bigint NOT NULL,
  blueprint_location_id bigint NOT NULL,
  blueprint_type_id integer NOT NULL,
  completed_character_id integer,
  completed_date timestamp,
  cost double precision,
  duration integer NOT NULL,
  end_date timestamp NOT NULL,
  facility_id bigint NOT NULL,
  installer_id integer NOT NULL,
  job_id integer NOT NULL,
  licensed_runs integer,
  output_location_id bigint NOT NULL,
  pause_date timestamp,
  probability float,
  product_type_id integer,
  runs integer NOT NULL,
  start_date timestamp NOT NULL,
  station_id bigint NOT NULL,
  status varchar(4000) NOT NULL,
  successful_runs integer
);
ALTER TABLE chr_industry_job OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_industry_job TO authenticated;
GRANT INSERT ON TABLE chr_industry_job TO authenticated;
GRANT DELETE ON TABLE chr_industry_job TO authenticated;
ALTER TABLE chr_industry_job ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_industry_job ON chr_industry_job TO authenticated USING (user_id = current_user);

-- Get a character's recent kills and losses
-- operation id: get_characters_character_id_killmails_recent
CREATE TABLE chr_killmail_recent
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  killmail_hash varchar(4000) NOT NULL,
  killmail_id integer NOT NULL
);
ALTER TABLE chr_killmail_recent OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_killmail_recent TO authenticated;
GRANT INSERT ON TABLE chr_killmail_recent TO authenticated;
GRANT DELETE ON TABLE chr_killmail_recent TO authenticated;
ALTER TABLE chr_killmail_recent ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_killmail_recent ON chr_killmail_recent TO authenticated USING (user_id = current_user);

-- Get character location
-- operation id: get_characters_character_id_location
CREATE TABLE chr_location
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  solar_system_id integer NOT NULL,
  station_id integer,
  structure_id bigint
);
ALTER TABLE chr_location OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_location TO authenticated;
GRANT INSERT ON TABLE chr_location TO authenticated;
GRANT DELETE ON TABLE chr_location TO authenticated;
ALTER TABLE chr_location ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_location ON chr_location TO authenticated USING (user_id = current_user);

-- Get loyalty points
-- operation id: get_characters_character_id_loyalty_points
CREATE TABLE chr_loyalty_point
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  corporation_id integer NOT NULL,
  loyalty_points integer NOT NULL
);
ALTER TABLE chr_loyalty_point OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_loyalty_point TO authenticated;
GRANT INSERT ON TABLE chr_loyalty_point TO authenticated;
GRANT DELETE ON TABLE chr_loyalty_point TO authenticated;
ALTER TABLE chr_loyalty_point ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_loyalty_point ON chr_loyalty_point TO authenticated USING (user_id = current_user);

-- Return mail headers
-- operation id: get_characters_character_id_mail
CREATE TABLE chr_mail
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  "from" integer,
  is_read boolean,
  labels json,
  mail_id integer,
  recipients json,
  subject varchar(4000),
  timestamp timestamp
);
ALTER TABLE chr_mail OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_mail TO authenticated;
GRANT INSERT ON TABLE chr_mail TO authenticated;
GRANT DELETE ON TABLE chr_mail TO authenticated;
ALTER TABLE chr_mail ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_mail ON chr_mail TO authenticated USING (user_id = current_user);

-- Get mail labels and unread counts
-- operation id: get_characters_character_id_mail_labels
CREATE TABLE chr_mail_label
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  labels json,
  total_unread_count integer
);
ALTER TABLE chr_mail_label OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_mail_label TO authenticated;
GRANT INSERT ON TABLE chr_mail_label TO authenticated;
GRANT DELETE ON TABLE chr_mail_label TO authenticated;
ALTER TABLE chr_mail_label ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_mail_label ON chr_mail_label TO authenticated USING (user_id = current_user);

-- Return mailing list subscriptions
-- operation id: get_characters_character_id_mail_lists
CREATE TABLE chr_mail_list
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  mailing_list_id integer NOT NULL,
  name varchar(4000) NOT NULL
);
ALTER TABLE chr_mail_list OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_mail_list TO authenticated;
GRANT INSERT ON TABLE chr_mail_list TO authenticated;
GRANT DELETE ON TABLE chr_mail_list TO authenticated;
ALTER TABLE chr_mail_list ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_mail_list ON chr_mail_list TO authenticated USING (user_id = current_user);

-- Return a mail
-- operation id: get_characters_character_id_mail_mail_id
CREATE TABLE chr_mail_dtl
(
  character_id integer NOT NULL,
  mail_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  body varchar(4000),
  "from" integer,
  labels json,
  read boolean,
  recipients json,
  subject varchar(4000),
  timestamp timestamp
);
ALTER TABLE chr_mail_dtl OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_mail_dtl TO authenticated;
GRANT INSERT ON TABLE chr_mail_dtl TO authenticated;
GRANT DELETE ON TABLE chr_mail_dtl TO authenticated;
ALTER TABLE chr_mail_dtl ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_mail_dtl ON chr_mail_dtl TO authenticated USING (user_id = current_user);

-- Get medals
-- operation id: get_characters_character_id_medals
CREATE TABLE chr_medal
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  corporation_id integer NOT NULL,
  date timestamp NOT NULL,
  description varchar(4000) NOT NULL,
  graphics json NOT NULL,
  issuer_id integer NOT NULL,
  medal_id integer NOT NULL,
  reason varchar(4000) NOT NULL,
  status varchar(4000) NOT NULL,
  title varchar(4000) NOT NULL
);
ALTER TABLE chr_medal OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_medal TO authenticated;
GRANT INSERT ON TABLE chr_medal TO authenticated;
GRANT DELETE ON TABLE chr_medal TO authenticated;
ALTER TABLE chr_medal ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_medal ON chr_medal TO authenticated USING (user_id = current_user);

-- Character mining ledger
-- operation id: get_characters_character_id_mining
CREATE TABLE chr_mining
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  date date NOT NULL,
  quantity bigint NOT NULL,
  solar_system_id integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE chr_mining OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_mining TO authenticated;
GRANT INSERT ON TABLE chr_mining TO authenticated;
GRANT DELETE ON TABLE chr_mining TO authenticated;
ALTER TABLE chr_mining ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_mining ON chr_mining TO authenticated USING (user_id = current_user);

-- Get character notifications
-- operation id: get_characters_character_id_notifications
CREATE TABLE chr_notification
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  is_read boolean,
  notification_id bigint NOT NULL,
  sender_id integer NOT NULL,
  sender_type varchar(4000) NOT NULL,
  text varchar(4000),
  timestamp timestamp NOT NULL,
  type varchar(4000) NOT NULL
);
ALTER TABLE chr_notification OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_notification TO authenticated;
GRANT INSERT ON TABLE chr_notification TO authenticated;
GRANT DELETE ON TABLE chr_notification TO authenticated;
ALTER TABLE chr_notification ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_notification ON chr_notification TO authenticated USING (user_id = current_user);

-- Get new contact notifications
-- operation id: get_characters_character_id_notifications_contacts
CREATE TABLE chr_notification_contact
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  message varchar(4000) NOT NULL,
  notification_id integer NOT NULL,
  send_date timestamp NOT NULL,
  sender_character_id integer NOT NULL,
  standing_level float NOT NULL
);
ALTER TABLE chr_notification_contact OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_notification_contact TO authenticated;
GRANT INSERT ON TABLE chr_notification_contact TO authenticated;
GRANT DELETE ON TABLE chr_notification_contact TO authenticated;
ALTER TABLE chr_notification_contact ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_notification_contact ON chr_notification_contact TO authenticated USING (user_id = current_user);

-- Get character online
-- operation id: get_characters_character_id_online
CREATE TABLE chr_online
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  last_login timestamp,
  last_logout timestamp,
  logins integer,
  online boolean NOT NULL
);
ALTER TABLE chr_online OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_online TO authenticated;
GRANT INSERT ON TABLE chr_online TO authenticated;
GRANT DELETE ON TABLE chr_online TO authenticated;
ALTER TABLE chr_online ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_online ON chr_online TO authenticated USING (user_id = current_user);

-- Get a character's completed tasks
-- operation id: get_characters_character_id_opportunities
CREATE TABLE chr_opportunity
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  completed_at timestamp NOT NULL,
  task_id integer NOT NULL
);
ALTER TABLE chr_opportunity OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_opportunity TO authenticated;
GRANT INSERT ON TABLE chr_opportunity TO authenticated;
GRANT DELETE ON TABLE chr_opportunity TO authenticated;
ALTER TABLE chr_opportunity ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_opportunity ON chr_opportunity TO authenticated USING (user_id = current_user);

-- List open orders from a character
-- operation id: get_characters_character_id_orders
CREATE TABLE chr_order
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  duration integer NOT NULL,
  escrow double precision,
  is_buy_order boolean,
  is_corporation boolean NOT NULL,
  issued timestamp NOT NULL,
  location_id bigint NOT NULL,
  min_volume integer,
  order_id bigint NOT NULL,
  price double precision NOT NULL,
  range varchar(4000) NOT NULL,
  region_id integer NOT NULL,
  type_id integer NOT NULL,
  volume_remain integer NOT NULL,
  volume_total integer NOT NULL
);
ALTER TABLE chr_order OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_order TO authenticated;
GRANT INSERT ON TABLE chr_order TO authenticated;
GRANT DELETE ON TABLE chr_order TO authenticated;
ALTER TABLE chr_order ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_order ON chr_order TO authenticated USING (user_id = current_user);

-- List historical orders by a character
-- operation id: get_characters_character_id_orders_history
CREATE TABLE chr_order_history
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  duration integer NOT NULL,
  escrow double precision,
  is_buy_order boolean,
  is_corporation boolean NOT NULL,
  issued timestamp NOT NULL,
  location_id bigint NOT NULL,
  min_volume integer,
  order_id bigint NOT NULL,
  price double precision NOT NULL,
  range varchar(4000) NOT NULL,
  region_id integer NOT NULL,
  state varchar(4000) NOT NULL,
  type_id integer NOT NULL,
  volume_remain integer NOT NULL,
  volume_total integer NOT NULL
);
ALTER TABLE chr_order_history OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_order_history TO authenticated;
GRANT INSERT ON TABLE chr_order_history TO authenticated;
GRANT DELETE ON TABLE chr_order_history TO authenticated;
ALTER TABLE chr_order_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_order_history ON chr_order_history TO authenticated USING (user_id = current_user);

-- Get colonies
-- operation id: get_characters_character_id_planets
CREATE TABLE chr_planet
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  last_update timestamp NOT NULL,
  num_pins integer NOT NULL,
  owner_id integer NOT NULL,
  planet_id integer NOT NULL,
  planet_type varchar(4000) NOT NULL,
  solar_system_id integer NOT NULL,
  upgrade_level integer NOT NULL
);
ALTER TABLE chr_planet OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_planet TO authenticated;
GRANT INSERT ON TABLE chr_planet TO authenticated;
GRANT DELETE ON TABLE chr_planet TO authenticated;
ALTER TABLE chr_planet ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_planet ON chr_planet TO authenticated USING (user_id = current_user);

-- Get colony layout
-- operation id: get_characters_character_id_planets_planet_id
CREATE TABLE chr_planet_dtl
(
  character_id integer NOT NULL,
  planet_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  links json NOT NULL,
  pins json NOT NULL,
  routes json NOT NULL
);
ALTER TABLE chr_planet_dtl OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_planet_dtl TO authenticated;
GRANT INSERT ON TABLE chr_planet_dtl TO authenticated;
GRANT DELETE ON TABLE chr_planet_dtl TO authenticated;
ALTER TABLE chr_planet_dtl ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_planet_dtl ON chr_planet_dtl TO authenticated USING (user_id = current_user);

-- Get character portraits
-- operation id: get_characters_character_id_portrait
CREATE TABLE chr_portrait
(
  character_id integer PRIMARY KEY,
  px128x128 varchar(4000),
  px256x256 varchar(4000),
  px512x512 varchar(4000),
  px64x64 varchar(4000)
);
ALTER TABLE chr_portrait OWNER TO esi_v1_11;

-- Get character corporation roles
-- operation id: get_characters_character_id_roles
CREATE TABLE chr_role
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  roles json,
  roles_at_base json,
  roles_at_hq json,
  roles_at_other json
);
ALTER TABLE chr_role OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_role TO authenticated;
GRANT INSERT ON TABLE chr_role TO authenticated;
GRANT DELETE ON TABLE chr_role TO authenticated;
ALTER TABLE chr_role ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_role ON chr_role TO authenticated USING (user_id = current_user);

-- Search on a string
-- operation id: get_characters_character_id_search
CREATE TABLE chr_search
(
  categories varchar(4000) NOT NULL,
  character_id integer PRIMARY KEY,
  search varchar(4000) NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  agent json,
  alliance json,
  character json,
  constellation json,
  corporation json,
  faction json,
  inventory_type json,
  region json,
  solar_system json,
  station json,
  structure json
);
ALTER TABLE chr_search OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_search TO authenticated;
GRANT INSERT ON TABLE chr_search TO authenticated;
GRANT DELETE ON TABLE chr_search TO authenticated;
ALTER TABLE chr_search ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_search ON chr_search TO authenticated USING (user_id = current_user);

-- Get current ship
-- operation id: get_characters_character_id_ship
CREATE TABLE chr_ship
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  ship_item_id bigint NOT NULL,
  ship_name varchar(4000) NOT NULL,
  ship_type_id integer NOT NULL
);
ALTER TABLE chr_ship OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_ship TO authenticated;
GRANT INSERT ON TABLE chr_ship TO authenticated;
GRANT DELETE ON TABLE chr_ship TO authenticated;
ALTER TABLE chr_ship ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_ship ON chr_ship TO authenticated USING (user_id = current_user);

-- Get character's skill queue
-- operation id: get_characters_character_id_skillqueue
CREATE TABLE chr_skillqueue
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  finish_date timestamp,
  finished_level integer NOT NULL,
  level_end_sp integer,
  level_start_sp integer,
  queue_position integer NOT NULL,
  skill_id integer NOT NULL,
  start_date timestamp,
  training_start_sp integer
);
ALTER TABLE chr_skillqueue OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_skillqueue TO authenticated;
GRANT INSERT ON TABLE chr_skillqueue TO authenticated;
GRANT DELETE ON TABLE chr_skillqueue TO authenticated;
ALTER TABLE chr_skillqueue ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_skillqueue ON chr_skillqueue TO authenticated USING (user_id = current_user);

-- Get character skills
-- operation id: get_characters_character_id_skills
CREATE TABLE chr_skill
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  skills json NOT NULL,
  total_sp bigint NOT NULL,
  unallocated_sp integer
);
ALTER TABLE chr_skill OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_skill TO authenticated;
GRANT INSERT ON TABLE chr_skill TO authenticated;
GRANT DELETE ON TABLE chr_skill TO authenticated;
ALTER TABLE chr_skill ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_skill ON chr_skill TO authenticated USING (user_id = current_user);

-- Get standings
-- operation id: get_characters_character_id_standings
CREATE TABLE chr_standing
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  from_id integer NOT NULL,
  from_type varchar(4000) NOT NULL,
  standing float NOT NULL
);
ALTER TABLE chr_standing OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_standing TO authenticated;
GRANT INSERT ON TABLE chr_standing TO authenticated;
GRANT DELETE ON TABLE chr_standing TO authenticated;
ALTER TABLE chr_standing ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_standing ON chr_standing TO authenticated USING (user_id = current_user);

-- Get character corporation titles
-- operation id: get_characters_character_id_titles
CREATE TABLE chr_title
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  name varchar(4000),
  title_id integer
);
ALTER TABLE chr_title OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_title TO authenticated;
GRANT INSERT ON TABLE chr_title TO authenticated;
GRANT DELETE ON TABLE chr_title TO authenticated;
ALTER TABLE chr_title ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_title ON chr_title TO authenticated USING (user_id = current_user);

-- Get a character's wallet balance
-- operation id: get_characters_character_id_wallet
CREATE TABLE chr_wallet
(
  character_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  wallet_id double precision
);
ALTER TABLE chr_wallet OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_wallet TO authenticated;
GRANT INSERT ON TABLE chr_wallet TO authenticated;
GRANT DELETE ON TABLE chr_wallet TO authenticated;
ALTER TABLE chr_wallet ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_wallet ON chr_wallet TO authenticated USING (user_id = current_user);

-- Get character wallet journal
-- operation id: get_characters_character_id_wallet_journal
CREATE TABLE chr_wallet_journal
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  amount double precision,
  balance double precision,
  context_id bigint,
  context_id_type varchar(4000),
  date timestamp NOT NULL,
  description varchar(4000) NOT NULL,
  first_party_id integer,
  id bigint NOT NULL,
  reason varchar(4000),
  ref_type varchar(4000) NOT NULL,
  second_party_id integer,
  tax double precision,
  tax_receiver_id integer
);
ALTER TABLE chr_wallet_journal OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_wallet_journal TO authenticated;
GRANT INSERT ON TABLE chr_wallet_journal TO authenticated;
GRANT DELETE ON TABLE chr_wallet_journal TO authenticated;
ALTER TABLE chr_wallet_journal ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_wallet_journal ON chr_wallet_journal TO authenticated USING (user_id = current_user);

-- Get wallet transactions
-- operation id: get_characters_character_id_wallet_transactions
CREATE TABLE chr_wallet_transaction
(
  character_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  client_id integer NOT NULL,
  date timestamp NOT NULL,
  is_buy boolean NOT NULL,
  is_personal boolean NOT NULL,
  journal_ref_id bigint NOT NULL,
  location_id bigint NOT NULL,
  quantity integer NOT NULL,
  transaction_id bigint NOT NULL,
  type_id integer NOT NULL,
  unit_price double precision NOT NULL
);
ALTER TABLE chr_wallet_transaction OWNER TO esi_v1_11;
GRANT SELECT ON TABLE chr_wallet_transaction TO authenticated;
GRANT INSERT ON TABLE chr_wallet_transaction TO authenticated;
GRANT DELETE ON TABLE chr_wallet_transaction TO authenticated;
ALTER TABLE chr_wallet_transaction ENABLE ROW LEVEL SECURITY;
CREATE POLICY chr_wallet_transaction ON chr_wallet_transaction TO authenticated USING (user_id = current_user);

-- Get public contract bids
-- operation id: get_contracts_public_bids_contract_id
CREATE TABLE con_public_bid_contract
(
  contract_id integer NOT NULL,
  amount float NOT NULL,
  bid_id integer NOT NULL,
  date_bid timestamp NOT NULL
);
ALTER TABLE con_public_bid_contract OWNER TO esi_v1_11;

-- Get public contract items
-- operation id: get_contracts_public_items_contract_id
CREATE TABLE con_public_item_contract
(
  contract_id integer NOT NULL,
  is_blueprint_copy boolean,
  is_included boolean NOT NULL,
  item_id bigint,
  material_efficiency integer,
  quantity integer NOT NULL,
  record_id bigint NOT NULL,
  runs integer,
  time_efficiency integer,
  type_id integer NOT NULL
);
ALTER TABLE con_public_item_contract OWNER TO esi_v1_11;

-- Get public contracts
-- operation id: get_contracts_public_region_id
CREATE TABLE con_public_region
(
  region_id integer NOT NULL,
  buyout double precision,
  collateral double precision,
  contract_id integer NOT NULL,
  date_expired timestamp NOT NULL,
  date_issued timestamp NOT NULL,
  days_to_complete integer,
  end_location_id bigint,
  for_corporation boolean,
  issuer_corporation_id integer NOT NULL,
  issuer_id integer NOT NULL,
  price double precision,
  reward double precision,
  start_location_id bigint,
  title varchar(4000),
  type varchar(4000) NOT NULL,
  volume double precision
);
ALTER TABLE con_public_region OWNER TO esi_v1_11;

-- Moon extraction timers
-- operation id: get_corporation_corporation_id_mining_extractions
CREATE TABLE crp_mining_extraction
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  chunk_arrival_time timestamp NOT NULL,
  extraction_start_time timestamp NOT NULL,
  moon_id integer NOT NULL,
  natural_decay_time timestamp NOT NULL,
  structure_id bigint NOT NULL
);
ALTER TABLE crp_mining_extraction OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_mining_extraction TO Station_Manager;
GRANT INSERT ON TABLE crp_mining_extraction TO Station_Manager;
GRANT DELETE ON TABLE crp_mining_extraction TO Station_Manager;
ALTER TABLE crp_mining_extraction ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_mining_extraction ON crp_mining_extraction TO authenticated USING (user_id = current_user);

-- Corporation mining observers
-- operation id: get_corporation_corporation_id_mining_observers
CREATE TABLE crp_mining_observer
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  last_updated date NOT NULL,
  observer_id bigint NOT NULL,
  observer_type varchar(4000) NOT NULL
);
ALTER TABLE crp_mining_observer OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_mining_observer TO Accountant;
GRANT INSERT ON TABLE crp_mining_observer TO Accountant;
GRANT DELETE ON TABLE crp_mining_observer TO Accountant;
ALTER TABLE crp_mining_observer ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_mining_observer ON crp_mining_observer TO authenticated USING (user_id = current_user);

-- Observed corporation mining
-- operation id: get_corporation_corporation_id_mining_observers_observer_id
CREATE TABLE crp_mining_observer_dtl
(
  corporation_id integer NOT NULL,
  observer_id bigint NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  character_id integer NOT NULL,
  last_updated date NOT NULL,
  quantity bigint NOT NULL,
  recorded_corporation_id integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE crp_mining_observer_dtl OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_mining_observer_dtl TO Accountant;
GRANT INSERT ON TABLE crp_mining_observer_dtl TO Accountant;
GRANT DELETE ON TABLE crp_mining_observer_dtl TO Accountant;
ALTER TABLE crp_mining_observer_dtl ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_mining_observer_dtl ON crp_mining_observer_dtl TO authenticated USING (user_id = current_user);

-- Get npc corporations
-- operation id: get_corporations_npccorps
CREATE TABLE crp_npccorp
(
  npccorp_id integer
);
ALTER TABLE crp_npccorp OWNER TO esi_v1_11;

-- Get corporation information
-- operation id: get_corporations_corporation_id
CREATE TABLE corporation
(
  corporation_id integer PRIMARY KEY,
  alliance_id integer,
  ceo_id integer NOT NULL,
  creator_id integer NOT NULL,
  date_founded timestamp,
  description varchar(4000),
  faction_id integer,
  home_station_id integer,
  member_count integer NOT NULL,
  name varchar(4000) NOT NULL,
  shares bigint,
  tax_rate float NOT NULL,
  ticker varchar(4000) NOT NULL,
  url varchar(4000),
  war_eligible boolean
);
ALTER TABLE corporation OWNER TO esi_v1_11;

-- Get alliance history
-- operation id: get_corporations_corporation_id_alliancehistory
CREATE TABLE crp_alliancehistory
(
  corporation_id integer NOT NULL,
  alliance_id integer,
  is_deleted boolean,
  record_id integer NOT NULL,
  start_date timestamp NOT NULL
);
ALTER TABLE crp_alliancehistory OWNER TO esi_v1_11;

-- Get corporation assets
-- operation id: get_corporations_corporation_id_assets
CREATE TABLE crp_asset
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  is_blueprint_copy boolean,
  is_singleton boolean NOT NULL,
  item_id bigint NOT NULL,
  location_flag varchar(4000) NOT NULL,
  location_id bigint NOT NULL,
  location_type varchar(4000) NOT NULL,
  quantity integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE crp_asset OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_asset TO Director;
GRANT INSERT ON TABLE crp_asset TO Director;
GRANT DELETE ON TABLE crp_asset TO Director;
ALTER TABLE crp_asset ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_asset ON crp_asset TO authenticated USING (user_id = current_user);

-- Get corporation blueprints
-- operation id: get_corporations_corporation_id_blueprints
CREATE TABLE crp_blueprint
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  item_id bigint NOT NULL,
  location_flag varchar(4000) NOT NULL,
  location_id bigint NOT NULL,
  material_efficiency integer NOT NULL,
  quantity integer NOT NULL,
  runs integer NOT NULL,
  time_efficiency integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE crp_blueprint OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_blueprint TO Director;
GRANT INSERT ON TABLE crp_blueprint TO Director;
GRANT DELETE ON TABLE crp_blueprint TO Director;
ALTER TABLE crp_blueprint ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_blueprint ON crp_blueprint TO authenticated USING (user_id = current_user);

-- List corporation bookmarks
-- operation id: get_corporations_corporation_id_bookmarks
CREATE TABLE crp_bookmark
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  bookmark_id integer NOT NULL,
  coordinates json NOT NULL,
  created timestamp NOT NULL,
  creator_id integer NOT NULL,
  folder_id integer,
  item json NOT NULL,
  label varchar(4000) NOT NULL,
  location_id integer NOT NULL,
  notes varchar(4000) NOT NULL
);
ALTER TABLE crp_bookmark OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_bookmark TO authenticated;
GRANT INSERT ON TABLE crp_bookmark TO authenticated;
GRANT DELETE ON TABLE crp_bookmark TO authenticated;
ALTER TABLE crp_bookmark ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_bookmark ON crp_bookmark TO authenticated USING (user_id = current_user);

-- List corporation bookmark folders
-- operation id: get_corporations_corporation_id_bookmarks_folders
CREATE TABLE crp_bookmark_folder
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  creator_id integer,
  folder_id integer NOT NULL,
  name varchar(4000) NOT NULL
);
ALTER TABLE crp_bookmark_folder OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_bookmark_folder TO authenticated;
GRANT INSERT ON TABLE crp_bookmark_folder TO authenticated;
GRANT DELETE ON TABLE crp_bookmark_folder TO authenticated;
ALTER TABLE crp_bookmark_folder ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_bookmark_folder ON crp_bookmark_folder TO authenticated USING (user_id = current_user);

-- Get corporation contacts
-- operation id: get_corporations_corporation_id_contacts
CREATE TABLE crp_contact
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  contact_id integer NOT NULL,
  contact_type varchar(4000) NOT NULL,
  is_watched boolean,
  label_ids json,
  standing float NOT NULL
);
ALTER TABLE crp_contact OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_contact TO CEO;
GRANT INSERT ON TABLE crp_contact TO CEO;
GRANT DELETE ON TABLE crp_contact TO CEO;
ALTER TABLE crp_contact ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_contact ON crp_contact TO authenticated USING (user_id = current_user);

-- Get corporation contact labels
-- operation id: get_corporations_corporation_id_contacts_labels
CREATE TABLE crp_contact_label
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  label_id bigint NOT NULL,
  label_name varchar(4000) NOT NULL
);
ALTER TABLE crp_contact_label OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_contact_label TO CEO;
GRANT INSERT ON TABLE crp_contact_label TO CEO;
GRANT DELETE ON TABLE crp_contact_label TO CEO;
ALTER TABLE crp_contact_label ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_contact_label ON crp_contact_label TO authenticated USING (user_id = current_user);

-- Get all corporation ALSC logs
-- operation id: get_corporations_corporation_id_containers_logs
CREATE TABLE crp_container_log
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  action varchar(4000) NOT NULL,
  character_id integer NOT NULL,
  container_id bigint NOT NULL,
  container_type_id integer NOT NULL,
  location_flag varchar(4000) NOT NULL,
  location_id bigint NOT NULL,
  logged_at timestamp NOT NULL,
  new_config_bitmask integer,
  old_config_bitmask integer,
  password_type varchar(4000),
  quantity integer,
  type_id integer
);
ALTER TABLE crp_container_log OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_container_log TO Director;
GRANT INSERT ON TABLE crp_container_log TO Director;
GRANT DELETE ON TABLE crp_container_log TO Director;
ALTER TABLE crp_container_log ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_container_log ON crp_container_log TO authenticated USING (user_id = current_user);

-- Get corporation contracts
-- operation id: get_corporations_corporation_id_contracts
CREATE TABLE crp_contract
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  acceptor_id integer NOT NULL,
  assignee_id integer NOT NULL,
  availability varchar(4000) NOT NULL,
  buyout double precision,
  collateral double precision,
  contract_id integer NOT NULL,
  date_accepted timestamp,
  date_completed timestamp,
  date_expired timestamp NOT NULL,
  date_issued timestamp NOT NULL,
  days_to_complete integer,
  end_location_id bigint,
  for_corporation boolean NOT NULL,
  issuer_corporation_id integer NOT NULL,
  issuer_id integer NOT NULL,
  price double precision,
  reward double precision,
  start_location_id bigint,
  status varchar(4000) NOT NULL,
  title varchar(4000),
  type varchar(4000) NOT NULL,
  volume double precision
);
ALTER TABLE crp_contract OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_contract TO CEO;
GRANT INSERT ON TABLE crp_contract TO CEO;
GRANT DELETE ON TABLE crp_contract TO CEO;
ALTER TABLE crp_contract ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_contract ON crp_contract TO authenticated USING (user_id = current_user);

-- Get corporation contract bids
-- operation id: get_corporations_corporation_id_contracts_contract_id_bids
CREATE TABLE crp_contract_bid
(
  contract_id integer NOT NULL,
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  amount float NOT NULL,
  bid_id integer NOT NULL,
  bidder_id integer NOT NULL,
  date_bid timestamp NOT NULL
);
ALTER TABLE crp_contract_bid OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_contract_bid TO CEO;
GRANT INSERT ON TABLE crp_contract_bid TO CEO;
GRANT DELETE ON TABLE crp_contract_bid TO CEO;
ALTER TABLE crp_contract_bid ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_contract_bid ON crp_contract_bid TO authenticated USING (user_id = current_user);

-- Get corporation contract items
-- operation id: get_corporations_corporation_id_contracts_contract_id_items
CREATE TABLE crp_contract_item
(
  contract_id integer NOT NULL,
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  is_included boolean NOT NULL,
  is_singleton boolean NOT NULL,
  quantity integer NOT NULL,
  raw_quantity integer,
  record_id bigint NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE crp_contract_item OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_contract_item TO CEO;
GRANT INSERT ON TABLE crp_contract_item TO CEO;
GRANT DELETE ON TABLE crp_contract_item TO CEO;
ALTER TABLE crp_contract_item ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_contract_item ON crp_contract_item TO authenticated USING (user_id = current_user);

-- List corporation customs offices
-- operation id: get_corporations_corporation_id_customs_offices
CREATE TABLE crp_customs_office
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  alliance_tax_rate float,
  allow_access_with_standings boolean NOT NULL,
  allow_alliance_access boolean NOT NULL,
  bad_standing_tax_rate float,
  corporation_tax_rate float,
  excellent_standing_tax_rate float,
  good_standing_tax_rate float,
  neutral_standing_tax_rate float,
  office_id bigint NOT NULL,
  reinforce_exit_end integer NOT NULL,
  reinforce_exit_start integer NOT NULL,
  standing_level varchar(4000),
  system_id integer NOT NULL,
  terrible_standing_tax_rate float
);
ALTER TABLE crp_customs_office OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_customs_office TO Director;
GRANT INSERT ON TABLE crp_customs_office TO Director;
GRANT DELETE ON TABLE crp_customs_office TO Director;
ALTER TABLE crp_customs_office ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_customs_office ON crp_customs_office TO authenticated USING (user_id = current_user);

-- Get corporation divisions
-- operation id: get_corporations_corporation_id_divisions
CREATE TABLE crp_div
(
  corporation_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  hangar json,
  wallet json
);
ALTER TABLE crp_div OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_div TO Director;
GRANT INSERT ON TABLE crp_div TO Director;
GRANT DELETE ON TABLE crp_div TO Director;
ALTER TABLE crp_div ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_div ON crp_div TO authenticated USING (user_id = current_user);

-- Get corporation facilities
-- operation id: get_corporations_corporation_id_facilities
CREATE TABLE crp_facility
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  facility_id bigint NOT NULL,
  system_id integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE crp_facility OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_facility TO Factory_Manager;
GRANT INSERT ON TABLE crp_facility TO Factory_Manager;
GRANT DELETE ON TABLE crp_facility TO Factory_Manager;
ALTER TABLE crp_facility ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_facility ON crp_facility TO authenticated USING (user_id = current_user);

-- Overview of a corporation involved in faction warfare
-- operation id: get_corporations_corporation_id_fw_stats
CREATE TABLE crp_fw_stat
(
  corporation_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  enlisted_on timestamp,
  faction_id integer,
  kills json NOT NULL,
  pilots integer,
  victory_points json NOT NULL
);
ALTER TABLE crp_fw_stat OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_fw_stat TO authenticated;
GRANT INSERT ON TABLE crp_fw_stat TO authenticated;
GRANT DELETE ON TABLE crp_fw_stat TO authenticated;
ALTER TABLE crp_fw_stat ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_fw_stat ON crp_fw_stat TO authenticated USING (user_id = current_user);

-- Get corporation icon
-- operation id: get_corporations_corporation_id_icons
CREATE TABLE crp_icon
(
  corporation_id integer PRIMARY KEY,
  px128x128 varchar(4000),
  px256x256 varchar(4000),
  px64x64 varchar(4000)
);
ALTER TABLE crp_icon OWNER TO esi_v1_11;

-- List corporation industry jobs
-- operation id: get_corporations_corporation_id_industry_jobs
CREATE TABLE crp_industry_job
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  activity_id integer NOT NULL,
  blueprint_id bigint NOT NULL,
  blueprint_location_id bigint NOT NULL,
  blueprint_type_id integer NOT NULL,
  completed_character_id integer,
  completed_date timestamp,
  cost double precision,
  duration integer NOT NULL,
  end_date timestamp NOT NULL,
  facility_id bigint NOT NULL,
  installer_id integer NOT NULL,
  job_id integer NOT NULL,
  licensed_runs integer,
  location_id bigint NOT NULL,
  output_location_id bigint NOT NULL,
  pause_date timestamp,
  probability float,
  product_type_id integer,
  runs integer NOT NULL,
  start_date timestamp NOT NULL,
  status varchar(4000) NOT NULL,
  successful_runs integer
);
ALTER TABLE crp_industry_job OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_industry_job TO Factory_Manager;
GRANT INSERT ON TABLE crp_industry_job TO Factory_Manager;
GRANT DELETE ON TABLE crp_industry_job TO Factory_Manager;
ALTER TABLE crp_industry_job ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_industry_job ON crp_industry_job TO authenticated USING (user_id = current_user);

-- Get a corporation's recent kills and losses
-- operation id: get_corporations_corporation_id_killmails_recent
CREATE TABLE crp_killmail_recent
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  killmail_hash varchar(4000) NOT NULL,
  killmail_id integer NOT NULL
);
ALTER TABLE crp_killmail_recent OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_killmail_recent TO Director;
GRANT INSERT ON TABLE crp_killmail_recent TO Director;
GRANT DELETE ON TABLE crp_killmail_recent TO Director;
ALTER TABLE crp_killmail_recent ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_killmail_recent ON crp_killmail_recent TO authenticated USING (user_id = current_user);

-- Get corporation medals
-- operation id: get_corporations_corporation_id_medals
CREATE TABLE crp_medal
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  created_at timestamp NOT NULL,
  creator_id integer NOT NULL,
  description varchar(4000) NOT NULL,
  medal_id integer NOT NULL,
  title varchar(4000) NOT NULL
);
ALTER TABLE crp_medal OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_medal TO CEO;
GRANT INSERT ON TABLE crp_medal TO CEO;
GRANT DELETE ON TABLE crp_medal TO CEO;
ALTER TABLE crp_medal ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_medal ON crp_medal TO authenticated USING (user_id = current_user);

-- Get corporation issued medals
-- operation id: get_corporations_corporation_id_medals_issued
CREATE TABLE crp_medal_issued
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  character_id integer NOT NULL,
  issued_at timestamp NOT NULL,
  issuer_id integer NOT NULL,
  medal_id integer NOT NULL,
  reason varchar(4000) NOT NULL,
  status varchar(4000) NOT NULL
);
ALTER TABLE crp_medal_issued OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_medal_issued TO Director;
GRANT INSERT ON TABLE crp_medal_issued TO Director;
GRANT DELETE ON TABLE crp_medal_issued TO Director;
ALTER TABLE crp_medal_issued ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_medal_issued ON crp_medal_issued TO authenticated USING (user_id = current_user);

-- Get corporation members
-- operation id: get_corporations_corporation_id_members
CREATE TABLE crp_member
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  member_id integer
);
ALTER TABLE crp_member OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_member TO authenticated;
GRANT INSERT ON TABLE crp_member TO authenticated;
GRANT DELETE ON TABLE crp_member TO authenticated;
ALTER TABLE crp_member ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_member ON crp_member TO authenticated USING (user_id = current_user);

-- Get corporation member limit
-- operation id: get_corporations_corporation_id_members_limit
CREATE TABLE crp_member_limit
(
  corporation_id integer PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  limit_id integer
);
ALTER TABLE crp_member_limit OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_member_limit TO Director;
GRANT INSERT ON TABLE crp_member_limit TO Director;
GRANT DELETE ON TABLE crp_member_limit TO Director;
ALTER TABLE crp_member_limit ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_member_limit ON crp_member_limit TO authenticated USING (user_id = current_user);

-- Get corporation's members' titles
-- operation id: get_corporations_corporation_id_members_titles
CREATE TABLE crp_member_title
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  character_id integer NOT NULL,
  titles json NOT NULL
);
ALTER TABLE crp_member_title OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_member_title TO Director;
GRANT INSERT ON TABLE crp_member_title TO Director;
GRANT DELETE ON TABLE crp_member_title TO Director;
ALTER TABLE crp_member_title ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_member_title ON crp_member_title TO authenticated USING (user_id = current_user);

-- Track corporation members
-- operation id: get_corporations_corporation_id_membertracking
CREATE TABLE crp_membertracking
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  base_id integer,
  character_id integer NOT NULL,
  location_id bigint,
  logoff_date timestamp,
  logon_date timestamp,
  ship_type_id integer,
  start_date timestamp
);
ALTER TABLE crp_membertracking OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_membertracking TO Director;
GRANT INSERT ON TABLE crp_membertracking TO Director;
GRANT DELETE ON TABLE crp_membertracking TO Director;
ALTER TABLE crp_membertracking ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_membertracking ON crp_membertracking TO authenticated USING (user_id = current_user);

-- List open orders from a corporation
-- operation id: get_corporations_corporation_id_orders
CREATE TABLE crp_order
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  duration integer NOT NULL,
  escrow double precision,
  is_buy_order boolean,
  issued timestamp NOT NULL,
  issued_by integer NOT NULL,
  location_id bigint NOT NULL,
  min_volume integer,
  order_id bigint NOT NULL,
  price double precision NOT NULL,
  range varchar(4000) NOT NULL,
  region_id integer NOT NULL,
  type_id integer NOT NULL,
  volume_remain integer NOT NULL,
  volume_total integer NOT NULL,
  wallet_division integer NOT NULL
);
ALTER TABLE crp_order OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_order TO Accountant,Trader;
GRANT INSERT ON TABLE crp_order TO Accountant,Trader;
GRANT DELETE ON TABLE crp_order TO Accountant,Trader;
ALTER TABLE crp_order ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_order ON crp_order TO authenticated USING (user_id = current_user);

-- List historical orders from a corporation
-- operation id: get_corporations_corporation_id_orders_history
CREATE TABLE crp_order_history
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  duration integer NOT NULL,
  escrow double precision,
  is_buy_order boolean,
  issued timestamp NOT NULL,
  issued_by integer,
  location_id bigint NOT NULL,
  min_volume integer,
  order_id bigint NOT NULL,
  price double precision NOT NULL,
  range varchar(4000) NOT NULL,
  region_id integer NOT NULL,
  state varchar(4000) NOT NULL,
  type_id integer NOT NULL,
  volume_remain integer NOT NULL,
  volume_total integer NOT NULL,
  wallet_division integer NOT NULL
);
ALTER TABLE crp_order_history OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_order_history TO Accountant,Trader;
GRANT INSERT ON TABLE crp_order_history TO Accountant,Trader;
GRANT DELETE ON TABLE crp_order_history TO Accountant,Trader;
ALTER TABLE crp_order_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_order_history ON crp_order_history TO authenticated USING (user_id = current_user);

-- Get corporation member roles
-- operation id: get_corporations_corporation_id_roles
CREATE TABLE crp_role
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  character_id integer NOT NULL,
  grantable_roles json,
  grantable_roles_at_base json,
  grantable_roles_at_hq json,
  grantable_roles_at_other json,
  roles json,
  roles_at_base json,
  roles_at_hq json,
  roles_at_other json
);
ALTER TABLE crp_role OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_role TO authenticated;
GRANT INSERT ON TABLE crp_role TO authenticated;
GRANT DELETE ON TABLE crp_role TO authenticated;
ALTER TABLE crp_role ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_role ON crp_role TO authenticated USING (user_id = current_user);

-- Get corporation member roles history
-- operation id: get_corporations_corporation_id_roles_history
CREATE TABLE crp_role_history
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  changed_at timestamp NOT NULL,
  character_id integer NOT NULL,
  issuer_id integer NOT NULL,
  new_roles json NOT NULL,
  old_roles json NOT NULL,
  role_type varchar(4000) NOT NULL
);
ALTER TABLE crp_role_history OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_role_history TO Director;
GRANT INSERT ON TABLE crp_role_history TO Director;
GRANT DELETE ON TABLE crp_role_history TO Director;
ALTER TABLE crp_role_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_role_history ON crp_role_history TO authenticated USING (user_id = current_user);

-- Get corporation shareholders
-- operation id: get_corporations_corporation_id_shareholders
CREATE TABLE crp_shareholder
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  share_count bigint NOT NULL,
  shareholder_id integer NOT NULL,
  shareholder_type varchar(4000) NOT NULL
);
ALTER TABLE crp_shareholder OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_shareholder TO Director;
GRANT INSERT ON TABLE crp_shareholder TO Director;
GRANT DELETE ON TABLE crp_shareholder TO Director;
ALTER TABLE crp_shareholder ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_shareholder ON crp_shareholder TO authenticated USING (user_id = current_user);

-- Get corporation standings
-- operation id: get_corporations_corporation_id_standings
CREATE TABLE crp_standing
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  from_id integer NOT NULL,
  from_type varchar(4000) NOT NULL,
  standing float NOT NULL
);
ALTER TABLE crp_standing OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_standing TO CEO;
GRANT INSERT ON TABLE crp_standing TO CEO;
GRANT DELETE ON TABLE crp_standing TO CEO;
ALTER TABLE crp_standing ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_standing ON crp_standing TO authenticated USING (user_id = current_user);

-- Get corporation starbases (POSes)
-- operation id: get_corporations_corporation_id_starbases
CREATE TABLE crp_starbase
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  moon_id integer,
  onlined_since timestamp,
  reinforced_until timestamp,
  starbase_id bigint NOT NULL,
  state varchar(4000),
  system_id integer NOT NULL,
  type_id integer NOT NULL,
  unanchor_at timestamp
);
ALTER TABLE crp_starbase OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_starbase TO Director;
GRANT INSERT ON TABLE crp_starbase TO Director;
GRANT DELETE ON TABLE crp_starbase TO Director;
ALTER TABLE crp_starbase ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_starbase ON crp_starbase TO authenticated USING (user_id = current_user);

-- Get starbase (POS) detail
-- operation id: get_corporations_corporation_id_starbases_starbase_id
CREATE TABLE crp_starbase_dtl
(
  corporation_id integer NOT NULL,
  starbase_id bigint NOT NULL,
  system_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  allow_alliance_members boolean NOT NULL,
  allow_corporation_members boolean NOT NULL,
  anchor varchar(4000) NOT NULL,
  attack_if_at_war boolean NOT NULL,
  attack_if_o757483785us_dropping boolean NOT NULL,
  attack_secu698664890s_threshold float,
  attack_standing_threshold float,
  fuel_bay_take varchar(4000) NOT NULL,
  fuel_bay_view varchar(4000) NOT NULL,
  fuels json,
  offline varchar(4000) NOT NULL,
  online varchar(4000) NOT NULL,
  unanchor varchar(4000) NOT NULL,
  use_alliance_standings boolean NOT NULL
);
ALTER TABLE crp_starbase_dtl OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_starbase_dtl TO Director;
GRANT INSERT ON TABLE crp_starbase_dtl TO Director;
GRANT DELETE ON TABLE crp_starbase_dtl TO Director;
ALTER TABLE crp_starbase_dtl ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_starbase_dtl ON crp_starbase_dtl TO authenticated USING (user_id = current_user);

-- Get corporation structures
-- operation id: get_corporations_corporation_id_structures
CREATE TABLE crp_structure
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  fuel_expires timestamp,
  name varchar(4000),
  next_reinforce_apply timestamp,
  next_reinforce_hour integer,
  profile_id integer NOT NULL,
  reinforce_hour integer,
  services json,
  state varchar(4000) NOT NULL,
  state_timer_end timestamp,
  state_timer_start timestamp,
  structure_id bigint NOT NULL,
  system_id integer NOT NULL,
  type_id integer NOT NULL,
  unanchors_at timestamp
);
ALTER TABLE crp_structure OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_structure TO Station_Manager;
GRANT INSERT ON TABLE crp_structure TO Station_Manager;
GRANT DELETE ON TABLE crp_structure TO Station_Manager;
ALTER TABLE crp_structure ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_structure ON crp_structure TO authenticated USING (user_id = current_user);

-- Get corporation titles
-- operation id: get_corporations_corporation_id_titles
CREATE TABLE crp_title
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  grantable_roles json,
  grantable_roles_at_base json,
  grantable_roles_at_hq json,
  grantable_roles_at_other json,
  name varchar(4000),
  roles json,
  roles_at_base json,
  roles_at_hq json,
  roles_at_other json,
  title_id integer
);
ALTER TABLE crp_title OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_title TO Director;
GRANT INSERT ON TABLE crp_title TO Director;
GRANT DELETE ON TABLE crp_title TO Director;
ALTER TABLE crp_title ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_title ON crp_title TO authenticated USING (user_id = current_user);

-- Returns a corporation's wallet balance
-- operation id: get_corporations_corporation_id_wallets
CREATE TABLE crp_wallet
(
  corporation_id integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  balance double precision NOT NULL,
  division integer NOT NULL
);
ALTER TABLE crp_wallet OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_wallet TO Accountant,Junior_Accountant;
GRANT INSERT ON TABLE crp_wallet TO Accountant,Junior_Accountant;
GRANT DELETE ON TABLE crp_wallet TO Accountant,Junior_Accountant;
ALTER TABLE crp_wallet ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_wallet ON crp_wallet TO authenticated USING (user_id = current_user);

-- Get corporation wallet journal
-- operation id: get_corporations_corporation_id_wallets_division_journal
CREATE TABLE crp_wallet_div_journal
(
  corporation_id integer NOT NULL,
  division integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  amount double precision,
  balance double precision,
  context_id bigint,
  context_id_type varchar(4000),
  date timestamp NOT NULL,
  description varchar(4000) NOT NULL,
  first_party_id integer,
  id bigint NOT NULL,
  reason varchar(4000),
  ref_type varchar(4000) NOT NULL,
  second_party_id integer,
  tax double precision,
  tax_receiver_id integer
);
ALTER TABLE crp_wallet_div_journal OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_wallet_div_journal TO Accountant,Junior_Accountant;
GRANT INSERT ON TABLE crp_wallet_div_journal TO Accountant,Junior_Accountant;
GRANT DELETE ON TABLE crp_wallet_div_journal TO Accountant,Junior_Accountant;
ALTER TABLE crp_wallet_div_journal ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_wallet_div_journal ON crp_wallet_div_journal TO authenticated USING (user_id = current_user);

-- Get corporation wallet transactions
-- operation id: get_corporations_corporation_id_wallets_division_transactions
CREATE TABLE crp_wallet_div_transaction
(
  corporation_id integer NOT NULL,
  division integer NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  client_id integer NOT NULL,
  date timestamp NOT NULL,
  is_buy boolean NOT NULL,
  journal_ref_id bigint NOT NULL,
  location_id bigint NOT NULL,
  quantity integer NOT NULL,
  transaction_id bigint NOT NULL,
  type_id integer NOT NULL,
  unit_price double precision NOT NULL
);
ALTER TABLE crp_wallet_div_transaction OWNER TO esi_v1_11;
GRANT SELECT ON TABLE crp_wallet_div_transaction TO Accountant,Junior_Accountant;
GRANT INSERT ON TABLE crp_wallet_div_transaction TO Accountant,Junior_Accountant;
GRANT DELETE ON TABLE crp_wallet_div_transaction TO Accountant,Junior_Accountant;
ALTER TABLE crp_wallet_div_transaction ENABLE ROW LEVEL SECURITY;
CREATE POLICY crp_wallet_div_transaction ON crp_wallet_div_transaction TO authenticated USING (user_id = current_user);

-- Get attributes
-- operation id: get_dogma_attributes
CREATE TABLE dgm_attribute
(
  attribute_id integer
);
ALTER TABLE dgm_attribute OWNER TO esi_v1_11;

-- Get attribute information
-- operation id: get_dogma_attributes_attribute_id
CREATE TABLE dgm_attribute_dtl
(
  attribute_id integer PRIMARY KEY,
  default_value float,
  description varchar(4000),
  display_name varchar(4000),
  high_is_good boolean,
  icon_id integer,
  name varchar(4000),
  published boolean,
  stackable boolean,
  unit_id integer
);
ALTER TABLE dgm_attribute_dtl OWNER TO esi_v1_11;

-- Get dynamic item information
-- operation id: get_dogma_dynamic_items_type_id_item_id
CREATE TABLE dgm_dynamic_item_type_item
(
  item_id bigint NOT NULL,
  type_id integer NOT NULL,
  created_by integer NOT NULL,
  dogma_attributes json NOT NULL,
  dogma_effects json NOT NULL,
  mutator_type_id integer NOT NULL,
  source_type_id integer NOT NULL
);
ALTER TABLE dgm_dynamic_item_type_item OWNER TO esi_v1_11;

-- Get effects
-- operation id: get_dogma_effects
CREATE TABLE dgm_effect
(
  effect_id integer
);
ALTER TABLE dgm_effect OWNER TO esi_v1_11;

-- Get effect information
-- operation id: get_dogma_effects_effect_id
CREATE TABLE dgm_effect_dtl
(
  effect_id integer PRIMARY KEY,
  description varchar(4000),
  disallow_auto_repeat boolean,
  discharge_attribute_id integer,
  display_name varchar(4000),
  duration_attribute_id integer,
  effect_category integer,
  electronic_chance boolean,
  falloff_attribute_id integer,
  icon_id integer,
  is_assistance boolean,
  is_offensive boolean,
  is_warp_safe boolean,
  modifiers json,
  name varchar(4000),
  post_expression integer,
  pre_expression integer,
  published boolean,
  range_attribute_id integer,
  range_chance boolean,
  tracking_speed_attribute_id integer
);
ALTER TABLE dgm_effect_dtl OWNER TO esi_v1_11;

-- Get fleet information
-- operation id: get_fleets_fleet_id
CREATE TABLE fleet
(
  fleet_id bigint PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  is_free_move boolean NOT NULL,
  is_registered boolean NOT NULL,
  is_voice_enabled boolean NOT NULL,
  motd varchar(4000) NOT NULL
);
ALTER TABLE fleet OWNER TO esi_v1_11;
GRANT SELECT ON TABLE fleet TO authenticated;
GRANT INSERT ON TABLE fleet TO authenticated;
GRANT DELETE ON TABLE fleet TO authenticated;
ALTER TABLE fleet ENABLE ROW LEVEL SECURITY;
CREATE POLICY fleet ON fleet TO authenticated USING (user_id = current_user);

-- Get fleet members
-- operation id: get_fleets_fleet_id_members
CREATE TABLE flt_member
(
  fleet_id bigint NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  character_id integer NOT NULL,
  join_time timestamp NOT NULL,
  role varchar(4000) NOT NULL,
  role_name varchar(4000) NOT NULL,
  ship_type_id integer NOT NULL,
  solar_system_id integer NOT NULL,
  squad_id bigint NOT NULL,
  station_id bigint,
  takes_fleet_warp boolean NOT NULL,
  wing_id bigint NOT NULL
);
ALTER TABLE flt_member OWNER TO esi_v1_11;
GRANT SELECT ON TABLE flt_member TO authenticated;
GRANT INSERT ON TABLE flt_member TO authenticated;
GRANT DELETE ON TABLE flt_member TO authenticated;
ALTER TABLE flt_member ENABLE ROW LEVEL SECURITY;
CREATE POLICY flt_member ON flt_member TO authenticated USING (user_id = current_user);

-- Get fleet wings
-- operation id: get_fleets_fleet_id_wings
CREATE TABLE flt_wing
(
  fleet_id bigint NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  id bigint NOT NULL,
  name varchar(4000) NOT NULL,
  squads json NOT NULL
);
ALTER TABLE flt_wing OWNER TO esi_v1_11;
GRANT SELECT ON TABLE flt_wing TO authenticated;
GRANT INSERT ON TABLE flt_wing TO authenticated;
GRANT DELETE ON TABLE flt_wing TO authenticated;
ALTER TABLE flt_wing ENABLE ROW LEVEL SECURITY;
CREATE POLICY flt_wing ON flt_wing TO authenticated USING (user_id = current_user);

-- List of the top factions in faction warfare
-- operation id: get_fw_leaderboards
CREATE TABLE fw_leaderboard
(
  kills json NOT NULL,
  victory_points json NOT NULL
);
ALTER TABLE fw_leaderboard OWNER TO esi_v1_11;

-- List of the top pilots in faction warfare
-- operation id: get_fw_leaderboards_characters
CREATE TABLE fw_leaderboard_character
(
  kills json NOT NULL,
  victory_points json NOT NULL
);
ALTER TABLE fw_leaderboard_character OWNER TO esi_v1_11;

-- List of the top corporations in faction warfare
-- operation id: get_fw_leaderboards_corporations
CREATE TABLE fw_leaderboard_corporation
(
  kills json NOT NULL,
  victory_points json NOT NULL
);
ALTER TABLE fw_leaderboard_corporation OWNER TO esi_v1_11;

-- An overview of statistics about factions involved in faction warfare
-- operation id: get_fw_stats
CREATE TABLE fw_stat
(
  faction_id integer NOT NULL,
  kills json NOT NULL,
  pilots integer NOT NULL,
  systems_controlled integer NOT NULL,
  victory_points json NOT NULL
);
ALTER TABLE fw_stat OWNER TO esi_v1_11;

-- Ownership of faction warfare systems
-- operation id: get_fw_systems
CREATE TABLE fw_system
(
  contested varchar(4000) NOT NULL,
  occupier_faction_id integer NOT NULL,
  owner_faction_id integer NOT NULL,
  solar_system_id integer NOT NULL,
  victory_points integer NOT NULL,
  victory_points_threshold integer NOT NULL
);
ALTER TABLE fw_system OWNER TO esi_v1_11;

-- Data about which NPC factions are at war
-- operation id: get_fw_wars
CREATE TABLE fw_war
(
  against_id integer NOT NULL,
  faction_id integer NOT NULL
);
ALTER TABLE fw_war OWNER TO esi_v1_11;

-- List incursions
-- operation id: get_incursions
CREATE TABLE incursions
(
  constellation_id integer NOT NULL,
  faction_id integer NOT NULL,
  has_boss boolean NOT NULL,
  infested_solar_systems json NOT NULL,
  influence float NOT NULL,
  staging_solar_system_id integer NOT NULL,
  state varchar(4000) NOT NULL,
  type varchar(4000) NOT NULL
);
ALTER TABLE incursions OWNER TO esi_v1_11;

-- List industry facilities
-- operation id: get_industry_facilities
CREATE TABLE ind_facility
(
  facility_id bigint NOT NULL,
  owner_id integer NOT NULL,
  region_id integer NOT NULL,
  solar_system_id integer NOT NULL,
  tax float,
  type_id integer NOT NULL
);
ALTER TABLE ind_facility OWNER TO esi_v1_11;

-- List solar system cost indices
-- operation id: get_industry_systems
CREATE TABLE ind_system
(
  cost_indices json NOT NULL,
  solar_system_id integer NOT NULL
);
ALTER TABLE ind_system OWNER TO esi_v1_11;

-- List insurance levels
-- operation id: get_insurance_prices
CREATE TABLE ins_price
(
  levels json NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE ins_price OWNER TO esi_v1_11;

-- Get a single killmail
-- operation id: get_killmails_killmail_id_killmail_hash
CREATE TABLE km_killmail_hash
(
  killmail_hash varchar(4000) NOT NULL,
  killmail_id integer NOT NULL,
  attackers json NOT NULL,
  killmail_time timestamp NOT NULL,
  moon_id integer,
  solar_system_id integer NOT NULL,
  victim json NOT NULL,
  war_id integer
);
ALTER TABLE km_killmail_hash OWNER TO esi_v1_11;

-- List loyalty store offers
-- operation id: get_loyalty_stores_corporation_id_offers
CREATE TABLE lty_store_corporation_offer
(
  corporation_id integer NOT NULL,
  ak_cost integer,
  isk_cost bigint NOT NULL,
  lp_cost integer NOT NULL,
  offer_id integer NOT NULL,
  quantity integer NOT NULL,
  required_items json NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE lty_store_corporation_offer OWNER TO esi_v1_11;

-- Get item groups
-- operation id: get_markets_groups
CREATE TABLE mkt_group
(
  group_id integer
);
ALTER TABLE mkt_group OWNER TO esi_v1_11;

-- Get item group information
-- operation id: get_markets_groups_market_group_id
CREATE TABLE mkt_group_market_group
(
  market_group_id integer PRIMARY KEY,
  description varchar(4000) NOT NULL,
  name varchar(4000) NOT NULL,
  parent_group_id integer,
  types json NOT NULL
);
ALTER TABLE mkt_group_market_group OWNER TO esi_v1_11;

-- List market prices
-- operation id: get_markets_prices
CREATE TABLE mkt_price
(
  adjusted_price double precision,
  average_price double precision,
  type_id integer NOT NULL
);
ALTER TABLE mkt_price OWNER TO esi_v1_11;

-- List orders in a structure
-- operation id: get_markets_structures_structure_id
CREATE TABLE mkt_structure_dtl
(
  structure_id bigint NOT NULL,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  duration integer NOT NULL,
  is_buy_order boolean NOT NULL,
  issued timestamp NOT NULL,
  location_id bigint NOT NULL,
  min_volume integer NOT NULL,
  order_id bigint NOT NULL,
  price double precision NOT NULL,
  range varchar(4000) NOT NULL,
  type_id integer NOT NULL,
  volume_remain integer NOT NULL,
  volume_total integer NOT NULL
);
ALTER TABLE mkt_structure_dtl OWNER TO esi_v1_11;
GRANT SELECT ON TABLE mkt_structure_dtl TO authenticated;
GRANT INSERT ON TABLE mkt_structure_dtl TO authenticated;
GRANT DELETE ON TABLE mkt_structure_dtl TO authenticated;
ALTER TABLE mkt_structure_dtl ENABLE ROW LEVEL SECURITY;
CREATE POLICY mkt_structure_dtl ON mkt_structure_dtl TO authenticated USING (user_id = current_user);

-- List historical market statistics in a region
-- operation id: get_markets_region_id_history
CREATE TABLE mkt_region_history
(
  region_id integer NOT NULL,
  type_id integer NOT NULL,
  average double precision NOT NULL,
  date date NOT NULL,
  highest double precision NOT NULL,
  lowest double precision NOT NULL,
  order_count bigint NOT NULL,
  volume bigint NOT NULL
);
ALTER TABLE mkt_region_history OWNER TO esi_v1_11;

-- List orders in a region
-- operation id: get_markets_region_id_orders
CREATE TABLE mkt_region_order
(
  order_type varchar(4000) NOT NULL,
  region_id integer NOT NULL,
  duration integer NOT NULL,
  is_buy_order boolean NOT NULL,
  issued timestamp NOT NULL,
  location_id bigint NOT NULL,
  min_volume integer NOT NULL,
  order_id bigint NOT NULL,
  price double precision NOT NULL,
  range varchar(4000) NOT NULL,
  system_id integer NOT NULL,
  type_id integer NOT NULL,
  volume_remain integer NOT NULL,
  volume_total integer NOT NULL
);
ALTER TABLE mkt_region_order OWNER TO esi_v1_11;

-- List type IDs relevant to a market
-- operation id: get_markets_region_id_types
CREATE TABLE mkt_region_type
(
  region_id integer NOT NULL,
  type_id integer
);
ALTER TABLE mkt_region_type OWNER TO esi_v1_11;

-- Get opportunities groups
-- operation id: get_opportunities_groups
CREATE TABLE opp_group
(
  group_id integer
);
ALTER TABLE opp_group OWNER TO esi_v1_11;

-- Get opportunities group
-- operation id: get_opportunities_groups_group_id
CREATE TABLE opp_group_dtl
(
  group_id integer PRIMARY KEY,
  connected_groups json NOT NULL,
  description varchar(4000) NOT NULL,
  name varchar(4000) NOT NULL,
  notification varchar(4000) NOT NULL,
  required_tasks json NOT NULL
);
ALTER TABLE opp_group_dtl OWNER TO esi_v1_11;

-- Get opportunities tasks
-- operation id: get_opportunities_tasks
CREATE TABLE opp_task
(
  task_id integer
);
ALTER TABLE opp_task OWNER TO esi_v1_11;

-- Get opportunities task
-- operation id: get_opportunities_tasks_task_id
CREATE TABLE opp_task_dtl
(
  task_id integer PRIMARY KEY,
  description varchar(4000) NOT NULL,
  name varchar(4000) NOT NULL,
  notification varchar(4000) NOT NULL
);
ALTER TABLE opp_task_dtl OWNER TO esi_v1_11;

-- Get route
-- operation id: get_route_origin_destination
CREATE TABLE route_origin_destination
(
  destination integer NOT NULL,
  origin integer NOT NULL,
  destination_id integer
);
ALTER TABLE route_origin_destination OWNER TO esi_v1_11;

-- Search on a string
-- operation id: get_search
CREATE TABLE search
(
  categories varchar(4000) NOT NULL,
  search varchar(4000) NOT NULL,
  agent json,
  alliance json,
  character json,
  constellation json,
  corporation json,
  faction json,
  inventory_type json,
  region json,
  solar_system json,
  station json
);
ALTER TABLE search OWNER TO esi_v1_11;

-- List sovereignty campaigns
-- operation id: get_sovereignty_campaigns
CREATE TABLE sov_campaign
(
  attackers_score float,
  campaign_id integer NOT NULL,
  constellation_id integer NOT NULL,
  defender_id integer,
  defender_score float,
  event_type varchar(4000) NOT NULL,
  participants json,
  solar_system_id integer NOT NULL,
  start_time timestamp NOT NULL,
  structure_id bigint NOT NULL
);
ALTER TABLE sov_campaign OWNER TO esi_v1_11;

-- List sovereignty of systems
-- operation id: get_sovereignty_map
CREATE TABLE sov_map
(
  alliance_id integer,
  corporation_id integer,
  faction_id integer,
  system_id integer NOT NULL
);
ALTER TABLE sov_map OWNER TO esi_v1_11;

-- List sovereignty structures
-- operation id: get_sovereignty_structures
CREATE TABLE sov_structure
(
  alliance_id integer NOT NULL,
  solar_system_id integer NOT NULL,
  structure_id bigint NOT NULL,
  structure_type_id integer NOT NULL,
  vulnerability_occupancy_level float,
  vulnerable_end_time timestamp,
  vulnerable_start_time timestamp
);
ALTER TABLE sov_structure OWNER TO esi_v1_11;

-- Retrieve the uptime and player counts
-- operation id: get_status
CREATE TABLE status
(
  players integer NOT NULL,
  server_version varchar(4000) NOT NULL,
  start_time timestamp NOT NULL,
  vip boolean
);
ALTER TABLE status OWNER TO esi_v1_11;

-- Get ancestries
-- operation id: get_universe_ancestries
CREATE TABLE uni_ancestry
(
  bloodline_id integer NOT NULL,
  description varchar(4000) NOT NULL,
  icon_id integer,
  id integer NOT NULL,
  name varchar(4000) NOT NULL,
  short_description varchar(4000)
);
ALTER TABLE uni_ancestry OWNER TO esi_v1_11;

-- Get asteroid belt information
-- operation id: get_universe_asteroid_belts_asteroid_belt_id
CREATE TABLE uni_asteroid_belt_dtl
(
  asteroid_belt_id integer PRIMARY KEY,
  name varchar(4000) NOT NULL,
  position json NOT NULL,
  system_id integer NOT NULL
);
ALTER TABLE uni_asteroid_belt_dtl OWNER TO esi_v1_11;

-- Get bloodlines
-- operation id: get_universe_bloodlines
CREATE TABLE uni_bloodline
(
  bloodline_id integer NOT NULL,
  charisma integer NOT NULL,
  corporation_id integer NOT NULL,
  description varchar(4000) NOT NULL,
  intelligence integer NOT NULL,
  memory integer NOT NULL,
  name varchar(4000) NOT NULL,
  perception integer NOT NULL,
  race_id integer NOT NULL,
  ship_type_id integer NOT NULL,
  willpower integer NOT NULL
);
ALTER TABLE uni_bloodline OWNER TO esi_v1_11;

-- Get item categories
-- operation id: get_universe_categories
CREATE TABLE uni_category
(
  category_id integer
);
ALTER TABLE uni_category OWNER TO esi_v1_11;

-- Get item category information
-- operation id: get_universe_categories_category_id
CREATE TABLE uni_category_category
(
  category_id integer PRIMARY KEY,
  groups json NOT NULL,
  name varchar(4000) NOT NULL,
  published boolean NOT NULL
);
ALTER TABLE uni_category_category OWNER TO esi_v1_11;

-- Get constellations
-- operation id: get_universe_constellations
CREATE TABLE uni_constellation
(
  constellation_id integer
);
ALTER TABLE uni_constellation OWNER TO esi_v1_11;

-- Get constellation information
-- operation id: get_universe_constellations_constellation_id
CREATE TABLE uni_constellation_dtl
(
  constellation_id integer PRIMARY KEY,
  name varchar(4000) NOT NULL,
  position json NOT NULL,
  region_id integer NOT NULL,
  systems json NOT NULL
);
ALTER TABLE uni_constellation_dtl OWNER TO esi_v1_11;

-- Get factions
-- operation id: get_universe_factions
CREATE TABLE uni_faction
(
  corporation_id integer,
  description varchar(4000) NOT NULL,
  faction_id integer NOT NULL,
  is_unique boolean NOT NULL,
  militia_corporation_id integer,
  name varchar(4000) NOT NULL,
  size_factor float NOT NULL,
  solar_system_id integer,
  station_count integer NOT NULL,
  station_system_count integer NOT NULL
);
ALTER TABLE uni_faction OWNER TO esi_v1_11;

-- Get graphics
-- operation id: get_universe_graphics
CREATE TABLE uni_graphic
(
  graphic_id integer
);
ALTER TABLE uni_graphic OWNER TO esi_v1_11;

-- Get graphic information
-- operation id: get_universe_graphics_graphic_id
CREATE TABLE uni_graphic_dtl
(
  graphic_id integer PRIMARY KEY,
  collision_file varchar(4000),
  graphic_file varchar(4000),
  icon_folder varchar(4000),
  sof_dna varchar(4000),
  sof_fation_name varchar(4000),
  sof_hull_name varchar(4000),
  sof_race_name varchar(4000)
);
ALTER TABLE uni_graphic_dtl OWNER TO esi_v1_11;

-- Get item groups
-- operation id: get_universe_groups
CREATE TABLE uni_group
(
  group_id integer
);
ALTER TABLE uni_group OWNER TO esi_v1_11;

-- Get item group information
-- operation id: get_universe_groups_group_id
CREATE TABLE uni_group_dtl
(
  group_id integer PRIMARY KEY,
  category_id integer NOT NULL,
  name varchar(4000) NOT NULL,
  published boolean NOT NULL,
  types json NOT NULL
);
ALTER TABLE uni_group_dtl OWNER TO esi_v1_11;

-- Get moon information
-- operation id: get_universe_moons_moon_id
CREATE TABLE uni_moon_dtl
(
  moon_id integer PRIMARY KEY,
  name varchar(4000) NOT NULL,
  position json NOT NULL,
  system_id integer NOT NULL
);
ALTER TABLE uni_moon_dtl OWNER TO esi_v1_11;

-- Get planet information
-- operation id: get_universe_planets_planet_id
CREATE TABLE uni_planet_dtl
(
  planet_id integer PRIMARY KEY,
  name varchar(4000) NOT NULL,
  position json NOT NULL,
  system_id integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE uni_planet_dtl OWNER TO esi_v1_11;

-- Get character races
-- operation id: get_universe_races
CREATE TABLE uni_race
(
  alliance_id integer NOT NULL,
  description varchar(4000) NOT NULL,
  name varchar(4000) NOT NULL,
  race_id integer NOT NULL
);
ALTER TABLE uni_race OWNER TO esi_v1_11;

-- Get regions
-- operation id: get_universe_regions
CREATE TABLE uni_region
(
  region_id integer
);
ALTER TABLE uni_region OWNER TO esi_v1_11;

-- Get region information
-- operation id: get_universe_regions_region_id
CREATE TABLE uni_region_dtl
(
  region_id integer PRIMARY KEY,
  constellations json NOT NULL,
  description varchar(4000),
  name varchar(4000) NOT NULL
);
ALTER TABLE uni_region_dtl OWNER TO esi_v1_11;

-- Get schematic information
-- operation id: get_universe_schematics_schematic_id
CREATE TABLE uni_schematic_dtl
(
  schematic_id integer PRIMARY KEY,
  cycle_time integer NOT NULL,
  schematic_name varchar(4000) NOT NULL
);
ALTER TABLE uni_schematic_dtl OWNER TO esi_v1_11;

-- Get stargate information
-- operation id: get_universe_stargates_stargate_id
CREATE TABLE uni_stargate_dtl
(
  stargate_id integer PRIMARY KEY,
  destination json NOT NULL,
  name varchar(4000) NOT NULL,
  position json NOT NULL,
  system_id integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE uni_stargate_dtl OWNER TO esi_v1_11;

-- Get star information
-- operation id: get_universe_stars_star_id
CREATE TABLE uni_star_dtl
(
  star_id integer PRIMARY KEY,
  age bigint NOT NULL,
  luminosity float NOT NULL,
  name varchar(4000) NOT NULL,
  radius bigint NOT NULL,
  solar_system_id integer NOT NULL,
  spectral_class varchar(4000) NOT NULL,
  temperature integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE uni_star_dtl OWNER TO esi_v1_11;

-- Get station information
-- operation id: get_universe_stations_station_id
CREATE TABLE uni_station_dtl
(
  station_id integer PRIMARY KEY,
  max_dockable_ship_volume float NOT NULL,
  name varchar(4000) NOT NULL,
  office_rental_cost float NOT NULL,
  owner integer,
  position json NOT NULL,
  race_id integer,
  reprocessing_efficiency float NOT NULL,
  reprocessing_stations_take float NOT NULL,
  services json NOT NULL,
  system_id integer NOT NULL,
  type_id integer NOT NULL
);
ALTER TABLE uni_station_dtl OWNER TO esi_v1_11;

-- List all public structures
-- operation id: get_universe_structures
CREATE TABLE uni_structure
(
  structure_id bigint
);
ALTER TABLE uni_structure OWNER TO esi_v1_11;

-- Get structure information
-- operation id: get_universe_structures_structure_id
CREATE TABLE uni_structure_dtl
(
  structure_id bigint PRIMARY KEY,
  user_id varchar(20) not null references auth.users(user_id) DEFAULT current_user,
  name varchar(4000) NOT NULL,
  owner_id integer NOT NULL,
  position json NOT NULL,
  solar_system_id integer NOT NULL,
  type_id integer
);
ALTER TABLE uni_structure_dtl OWNER TO esi_v1_11;
GRANT SELECT ON TABLE uni_structure_dtl TO authenticated;
GRANT INSERT ON TABLE uni_structure_dtl TO authenticated;
GRANT DELETE ON TABLE uni_structure_dtl TO authenticated;
ALTER TABLE uni_structure_dtl ENABLE ROW LEVEL SECURITY;
CREATE POLICY uni_structure_dtl ON uni_structure_dtl TO authenticated USING (user_id = current_user);

-- Get system jumps
-- operation id: get_universe_system_jumps
CREATE TABLE uni_system_jump
(
  ship_jumps integer NOT NULL,
  system_id integer NOT NULL
);
ALTER TABLE uni_system_jump OWNER TO esi_v1_11;

-- Get system kills
-- operation id: get_universe_system_kills
CREATE TABLE uni_system_kill
(
  npc_kills integer NOT NULL,
  pod_kills integer NOT NULL,
  ship_kills integer NOT NULL,
  system_id integer NOT NULL
);
ALTER TABLE uni_system_kill OWNER TO esi_v1_11;

-- Get solar systems
-- operation id: get_universe_systems
CREATE TABLE uni_system
(
  system_id integer
);
ALTER TABLE uni_system OWNER TO esi_v1_11;

-- Get solar system information
-- operation id: get_universe_systems_system_id
CREATE TABLE uni_system_dtl
(
  system_id integer PRIMARY KEY,
  constellation_id integer NOT NULL,
  name varchar(4000) NOT NULL,
  planets json,
  position json NOT NULL,
  security_class varchar(4000),
  security_status float NOT NULL,
  star_id integer,
  stargates json,
  stations json
);
ALTER TABLE uni_system_dtl OWNER TO esi_v1_11;

-- Get types
-- operation id: get_universe_types
CREATE TABLE uni_type
(
  type_id integer
);
ALTER TABLE uni_type OWNER TO esi_v1_11;

-- Get type information
-- operation id: get_universe_types_type_id
CREATE TABLE uni_type_dtl
(
  type_id integer PRIMARY KEY,
  capacity float,
  description varchar(4000) NOT NULL,
  dogma_attributes json,
  dogma_effects json,
  graphic_id integer,
  group_id integer NOT NULL,
  icon_id integer,
  market_group_id integer,
  mass float,
  name varchar(4000) NOT NULL,
  packaged_volume float,
  portion_size integer,
  published boolean NOT NULL,
  radius float,
  volume float
);
ALTER TABLE uni_type_dtl OWNER TO esi_v1_11;

-- List wars
-- operation id: get_wars
CREATE TABLE wars
(
  wars_id integer
);
ALTER TABLE wars OWNER TO esi_v1_11;

-- Get war information
-- operation id: get_wars_war_id
CREATE TABLE war
(
  war_id integer PRIMARY KEY,
  aggressor json NOT NULL,
  allies json,
  declared timestamp NOT NULL,
  defender json NOT NULL,
  finished timestamp,
  id integer NOT NULL,
  mutual boolean NOT NULL,
  open_for_allies boolean NOT NULL,
  retracted timestamp,
  started timestamp
);
ALTER TABLE war OWNER TO esi_v1_11;

-- List kills for a war
-- operation id: get_wars_war_id_killmails
CREATE TABLE war_killmail
(
  war_id integer NOT NULL,
  killmail_hash varchar(4000) NOT NULL,
  killmail_id integer NOT NULL
);
ALTER TABLE war_killmail OWNER TO esi_v1_11;

-- Swagger Mapping
CREATE TABLE swagger_mapping
(
  version varchar(50) NOT NULL,
  description varchar(255),
  mapping text not null
);
ALTER TABLE swagger_mapping OWNER TO esi_v1_11;
INSERT INTO swagger_mapping(version, description, mapping) VALUES ('1.11', 'An OpenAPI for EVE Online', '{"title":"EVE Swagger Interface","version":"1.11","description":"An OpenAPI for EVE Online","operations":{"get_alliances":{"table":"alliances","type":"primitive","fields":{"alliances_id":"alliances_id"}},"get_alliances_alliance_id":{"table":"alliance","fields":{"alliance_id":"alliance_id","creator_corporation_id":"creator_corporation_id","creator_id":"creator_id","date_founded":"date_founded","executor_corporation_id":"executor_corporation_id","faction_id":"faction_id","name":"name","ticker":"ticker"},"key":["alliance_id"]},"get_alliances_alliance_id_contacts":{"table":"ali_contact","fields":{"alliance_id":"alliance_id","user_id":"user_id","contact_id":"contact_id","contact_type":"contact_type","label_ids":"label_ids","standing":"standing"},"key":["alliance_id"]},"get_alliances_alliance_id_contacts_labels":{"table":"ali_contact_label","fields":{"alliance_id":"alliance_id","user_id":"user_id","label_id":"label_id","label_name":"label_name"},"key":["alliance_id"]},"get_alliances_alliance_id_corporations":{"table":"ali_corporation","type":"primitive","fields":{"alliance_id":"alliance_id","corporation_id":"corporation_id"},"key":["alliance_id"]},"get_alliances_alliance_id_icons":{"table":"ali_icon","fields":{"alliance_id":"alliance_id","px128x128":"px128x128","px64x64":"px64x64"},"key":["alliance_id"]},"get_characters_character_id":{"table":"character","fields":{"character_id":"character_id","alliance_id":"alliance_id","birthday":"birthday","bloodline_id":"bloodline_id","corporation_id":"corporation_id","description":"description","faction_id":"faction_id","gender":"gender","name":"name","race_id":"race_id","security_status":"security_status","title":"title"},"key":["character_id"]},"get_characters_character_id_agents_research":{"table":"chr_agents_research","fields":{"character_id":"character_id","user_id":"user_id","agent_id":"agent_id","points_per_day":"points_per_day","remainder_points":"remainder_points","skill_type_id":"skill_type_id","started_at":"started_at"},"key":["character_id"]},"get_characters_character_id_assets":{"table":"chr_asset","fields":{"character_id":"character_id","user_id":"user_id","is_blueprint_copy":"is_blueprint_copy","is_singleton":"is_singleton","item_id":"item_id","location_flag":"location_flag","location_id":"location_id","location_type":"location_type","quantity":"quantity","type_id":"type_id"},"key":["character_id"]},"get_characters_character_id_attributes":{"table":"chr_attribute","fields":{"character_id":"character_id","user_id":"user_id","accrued_remap_cooldown_date":"accrued_remap_cooldown_date","bonus_remaps":"bonus_remaps","charisma":"charisma","intelligence":"intelligence","last_remap_date":"last_remap_date","memory":"memory","perception":"perception","willpower":"willpower"},"key":["character_id"]},"get_characters_character_id_blueprints":{"table":"chr_blueprint","fields":{"character_id":"character_id","user_id":"user_id","item_id":"item_id","location_flag":"location_flag","location_id":"location_id","material_efficiency":"material_efficiency","quantity":"quantity","runs":"runs","time_efficiency":"time_efficiency","type_id":"type_id"},"key":["character_id"]},"get_characters_character_id_bookmarks":{"table":"chr_bookmark","fields":{"character_id":"character_id","user_id":"user_id","bookmark_id":"bookmark_id","coordinates":"coordinates","created":"created","creator_id":"creator_id","folder_id":"folder_id","item":"item","label":"label","location_id":"location_id","notes":"notes"},"key":["character_id"]},"get_characters_character_id_bookmarks_folders":{"table":"chr_bookmark_folder","fields":{"character_id":"character_id","user_id":"user_id","folder_id":"folder_id","name":"name"},"key":["character_id"]},"get_characters_character_id_calendar":{"table":"chr_calendar","fields":{"character_id":"character_id","user_id":"user_id","event_date":"event_date","event_id":"event_id","event_response":"event_response","importance":"importance","title":"title"},"key":["character_id"]},"get_characters_character_id_calendar_event_id":{"table":"chr_calendar_event","fields":{"character_id":"character_id","event_id":"event_id","user_id":"user_id","date":"date","duration":"duration","importance":"importance","owner_id":"owner_id","owner_name":"owner_name","owner_type":"owner_type","response":"response","text":"text","title":"title"},"key":["character_id","event_id"]},"get_characters_character_id_calendar_event_id_attendees":{"table":"chr_calendar_event_attendee","fields":{"character_id":"character_id","event_id":"event_id","user_id":"user_id","event_response":"event_response"},"key":["character_id","event_id"]},"get_characters_character_id_clones":{"table":"chr_clone","fields":{"character_id":"character_id","user_id":"user_id","home_location":"home_location","jump_clones":"jump_clones","last_clone_jump_date":"last_clone_jump_date","last_station_change_date":"last_station_change_date"},"key":["character_id"]},"get_characters_character_id_contacts":{"table":"chr_contact","fields":{"character_id":"character_id","user_id":"user_id","contact_id":"contact_id","contact_type":"contact_type","is_blocked":"is_blocked","is_watched":"is_watched","label_ids":"label_ids","standing":"standing"},"key":["character_id"]},"get_characters_character_id_contacts_labels":{"table":"chr_contact_label","fields":{"character_id":"character_id","user_id":"user_id","label_id":"label_id","label_name":"label_name"},"key":["character_id"]},"get_characters_character_id_contracts":{"table":"chr_contract","fields":{"character_id":"character_id","user_id":"user_id","acceptor_id":"acceptor_id","assignee_id":"assignee_id","availability":"availability","buyout":"buyout","collateral":"collateral","contract_id":"contract_id","date_accepted":"date_accepted","date_completed":"date_completed","date_expired":"date_expired","date_issued":"date_issued","days_to_complete":"days_to_complete","end_location_id":"end_location_id","for_corporation":"for_corporation","issuer_corporation_id":"issuer_corporation_id","issuer_id":"issuer_id","price":"price","reward":"reward","start_location_id":"start_location_id","status":"status","title":"title","type":"type","volume":"volume"},"key":["character_id"]},"get_characters_character_id_contracts_contract_id_bids":{"table":"chr_contract_bid","fields":{"character_id":"character_id","contract_id":"contract_id","user_id":"user_id","amount":"amount","bid_id":"bid_id","bidder_id":"bidder_id","date_bid":"date_bid"},"key":["character_id","contract_id"]},"get_characters_character_id_contracts_contract_id_items":{"table":"chr_contract_item","fields":{"character_id":"character_id","contract_id":"contract_id","user_id":"user_id","is_included":"is_included","is_singleton":"is_singleton","quantity":"quantity","raw_quantity":"raw_quantity","record_id":"record_id","type_id":"type_id"},"key":["character_id","contract_id"]},"get_characters_character_id_corporationhistory":{"table":"chr_corporationhistory","fields":{"character_id":"character_id","corporation_id":"corporation_id","is_deleted":"is_deleted","record_id":"record_id","start_date":"start_date"},"key":["character_id"]},"get_characters_character_id_fatigue":{"table":"chr_fatigue","fields":{"character_id":"character_id","user_id":"user_id","jump_fatigue_expire_date":"jump_fatigue_expire_date","last_jump_date":"last_jump_date","last_update_date":"last_update_date"},"key":["character_id"]},"get_characters_character_id_fittings":{"table":"chr_fitting","fields":{"character_id":"character_id","user_id":"user_id","description":"description","fitting_id":"fitting_id","items":"items","name":"name","ship_type_id":"ship_type_id"},"key":["character_id"]},"get_characters_character_id_fleet":{"table":"chr_fleet","fields":{"character_id":"character_id","user_id":"user_id","fleet_id":"fleet_id","role":"role","squad_id":"squad_id","wing_id":"wing_id"},"key":["character_id"]},"get_characters_character_id_fw_stats":{"table":"chr_fw_stat","fields":{"character_id":"character_id","user_id":"user_id","current_rank":"current_rank","enlisted_on":"enlisted_on","faction_id":"faction_id","highest_rank":"highest_rank","kills":"kills","victory_points":"victory_points"},"key":["character_id"]},"get_characters_character_id_implants":{"table":"chr_implant","type":"primitive","fields":{"character_id":"character_id","user_id":"user_id","implant_id":"implant_id"},"key":["character_id"]},"get_characters_character_id_industry_jobs":{"table":"chr_industry_job","fields":{"character_id":"character_id","user_id":"user_id","activity_id":"activity_id","blueprint_id":"blueprint_id","blueprint_location_id":"blueprint_location_id","blueprint_type_id":"blueprint_type_id","completed_character_id":"completed_character_id","completed_date":"completed_date","cost":"cost","duration":"duration","end_date":"end_date","facility_id":"facility_id","installer_id":"installer_id","job_id":"job_id","licensed_runs":"licensed_runs","output_location_id":"output_location_id","pause_date":"pause_date","probability":"probability","product_type_id":"product_type_id","runs":"runs","start_date":"start_date","station_id":"station_id","status":"status","successful_runs":"successful_runs"},"key":["character_id"]},"get_characters_character_id_killmails_recent":{"table":"chr_killmail_recent","fields":{"character_id":"character_id","user_id":"user_id","killmail_hash":"killmail_hash","killmail_id":"killmail_id"},"key":["character_id"]},"get_characters_character_id_location":{"table":"chr_location","fields":{"character_id":"character_id","user_id":"user_id","solar_system_id":"solar_system_id","station_id":"station_id","structure_id":"structure_id"},"key":["character_id"]},"get_characters_character_id_loyalty_points":{"table":"chr_loyalty_point","fields":{"character_id":"character_id","user_id":"user_id","corporation_id":"corporation_id","loyalty_points":"loyalty_points"},"key":["character_id"]},"get_characters_character_id_mail":{"table":"chr_mail","fields":{"character_id":"character_id","user_id":"user_id","from":"\"from\"","is_read":"is_read","labels":"labels","mail_id":"mail_id","recipients":"recipients","subject":"subject","timestamp":"timestamp"},"key":["character_id"]},"get_characters_character_id_mail_labels":{"table":"chr_mail_label","fields":{"character_id":"character_id","user_id":"user_id","labels":"labels","total_unread_count":"total_unread_count"},"key":["character_id"]},"get_characters_character_id_mail_lists":{"table":"chr_mail_list","fields":{"character_id":"character_id","user_id":"user_id","mailing_list_id":"mailing_list_id","name":"name"},"key":["character_id"]},"get_characters_character_id_mail_mail_id":{"table":"chr_mail_dtl","fields":{"character_id":"character_id","mail_id":"mail_id","user_id":"user_id","body":"body","from":"\"from\"","labels":"labels","read":"read","recipients":"recipients","subject":"subject","timestamp":"timestamp"},"key":["character_id","mail_id"]},"get_characters_character_id_medals":{"table":"chr_medal","fields":{"character_id":"character_id","user_id":"user_id","corporation_id":"corporation_id","date":"date","description":"description","graphics":"graphics","issuer_id":"issuer_id","medal_id":"medal_id","reason":"reason","status":"status","title":"title"},"key":["character_id"]},"get_characters_character_id_mining":{"table":"chr_mining","fields":{"character_id":"character_id","user_id":"user_id","date":"date","quantity":"quantity","solar_system_id":"solar_system_id","type_id":"type_id"},"key":["character_id"]},"get_characters_character_id_notifications":{"table":"chr_notification","fields":{"character_id":"character_id","user_id":"user_id","is_read":"is_read","notification_id":"notification_id","sender_id":"sender_id","sender_type":"sender_type","text":"text","timestamp":"timestamp","type":"type"},"key":["character_id"]},"get_characters_character_id_notifications_contacts":{"table":"chr_notification_contact","fields":{"character_id":"character_id","user_id":"user_id","message":"message","notification_id":"notification_id","send_date":"send_date","sender_character_id":"sender_character_id","standing_level":"standing_level"},"key":["character_id"]},"get_characters_character_id_online":{"table":"chr_online","fields":{"character_id":"character_id","user_id":"user_id","last_login":"last_login","last_logout":"last_logout","logins":"logins","online":"online"},"key":["character_id"]},"get_characters_character_id_opportunities":{"table":"chr_opportunity","fields":{"character_id":"character_id","user_id":"user_id","completed_at":"completed_at","task_id":"task_id"},"key":["character_id"]},"get_characters_character_id_orders":{"table":"chr_order","fields":{"character_id":"character_id","user_id":"user_id","duration":"duration","escrow":"escrow","is_buy_order":"is_buy_order","is_corporation":"is_corporation","issued":"issued","location_id":"location_id","min_volume":"min_volume","order_id":"order_id","price":"price","range":"range","region_id":"region_id","type_id":"type_id","volume_remain":"volume_remain","volume_total":"volume_total"},"key":["character_id"]},"get_characters_character_id_orders_history":{"table":"chr_order_history","fields":{"character_id":"character_id","user_id":"user_id","duration":"duration","escrow":"escrow","is_buy_order":"is_buy_order","is_corporation":"is_corporation","issued":"issued","location_id":"location_id","min_volume":"min_volume","order_id":"order_id","price":"price","range":"range","region_id":"region_id","state":"state","type_id":"type_id","volume_remain":"volume_remain","volume_total":"volume_total"},"key":["character_id"]},"get_characters_character_id_planets":{"table":"chr_planet","fields":{"character_id":"character_id","user_id":"user_id","last_update":"last_update","num_pins":"num_pins","owner_id":"owner_id","planet_id":"planet_id","planet_type":"planet_type","solar_system_id":"solar_system_id","upgrade_level":"upgrade_level"},"key":["character_id"]},"get_characters_character_id_planets_planet_id":{"table":"chr_planet_dtl","fields":{"character_id":"character_id","planet_id":"planet_id","user_id":"user_id","links":"links","pins":"pins","routes":"routes"},"key":["character_id","planet_id"]},"get_characters_character_id_portrait":{"table":"chr_portrait","fields":{"character_id":"character_id","px128x128":"px128x128","px256x256":"px256x256","px512x512":"px512x512","px64x64":"px64x64"},"key":["character_id"]},"get_characters_character_id_roles":{"table":"chr_role","fields":{"character_id":"character_id","user_id":"user_id","roles":"roles","roles_at_base":"roles_at_base","roles_at_hq":"roles_at_hq","roles_at_other":"roles_at_other"},"key":["character_id"]},"get_characters_character_id_search":{"table":"chr_search","fields":{"categories":"categories","character_id":"character_id","search":"search","user_id":"user_id","agent":"agent","alliance":"alliance","character":"character","constellation":"constellation","corporation":"corporation","faction":"faction","inventory_type":"inventory_type","region":"region","solar_system":"solar_system","station":"station","structure":"structure"},"key":["character_id"]},"get_characters_character_id_ship":{"table":"chr_ship","fields":{"character_id":"character_id","user_id":"user_id","ship_item_id":"ship_item_id","ship_name":"ship_name","ship_type_id":"ship_type_id"},"key":["character_id"]},"get_characters_character_id_skillqueue":{"table":"chr_skillqueue","fields":{"character_id":"character_id","user_id":"user_id","finish_date":"finish_date","finished_level":"finished_level","level_end_sp":"level_end_sp","level_start_sp":"level_start_sp","queue_position":"queue_position","skill_id":"skill_id","start_date":"start_date","training_start_sp":"training_start_sp"},"key":["character_id"]},"get_characters_character_id_skills":{"table":"chr_skill","fields":{"character_id":"character_id","user_id":"user_id","skills":"skills","total_sp":"total_sp","unallocated_sp":"unallocated_sp"},"key":["character_id"]},"get_characters_character_id_standings":{"table":"chr_standing","fields":{"character_id":"character_id","user_id":"user_id","from_id":"from_id","from_type":"from_type","standing":"standing"},"key":["character_id"]},"get_characters_character_id_titles":{"table":"chr_title","fields":{"character_id":"character_id","user_id":"user_id","name":"name","title_id":"title_id"},"key":["character_id"]},"get_characters_character_id_wallet":{"table":"chr_wallet","type":"primitive","fields":{"character_id":"character_id","user_id":"user_id","wallet_id":"wallet_id"},"key":["character_id"]},"get_characters_character_id_wallet_journal":{"table":"chr_wallet_journal","fields":{"character_id":"character_id","user_id":"user_id","amount":"amount","balance":"balance","context_id":"context_id","context_id_type":"context_id_type","date":"date","description":"description","first_party_id":"first_party_id","id":"id","reason":"reason","ref_type":"ref_type","second_party_id":"second_party_id","tax":"tax","tax_receiver_id":"tax_receiver_id"},"key":["character_id"]},"get_characters_character_id_wallet_transactions":{"table":"chr_wallet_transaction","fields":{"character_id":"character_id","user_id":"user_id","client_id":"client_id","date":"date","is_buy":"is_buy","is_personal":"is_personal","journal_ref_id":"journal_ref_id","location_id":"location_id","quantity":"quantity","transaction_id":"transaction_id","type_id":"type_id","unit_price":"unit_price"},"key":["character_id"]},"get_contracts_public_bids_contract_id":{"table":"con_public_bid_contract","fields":{"contract_id":"contract_id","amount":"amount","bid_id":"bid_id","date_bid":"date_bid"},"key":["contract_id"]},"get_contracts_public_items_contract_id":{"table":"con_public_item_contract","fields":{"contract_id":"contract_id","is_blueprint_copy":"is_blueprint_copy","is_included":"is_included","item_id":"item_id","material_efficiency":"material_efficiency","quantity":"quantity","record_id":"record_id","runs":"runs","time_efficiency":"time_efficiency","type_id":"type_id"},"key":["contract_id"]},"get_contracts_public_region_id":{"table":"con_public_region","fields":{"region_id":"region_id","buyout":"buyout","collateral":"collateral","contract_id":"contract_id","date_expired":"date_expired","date_issued":"date_issued","days_to_complete":"days_to_complete","end_location_id":"end_location_id","for_corporation":"for_corporation","issuer_corporation_id":"issuer_corporation_id","issuer_id":"issuer_id","price":"price","reward":"reward","start_location_id":"start_location_id","title":"title","type":"type","volume":"volume"},"key":["region_id"]},"get_corporation_corporation_id_mining_extractions":{"table":"crp_mining_extraction","fields":{"corporation_id":"corporation_id","user_id":"user_id","chunk_arrival_time":"chunk_arrival_time","extraction_start_time":"extraction_start_time","moon_id":"moon_id","natural_decay_time":"natural_decay_time","structure_id":"structure_id"},"key":["corporation_id"]},"get_corporation_corporation_id_mining_observers":{"table":"crp_mining_observer","fields":{"corporation_id":"corporation_id","user_id":"user_id","last_updated":"last_updated","observer_id":"observer_id","observer_type":"observer_type"},"key":["corporation_id"]},"get_corporation_corporation_id_mining_observers_observer_id":{"table":"crp_mining_observer_dtl","fields":{"corporation_id":"corporation_id","observer_id":"observer_id","user_id":"user_id","character_id":"character_id","last_updated":"last_updated","quantity":"quantity","recorded_corporation_id":"recorded_corporation_id","type_id":"type_id"},"key":["corporation_id","observer_id"]},"get_corporations_npccorps":{"table":"crp_npccorp","type":"primitive","fields":{"npccorp_id":"npccorp_id"}},"get_corporations_corporation_id":{"table":"corporation","fields":{"corporation_id":"corporation_id","alliance_id":"alliance_id","ceo_id":"ceo_id","creator_id":"creator_id","date_founded":"date_founded","description":"description","faction_id":"faction_id","home_station_id":"home_station_id","member_count":"member_count","name":"name","shares":"shares","tax_rate":"tax_rate","ticker":"ticker","url":"url","war_eligible":"war_eligible"},"key":["corporation_id"]},"get_corporations_corporation_id_alliancehistory":{"table":"crp_alliancehistory","fields":{"corporation_id":"corporation_id","alliance_id":"alliance_id","is_deleted":"is_deleted","record_id":"record_id","start_date":"start_date"},"key":["corporation_id"]},"get_corporations_corporation_id_assets":{"table":"crp_asset","fields":{"corporation_id":"corporation_id","user_id":"user_id","is_blueprint_copy":"is_blueprint_copy","is_singleton":"is_singleton","item_id":"item_id","location_flag":"location_flag","location_id":"location_id","location_type":"location_type","quantity":"quantity","type_id":"type_id"},"key":["corporation_id"]},"get_corporations_corporation_id_blueprints":{"table":"crp_blueprint","fields":{"corporation_id":"corporation_id","user_id":"user_id","item_id":"item_id","location_flag":"location_flag","location_id":"location_id","material_efficiency":"material_efficiency","quantity":"quantity","runs":"runs","time_efficiency":"time_efficiency","type_id":"type_id"},"key":["corporation_id"]},"get_corporations_corporation_id_bookmarks":{"table":"crp_bookmark","fields":{"corporation_id":"corporation_id","user_id":"user_id","bookmark_id":"bookmark_id","coordinates":"coordinates","created":"created","creator_id":"creator_id","folder_id":"folder_id","item":"item","label":"label","location_id":"location_id","notes":"notes"},"key":["corporation_id"]},"get_corporations_corporation_id_bookmarks_folders":{"table":"crp_bookmark_folder","fields":{"corporation_id":"corporation_id","user_id":"user_id","creator_id":"creator_id","folder_id":"folder_id","name":"name"},"key":["corporation_id"]},"get_corporations_corporation_id_contacts":{"table":"crp_contact","fields":{"corporation_id":"corporation_id","user_id":"user_id","contact_id":"contact_id","contact_type":"contact_type","is_watched":"is_watched","label_ids":"label_ids","standing":"standing"},"key":["corporation_id"]},"get_corporations_corporation_id_contacts_labels":{"table":"crp_contact_label","fields":{"corporation_id":"corporation_id","user_id":"user_id","label_id":"label_id","label_name":"label_name"},"key":["corporation_id"]},"get_corporations_corporation_id_containers_logs":{"table":"crp_container_log","fields":{"corporation_id":"corporation_id","user_id":"user_id","action":"action","character_id":"character_id","container_id":"container_id","container_type_id":"container_type_id","location_flag":"location_flag","location_id":"location_id","logged_at":"logged_at","new_config_bitmask":"new_config_bitmask","old_config_bitmask":"old_config_bitmask","password_type":"password_type","quantity":"quantity","type_id":"type_id"},"key":["corporation_id"]},"get_corporations_corporation_id_contracts":{"table":"crp_contract","fields":{"corporation_id":"corporation_id","user_id":"user_id","acceptor_id":"acceptor_id","assignee_id":"assignee_id","availability":"availability","buyout":"buyout","collateral":"collateral","contract_id":"contract_id","date_accepted":"date_accepted","date_completed":"date_completed","date_expired":"date_expired","date_issued":"date_issued","days_to_complete":"days_to_complete","end_location_id":"end_location_id","for_corporation":"for_corporation","issuer_corporation_id":"issuer_corporation_id","issuer_id":"issuer_id","price":"price","reward":"reward","start_location_id":"start_location_id","status":"status","title":"title","type":"type","volume":"volume"},"key":["corporation_id"]},"get_corporations_corporation_id_contracts_contract_id_bids":{"table":"crp_contract_bid","fields":{"contract_id":"contract_id","corporation_id":"corporation_id","user_id":"user_id","amount":"amount","bid_id":"bid_id","bidder_id":"bidder_id","date_bid":"date_bid"},"key":["contract_id","corporation_id"]},"get_corporations_corporation_id_contracts_contract_id_items":{"table":"crp_contract_item","fields":{"contract_id":"contract_id","corporation_id":"corporation_id","user_id":"user_id","is_included":"is_included","is_singleton":"is_singleton","quantity":"quantity","raw_quantity":"raw_quantity","record_id":"record_id","type_id":"type_id"},"key":["contract_id","corporation_id"]},"get_corporations_corporation_id_customs_offices":{"table":"crp_customs_office","fields":{"corporation_id":"corporation_id","user_id":"user_id","alliance_tax_rate":"alliance_tax_rate","allow_access_with_standings":"allow_access_with_standings","allow_alliance_access":"allow_alliance_access","bad_standing_tax_rate":"bad_standing_tax_rate","corporation_tax_rate":"corporation_tax_rate","excellent_standing_tax_rate":"excellent_standing_tax_rate","good_standing_tax_rate":"good_standing_tax_rate","neutral_standing_tax_rate":"neutral_standing_tax_rate","office_id":"office_id","reinforce_exit_end":"reinforce_exit_end","reinforce_exit_start":"reinforce_exit_start","standing_level":"standing_level","system_id":"system_id","terrible_standing_tax_rate":"terrible_standing_tax_rate"},"key":["corporation_id"]},"get_corporations_corporation_id_divisions":{"table":"crp_div","fields":{"corporation_id":"corporation_id","user_id":"user_id","hangar":"hangar","wallet":"wallet"},"key":["corporation_id"]},"get_corporations_corporation_id_facilities":{"table":"crp_facility","fields":{"corporation_id":"corporation_id","user_id":"user_id","facility_id":"facility_id","system_id":"system_id","type_id":"type_id"},"key":["corporation_id"]},"get_corporations_corporation_id_fw_stats":{"table":"crp_fw_stat","fields":{"corporation_id":"corporation_id","user_id":"user_id","enlisted_on":"enlisted_on","faction_id":"faction_id","kills":"kills","pilots":"pilots","victory_points":"victory_points"},"key":["corporation_id"]},"get_corporations_corporation_id_icons":{"table":"crp_icon","fields":{"corporation_id":"corporation_id","px128x128":"px128x128","px256x256":"px256x256","px64x64":"px64x64"},"key":["corporation_id"]},"get_corporations_corporation_id_industry_jobs":{"table":"crp_industry_job","fields":{"corporation_id":"corporation_id","user_id":"user_id","activity_id":"activity_id","blueprint_id":"blueprint_id","blueprint_location_id":"blueprint_location_id","blueprint_type_id":"blueprint_type_id","completed_character_id":"completed_character_id","completed_date":"completed_date","cost":"cost","duration":"duration","end_date":"end_date","facility_id":"facility_id","installer_id":"installer_id","job_id":"job_id","licensed_runs":"licensed_runs","location_id":"location_id","output_location_id":"output_location_id","pause_date":"pause_date","probability":"probability","product_type_id":"product_type_id","runs":"runs","start_date":"start_date","status":"status","successful_runs":"successful_runs"},"key":["corporation_id"]},"get_corporations_corporation_id_killmails_recent":{"table":"crp_killmail_recent","fields":{"corporation_id":"corporation_id","user_id":"user_id","killmail_hash":"killmail_hash","killmail_id":"killmail_id"},"key":["corporation_id"]},"get_corporations_corporation_id_medals":{"table":"crp_medal","fields":{"corporation_id":"corporation_id","user_id":"user_id","created_at":"created_at","creator_id":"creator_id","description":"description","medal_id":"medal_id","title":"title"},"key":["corporation_id"]},"get_corporations_corporation_id_medals_issued":{"table":"crp_medal_issued","fields":{"corporation_id":"corporation_id","user_id":"user_id","character_id":"character_id","issued_at":"issued_at","issuer_id":"issuer_id","medal_id":"medal_id","reason":"reason","status":"status"},"key":["corporation_id"]},"get_corporations_corporation_id_members":{"table":"crp_member","type":"primitive","fields":{"corporation_id":"corporation_id","user_id":"user_id","member_id":"member_id"},"key":["corporation_id"]},"get_corporations_corporation_id_members_limit":{"table":"crp_member_limit","type":"primitive","fields":{"corporation_id":"corporation_id","user_id":"user_id","limit_id":"limit_id"},"key":["corporation_id"]},"get_corporations_corporation_id_members_titles":{"table":"crp_member_title","fields":{"corporation_id":"corporation_id","user_id":"user_id","character_id":"character_id","titles":"titles"},"key":["corporation_id"]},"get_corporations_corporation_id_membertracking":{"table":"crp_membertracking","fields":{"corporation_id":"corporation_id","user_id":"user_id","base_id":"base_id","character_id":"character_id","location_id":"location_id","logoff_date":"logoff_date","logon_date":"logon_date","ship_type_id":"ship_type_id","start_date":"start_date"},"key":["corporation_id"]},"get_corporations_corporation_id_orders":{"table":"crp_order","fields":{"corporation_id":"corporation_id","user_id":"user_id","duration":"duration","escrow":"escrow","is_buy_order":"is_buy_order","issued":"issued","issued_by":"issued_by","location_id":"location_id","min_volume":"min_volume","order_id":"order_id","price":"price","range":"range","region_id":"region_id","type_id":"type_id","volume_remain":"volume_remain","volume_total":"volume_total","wallet_division":"wallet_division"},"key":["corporation_id"]},"get_corporations_corporation_id_orders_history":{"table":"crp_order_history","fields":{"corporation_id":"corporation_id","user_id":"user_id","duration":"duration","escrow":"escrow","is_buy_order":"is_buy_order","issued":"issued","issued_by":"issued_by","location_id":"location_id","min_volume":"min_volume","order_id":"order_id","price":"price","range":"range","region_id":"region_id","state":"state","type_id":"type_id","volume_remain":"volume_remain","volume_total":"volume_total","wallet_division":"wallet_division"},"key":["corporation_id"]},"get_corporations_corporation_id_roles":{"table":"crp_role","fields":{"corporation_id":"corporation_id","user_id":"user_id","character_id":"character_id","grantable_roles":"grantable_roles","grantable_roles_at_base":"grantable_roles_at_base","grantable_roles_at_hq":"grantable_roles_at_hq","grantable_roles_at_other":"grantable_roles_at_other","roles":"roles","roles_at_base":"roles_at_base","roles_at_hq":"roles_at_hq","roles_at_other":"roles_at_other"},"key":["corporation_id"]},"get_corporations_corporation_id_roles_history":{"table":"crp_role_history","fields":{"corporation_id":"corporation_id","user_id":"user_id","changed_at":"changed_at","character_id":"character_id","issuer_id":"issuer_id","new_roles":"new_roles","old_roles":"old_roles","role_type":"role_type"},"key":["corporation_id"]},"get_corporations_corporation_id_shareholders":{"table":"crp_shareholder","fields":{"corporation_id":"corporation_id","user_id":"user_id","share_count":"share_count","shareholder_id":"shareholder_id","shareholder_type":"shareholder_type"},"key":["corporation_id"]},"get_corporations_corporation_id_standings":{"table":"crp_standing","fields":{"corporation_id":"corporation_id","user_id":"user_id","from_id":"from_id","from_type":"from_type","standing":"standing"},"key":["corporation_id"]},"get_corporations_corporation_id_starbases":{"table":"crp_starbase","fields":{"corporation_id":"corporation_id","user_id":"user_id","moon_id":"moon_id","onlined_since":"onlined_since","reinforced_until":"reinforced_until","starbase_id":"starbase_id","state":"state","system_id":"system_id","type_id":"type_id","unanchor_at":"unanchor_at"},"key":["corporation_id"]},"get_corporations_corporation_id_starbases_starbase_id":{"table":"crp_starbase_dtl","fields":{"corporation_id":"corporation_id","starbase_id":"starbase_id","system_id":"system_id","user_id":"user_id","allow_alliance_members":"allow_alliance_members","allow_corporation_members":"allow_corporation_members","anchor":"anchor","attack_if_at_war":"attack_if_at_war","attack_if_other_security_status_dropping":"attack_if_o757483785us_dropping","attack_security_status_threshold":"attack_secu698664890s_threshold","attack_standing_threshold":"attack_standing_threshold","fuel_bay_take":"fuel_bay_take","fuel_bay_view":"fuel_bay_view","fuels":"fuels","offline":"offline","online":"online","unanchor":"unanchor","use_alliance_standings":"use_alliance_standings"},"key":["corporation_id","starbase_id"]},"get_corporations_corporation_id_structures":{"table":"crp_structure","fields":{"corporation_id":"corporation_id","user_id":"user_id","fuel_expires":"fuel_expires","name":"name","next_reinforce_apply":"next_reinforce_apply","next_reinforce_hour":"next_reinforce_hour","profile_id":"profile_id","reinforce_hour":"reinforce_hour","services":"services","state":"state","state_timer_end":"state_timer_end","state_timer_start":"state_timer_start","structure_id":"structure_id","system_id":"system_id","type_id":"type_id","unanchors_at":"unanchors_at"},"key":["corporation_id"]},"get_corporations_corporation_id_titles":{"table":"crp_title","fields":{"corporation_id":"corporation_id","user_id":"user_id","grantable_roles":"grantable_roles","grantable_roles_at_base":"grantable_roles_at_base","grantable_roles_at_hq":"grantable_roles_at_hq","grantable_roles_at_other":"grantable_roles_at_other","name":"name","roles":"roles","roles_at_base":"roles_at_base","roles_at_hq":"roles_at_hq","roles_at_other":"roles_at_other","title_id":"title_id"},"key":["corporation_id"]},"get_corporations_corporation_id_wallets":{"table":"crp_wallet","fields":{"corporation_id":"corporation_id","user_id":"user_id","balance":"balance","division":"division"},"key":["corporation_id"]},"get_corporations_corporation_id_wallets_division_journal":{"table":"crp_wallet_div_journal","fields":{"corporation_id":"corporation_id","division":"division","user_id":"user_id","amount":"amount","balance":"balance","context_id":"context_id","context_id_type":"context_id_type","date":"date","description":"description","first_party_id":"first_party_id","id":"id","reason":"reason","ref_type":"ref_type","second_party_id":"second_party_id","tax":"tax","tax_receiver_id":"tax_receiver_id"},"key":["corporation_id","division"]},"get_corporations_corporation_id_wallets_division_transactions":{"table":"crp_wallet_div_transaction","fields":{"corporation_id":"corporation_id","division":"division","user_id":"user_id","client_id":"client_id","date":"date","is_buy":"is_buy","journal_ref_id":"journal_ref_id","location_id":"location_id","quantity":"quantity","transaction_id":"transaction_id","type_id":"type_id","unit_price":"unit_price"},"key":["corporation_id","division"]},"get_dogma_attributes":{"table":"dgm_attribute","type":"primitive","fields":{"attribute_id":"attribute_id"}},"get_dogma_attributes_attribute_id":{"table":"dgm_attribute_dtl","fields":{"attribute_id":"attribute_id","default_value":"default_value","description":"description","display_name":"display_name","high_is_good":"high_is_good","icon_id":"icon_id","name":"name","published":"published","stackable":"stackable","unit_id":"unit_id"},"key":["attribute_id"]},"get_dogma_dynamic_items_type_id_item_id":{"table":"dgm_dynamic_item_type_item","fields":{"item_id":"item_id","type_id":"type_id","created_by":"created_by","dogma_attributes":"dogma_attributes","dogma_effects":"dogma_effects","mutator_type_id":"mutator_type_id","source_type_id":"source_type_id"},"key":["item_id","type_id"]},"get_dogma_effects":{"table":"dgm_effect","type":"primitive","fields":{"effect_id":"effect_id"}},"get_dogma_effects_effect_id":{"table":"dgm_effect_dtl","fields":{"effect_id":"effect_id","description":"description","disallow_auto_repeat":"disallow_auto_repeat","discharge_attribute_id":"discharge_attribute_id","display_name":"display_name","duration_attribute_id":"duration_attribute_id","effect_category":"effect_category","electronic_chance":"electronic_chance","falloff_attribute_id":"falloff_attribute_id","icon_id":"icon_id","is_assistance":"is_assistance","is_offensive":"is_offensive","is_warp_safe":"is_warp_safe","modifiers":"modifiers","name":"name","post_expression":"post_expression","pre_expression":"pre_expression","published":"published","range_attribute_id":"range_attribute_id","range_chance":"range_chance","tracking_speed_attribute_id":"tracking_speed_attribute_id"},"key":["effect_id"]},"get_fleets_fleet_id":{"table":"fleet","fields":{"fleet_id":"fleet_id","user_id":"user_id","is_free_move":"is_free_move","is_registered":"is_registered","is_voice_enabled":"is_voice_enabled","motd":"motd"},"key":["fleet_id"]},"get_fleets_fleet_id_members":{"table":"flt_member","fields":{"fleet_id":"fleet_id","user_id":"user_id","character_id":"character_id","join_time":"join_time","role":"role","role_name":"role_name","ship_type_id":"ship_type_id","solar_system_id":"solar_system_id","squad_id":"squad_id","station_id":"station_id","takes_fleet_warp":"takes_fleet_warp","wing_id":"wing_id"},"key":["fleet_id"]},"get_fleets_fleet_id_wings":{"table":"flt_wing","fields":{"fleet_id":"fleet_id","user_id":"user_id","id":"id","name":"name","squads":"squads"},"key":["fleet_id"]},"get_fw_leaderboards":{"table":"fw_leaderboard","fields":{"kills":"kills","victory_points":"victory_points"}},"get_fw_leaderboards_characters":{"table":"fw_leaderboard_character","fields":{"kills":"kills","victory_points":"victory_points"}},"get_fw_leaderboards_corporations":{"table":"fw_leaderboard_corporation","fields":{"kills":"kills","victory_points":"victory_points"}},"get_fw_stats":{"table":"fw_stat","fields":{"faction_id":"faction_id","kills":"kills","pilots":"pilots","systems_controlled":"systems_controlled","victory_points":"victory_points"}},"get_fw_systems":{"table":"fw_system","fields":{"contested":"contested","occupier_faction_id":"occupier_faction_id","owner_faction_id":"owner_faction_id","solar_system_id":"solar_system_id","victory_points":"victory_points","victory_points_threshold":"victory_points_threshold"}},"get_fw_wars":{"table":"fw_war","fields":{"against_id":"against_id","faction_id":"faction_id"}},"get_incursions":{"table":"incursions","fields":{"constellation_id":"constellation_id","faction_id":"faction_id","has_boss":"has_boss","infested_solar_systems":"infested_solar_systems","influence":"influence","staging_solar_system_id":"staging_solar_system_id","state":"state","type":"type"}},"get_industry_facilities":{"table":"ind_facility","fields":{"facility_id":"facility_id","owner_id":"owner_id","region_id":"region_id","solar_system_id":"solar_system_id","tax":"tax","type_id":"type_id"}},"get_industry_systems":{"table":"ind_system","fields":{"cost_indices":"cost_indices","solar_system_id":"solar_system_id"}},"get_insurance_prices":{"table":"ins_price","fields":{"levels":"levels","type_id":"type_id"}},"get_killmails_killmail_id_killmail_hash":{"table":"km_killmail_hash","fields":{"killmail_hash":"killmail_hash","killmail_id":"killmail_id","attackers":"attackers","killmail_time":"killmail_time","moon_id":"moon_id","solar_system_id":"solar_system_id","victim":"victim","war_id":"war_id"},"key":["killmail_hash","killmail_id"]},"get_loyalty_stores_corporation_id_offers":{"table":"lty_store_corporation_offer","fields":{"corporation_id":"corporation_id","ak_cost":"ak_cost","isk_cost":"isk_cost","lp_cost":"lp_cost","offer_id":"offer_id","quantity":"quantity","required_items":"required_items","type_id":"type_id"},"key":["corporation_id"]},"get_markets_groups":{"table":"mkt_group","type":"primitive","fields":{"group_id":"group_id"}},"get_markets_groups_market_group_id":{"table":"mkt_group_market_group","fields":{"market_group_id":"market_group_id","description":"description","name":"name","parent_group_id":"parent_group_id","types":"types"},"key":["market_group_id"]},"get_markets_prices":{"table":"mkt_price","fields":{"adjusted_price":"adjusted_price","average_price":"average_price","type_id":"type_id"}},"get_markets_structures_structure_id":{"table":"mkt_structure_dtl","fields":{"structure_id":"structure_id","user_id":"user_id","duration":"duration","is_buy_order":"is_buy_order","issued":"issued","location_id":"location_id","min_volume":"min_volume","order_id":"order_id","price":"price","range":"range","type_id":"type_id","volume_remain":"volume_remain","volume_total":"volume_total"},"key":["structure_id"]},"get_markets_region_id_history":{"table":"mkt_region_history","fields":{"region_id":"region_id","type_id":"type_id","average":"average","date":"date","highest":"highest","lowest":"lowest","order_count":"order_count","volume":"volume"},"key":["region_id"]},"get_markets_region_id_orders":{"table":"mkt_region_order","fields":{"order_type":"order_type","region_id":"region_id","duration":"duration","is_buy_order":"is_buy_order","issued":"issued","location_id":"location_id","min_volume":"min_volume","order_id":"order_id","price":"price","range":"range","system_id":"system_id","type_id":"type_id","volume_remain":"volume_remain","volume_total":"volume_total"},"key":["region_id"]},"get_markets_region_id_types":{"table":"mkt_region_type","type":"primitive","fields":{"region_id":"region_id","type_id":"type_id"},"key":["region_id"]},"get_opportunities_groups":{"table":"opp_group","type":"primitive","fields":{"group_id":"group_id"}},"get_opportunities_groups_group_id":{"table":"opp_group_dtl","fields":{"group_id":"group_id","connected_groups":"connected_groups","description":"description","name":"name","notification":"notification","required_tasks":"required_tasks"},"key":["group_id"]},"get_opportunities_tasks":{"table":"opp_task","type":"primitive","fields":{"task_id":"task_id"}},"get_opportunities_tasks_task_id":{"table":"opp_task_dtl","fields":{"task_id":"task_id","description":"description","name":"name","notification":"notification"},"key":["task_id"]},"get_route_origin_destination":{"table":"route_origin_destination","type":"primitive","fields":{"destination":"destination","origin":"origin","destination_id":"destination_id"},"key":["destination","origin"]},"get_search":{"table":"search","fields":{"categories":"categories","search":"search","agent":"agent","alliance":"alliance","character":"character","constellation":"constellation","corporation":"corporation","faction":"faction","inventory_type":"inventory_type","region":"region","solar_system":"solar_system","station":"station"}},"get_sovereignty_campaigns":{"table":"sov_campaign","fields":{"attackers_score":"attackers_score","campaign_id":"campaign_id","constellation_id":"constellation_id","defender_id":"defender_id","defender_score":"defender_score","event_type":"event_type","participants":"participants","solar_system_id":"solar_system_id","start_time":"start_time","structure_id":"structure_id"}},"get_sovereignty_map":{"table":"sov_map","fields":{"alliance_id":"alliance_id","corporation_id":"corporation_id","faction_id":"faction_id","system_id":"system_id"}},"get_sovereignty_structures":{"table":"sov_structure","fields":{"alliance_id":"alliance_id","solar_system_id":"solar_system_id","structure_id":"structure_id","structure_type_id":"structure_type_id","vulnerability_occupancy_level":"vulnerability_occupancy_level","vulnerable_end_time":"vulnerable_end_time","vulnerable_start_time":"vulnerable_start_time"}},"get_status":{"table":"status","fields":{"players":"players","server_version":"server_version","start_time":"start_time","vip":"vip"}},"get_universe_ancestries":{"table":"uni_ancestry","fields":{"bloodline_id":"bloodline_id","description":"description","icon_id":"icon_id","id":"id","name":"name","short_description":"short_description"}},"get_universe_asteroid_belts_asteroid_belt_id":{"table":"uni_asteroid_belt_dtl","fields":{"asteroid_belt_id":"asteroid_belt_id","name":"name","position":"position","system_id":"system_id"},"key":["asteroid_belt_id"]},"get_universe_bloodlines":{"table":"uni_bloodline","fields":{"bloodline_id":"bloodline_id","charisma":"charisma","corporation_id":"corporation_id","description":"description","intelligence":"intelligence","memory":"memory","name":"name","perception":"perception","race_id":"race_id","ship_type_id":"ship_type_id","willpower":"willpower"}},"get_universe_categories":{"table":"uni_category","type":"primitive","fields":{"category_id":"category_id"}},"get_universe_categories_category_id":{"table":"uni_category_category","fields":{"category_id":"category_id","groups":"groups","name":"name","published":"published"},"key":["category_id"]},"get_universe_constellations":{"table":"uni_constellation","type":"primitive","fields":{"constellation_id":"constellation_id"}},"get_universe_constellations_constellation_id":{"table":"uni_constellation_dtl","fields":{"constellation_id":"constellation_id","name":"name","position":"position","region_id":"region_id","systems":"systems"},"key":["constellation_id"]},"get_universe_factions":{"table":"uni_faction","fields":{"corporation_id":"corporation_id","description":"description","faction_id":"faction_id","is_unique":"is_unique","militia_corporation_id":"militia_corporation_id","name":"name","size_factor":"size_factor","solar_system_id":"solar_system_id","station_count":"station_count","station_system_count":"station_system_count"}},"get_universe_graphics":{"table":"uni_graphic","type":"primitive","fields":{"graphic_id":"graphic_id"}},"get_universe_graphics_graphic_id":{"table":"uni_graphic_dtl","fields":{"graphic_id":"graphic_id","collision_file":"collision_file","graphic_file":"graphic_file","icon_folder":"icon_folder","sof_dna":"sof_dna","sof_fation_name":"sof_fation_name","sof_hull_name":"sof_hull_name","sof_race_name":"sof_race_name"},"key":["graphic_id"]},"get_universe_groups":{"table":"uni_group","type":"primitive","fields":{"group_id":"group_id"}},"get_universe_groups_group_id":{"table":"uni_group_dtl","fields":{"group_id":"group_id","category_id":"category_id","name":"name","published":"published","types":"types"},"key":["group_id"]},"get_universe_moons_moon_id":{"table":"uni_moon_dtl","fields":{"moon_id":"moon_id","name":"name","position":"position","system_id":"system_id"},"key":["moon_id"]},"get_universe_planets_planet_id":{"table":"uni_planet_dtl","fields":{"planet_id":"planet_id","name":"name","position":"position","system_id":"system_id","type_id":"type_id"},"key":["planet_id"]},"get_universe_races":{"table":"uni_race","fields":{"alliance_id":"alliance_id","description":"description","name":"name","race_id":"race_id"}},"get_universe_regions":{"table":"uni_region","type":"primitive","fields":{"region_id":"region_id"}},"get_universe_regions_region_id":{"table":"uni_region_dtl","fields":{"region_id":"region_id","constellations":"constellations","description":"description","name":"name"},"key":["region_id"]},"get_universe_schematics_schematic_id":{"table":"uni_schematic_dtl","fields":{"schematic_id":"schematic_id","cycle_time":"cycle_time","schematic_name":"schematic_name"},"key":["schematic_id"]},"get_universe_stargates_stargate_id":{"table":"uni_stargate_dtl","fields":{"stargate_id":"stargate_id","destination":"destination","name":"name","position":"position","system_id":"system_id","type_id":"type_id"},"key":["stargate_id"]},"get_universe_stars_star_id":{"table":"uni_star_dtl","fields":{"star_id":"star_id","age":"age","luminosity":"luminosity","name":"name","radius":"radius","solar_system_id":"solar_system_id","spectral_class":"spectral_class","temperature":"temperature","type_id":"type_id"},"key":["star_id"]},"get_universe_stations_station_id":{"table":"uni_station_dtl","fields":{"station_id":"station_id","max_dockable_ship_volume":"max_dockable_ship_volume","name":"name","office_rental_cost":"office_rental_cost","owner":"owner","position":"position","race_id":"race_id","reprocessing_efficiency":"reprocessing_efficiency","reprocessing_stations_take":"reprocessing_stations_take","services":"services","system_id":"system_id","type_id":"type_id"},"key":["station_id"]},"get_universe_structures":{"table":"uni_structure","type":"primitive","fields":{"structure_id":"structure_id"}},"get_universe_structures_structure_id":{"table":"uni_structure_dtl","fields":{"structure_id":"structure_id","user_id":"user_id","name":"name","owner_id":"owner_id","position":"position","solar_system_id":"solar_system_id","type_id":"type_id"},"key":["structure_id"]},"get_universe_system_jumps":{"table":"uni_system_jump","fields":{"ship_jumps":"ship_jumps","system_id":"system_id"}},"get_universe_system_kills":{"table":"uni_system_kill","fields":{"npc_kills":"npc_kills","pod_kills":"pod_kills","ship_kills":"ship_kills","system_id":"system_id"}},"get_universe_systems":{"table":"uni_system","type":"primitive","fields":{"system_id":"system_id"}},"get_universe_systems_system_id":{"table":"uni_system_dtl","fields":{"system_id":"system_id","constellation_id":"constellation_id","name":"name","planets":"planets","position":"position","security_class":"security_class","security_status":"security_status","star_id":"star_id","stargates":"stargates","stations":"stations"},"key":["system_id"]},"get_universe_types":{"table":"uni_type","type":"primitive","fields":{"type_id":"type_id"}},"get_universe_types_type_id":{"table":"uni_type_dtl","fields":{"type_id":"type_id","capacity":"capacity","description":"description","dogma_attributes":"dogma_attributes","dogma_effects":"dogma_effects","graphic_id":"graphic_id","group_id":"group_id","icon_id":"icon_id","market_group_id":"market_group_id","mass":"mass","name":"name","packaged_volume":"packaged_volume","portion_size":"portion_size","published":"published","radius":"radius","volume":"volume"},"key":["type_id"]},"get_wars":{"table":"wars","type":"primitive","fields":{"wars_id":"wars_id"}},"get_wars_war_id":{"table":"war","fields":{"war_id":"war_id","aggressor":"aggressor","allies":"allies","declared":"declared","defender":"defender","finished":"finished","id":"id","mutual":"mutual","open_for_allies":"open_for_allies","retracted":"retracted","started":"started"},"key":["war_id"]},"get_wars_war_id_killmails":{"table":"war_killmail","fields":{"war_id":"war_id","killmail_hash":"killmail_hash","killmail_id":"killmail_id"},"key":["war_id"]}}}');