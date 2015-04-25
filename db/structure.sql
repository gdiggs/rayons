--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: item_counts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE item_counts (
    id integer NOT NULL,
    num integer,
    date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: item_counts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_counts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_counts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE item_counts_id_seq OWNED BY item_counts.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE items (
    id integer NOT NULL,
    title text,
    artist text,
    year integer,
    label text,
    format text,
    condition text,
    price_paid text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    color text,
    deleted boolean DEFAULT false,
    discogs_url text,
    notes text
);


--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- Name: rails_admin_histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rails_admin_histories (
    id integer NOT NULL,
    message text,
    username character varying,
    item integer,
    "table" character varying,
    month smallint,
    year bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rails_admin_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rails_admin_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rails_admin_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rails_admin_histories_id_seq OWNED BY rails_admin_histories.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY item_counts ALTER COLUMN id SET DEFAULT nextval('item_counts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rails_admin_histories ALTER COLUMN id SET DEFAULT nextval('rails_admin_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: item_counts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY item_counts
    ADD CONSTRAINT item_counts_pkey PRIMARY KEY (id);


--
-- Name: items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: rails_admin_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rails_admin_histories
    ADD CONSTRAINT rails_admin_histories_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_item_counts_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_counts_on_date ON item_counts USING btree (date);


--
-- Name: index_items_on_artist; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_artist ON items USING btree (artist);


--
-- Name: index_items_on_color; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_color ON items USING btree (color);


--
-- Name: index_items_on_condition; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_condition ON items USING btree (condition);


--
-- Name: index_items_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_created_at ON items USING btree (created_at);


--
-- Name: index_items_on_format; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_format ON items USING btree (format);


--
-- Name: index_items_on_label; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_label ON items USING btree (label);


--
-- Name: index_items_on_price_paid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_price_paid ON items USING btree (price_paid);


--
-- Name: index_items_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_title ON items USING btree (title);


--
-- Name: index_items_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_updated_at ON items USING btree (updated_at);


--
-- Name: index_items_on_year; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_items_on_year ON items USING btree (year);


--
-- Name: index_rails_admin_histories; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rails_admin_histories ON rails_admin_histories USING btree (item, "table", month, year);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: items_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx ON items USING gin (to_tsvector('english'::regconfig, title));


--
-- Name: items_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx1 ON items USING gin (to_tsvector('english'::regconfig, artist));


--
-- Name: items_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx2 ON items USING gin (to_tsvector('english'::regconfig, label));


--
-- Name: items_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx3 ON items USING gin (to_tsvector('english'::regconfig, format));


--
-- Name: items_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx4 ON items USING gin (to_tsvector('english'::regconfig, condition));


--
-- Name: items_to_tsvector_idx5; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx5 ON items USING gin (to_tsvector('english'::regconfig, color));


--
-- Name: items_to_tsvector_idx6; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX items_to_tsvector_idx6 ON items USING gin (to_tsvector('english'::regconfig, notes));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130223220750');

INSERT INTO schema_migrations (version) VALUES ('20130223223654');

INSERT INTO schema_migrations (version) VALUES ('20130224014932');

INSERT INTO schema_migrations (version) VALUES ('20130224014933');

INSERT INTO schema_migrations (version) VALUES ('20130224161425');

INSERT INTO schema_migrations (version) VALUES ('20130224180111');

INSERT INTO schema_migrations (version) VALUES ('20130609180946');

INSERT INTO schema_migrations (version) VALUES ('20140112194406');

INSERT INTO schema_migrations (version) VALUES ('20140316192819');

INSERT INTO schema_migrations (version) VALUES ('20140913205342');

INSERT INTO schema_migrations (version) VALUES ('20140928174302');

