--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

-- Started on 2020-12-08 22:47:00 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16385)
-- Name: _fluent_migrations; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public._fluent_migrations (
    id uuid NOT NULL,
    name text NOT NULL,
    batch bigint NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public._fluent_migrations OWNER TO vaporuser;

--
-- TOC entry 204 (class 1259 OID 16403)
-- Name: activities; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.activities (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    title text NOT NULL,
    organization_id uuid NOT NULL,
    is_disabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.activities OWNER TO vaporuser;

--
-- TOC entry 207 (class 1259 OID 16446)
-- Name: appointments; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.appointments (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    details text NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    ends_at timestamp with time zone NOT NULL,
    private boolean NOT NULL,
    place text,
    price double precision,
    client_id uuid,
    employee_id uuid NOT NULL,
    activity_id uuid,
    organization_id uuid NOT NULL,
    is_online boolean DEFAULT false
);


ALTER TABLE public.appointments OWNER TO vaporuser;

--
-- TOC entry 205 (class 1259 OID 16416)
-- Name: clients; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.clients (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    email text NOT NULL,
    hashed_password text,
    refresh_token text,
    organization_id uuid NOT NULL
);


ALTER TABLE public.clients OWNER TO vaporuser;

--
-- TOC entry 208 (class 1259 OID 16474)
-- Name: employee+activity; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public."employee+activity" (
    id uuid NOT NULL,
    activity_id uuid NOT NULL,
    employee_id uuid NOT NULL
);


ALTER TABLE public."employee+activity" OWNER TO vaporuser;

--
-- TOC entry 206 (class 1259 OID 16431)
-- Name: employees; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.employees (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    name text NOT NULL,
    can_add_client boolean NOT NULL,
    role text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    hashed_password text,
    refresh_token text,
    organization_id uuid NOT NULL
);


ALTER TABLE public.employees OWNER TO vaporuser;

--
-- TOC entry 211 (class 1259 OID 16515)
-- Name: jitsi_consultations; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.jitsi_consultations (
    id uuid NOT NULL,
    appointment_id uuid NOT NULL,
    subject text NOT NULL,
    token text NOT NULL
);


ALTER TABLE public.jitsi_consultations OWNER TO vaporuser;

--
-- TOC entry 203 (class 1259 OID 16395)
-- Name: organizations; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.organizations (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    name text NOT NULL,
    addresses text[] NOT NULL,
    details text NOT NULL,
    can_client_contact_employees boolean NOT NULL,
    client_personal_info_fields text[] NOT NULL,
    jitsi_url text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.organizations OWNER TO vaporuser;

--
-- TOC entry 210 (class 1259 OID 16504)
-- Name: password_resets; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.password_resets (
    id uuid NOT NULL,
    subject_email text NOT NULL,
    validation_code bigint NOT NULL
);


ALTER TABLE public.password_resets OWNER TO vaporuser;

--
-- TOC entry 209 (class 1259 OID 16491)
-- Name: personal_infos; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.personal_infos (
    id uuid NOT NULL,
    key text NOT NULL,
    value text NOT NULL,
    client_id uuid NOT NULL
);


ALTER TABLE public.personal_infos OWNER TO vaporuser;

--
-- TOC entry 3034 (class 0 OID 16385)
-- Dependencies: 202
-- Data for Name: _fluent_migrations; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public._fluent_migrations (id, name, batch, created_at, updated_at) FROM stdin;
292bc6d2-4e65-405f-8dff-6cafc09a34ed	App.CreateOrganization	1	2020-11-01 10:08:14.813272+00	2020-11-01 10:08:14.813272+00
ff40ccb7-afa6-43fd-a89f-35f4a76a7571	App.CreateActivity	1	2020-11-01 10:08:14.891808+00	2020-11-01 10:08:14.891808+00
071620b5-2688-4568-aadb-3bba5bba9e59	App.CreateClient	1	2020-11-01 10:08:15.009186+00	2020-11-01 10:08:15.009186+00
f8fdf163-b1dd-4aa5-a320-72825142475e	App.CreateEmployee	1	2020-11-01 10:08:15.11405+00	2020-11-01 10:08:15.11405+00
20d18545-17bf-4ebf-a850-1dcc1264b15b	App.CreateAppointment	1	2020-11-01 10:08:15.192682+00	2020-11-01 10:08:15.192682+00
9ff15b56-dd7a-4a5d-80ea-4894083aded7	App.CreateEmployeeActivity	1	2020-11-01 10:08:15.27144+00	2020-11-01 10:08:15.27144+00
0b625569-575f-48db-ab18-6f1190fd3a4f	App.CreatePersonalInfo	1	2020-11-01 10:08:15.35167+00	2020-11-01 10:08:15.35167+00
be4e03df-b952-4025-b6d7-8530b58241c9	App.CreateTestData	1	2020-11-01 10:08:16.438851+00	2020-11-01 10:08:16.438851+00
a7775e37-06a1-4983-a49d-b767e81ddb8d	App.CreatePasswordReset	1	2020-11-01 10:08:16.517166+00	2020-11-01 10:08:16.517166+00
0e10e20f-3941-4c7b-a33b-0f742ab1c25b	App.UpdateActivityWithDisabled	1	2020-11-01 10:08:16.543326+00	2020-11-01 10:08:16.543326+00
4e8dafe1-5ffa-48c0-ad94-b47da0698ee2	App.UpdateOrganizationWithJitsiUrl	2	2020-11-02 23:08:43.816291+00	2020-11-02 23:08:43.816291+00
a4cf3c1a-cc94-4cf2-926e-3f20132bd12b	App.UpdateAppintmentWithOnline	2	2020-11-02 23:08:43.895626+00	2020-11-02 23:08:43.895626+00
9ecb9421-8c19-4fb4-a91d-8ac0c2b7465a	App.CreateJitsiConsultation	2	2020-11-02 23:08:44.030743+00	2020-11-02 23:08:44.030743+00
\.


--
-- TOC entry 3036 (class 0 OID 16403)
-- Dependencies: 204
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.activities (id, created_at, title, organization_id, is_disabled) FROM stdin;
2ea22442-acdc-4771-9f3a-724b638ae582	1604225296.267668	Arckezelés	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
15a007cb-2212-46c0-b82b-f431faa54508	1604225296.268423	Gyantázás	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
c6bf8714-96bb-420f-a9e5-f3b8d96b28e9	1604225296.268755	Sminkelés	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
\.


--
-- TOC entry 3039 (class 0 OID 16446)
-- Dependencies: 207
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.appointments (id, created_at, details, starts_at, ends_at, private, place, price, client_id, employee_id, activity_id, organization_id, is_online) FROM stdin;
1c030d02-9df5-4ef1-8fc6-f3bc65d33a3e	1604527167.626719	Egyéb információk	2020-12-10 07:30:00+00	2020-12-10 08:00:00+00	f	Online	200	c69066e4-178c-4b87-acf3-e327586cc5d6	350cdf7b-dbf8-42ac-84b6-c016058f5423	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
031f145f-b9cc-4115-aa2a-50a56db8b40e	1604430493.879548	Egyéb információk	2020-11-07 01:08:00+00	2020-11-07 02:08:00+00	f	Online	1000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
c2a64c3f-23a0-4ab4-bf51-82ced79eab75	1604603858.847781	Egyéb információk	2020-11-06 11:00:10.7+00	2020-11-06 12:00:10.7+00	f	Online	3000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	c6bf8714-96bb-420f-a9e5-f3b8d96b28e9	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
a4221d02-b186-4d22-82ef-8f6bbb46d2a1	1604604586.838614	Egyéb információk	2020-11-08 05:00:00+00	2020-11-08 06:05:00+00	f	Online	3000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	c6bf8714-96bb-420f-a9e5-f3b8d96b28e9	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
44edc379-fecf-427e-8cca-96ff2560ea75	1605100019.724893	Egyéb információk	2020-12-30 09:00:00+00	2020-12-30 09:10:00+00	f	Online	600	c69066e4-178c-4b87-acf3-e327586cc5d6	350cdf7b-dbf8-42ac-84b6-c016058f5423	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
a080091d-e2f4-4ea8-ab5b-104d23f0050a	1605533366.55016	Egyéb információk	2020-11-17 08:00:04.03+00	2020-11-17 17:00:04.03+00	f	Online	5000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
8d3f9109-f18d-4260-b8be-affc06fc0a9f	1605537408.434694	Egyéb információk	2020-11-17 00:36:40.635+00	2020-11-17 01:36:40.635+00	f	Online	2000	ba589ab2-1297-481f-80ce-a2fbc1ff173f	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
26b29473-32ec-4b5c-be73-7fe7730982b2	1605537579.0336208	Egyéb információk	2020-11-22 03:39:31.698+00	2020-11-22 04:39:31.698+00	f	Online	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
a2c7d27d-6e08-4581-8c60-7ac4c49364ef	1607457858.153527	Egyéb információk	2021-01-01 07:00:00+00	2021-01-01 07:05:00+00	f	Online	200	7207314f-918e-40d1-9e58-7d42fb328940	350cdf7b-dbf8-42ac-84b6-c016058f5423	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
1284b575-a8d8-46d9-bcc1-e7c0e790c57a	1607373997.239357	Egyéb információk	2020-12-31 11:00:00+00	2020-12-31 12:00:00+00	f	Online	400	c69066e4-178c-4b87-acf3-e327586cc5d6	350cdf7b-dbf8-42ac-84b6-c016058f5423	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
204f067a-8ec9-4307-a058-32ff213d9947	1604484220.257251	Egyéb információk	2020-11-07 02:03:31.122999+00	2020-11-07 03:03:31.122999+00	f	Online	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
8fbdb8a7-7dda-4b7b-91fe-d35344acfd5a	1604405326.667727	Egyéb információk	2020-11-06 13:08:39.362+00	2020-11-06 14:08:39.362+00	f	Online	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
198c003e-d6a2-4792-8a3c-da2757794f59	1604444557.6292481	Egyéb információk	2020-11-08 01:00:00+00	2020-11-08 02:00:00+00	f	Online	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
fd7fc4e8-d925-4197-b7f9-134a0508373d	1606937545.436063	Egyéb információk	2020-12-03 19:32:02.15+00	2020-12-03 20:32:02.15+00	f	Online	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
6aff7f6d-52ec-4d1a-9c02-49289c91bb51	1604225296.4178529	Egyéb információk	2020-10-30 10:08:15.366043+00	2020-10-30 12:08:15.3679+00	f	1117 Budapest, Béke út 24.	6000	c69066e4-178c-4b87-acf3-e327586cc5d6	b70de57e-8e07-477b-a26e-12a0bcd47d54	c6bf8714-96bb-420f-a9e5-f3b8d96b28e9	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
663fd083-490a-46b5-a41a-fa9a97544b94	1604427662.393307	Egyéb információk	2020-11-04 00:20:56.301+00	2020-11-04 01:20:56.301+00	f	Online	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
412c1587-7c22-4d2b-a250-333012d41613	1607463281.55777		2020-12-09 00:00:37.813999+00	2020-12-09 01:00:37.813999+00	f	1117 Budapest, Béke út 24.	3000	fa48ae2e-7756-42b5-acbb-a0602512f610	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
dc434b62-ca5c-4487-a5aa-58144b92ede3	1607265953.153517	Egyéb információk	2020-12-07 13:00:47.691999+00	2020-12-07 14:00:47.691999+00	f	Ügyfélnél	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
8af9fc10-2795-4b40-b664-90247d2eee04	1604255300.620086	Egyéb információk	2020-11-02 00:28:07.595+00	2020-11-02 01:28:07.595+00	f	1117 Budapest, Béke út 24.	2500	c69066e4-178c-4b87-acf3-e327586cc5d6	b70de57e-8e07-477b-a26e-12a0bcd47d54	c6bf8714-96bb-420f-a9e5-f3b8d96b28e9	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
3643e3fd-4cba-4cfe-99aa-61fc7236249d	1607265976.406853	Egyéb információk	2020-12-07 15:00:04.507+00	2020-12-07 16:00:04.507+00	f	Ügyfélnél	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
d39a61b4-d31e-440e-9cbb-77dec52877af	1607265995.334975	Egyéb információk	2020-12-07 17:00:24.994999+00	2020-12-07 18:00:24.994999+00	f	Ügyfélnél	2000	059a3378-b0ea-4919-bd5c-bb99500f1194	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
1d9644df-48ab-4489-9a4e-9fffe42c337d	1604255933.824744	Egyéb információk	2020-11-04 03:38:46.675+00	2020-11-04 04:38:46.675+00	t	1117 Budapest, Béke út 24.	\N	\N	b70de57e-8e07-477b-a26e-12a0bcd47d54	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
c00fa143-d18d-4c5a-99ee-ab87267346d1	1604269471.414167	Egyéb információk	2020-11-09 23:24:15.93+00	2020-11-10 00:24:15.93+00	f	1117 Budapest, Béke út 24.	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
c65acfc9-0f2e-44c3-bf81-e368ea33674a	1604525897.232326	Egyéb információk	2020-12-01 08:00:00+00	2020-12-01 08:05:00+00	f	1117 Budapest, Béke út 24.	100	c69066e4-178c-4b87-acf3-e327586cc5d6	350cdf7b-dbf8-42ac-84b6-c016058f5423	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
679f9c96-085c-48af-b90d-7a6cb791154f	1607356961.677026	Egyéb információk	2020-12-07 18:00:23.591+00	2020-12-07 18:30:23.591+00	f	Ügyfélnél	2000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
41828cf7-8503-403a-adf4-416e2444f25c	1607261697.727727	Egyéb információk	2020-12-07 23:00:44.211+00	2020-12-08 00:00:44.211+00	f	Ügyfélnél	2000	059a3378-b0ea-4919-bd5c-bb99500f1194	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
acf0a690-d886-4de2-a573-a40f947781f7	1604270992.447223	Egyéb információk	2020-11-04 01:00:39.088+00	2020-11-04 02:00:39.088+00	f	1117 Budapest, Béke út 24.	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
a8b68251-3193-486c-9d57-b77655fe66bf	1607379110.0192919	Egyéb információk	2020-12-10 13:00:44.125+00	2020-12-10 14:00:44.125+00	f	1117 Budapest, Béke út 24.	7000	b796dc72-b116-4281-8af6-397d7c29af60	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
88fcdae3-1e3e-4e05-8fe0-103911b5e99c	1607265937.6405911	Egyéb információk	2020-12-07 09:00:28.464+00	2020-12-07 10:00:28.464+00	f	Ügyfélnél	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
f10e7cb1-a019-4aa6-ab7f-e3b368ef9177	1606147426.6656241	Egyéb információk	2020-11-24 00:03:43.733+00	2020-11-24 01:03:43.733+00	f	1117 Budapest, Béke út 24.	4000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
a8d17d28-dff6-4c6b-b59c-b514e0f18fde	1604430454.546597	Egyéb információk	2020-11-06 03:07:24.402+00	2020-11-06 04:07:24.402+00	t	1117 Budapest, Béke út 24.	\N	\N	b70de57e-8e07-477b-a26e-12a0bcd47d54	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	\N
11730323-c156-42d8-b8b4-8cd238bc2d9e	1607357375.06606	Egyéb információk	2020-12-07 20:00:30.515+00	2020-12-07 20:30:30.515+00	f	Ügyfélnél	2000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
2a9e5b54-e749-4470-b9cb-82be1c30aabc	1605280091.473067	Egyéb információk	2020-11-15 00:07:53.737+00	2020-11-15 01:07:53.737+00	f	1117 Budapest, Béke út 24.	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
86f00330-47e5-46f4-944d-55e5946ac556	1605306788.7449322	Egyéb információk	2020-11-15 01:32:54.744+00	2020-11-15 02:32:54.744+00	f	1117 Budapest, Béke út 24.	1000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
67add30d-9299-4dde-82c2-ad1f8a87594a	1604522829.332374	Egyéb információk	2020-11-30 12:00:00+00	2020-11-30 12:10:00+00	f	1117 Budapest, Béke út 24.	200	c69066e4-178c-4b87-acf3-e327586cc5d6	350cdf7b-dbf8-42ac-84b6-c016058f5423	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
9f70b60c-09af-47e8-a73d-250217d53c92	1604245200.753703	Egyéb információk	2020-11-14 01:39:47.224999+00	2020-11-14 02:39:47.224999+00	f	1117 Budapest, Béke út 24.	2588	c69066e4-178c-4b87-acf3-e327586cc5d6	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
1ca7605c-9ef7-432a-91c9-a13b8c432ca6	1607378904.688561	Egyéb információk	2020-12-09 21:00:16.303999+00	2020-12-09 22:00:16.303999+00	f	1117 Budapest, Béke út 24.	3000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
9b2e89c4-7599-4553-a8da-dfe82e669dd4	1607461363.24705	Egyéb információk	2020-12-12 21:02:39.142+00	2020-12-12 22:02:39.142+00	f	Ügyfélnél	5000	6c71253b-a200-4782-8685-eca6396b49b3	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
4cefc1cd-4132-4c5d-9e8c-697ca3053416	1607462160.105214	Egyéb információk	2020-12-09 01:00:36.079+00	2020-12-09 02:00:36.079+00	f	1117 Budapest, Béke út 24.	3000	6c71253b-a200-4782-8685-eca6396b49b3	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
e7da0570-e781-48a8-8dbf-30508a6f47e1	1605537197.7080731	Egyéb információk	2020-11-22 00:33:12.786+00	2020-11-22 01:33:12.786+00	f	1117 Budapest, Béke út 24.	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
f3b151ad-b110-4269-b21d-3c4ff070d635	1606001792.88973	Egyéb információk	2020-11-23 00:36:21.084+00	2020-11-23 01:36:21.084+00	f	1117 Budapest, Béke út 24.	1000	ba589ab2-1297-481f-80ce-a2fbc1ff173f	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
607992bd-4fdb-41d8-b2b4-93e509f021dd	1605973219.599331	Egyéb információk	2020-11-22 01:00:44.413+00	2020-11-22 02:00:44.413+00	f	1117 Budapest, Béke út 24.	3000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
e72f7b46-9285-4abd-94c9-b8c52bf4a5d9	1606147442.033818	Egyéb információk	2020-11-26 02:03:57.278+00	2020-11-26 03:03:57.278+00	f	1117 Budapest, Béke út 24.	4000	fa48ae2e-7756-42b5-acbb-a0602512f610	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
97101d1d-e99c-4667-93a1-3a4f639b04ec	1606144915.481802	Egyéb információk	2020-11-27 02:00:49.471+00	2020-11-27 03:00:49.471+00	f	1117 Budapest, Béke út 24.	4000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
20bb7000-1a19-493d-93a4-540092bf2629	1606151061.7075171	Egyéb információk	2020-11-27 00:04:15.427+00	2020-11-27 01:04:15.427+00	t	1117 Budapest, Béke út 24.	\N	\N	b70de57e-8e07-477b-a26e-12a0bcd47d54	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	\N
5033af94-1d1b-4b36-8c0d-90b42cf2fbd7	1607456371.252058	Egyéb információk	2020-12-09 00:00:25.655+00	2020-12-09 01:00:25.655+00	f	Ügyfélnél	5000	b796dc72-b116-4281-8af6-397d7c29af60	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
48284cd9-e0af-48e7-927d-bdfd6bf0a162	1607243988.184504	Egyéb információk	2020-12-07 01:00:38.611+00	2020-12-07 02:00:38.611+00	f	1117 Budapest, Béke út 24.	3000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
6ddeed79-4434-4e20-9d16-9f00ee1071cd	1607244069.173506	Egyéb információk	2020-12-07 02:00:53.532+00	2020-12-07 03:00:53.532+00	f	Ügyfélnél	2000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
9387fc73-105b-4b18-b4ca-52fe14d4f6d6	1607379135.589129	Egyéb információk	2020-12-10 12:00:09.983+00	2020-12-10 13:00:09.983+00	f	1117 Budapest, Béke út 24.	7000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
12336279-c3df-4e1e-9d4d-cb37108b91c3	1607357031.334858	Egyéb információk	2020-12-07 19:00:43.431+00	2020-12-07 19:30:43.431+00	f	Ügyfélnél	2000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
3d8e21f7-846a-4525-a347-9fc1890e5dc8	1607357206.606065	Egyéb információk	2020-12-07 22:00:40.688999+00	2020-12-07 22:30:40.688999+00	f	Ügyfélnél	2000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
9c4f93f1-b495-4f51-ba72-5e8a7fb42a5c	1607357178.007062	Egyéb információk	2020-12-07 21:00:18.256+00	2020-12-07 21:30:18.256+00	f	Ügyfélnél	2000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
eed8538d-745d-4ef0-b122-993c2175a6e4	1607387740.356621	Egyéb információk	2020-12-10 02:00:32.384+00	2020-12-10 03:00:32.384+00	f	1117 Budapest, Béke út 24.	7000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
5a137902-e6cb-4013-a2bc-51f092132ca4	1605459131.7960129	Egyéb információk	2020-11-16 00:51:52.19+00	2020-11-16 01:51:52.19+00	f	1117 Budapest, Béke út 24.	5000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
fbe782b7-66c2-4cbd-a8dd-3bdab2947732	1605526168.945712	Egyéb információk	2020-11-18 00:29:01.489+00	2020-11-18 01:29:01.489+00	f	1117 Budapest, Béke út 24.	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
d57e56eb-3d4e-42c0-8b73-b1abe3915d89	1607413276.528554	Egyéb információk	2020-12-10 07:41:10.405+00	2020-12-10 08:41:10.405+00	f	1117 Budapest, Béke út 24.	7000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
d747d3b4-2b80-481b-9ff2-71e5afd5aadc	1607413284.632194	Egyéb információk	2020-12-11 07:41:21.177+00	2020-12-11 08:41:21.177+00	f	1117 Budapest, Béke út 24.	7000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
e4e88951-998f-4176-937d-1c8811a16897	1607378146.674701	Egyéb információk	2020-12-08 14:00:00+00	2020-12-08 15:00:00+00	f	1117 Budapest, Béke út 24.	4000	7207314f-918e-40d1-9e58-7d42fb328940	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
b98e9965-c275-4cdb-84d1-9ae6fcbf0b8c	1607366514.570507	Egyéb információk	2020-12-08 04:00:36.296999+00	2020-12-08 05:00:36.296999+00	f	1117 Budapest, Béke út 24.	3000	7d5ea0da-e3fc-4560-9f20-33a62d09ac94	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
0f2902de-8a85-48ea-b85d-26e04dd3cfa9	1607370437.8129768	Egyéb információk	2020-12-08 01:00:33.21+00	2020-12-08 02:00:33.21+00	f	1117 Budapest, Béke út 24.	2000	4009a3bd-2429-4038-b66a-30dd380b0dec	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
82d1be0e-30f2-4b21-8df7-ad6e7ff2d013	1607378104.353094	Egyéb információk	2020-12-08 12:00:47.586999+00	2020-12-08 13:00:47.586999+00	f	1117 Budapest, Béke út 24.	3000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
b78f644c-49d5-4167-b85c-bc889fc3c946	1607378230.2365332	Egyéb információk	2020-12-08 17:00:59.579999+00	2020-12-08 18:30:59.579999+00	f	1117 Budapest, Béke út 24.	7500	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
9d8bac3b-895e-4990-b1d2-3d927535ee2e	1607378244.131102	Egyéb információk	2020-12-09 17:00:16.27+00	2020-12-09 18:30:16.27+00	f	1117 Budapest, Béke út 24.	7500	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
71857144-75dd-4239-b76f-566936233189	1607378288.629263	Egyéb információk	2020-12-15 12:00:57.283999+00	2020-12-15 13:00:57.283999+00	f	1117 Budapest, Béke út 24.	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
ca85656b-80a6-4353-bb2f-bbf17e71ca3a	1607378368.415254	Egyéb információk	2020-12-16 13:00:14.859+00	2020-12-16 14:00:14.859+00	f	1117 Budapest, Béke út 24.	9000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
c1a2a0a2-92b8-47b0-9f25-21c7170032cc	1607453420.4654179	Egyéb információk	2020-12-17 18:50:15.417+00	2020-12-17 19:50:15.417+00	f	Ügyfélnél	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
d9d4bdff-1002-4841-a565-1ae6d115cb53	1607366810.496307	Egyéb információk	2020-12-08 09:00:37.461+00	2020-12-08 10:30:37.461+00	f	Online	7500	be4c3dad-b836-4164-a9a1-d716976493ea	b70de57e-8e07-477b-a26e-12a0bcd47d54	15a007cb-2212-46c0-b82b-f431faa54508	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	t
cd53bb38-d722-44ca-97b6-7d933845f5c6	1607372516.168942	Egyéb információk	2020-12-08 20:21:47.734+00	2020-12-08 21:21:47.734+00	f	1117 Budapest, Béke út 24.	5000	e144f3aa-7e65-4cf0-b044-8d99d792d3e8	b70de57e-8e07-477b-a26e-12a0bcd47d54	2ea22442-acdc-4771-9f3a-724b638ae582	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	f
\.


--
-- TOC entry 3037 (class 0 OID 16416)
-- Dependencies: 205
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.clients (id, created_at, name, phone, email, hashed_password, refresh_token, organization_id) FROM stdin;
fa48ae2e-7756-42b5-acbb-a0602512f610	1604270554.873733	Molnár Fruzsi	+36308657678	nagyeva2@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
851a13c7-1888-44c2-bb30-e7e3a6def27b	1604429345.624089	Nagy Bernadett	+36307689098	eszty.bajmoczty@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
1a7907db-1c07-491d-8293-dff57e574f09	1605050380.7231221	Kiss Gábor	+36809878797	g@gmail.con	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
36853cb0-fd0e-4c4c-b799-590736bba43c	1605306081.730308	Kiss Szilvia	09090909098	eszty.bajmoczy+@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
ba589ab2-1297-481f-80ce-a2fbc1ff173f	1605537336.953703	Nagy Magdolna	09090909098	eszty.bajmoczy+nm@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStubUBnbWFpbC5jb20iLCJleHAiOjE2MDgxMjkzMDUuNjM5NjQ2LCJwdXIiOiJyZWZyZXNoIn0.bDz60Bh6wqQ0JCnCVi-TZgjhcDXaOgylX7RcEgXCwM8	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
087c16c0-5cb9-408c-bf6a-2faf88acf35d	1605538554.914408	Szűcs Anna	09090909098	eszty.bajmoczy+sza@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5K3N6YUBnbWFpbC5jb20iLCJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjA4MTMwNTIzLjE4OTgzMSwic3ViIjoidXNlcit0b2tlbiJ9.kHRRiYJidi_EUZxtRexnyA54YmeT1NWq-fk2h9aAZtQ	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
059a3378-b0ea-4919-bd5c-bb99500f1194	1605539392.59091	Nagy Dorottya	09090909098	eszty.bajmoczy+nd@gmail.com	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImVzenR5LmJham1vY3p5K25kQGdtYWlsLmNvbSIsImV4cCI6MTYwODEzMTUxMC4wNTc4OTEsInN1YiI6InVzZXIrdG9rZW4iLCJwdXIiOiJyZWZyZXNoIn0.12EgisHrUVHn_IIAFnGBNRFL9ghR8msNgegUNQeyeBE	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
99e51c00-5c33-480a-a836-e0bce4077c9b	1606472016.565861	Ács Anna	+36363636365	eszty.bajmoczy-aa@gmail.com	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjA5MDYzOTU1Ljg4MTU0NSwiaWQiOiJlc3p0eS5iYWptb2N6eS1hYUBnbWFpbC5jb20iLCJzdWIiOiJ1c2VyK3Rva2VuIn0.b_CtA4u8isIZ8QlGDZODAr44aSeqqsxwOKv3BDQ9vGA	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
c69066e4-178c-4b87-acf3-e327586cc5d6	1604225296.269153	Simon Adél	+36701212345	eszty.bajmoczy@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImV4cCI6MTYwNzkwNTE3My45NTgwNDc5LCJzdWIiOiJ1c2VyK3Rva2VuIiwicHVyIjoicmVmcmVzaCJ9.DGAvhXbGMXjbi1BRHR4kaCcN62q5kObScTAy0l6V9yE	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
0041bb64-67cf-4109-b65e-a14255f08726	1605539943.509372	Nagy Nóra	09090909098	eszty.bajmoczy+nn@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5K25uQGdtYWlsLmNvbSIsInB1ciI6InJlZnJlc2giLCJzdWIiOiJ1c2VyK3Rva2VuIiwiZXhwIjoxNjA4MTMxOTE2LjIwOTg3OX0.hqI_x1ilCukVadq3X4xx4eRd9gNP6VfSF1uLuSzKXK4	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
39359c8c-5994-4ffc-90e3-bc8067a00d8a	1605550826.671472	Nagy Andrea	09090909098	eszty.bajmoczy+na@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDgxNDMwOTEuMjQ2OTkyLCJzdWIiOiJ1c2VyK3Rva2VuIiwicHVyIjoicmVmcmVzaCIsImlkIjoiZXN6dHkuYmFqbW9jenkrbmFAZ21haWwuY29tIn0.9LtbT5-SNRfPaoNHCshjgidX8xXI66MC7z627mnK6c0	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
6a0bf0c8-b096-494d-bf31-3939bfb14c85	1607430741.681572	Szép Levente	+36707070777	szeplevi@xyzqw.yy	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
876e646e-8108-4dba-baa5-67af6ba4928a	1605536450.624557	Nagy Ildikó	09090909098	eszty.bajmoczy+ni@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDgxMjg1NzQuMDU2MjUyLCJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStuaUBnbWFpbC5jb20iLCJwdXIiOiJyZWZyZXNoIn0.VUtf5jf-dZk6Pl2rQAFk6IXI3XgUi-R17Q2Ds8fMCiA	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
cbc30cd5-886b-4b94-8364-a407288edee2	1604270965.4841518	Kiss Emma	+36408764656	nagyeva4@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
e144f3aa-7e65-4cf0-b044-8d99d792d3e8	1604269344.252203	Kiss Anna	+36308765454	nagyeva@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
b796dc72-b116-4281-8af6-397d7c29af60	1607456227.904922	Nagy Szilvia	+36909089090	eszty.bajmoczy+nsz@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjEwMDQ4MTc2LjM4MDA5LCJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStuc3pAZ21haWwuY29tIn0.B44Hxhk9aSXorrju90shS-Q5oe9qS0LUdF_KYPn2i5w	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
4009a3bd-2429-4038-b66a-30dd380b0dec	1607369535.5369248	Poll Andrea	+36301234567	andrea.poll07@ gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
7d5ea0da-e3fc-4560-9f20-33a62d09ac94	1605306733.046304	Kovács Katalin	09090909098	eszty.bajmoczy+kk@gmail.com	\N	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyK3Rva2VuIiwicHVyIjoicmVmcmVzaCIsImV4cCI6MTYwOTk2Mjc3NS44Mzg1NiwiaWQiOiJlc3p0eS5iYWptb2N6eStra0BnbWFpbC5jb20ifQ.ytPGbWvJx-jasm3iaUKqHqvt4RDbRK8MX_lyX5NN-70	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
6c71253b-a200-4782-8685-eca6396b49b3	1607456808.096556	Nagy Anna Sára	+369809098	eszty.bajmoczy+nas@gmail.com	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MTAwNTQ0NjguNTE1MzMyLCJwdXIiOiJyZWZyZXNoIiwiaWQiOiJlc3p0eS5iYWptb2N6eStuYXNAZ21haWwuY29tIiwic3ViIjoidXNlcit0b2tlbiJ9.IAxgHCh-Yn17NTOkAGP7v9iTxCT2ZqDjWUMQBrpNwVo	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
7207314f-918e-40d1-9e58-7d42fb328940	1607370491.699563	Poll Andris	+369809098	andrea.poll07+a@gmail.com	\N	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImFuZHJlYS5wb2xsMDcrYUBnbWFpbC5jb20iLCJzdWIiOiJ1c2VyK3Rva2VuIiwiZXhwIjoxNjA5OTYyODM5LjQ4MjE1MSwicHVyIjoicmVmcmVzaCJ9.XOBnSyaa4xF0Zu9ovpn67wrygv5FSIRPr69k92aARsA	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
7e1e1ca8-7a03-4493-808b-e0606c04f630	1607370171.175518	Poll Andi	+369809098	poll.andrea07@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
be4c3dad-b836-4164-a9a1-d716976493ea	1607370368.414349	Poll Andrea	+369809098	andrea.poll07@gmail.com	\N	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
\.


--
-- TOC entry 3040 (class 0 OID 16474)
-- Dependencies: 208
-- Data for Name: employee+activity; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public."employee+activity" (id, activity_id, employee_id) FROM stdin;
620803e8-96a8-456f-bd05-ab6cb0e2a52b	15a007cb-2212-46c0-b82b-f431faa54508	b70de57e-8e07-477b-a26e-12a0bcd47d54
daeadf35-8b70-4239-9503-fe76eca3fa8d	2ea22442-acdc-4771-9f3a-724b638ae582	350cdf7b-dbf8-42ac-84b6-c016058f5423
96801f34-e0f0-4048-be60-5c87b1bd37d4	15a007cb-2212-46c0-b82b-f431faa54508	350cdf7b-dbf8-42ac-84b6-c016058f5423
c1ecdd16-3af5-4faa-8a9a-0751c5a17af6	c6bf8714-96bb-420f-a9e5-f3b8d96b28e9	350cdf7b-dbf8-42ac-84b6-c016058f5423
a359db5f-1752-4d6b-8448-f09e4919f5d4	2ea22442-acdc-4771-9f3a-724b638ae582	b70de57e-8e07-477b-a26e-12a0bcd47d54
\.


--
-- TOC entry 3038 (class 0 OID 16431)
-- Dependencies: 206
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.employees (id, created_at, name, can_add_client, role, email, phone, hashed_password, refresh_token, organization_id) FROM stdin;
b70de57e-8e07-477b-a26e-12a0bcd47d54	1604225296.332563	Nagy Éva	t	general	eszty.bajmoczy@gmail.com	+36209876543	$2b$12$beVmVFvErZfa68dDG/hkmejB4x6xSjMnRNdHowSAtIfESwTxyyuYe	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbit0b2tlbiIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwicHVyIjoicmVmcmVzaCIsImV4cCI6MTYxMDA1NTEzNC4zNTk4Mjl9.2vHvHaNv18ZJ9ODQINW4mfHy0kJeVsisLhMKldbyViQ	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
b8b1c2e0-b689-475f-8cef-93497e4d65b5	1604225296.365649	Mihály Kristóf	t	admin	mihaly.kristof97@gmail.com	+36309876543	$2b$12$dR7GZwPpudnPKC/atyC8PefS/cmCz90m4HK2twUY6gYLbxhXJGN/a	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
92ed109d-7653-479c-ac9f-e8d6bfb03d88	1604225296.366788	Simon Anna	t	defaultContact	simonanna@emailszolgaltato.xy	+36709876543	$2b$12$CEHXBNfBShOK.EP49zHa2u7HRvgJkJQzvcC6SelHS5o5YCA29IBCi	\N	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
350cdf7b-dbf8-42ac-84b6-c016058f5423	1604522167.582491	Teszt Elek	t	general	mihaly.kristof@edu.bme.hu	+36709123645	$2b$12$tGZNWg56O3KwRYtn96x7m.xIbLx9pLdwNySfbBqxr7Wmn4k7zrmFK	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwdXIiOiJyZWZyZXNoIiwic3ViIjoiYWRtaW4rdG9rZW4iLCJleHAiOjE2MDk1MzAzMTAuNzk0NjM5LCJpZCI6IjM1MENERjdCLURCRjgtNDJBQy04NEI2LUMwMTYwNThGNTQyMyJ9.Bm8G_Us8cdn2YigHa9czn89LJtGpkKKW3j_WjJT99Y4	a93faa86-ae9e-4dc2-a8a9-9c861d2821c0
\.


--
-- TOC entry 3043 (class 0 OID 16515)
-- Dependencies: 211
-- Data for Name: jitsi_consultations; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.jitsi_consultations (id, appointment_id, subject, token) FROM stdin;
5c580d14-151c-4ad7-b8ff-ce39d828fe3a	fd7fc4e8-d925-4197-b7f9-134a0508373d	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJGRDdGQzRFOC1EOTI1LTQxOTctQjdGOS0xMzRBMDUwODM3M0QiLCJzdWIiOiIqIiwibmJmIjoxNjA2OTM3NTQ1Ljc2NTQ3MiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDcwMjc1MjIuMTUsImNvbnRleHQiOnsidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9LCJncm91cCI6ImVtcGxveWVlIn19.ddpXjFTSqfN-uYtS3uF6HjE_vpjkqBf5u1wumAADPwg
339d7e65-a850-4069-9908-ddc599ccacd2	fd7fc4e8-d925-4197-b7f9-134a0508373d	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJGRDdGQzRFOC1EOTI1LTQxOTctQjdGOS0xMzRBMDUwODM3M0QiLCJzdWIiOiIqIiwibmJmIjoxNjA2OTM3NTQ1Ljc3NDI0NiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDcwMjc1MjIuMTUsImNvbnRleHQiOnsidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4In0sImdyb3VwIjoiY2xpZW50In19.bkzxofMpAcgrWuA6qieG6iDWe5SG-1NTnPc6ILyShJQ
6fa559a5-559a-4987-b25a-de7a50f3704e	198c003e-d6a2-4792-8a3c-da2757794f59	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsIm5iZiI6MTYwNDc3NTI4OC44OTA0MzgsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IjE5OEMwMDNFLUQ2QTItNDc5Mi04QTNDLURBMjc1Nzc5NEY1OSIsInN1YiI6IioiLCJleHAiOjE2MDQ4MDA4MDAsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwibmFtZSI6Ik5hZ3kgw4l2YSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImVtcGxveWVlIn19.NduXSmm2K4255t38kyvV7zQK21ce-XUzAl2FjA7XlIE
ff9ce5df-8143-4953-b0cb-446ec5439be2	204f067a-8ec9-4307-a058-32ff213d9947	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiMjA0RjA2N0EtOEVDOS00MzA3LUEwNTgtMzJGRjIxM0Q5OTQ3IiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsIm5hbWUiOiJOYWd5IMOJdmEiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0In0sImdyb3VwIjoiZW1wbG95ZWUifSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJleHAiOjE2MDQ3MTgyMTEuMTIyOTk5fQ.J1JuB_NAjGasUidRNtFkdQUWq3u6wZXDqQUaIezgEko
3f18125e-9a04-432d-b1b4-5e95929a982c	663fd083-490a-46b5-a41a-fa9a97544b94	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtaml0c2kiLCJleHAiOjE2MDQ0NTI4NTYuMzAxLCJzdWIiOiIqIiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJhdmF0YXIiOiIiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsIm5hbWUiOiJOYWd5IMOJdmEiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSJ9fSwicm9vbSI6IjY2M0ZEMDgzLTQ5MEEtNDZCNS1BNDFBLUZBOUE5NzU0NEI5NCJ9.tKSsThcaaI-YUVoxw351LzoX6KYaV4ueZjv939mPPVk
deacd0b3-c944-41a6-b711-cde9fd8ece67	663fd083-490a-46b5-a41a-fa9a97544b94	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtaml0c2kiLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJhdmF0YXIiOiIiLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCIsIm5hbWUiOiJLaXNzIEFubmEiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIn19LCJleHAiOjE2MDQ0NTI4NTYuMzAxLCJzdWIiOiIqIiwicm9vbSI6IjY2M0ZEMDgzLTQ5MEEtNDZCNS1BNDFBLUZBOUE5NzU0NEI5NCJ9.RASOs9AVmy4wvIu47x_YEK2Ij0QQXIOW6Vz1FCqf34c
05dd841c-d281-491a-ad17-7dcc3ad95ebc	a327b20b-9a68-4cae-9383-f2e209730b06	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiQTMyN0IyMEItOUE2OC00Q0FFLTkzODMtRjJFMjA5NzMwQjA2IiwiZXhwIjoxNjA0NzEyMDgzLjEwNSwic3ViIjoiKiIsImF1ZCI6InRpbWV0aWMtaml0c2kiLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiJ9.yiBNv3x7mX2WGEBlf9QjNis-cp5Q67A3sOntlnCnU88
0a77983e-1eba-4ab4-ad64-2f53a0dc87be	a327b20b-9a68-4cae-9383-f2e209730b06	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiQTMyN0IyMEItOUE2OC00Q0FFLTkzODMtRjJFMjA5NzMwQjA2IiwiZXhwIjoxNjA0NzEyMDgzLjEwNSwic3ViIjoiKiIsImF1ZCI6InRpbWV0aWMtaml0c2kiLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiJ9.NyttmHvCvCsiDre4bdE2MX7UUAXhp25SBUOZAfwEw3c
1176ea21-743a-4337-af2e-5045131bcc96	8fbdb8a7-7dda-4b7b-91fe-d35344acfd5a	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwiYXZhdGFyIjoiIiwibmFtZSI6Iktpc3MgQW5uYSJ9fSwicm9vbSI6IjhGQkRCOEE3LTdEREEtNEI3Qi05MUZFLUQzNTM0NEFDRkQ1QSIsIm5iZiI6MTYwNDYwNDE5NC4zNjA1NzQsInN1YiI6IioiLCJleHAiOjE2MDQ2NzE3MTkuMzYyfQ.2BnSXpCg29Zg-8OpJMR6CDyMciAFhKCXz-1nEdT6pus
cb546f2e-0597-4616-afb2-e814fa50cb09	4609f293-05e5-4464-9b6e-3d5e2d67b6f7	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiZXhwIjoxNjA0NzEwODUwLjUzLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiTmFneSDDiXZhIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJyb29tIjoiNDYwOUYyOTMtMDVFNS00NDY0LTlCNkUtM0Q1RTJENjdCNkY3IiwiYXVkIjoidGltZXRpYy1qaXRzaSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIn0.h4TTt10R3m5w7j86QZwrdxkOMTWZ13p_lfVqJIsYUvM
5ef60e98-6864-451b-a522-736b760d1105	4609f293-05e5-4464-9b6e-3d5e2d67b6f7	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiZXhwIjoxNjA0NzEwODUwLjUzLCJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsIm5hbWUiOiJLaXNzIEFubmEiLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCJ9LCJncm91cCI6ImNsaWVudCJ9LCJyb29tIjoiNDYwOUYyOTMtMDVFNS00NDY0LTlCNkUtM0Q1RTJENjdCNkY3IiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJhdWQiOiJ0aW1ldGljLWppdHNpIn0.DqSY1fLsG5V-GfhBTDnnBSV4YkPbRDt-xdqaj2yG0VY
4a3639be-b4b0-474e-a6d8-70f799c8af36	031f145f-b9cc-4115-aa2a-50a56db8b40e	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDQ1NjkyOTguNDQzNDkxLCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Iktpc3MgQW5uYSIsImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJyb29tIjoiMDMxRjE0NUYtQjlDQy00MTE1LUFBMkEtNTBBNTZEQjhCNDBFIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDQ3MTQ4ODB9.gsIuOPJ5cflB7FXbwh1jvN0yyaZU-m3xD59a7L1Oqjs
7ec0f1b0-1278-4885-8cd2-045546d425c6	8fbdb8a7-7dda-4b7b-91fe-d35344acfd5a	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiYXZhdGFyIjoiIiwibmFtZSI6Ik5hZ3kgw4l2YSJ9fSwicm9vbSI6IjhGQkRCOEE3LTdEREEtNEI3Qi05MUZFLUQzNTM0NEFDRkQ1QSIsIm5iZiI6MTYwNDYwNDE5NC4zNTk1NjUsInN1YiI6IioiLCJleHAiOjE2MDQ2NzE3MTkuMzYyfQ.5gacWKvNpMZO_2FxqLYX2PPpQjL_uF4i-FcWoMEDPAE
d0191321-f5c5-4d19-83a7-7da43a4ce6a9	198c003e-d6a2-4792-8a3c-da2757794f59	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsIm5iZiI6MTYwNDc3NTI4OC44OTEzNzgsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IjE5OEMwMDNFLUQ2QTItNDc5Mi04QTNDLURBMjc1Nzc5NEY1OSIsInN1YiI6IioiLCJleHAiOjE2MDQ4MDA4MDAsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJuYW1lIjoiS2lzcyBBbm5hIiwiYXZhdGFyIjoiIn0sImdyb3VwIjoiY2xpZW50In19.OSaYbB93iUA1RDeFbTyeO9Q7MaZ00vEqW1-lgz4WAPw
c4f2cc59-1189-4ebe-a128-6a0d70f7b102	204f067a-8ec9-4307-a058-32ff213d9947	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiMjA0RjA2N0EtOEVDOS00MzA3LUEwNTgtMzJGRjIxM0Q5OTQ3IiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsIm5hbWUiOiJLaXNzIEFubmEiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgifSwiZ3JvdXAiOiJjbGllbnQifSwiZXhwIjoxNjA0NzE4MjExLjEyMjk5OSwic3ViIjoiKiIsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.Dcp7w94-79n1q6DkTJ6FDksTHGNdtTgt71x7YJygd8Q
4b05cf99-13cf-43c2-8109-8e51e1eff9bd	a93d23c1-167d-43cd-8707-19b2c4421477	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6IlRlc3p0IEVsZWsiLCJlbWFpbCI6InZpdGlzZXM4NDNAcGVldnIuY29tIiwiaWQiOiIzNTBDREY3Qi1EQkY4LTQyQUMtODRCNi1DMDE2MDU4RjU0MjMiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJyb29tIjoiQTkzRDIzQzEtMTY3RC00M0NELTg3MDctMTlCMkM0NDIxNDc3IiwibmJmIjoxNjA0NTIyNDU4LjQ2OTczNCwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDQ2Mzg4MzYuMDM2LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioifQ.dIWVpc_kB1AE2tWpPpztfGwHNyNBc3L44tXDi6215JM
ef936688-aa26-4285-b849-c2f8d1117d44	a93d23c1-167d-43cd-8707-19b2c4421477	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Iktpc3MgQW5uYSIsImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJyb29tIjoiQTkzRDIzQzEtMTY3RC00M0NELTg3MDctMTlCMkM0NDIxNDc3IiwibmJmIjoxNjA0NTIyNDU4LjQ3MTAyNCwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDQ2Mzg4MzYuMDM2LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioifQ.AVZ_uKUNyG24pnIFngULexUzLfUxzCiJLXlOUOgpDxM
33fa6971-63ce-4c63-b765-3cf8fe3dae91	a4221d02-b186-4d22-82ef-8f6bbb46d2a1	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiQTQyMjFEMDItQjE4Ni00RDIyLTgyRUYtOEY2QkJCNDZEMkExIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDQ4MTU1MDAsInN1YiI6IioiLCJuYmYiOjE2MDQ3NzUzMDkuNzUzNzU2LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiTmFneSDDiXZhIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifX19.ZvKm-qGlQ0uEnOGypDZVqWVJTVxeS0vLB7s6r8oaiz4
fd057968-dcb0-4f4c-af4a-0f38ce37770d	1c030d02-9df5-4ef1-8fc6-f3bc65d33a3e	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc1ODcyMDAsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDQ1Mjg5MDAuODAzODc2OSwic3ViIjoiKiIsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsiZW1haWwiOiJ2aXRpc2VzODQzQHBlZXZyLmNvbSIsImF2YXRhciI6IiIsImlkIjoiMzUwQ0RGN0ItREJGOC00MkFDLTg0QjYtQzAxNjA1OEY1NDIzIiwibmFtZSI6IlRlc3p0IEVsZWsifX0sInJvb20iOiIxQzAzMEQwMi05REY1LTRFRjEtOEZDNi1GM0JDNjVEMzNBM0UifQ.UXxC6VJ-c81vZSswK_Fre_TKX_Nf7wdnso8hmvTwB9k
8153e392-c7cb-407d-8572-8c3c497513c1	1c030d02-9df5-4ef1-8fc6-f3bc65d33a3e	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiIsImlkIjoiQzY5MDY2RTQtMTc4Qy00Qjg3LUFDRjMtRTMyNzU4NkNDNUQ2IiwibmFtZSI6IlNpbW9uIEFkw6lsIn19LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNzU4NzIwMCwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiMUMwMzBEMDItOURGNS00RUYxLThGQzYtRjNCQzY1RDMzQTNFIiwic3ViIjoiKiIsIm5iZiI6MTYwNDUyODkwMC44MDQ4Mzd9.A-zSVN2NNHvBg6c0LgW0kph2eu13o2yrAEvfvwFAfu4
c5bfa789-785e-4f6e-8564-a34338a401a5	031f145f-b9cc-4115-aa2a-50a56db8b40e	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDQ1NjkyOTguNDQyNTI1LCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Ik5hZ3kgw4l2YSIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJyb29tIjoiMDMxRjE0NUYtQjlDQy00MTE1LUFBMkEtNTBBNTZEQjhCNDBFIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDQ3MTQ4ODB9.ie569SOYuORkXm4kyPB8VkPKw0C1FMwtfXfCzr12A3k
c0cbd557-e3fb-43a4-b130-ae967c469a7d	c2a64c3f-23a0-4ab4-bf51-82ced79eab75	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJDMkE2NEMzRi0yM0EwLTRBQjQtQkY1MS04MkNFRDc5RUFCNzUiLCJleHAiOjE2MDQ2NjQwMTAuNywiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiYXZhdGFyIjoiIiwibmFtZSI6Ik5hZ3kgw4l2YSJ9fSwibmJmIjoxNjA0NjAzODU4Ljl9.A5aQN6eqqixqa0NBAKK3-EbaT-5RZhiRC36Wi9suvtc
a7dc260e-1d66-468d-9613-c6e027d52302	c2a64c3f-23a0-4ab4-bf51-82ced79eab75	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJDMkE2NEMzRi0yM0EwLTRBQjQtQkY1MS04MkNFRDc5RUFCNzUiLCJleHAiOjE2MDQ2NjQwMTAuNywiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwiYXZhdGFyIjoiIiwibmFtZSI6Iktpc3MgQW5uYSJ9fSwibmJmIjoxNjA0NjAzODU4LjkwMTIzNDF9.II4mCkKSSxHr1J6-Zmw53S604-YxfsqG7CT8mSVy-oc
6f5c5352-2eb1-4f48-b91d-53aaf9a3f603	9f70b60c-09af-47e8-a73d-250217d53c92	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJuYmYiOjE2MDQ2MDQwNTUuMzI1NDU4LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiI5RjcwQjYwQy0wOUFGLTQ3RTgtQTczRC0yNTAyMTdENTNDOTIiLCJzdWIiOiIqIiwiZXhwIjoxNjA1MzIxNTg3LjIyNDk5OSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.xAXA1P_v0dpqyAic8sIWoiayhVLBNy5jVfLDF3vIt8M
94b01e47-0e49-4326-b516-ba2cf6ad2dae	9f70b60c-09af-47e8-a73d-250217d53c92	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJDNjkwNjZFNC0xNzhDLTRCODctQUNGMy1FMzI3NTg2Q0M1RDYiLCJuYW1lIjoiU2ltb24gQWTDqWwiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJuYmYiOjE2MDQ2MDQwNTUuMzI2MzY2LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiI5RjcwQjYwQy0wOUFGLTQ3RTgtQTczRC0yNTAyMTdENTNDOTIiLCJzdWIiOiIqIiwiZXhwIjoxNjA1MzIxNTg3LjIyNDk5OSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.-PbDu2i7UYnl4qQRNbtSlfXpbqLVma26MJhg-jQ03WQ
7498d584-549f-4325-a009-bf818effad39	1ca7605c-9ef7-432a-91c9-a13b8c432ca6	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDc1NTEyMTYuMzAzOTk5LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7ImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwibmFtZSI6Ik5hZ3kgw4l2YSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0In19LCJuYmYiOjE2MDczODc4NzYuNDQxMTQzLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiIxQ0E3NjA1Qy05RUY3LTQzMkEtOTFDOS1BMTNCOEM0MzJDQTYifQ.FDY3yCybM580-DT_UKxFKWoJ1A_NfnsuTp3lcdddbV8
49714aea-9ff0-454a-b8b8-874f12b9ef26	1ca7605c-9ef7-432a-91c9-a13b8c432ca6	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDc1NTEyMTYuMzAzOTk5LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwibmFtZSI6Iktpc3MgQW5uYSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4In19LCJuYmYiOjE2MDczODc4NzYuNDQyMjYxLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiIxQ0E3NjA1Qy05RUY3LTQzMkEtOTFDOS1BMTNCOEM0MzJDQTYifQ.8HILSoj7HjJLCNRwgr9ceDo15_Za1KaUBojayd9wQzM
c97ff39c-197f-47b1-892e-f2e321bec6fc	d747d3b4-2b80-481b-9ff2-71e5afd5aadc	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDc0MTMyODQuNjkxMzI2MSwic3ViIjoiKiIsImV4cCI6MTYwNzY3NjA4MS4xNzcsInJvb20iOiJENzQ3RDNCNC0yQjgwLTQ4MUItOUZGMi03MUU1QUZENUFBREMiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiTmFneSDDiXZhIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.wAUwfOLk4pJObIN34o5u_TpmI8TLiaIIZe2MbBF7ujE
bd533e4e-f309-4e97-bd37-85fdb2db8376	9b2e89c4-7599-4553-a8da-dfe82e669dd4	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc4MTA1NTkuMTQyLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI5QjJFODlDNC03NTk5LTQ1NTMtQThEQS1ERkU4MkU2NjlERDQiLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsIm5hbWUiOiJOYWd5IMOJdmEifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJuYmYiOjE2MDc0NjEzNjMuMzIxMDMzfQ.m79dPVhZ5oIvfttnxK7nyS9qjGmzJ6dMzWUzbjMs9H4
832152d4-b631-4f40-a363-b37a1918b119	9b2e89c4-7599-4553-a8da-dfe82e669dd4	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc4MTA1NTkuMTQyLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI5QjJFODlDNC03NTk5LTQ1NTMtQThEQS1ERkU4MkU2NjlERDQiLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eStuYXNAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwiaWQiOiI2QzcxMjUzQi1BMjAwLTQ3ODItODY4NS1FQ0E2Mzk2QjQ5QjMiLCJuYW1lIjoiTmFneSBBbm5hIFPDoXJhIn0sImdyb3VwIjoiY2xpZW50In0sIm5iZiI6MTYwNzQ2MTM2My4zMjE5MzYxfQ.wJSwRJS1Tl6ipwzjuGKAPIEHQI0YIBq6C2HpXr-qXwg
6082e6a5-a2d7-408d-8060-9f578ffae78a	a4221d02-b186-4d22-82ef-8f6bbb46d2a1	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiQTQyMjFEMDItQjE4Ni00RDIyLTgyRUYtOEY2QkJCNDZEMkExIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDQ4MTU1MDAsInN1YiI6IioiLCJuYmYiOjE2MDQ3NzUzMDkuNzU0NzA1LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImNvbnRleHQiOnsiZ3JvdXAiOiJjbGllbnQiLCJ1c2VyIjp7ImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiS2lzcyBBbm5hIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgifX19.rZQIq64EfOc7i31hN-2NDsiI7GL6hhEZdlNP71ivRvI
22dc1c8c-5f6b-44b9-a99f-08b39da4ff0f	44edc379-fecf-427e-8cca-96ff2560ea75	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDkzMTk0MDAsInN1YiI6IioiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNTEwMDAxOS44ODM1MTgsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsibmFtZSI6IlRlc3p0IEVsZWsiLCJlbWFpbCI6InZpdGlzZXM4NDNAcGVldnIuY29tIiwiaWQiOiIzNTBDREY3Qi1EQkY4LTQyQUMtODRCNi1DMDE2MDU4RjU0MjMiLCJhdmF0YXIiOiIifX0sImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwicm9vbSI6IjQ0RURDMzc5LUZFQ0YtNDI3RS04Q0NBLTk2RkYyNTYwRUE3NSJ9.diy2rqg44Fuh7ZX663yOOshQ8PHQy36ajNja7ZvCkWk
ee523dd3-4649-4088-b3e3-a72cab8cd332	44edc379-fecf-427e-8cca-96ff2560ea75	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDkzMTk0MDAsInN1YiI6IioiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNTEwMDAxOS44ODYxMTk4LCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJuYW1lIjoiU2ltb24gQWTDqWwiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQzY5MDY2RTQtMTc4Qy00Qjg3LUFDRjMtRTMyNzU4NkNDNUQ2IiwiYXZhdGFyIjoiIn19LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiI0NEVEQzM3OS1GRUNGLTQyN0UtOENDQS05NkZGMjU2MEVBNzUifQ.5cDRwPs8s2WTO_SSi3-WIqQbsNdq3GnCDbGqCsS5KE8
1a1c7d2d-9c15-41f2-b39b-2a80be881798	6ddeed79-4434-4e20-9d16-9f00ee1071cd	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9LCJncm91cCI6ImVtcGxveWVlIn0sImV4cCI6MTYwNzMxMDA1My41MzIsInJvb20iOiI2RERFRUQ3OS00NDM0LTRFMjAtOUQxNi05RjAwRUUxMDcxQ0QiLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDcyNDQwNjkuMjI3NDIzfQ.pBxB0QoE0fJq0OVhzKUKn_Cb4vkyL2R8-R-Tm-jqDPI
9b48609d-b2c5-4510-8aff-9c624a4ffa72	6ddeed79-4434-4e20-9d16-9f00ee1071cd	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwibmFtZSI6Iktpc3MgQW5uYSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4In0sImdyb3VwIjoiY2xpZW50In0sImV4cCI6MTYwNzMxMDA1My41MzIsInJvb20iOiI2RERFRUQ3OS00NDM0LTRFMjAtOUQxNi05RjAwRUUxMDcxQ0QiLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDcyNDQwNjkuMjI4MzUzfQ.g3_pJfAQy-xCKzp5YsebefnHv7WmpPBWzER1Ty5i_bE
ec0b8385-7790-4b90-87a2-71bc5e9ffa82	d747d3b4-2b80-481b-9ff2-71e5afd5aadc	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDc0MTMyODQuNjkyMjQ4OCwic3ViIjoiKiIsImV4cCI6MTYwNzY3NjA4MS4xNzcsInJvb20iOiJENzQ3RDNCNC0yQjgwLTQ4MUItOUZGMi03MUU1QUZENUFBREMiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsImF2YXRhciI6IiIsIm5hbWUiOiJLaXNzIEFubmEiLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCJ9LCJncm91cCI6ImNsaWVudCJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.SSTT9-9dMKMNj4vb1RWV07wjvcVfx-LG_PVIXzSzHWY
29ed2837-1681-4cec-a1ab-5af9be530594	dc434b62-ca5c-4487-a5aa-58144b92ede3	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDczNDk2NDcuNjkxOTk5LCJzdWIiOiIqIiwibmJmIjoxNjA3MjY1OTUzLjIxMjkzNSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImNvbnRleHQiOnsidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwibmFtZSI6Ik5hZ3kgw4l2YSJ9LCJncm91cCI6ImVtcGxveWVlIn0sInJvb20iOiJEQzQzNEI2Mi1DQTVDLTQ0ODctQTVBQS01ODE0NEI5MkVERTMifQ.SXJmm6GC7cK8Iy6Wq_wgqt-l-Qn0-NUelYuK6lOmFyQ
2a0a1c38-22ea-42b0-877f-c83f0997e6a6	dc434b62-ca5c-4487-a5aa-58144b92ede3	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDczNDk2NDcuNjkxOTk5LCJzdWIiOiIqIiwibmJmIjoxNjA3MjY1OTUzLjIxMzg0NiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImNvbnRleHQiOnsidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJuYW1lIjoiS2lzcyBBbm5hIn0sImdyb3VwIjoiY2xpZW50In0sInJvb20iOiJEQzQzNEI2Mi1DQTVDLTQ0ODctQTVBQS01ODE0NEI5MkVERTMifQ.RPGWytvgo3_S55WljQlwwoPjfk5MpziLuI0LfDNQ8P8
021544db-79e8-4d71-8cd5-1ce2c08b03d9	d39a61b4-d31e-440e-9cbb-77dec52877af	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDcyNjU5OTUuMzg4ODA1OSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7ImF2YXRhciI6IiIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSDDiXZhIn19LCJleHAiOjE2MDczNjQwMjQuOTk0OTk5LCJyb29tIjoiRDM5QTYxQjQtRDMxRS00NDBFLTlDQkItNzdERUM1Mjg3N0FGIn0.APOFwap2kNITJe4A9m3ot4sgvKcys4utIh8KuPtyBQE
a363607d-dd9f-4252-bedc-491a1396c0fc	d39a61b4-d31e-440e-9cbb-77dec52877af	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDcyNjU5OTUuMzg5Njg3LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsiZ3JvdXAiOiJjbGllbnQiLCJ1c2VyIjp7ImF2YXRhciI6IiIsImlkIjoiMDU5QTMzNzgtQjBFQS00OTE5LUJENUMtQkI5OTUwMEYxMTk0IiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eStuZEBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSBEb3JvdHR5YSJ9fSwiZXhwIjoxNjA3MzY0MDI0Ljk5NDk5OSwicm9vbSI6IkQzOUE2MUI0LUQzMUUtNDQwRS05Q0JCLTc3REVDNTI4NzdBRiJ9.GtBJMUq8PdW4y8K0HLBLMdw-58iqLNTSWULsRJfoOVY
2be8769e-4a7c-4b58-8650-052392e6af25	b98e9965-c275-4cdb-84d1-9ae6fcbf0b8c	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJyb29tIjoiQjk4RTk5NjUtQzI3NS00Q0RCLTg0RDEtOUFFNkZDQkYwQjhDIiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIn0sImdyb3VwIjoiZW1wbG95ZWUifSwibmJmIjoxNjA3MzY2NTE0LjYzNjcwNTksImV4cCI6MTYwNzQwMzYzNi4yOTY5OTksImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIn0.lubpu1NMt0i0UsPoFQKBg2BhxI58PU74m9VXmAuOyYI
7d1d6a61-b974-4cab-b4ee-784bbe304210	4cefc1cd-4132-4c5d-9e8c-697ca3053416	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiNENFRkMxQ0QtNDEzMi00QzVELTlFOEMtNjk3Q0EzMDUzNDE2Iiwic3ViIjoiKiIsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJhdmF0YXIiOiIifX0sIm5iZiI6MTYwNzQ2MjE2MC4xOTMxMzEsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDc0NzkyMzYuMDc5fQ.qy6mZvMR8Fgnx8HpDIa0rLyT-6SnR0W7G8M0Tu6Tyx8
f19e5153-0ece-47c9-88ab-b37f5644b126	4cefc1cd-4132-4c5d-9e8c-697ca3053416	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI0Q0VGQzFDRC00MTMyLTRDNUQtOUU4Qy02OTdDQTMwNTM0MTYiLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc0NzkyMzYuMDc5LCJuYmYiOjE2MDc0NjIxNjAuMTk0MDExLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJpZCI6IjZDNzEyNTNCLUEyMDAtNDc4Mi04Njg1LUVDQTYzOTZCNDlCMyIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenkrbmFzQGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IEFubmEgU8OhcmEiLCJhdmF0YXIiOiIifX19.SPe0hYTiX-KJ-VeccMUAMlqe09LYs4xe4mBQpOFYNDs
ed4747d1-3e7f-48c7-a1bc-753d2496e645	2a9e5b54-e749-4470-b9cb-82be1c30aabc	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNTQwMjQ3My43MzcsImNvbnRleHQiOnsidXNlciI6eyJuYW1lIjoiTmFneSDDiXZhIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImF2YXRhciI6IiJ9LCJncm91cCI6ImVtcGxveWVlIn0sIm5iZiI6MTYwNTI4MDA5MS41MzYyNDQ5LCJzdWIiOiIqIiwicm9vbSI6IjJBOUU1QjU0LUU3NDktNDQ3MC1COUNCLTgyQkUxQzMwQUFCQyIsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.X96-Yb84LCYzH8xfkaJ9qeUz3wCaQlgB5Z1tRA1smHc
f712cf81-826c-4124-9aba-c26f5af13257	2a9e5b54-e749-4470-b9cb-82be1c30aabc	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNTQwMjQ3My43MzcsImNvbnRleHQiOnsidXNlciI6eyJuYW1lIjoiS2lzcyBBbm5hIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiYXZhdGFyIjoiIn0sImdyb3VwIjoiY2xpZW50In0sIm5iZiI6MTYwNTI4MDA5MS41MzczMDQ5LCJzdWIiOiIqIiwicm9vbSI6IjJBOUU1QjU0LUU3NDktNDQ3MC1COUNCLTgyQkUxQzMwQUFCQyIsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.l-HiXTCnjYRb0jA_RbeT06ERxqekr6ahWcAV1YIbwtE
6d136ae5-5a84-4dee-8d02-5bcf5b2544c6	86f00330-47e5-46f4-944d-55e5946ac556	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJleHAiOjE2MDU0MDc1NzQuNzQ0LCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Ik5hZ3kgw4l2YSIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJyb29tIjoiODZGMDAzMzAtNDdFNS00NkY0LTk0NEQtNTVFNTk0NkFDNTU2IiwibmJmIjoxNjA1MzA2Nzg4LjgwNDM5MywiYXVkIjoidGltZXRpYy1jbGllbnQifQ.GILDh5q2bGFhGAFblmNnz_eP-KqNZSIV5XWbrchWxBo
28fec5a1-b5ee-4721-8441-847cf36839a7	86f00330-47e5-46f4-944d-55e5946ac556	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJleHAiOjE2MDU0MDc1NzQuNzQ0LCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6IktvdsOhY3MgS2F0YWxpbiIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenkra2tAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwiaWQiOiI3RDVFQTBEQS1FM0ZDLTQ1NjAtOUYyMC0zM0E2MkQwOUFDOTQifSwiZ3JvdXAiOiJjbGllbnQifSwicm9vbSI6Ijg2RjAwMzMwLTQ3RTUtNDZGNC05NDRELTU1RTU5NDZBQzU1NiIsIm5iZiI6MTYwNTMwNjc4OC44MDUyOSwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.epZj1z7pN5-OXh8wgbe1NgPmWBq9gNeAEC4VibIgVGw
dde201a7-bf41-4802-83ce-bad56837d53b	5a137902-e6cb-4013-a2bc-51f092132ca4	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiI1QTEzNzkwMi1FNkNCLTQwMTMtQTJCQy01MUYwOTIxMzJDQTQiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsIm5hbWUiOiJOYWd5IMOJdmEiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNTQ1OTEzMS44NTQxODUsInN1YiI6IioiLCJleHAiOjE2MDU0OTE1MTIuMTl9.NliPHDNJfnuAoq0v25CZoenhfPItPaEicziwutoigvo
d3829072-f325-439f-b6bf-c0c529d6e6e3	5a137902-e6cb-4013-a2bc-51f092132ca4	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiI1QTEzNzkwMi1FNkNCLTQwMTMtQTJCQy01MUYwOTIxMzJDQTQiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eStra0BnbWFpbC5jb20iLCJpZCI6IjdENUVBMERBLUUzRkMtNDU2MC05RjIwLTMzQTYyRDA5QUM5NCIsIm5hbWUiOiJLb3bDoWNzIEthdGFsaW4iLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJjbGllbnQifSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDU0NTkxMzEuODU1MDU5MSwic3ViIjoiKiIsImV4cCI6MTYwNTQ5MTUxMi4xOX0.qJp9EB2UKxc1YZVYDzE6Xx3lkwImoofAjSDhq17V4uY
90fa3a54-ab55-420a-a534-77978a5a0438	48284cd9-e0af-48e7-927d-bdfd6bf0a162	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJuYmYiOjE2MDcyNDM5ODguMjQ0Mzg2LCJleHAiOjE2MDczMDY0MzguNjExLCJyb29tIjoiNDgyODRDRDktRTBBRi00OEU3LTkyN0QtQkRGRDZCRjBBMTYyIiwiY29udGV4dCI6eyJ1c2VyIjp7ImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIn0sImdyb3VwIjoiZW1wbG95ZWUifSwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.uIKC0EgM_PstYYdjiakzCmbmNkZj0cfAYTTmdsxrWoQ
71e89517-8aa5-4d01-96eb-b3ba183f1110	48284cd9-e0af-48e7-927d-bdfd6bf0a162	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJuYmYiOjE2MDcyNDM5ODguMjQ1Mjc1LCJleHAiOjE2MDczMDY0MzguNjExLCJyb29tIjoiNDgyODRDRDktRTBBRi00OEU3LTkyN0QtQkRGRDZCRjBBMTYyIiwiY29udGV4dCI6eyJ1c2VyIjp7ImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsIm5hbWUiOiJLaXNzIEFubmEiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJjbGllbnQifSwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.zruznEXbrUc73Q6Y1RxfH0mf1VP-dxd91RB_wwWXFZs
73414687-0227-4882-b68a-b3ca45c8ecdf	a8b68251-3193-486c-9d57-b77655fe66bf	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDc0NTY2NzYuNDczNDQ2LCJleHAiOjE2MDc2MDg4NDQuMTI1LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJBOEI2ODI1MS0zMTkzLTQ4NkMtOUQ1Ny1CNzc2NTVGRTY2QkYiLCJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20ifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.4f9CccS66BG5pzdPBbugWHI1EUkPs1Bm-q83-JugKQ0
6dbd1c8c-6382-476b-be60-f1c05fdf6df7	412c1587-7c22-4d2b-a250-333012d41613	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDc0NjMyODEuNjE3NTEyLCJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7Im5hbWUiOiJOYWd5IMOJdmEiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0In19LCJzdWIiOiIqIiwiZXhwIjoxNjA3NDc1NjM3LjgxMzk5OTIsInJvb20iOiI0MTJDMTU4Ny03QzIyLTREMkItQTI1MC0zMzMwMTJENDE2MTMiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.2_D6-jEm4-sy-RT9NSZTiQSaaVTjVdrUPPlKhj7GSPc
1701dc3e-5ba0-44cf-b417-0dfdf3c1879c	fbe782b7-66c2-4cbd-a8dd-3bdab2947732	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIqIiwicm9vbSI6IkZCRTc4MkI3LTY2QzItNENCRC1BOERELTNCREFCMjk0NzczMiIsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsibmFtZSI6Ik5hZ3kgw4l2YSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIifX0sIm5iZiI6MTYwNTUyNjE2OC45OTMyNzQsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiZXhwIjoxNjA1NjYyOTQxLjQ4ODk5OTgsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIn0.sV_iKiMSxL5EleK76VaNFLvmT-DhES1BPAn8TuItpNY
aff5066d-de5e-4373-8622-629f95bf5d83	fbe782b7-66c2-4cbd-a8dd-3bdab2947732	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIqIiwicm9vbSI6IkZCRTc4MkI3LTY2QzItNENCRC1BOERELTNCREFCMjk0NzczMiIsImNvbnRleHQiOnsiZ3JvdXAiOiJjbGllbnQiLCJ1c2VyIjp7Im5hbWUiOiJLaXNzIEFubmEiLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCIsImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJhdmF0YXIiOiIifX0sIm5iZiI6MTYwNTUyNjE2OC45OTQxNjIsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiZXhwIjoxNjA1NjYyOTQxLjQ4ODk5OTgsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIn0.fEh0Bl_1LyG5lHS2tXd_88pv5D3SKPwVFdcr6SFefwc
266f549d-92cd-4d74-9b02-e4e9700c632f	3643e3fd-4cba-4cfe-99aa-61fc7236249d	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiY29udGV4dCI6eyJ1c2VyIjp7ImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIn0sImdyb3VwIjoiZW1wbG95ZWUifSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDcyNjU5NzYuNDY0MTc2MiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiMzY0M0UzRkQtNENCQS00Q0ZFLTk5QUEtNjFGQzcyMzYyNDlEIiwiZXhwIjoxNjA3MzU2ODA0LjUwN30.3ttLBTAvHV0YMccOlxzDF6NMmnxX0I7kErwOdA0JlIY
fb2a6d4b-e4e4-4863-a784-3f7f76726e9a	3643e3fd-4cba-4cfe-99aa-61fc7236249d	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiY29udGV4dCI6eyJ1c2VyIjp7ImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsIm5hbWUiOiJLaXNzIEFubmEiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJjbGllbnQifSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDcyNjU5NzYuNDY1MDY2LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiIzNjQzRTNGRC00Q0JBLTRDRkUtOTlBQS02MUZDNzIzNjI0OUQiLCJleHAiOjE2MDczNTY4MDQuNTA3fQ.Ap66idi7D_lQVEMNrkTwJEr7hYV9IRrWKYK0unUvO1I
2e91fb2a-9542-432f-bcae-ff7998957c10	41828cf7-8503-403a-adf4-416e2444f25c	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIqIiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9fSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDczNTk5OTguNTEwMDc5OSwicm9vbSI6IjQxODI4Q0Y3LTg1MDMtNDAzQS1BREY0LTQxNkUyNDQ0RjI1QyIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiZXhwIjoxNjA3Mzg1NjQ0LjIxMX0.J1qpqB_VIxSjFrwaEp8szbsNt99PyOTXJvlJ4o-Wj10
e38ffa67-1088-41fb-97d5-5b5e0a44eda3	41828cf7-8503-403a-adf4-416e2444f25c	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIqIiwiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eStuZEBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiTmFneSBEb3JvdHR5YSIsImlkIjoiMDU5QTMzNzgtQjBFQS00OTE5LUJENUMtQkI5OTUwMEYxMTk0In19LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsIm5iZiI6MTYwNzM1OTk5OC41MTA5OTksInJvb20iOiI0MTgyOENGNy04NTAzLTQwM0EtQURGNC00MTZFMjQ0NEYyNUMiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNzM4NTY0NC4yMTF9.K2qUwkHt7N8p5LbljzH5sJUPQeOgDHDW9-po82uhAdE
4c7a4cb9-517c-4c2b-b74c-503595fd274e	a8b68251-3193-486c-9d57-b77655fe66bf	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDc0NTY2NzYuNDc0NTE5LCJleHAiOjE2MDc2MDg4NDQuMTI1LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJBOEI2ODI1MS0zMTkzLTQ4NkMtOUQ1Ny1CNzc2NTVGRTY2QkYiLCJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiJCNzk2REM3Mi1CMTE2LTQyODEtOEFGNi0zOTdEN0MyOUFGNjAiLCJuYW1lIjoiTmFneSBTemlsdmlhIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eStuc3pAZ21haWwuY29tIn0sImdyb3VwIjoiY2xpZW50In0sInN1YiI6IioiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiJ9.18uZgVoyZA8Ye99Fr00nFvgmPBblREX-okTLV-xvv9s
2eeb0050-1317-4714-b11f-89fcb54e3423	b98e9965-c275-4cdb-84d1-9ae6fcbf0b8c	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJyb29tIjoiQjk4RTk5NjUtQzI3NS00Q0RCLTg0RDEtOUFFNkZDQkYwQjhDIiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsIm5hbWUiOiJLb3bDoWNzIEthdGFsaW4iLCJpZCI6IjdENUVBMERBLUUzRkMtNDU2MC05RjIwLTMzQTYyRDA5QUM5NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenkra2tAZ21haWwuY29tIn0sImdyb3VwIjoiY2xpZW50In0sIm5iZiI6MTYwNzM2NjUxNC42Mzc1OCwiZXhwIjoxNjA3NDAzNjM2LjI5Njk5OSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.I6GyU8IMyW2rvLBt_v9ajDa0NndwBN4hdJ7hSdYeY0w
b264174f-8b72-40d1-b0ff-49a3cadf1991	cd53bb38-d722-44ca-97b6-7d933845f5c6	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsIm5hbWUiOiJOYWd5IMOJdmEifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJzdWIiOiIqIiwiZXhwIjoxNjA3NDYyNTA3LjczNCwibmJmIjoxNjA3MzcyNTE2LjIzMzE5ODIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiQ0Q1M0JCMzgtRDcyMi00NENBLTk3QjYtN0Q5MzM4NDVGNUM2In0.CGmn2T1LeDYHhx48_vtqhumTmpB4geVC0kWCS0tXtR8
e4ab4815-5e7c-4ca1-812f-3e0c33c85889	cd53bb38-d722-44ca-97b6-7d933845f5c6	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwibmFtZSI6Iktpc3MgQW5uYSJ9LCJncm91cCI6ImNsaWVudCJ9LCJzdWIiOiIqIiwiZXhwIjoxNjA3NDYyNTA3LjczNCwibmJmIjoxNjA3MzcyNTE2LjIzNDA4MSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJDRDUzQkIzOC1ENzIyLTQ0Q0EtOTdCNi03RDkzMzg0NUY1QzYifQ.NGNphgUwoUWprvNJeTTEjPU4OjbEZwxaWNlNm3yvYxQ
93447bbf-3619-4619-b6f8-28965e80436b	9d8bac3b-895e-4990-b1d2-3d927535ee2e	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsIm5hbWUiOiJOYWd5IMOJdmEiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImVtcGxveWVlIn0sImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwic3ViIjoiKiIsImV4cCI6MTYwNzUzODYxNi4yNywibmJmIjoxNjA3Mzc4MjQ0LjIwNTEyNDksInJvb20iOiI5RDhCQUMzQi04OTVFLTQ5OTAtQjFEMi0zRDkyNzUzNUVFMkUifQ.lxpBGwDKcQFwkSCX9S_-U1Hee4QkFCsAGd8kCFNsbX8
aa364765-0646-45a8-83cd-86accd3fe953	9d8bac3b-895e-4990-b1d2-3d927535ee2e	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCIsIm5hbWUiOiJLaXNzIEFubmEiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiYXZhdGFyIjoiIn0sImdyb3VwIjoiY2xpZW50In0sImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwic3ViIjoiKiIsImV4cCI6MTYwNzUzODYxNi4yNywibmJmIjoxNjA3Mzc4MjQ0LjIwNjAzNTEsInJvb20iOiI5RDhCQUMzQi04OTVFLTQ5OTAtQjFEMi0zRDkyNzUzNUVFMkUifQ.iiE0YfS_4TMfkvjSSw-PvDbxv9guCbYtUHArUmji46Y
5a684d43-6977-4d53-8648-a639ab440d8f	a080091d-e2f4-4ea8-ab5b-104d23f0050a	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNTYzMjQwNC4wMywibmJmIjoxNjA1NTMzMzY2LjU5OTM5MywiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9fSwic3ViIjoiKiIsImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwicm9vbSI6IkEwODAwOTFELUUyRjQtNEVBOC1BQjVCLTEwNEQyM0YwMDUwQSJ9.cf9WKyn-92ZqTsQxNkPgfDS9EpdaUfiLISKVOmd43jM
92ca7ab9-0781-430d-af21-c5b3d95e859c	412c1587-7c22-4d2b-a250-333012d41613	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDc0NjMyODEuNjE4NDM5LCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Ik1vbG7DoXIgRnJ1enNpIiwiZW1haWwiOiJuYWd5ZXZhMkBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJpZCI6IkZBNDhBRTJFLTc3NTYtNDJCNS1BQ0JCLUEwNjAyNTEyRjYxMCJ9LCJncm91cCI6ImNsaWVudCJ9LCJzdWIiOiIqIiwiZXhwIjoxNjA3NDc1NjM3LjgxMzk5OTIsInJvb20iOiI0MTJDMTU4Ny03QzIyLTREMkItQTI1MC0zMzMwMTJENDE2MTMiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.beEkDUbMNYxDn8aG-xEFfcmpCy4X7jugvAtljGK44fw
70ea54b2-95ee-4643-9b26-58fbbcaa6738	aba839b0-90a1-4961-8f2b-fc0a282f020c	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiI2MzkzNTE1OC1CRUQzLTRGNDUtOUNDMy01ODlBOTEzQUFEOTgiLCJuYW1lIjoiU3ppYSDDiW4iLCJlbWFpbCI6ImF6QGF6eXhkaHR6am0uaGgifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJBQkE4MzlCMC05MEExLTQ5NjEtOEYyQi1GQzBBMjgyRjAyMEMiLCJzdWIiOiIqIiwiZXhwIjoxNjA3NDk3MjAwLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzQ2MzQ3NS41NjY4ODN9.JL9zWVGLHn6-BHvAvS5JZFknxo8Kw2IgHH47d9bITSE
ce5a952c-756e-45b9-88b0-667632c3b5ee	9387fc73-105b-4b18-b4ca-52fe14d4f6d6	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsIm5iZiI6MTYwNzM3OTEzNS42NTI5NTQsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiTmFneSDDiXZhIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifX0sInJvb20iOiI5Mzg3RkM3My0xMDVCLTRCMTgtQjRDQS01MkZFMTRENEY2RDYiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJleHAiOjE2MDc2MDUyMDkuOTgzfQ.6kHp2iDWCYYO3rV_VImmds285SquaLZgTm_ZWvNVI6E
00589a73-271b-4b8d-8fa9-6e4737354ddc	9387fc73-105b-4b18-b4ca-52fe14d4f6d6	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsIm5iZiI6MTYwNzM3OTEzNS42NTM4NjgsImNvbnRleHQiOnsiZ3JvdXAiOiJjbGllbnQiLCJ1c2VyIjp7ImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJuYW1lIjoiS2lzcyBBbm5hIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgifX0sInJvb20iOiI5Mzg3RkM3My0xMDVCLTRCMTgtQjRDQS01MkZFMTRENEY2RDYiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJleHAiOjE2MDc2MDUyMDkuOTgzfQ.MPdSkjV8u8ssCcMtvxtlPojSYs-sYuNc1zVWMgpOHe0
04478b97-bcab-4be0-b553-5073609566d6	aba839b0-90a1-4961-8f2b-fc0a282f020c	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiI4NTFBMTNDNy0xODg4LTQ0QzItQkIzMC1FN0UzQTZERUYyN0IiLCJuYW1lIjoiTmFneSBCZXJuYWRldHQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p0eUBnbWFpbC5jb20ifSwiZ3JvdXAiOiJjbGllbnQifSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiQUJBODM5QjAtOTBBMS00OTYxLThGMkItRkMwQTI4MkYwMjBDIiwic3ViIjoiKiIsImV4cCI6MTYwNzQ5NzIwMCwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDc0NjM0NzUuNTY3ODE0OH0.wiiFjkL1m1IxrLbSsfiUksr2kpHKa_2YDG13mcS1O3M
a19a661a-825a-4969-b138-5eb78a509c68	21f0a022-a946-4c6d-98ab-ae285e959298	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiMjFGMEEwMjItQTk0Ni00QzZELTk4QUItQUUyODVFOTU5Mjk4IiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7ImVtYWlsIjoiYXpAYXp5eGRodHpqbS5oaCIsIm5hbWUiOiJTemlhIMOJbiIsImF2YXRhciI6IiIsImlkIjoiNjM5MzUxNTgtQkVEMy00RjQ1LTlDQzMtNTg5QTkxM0FBRDk4In19LCJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDc0OTc1MDAsIm5iZiI6MTYwNzQ2MzUxMy4zNjMwNDV9.ifB3RaFaXtciqIGkM0maUasVEA4WvOtTTg1-VMSx7JM
cfb8d597-5d7d-4119-a842-ca4aebbb917a	21f0a022-a946-4c6d-98ab-ae285e959298	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiMjFGMEEwMjItQTk0Ni00QzZELTk4QUItQUUyODVFOTU5Mjk4IiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p0eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSBCZXJuYWRldHQiLCJhdmF0YXIiOiIiLCJpZCI6Ijg1MUExM0M3LTE4ODgtNDRDMi1CQjMwLUU3RTNBNkRFRjI3QiJ9fSwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiZXhwIjoxNjA3NDk3NTAwLCJuYmYiOjE2MDc0NjM1MTMuMzYzOTc0fQ.iDN8i670lopaEdJo-QWp1jwVpvA6DvLno3WJrjHtz20
f6233350-1f1b-4442-856c-c9f46ee7c7b9	d9d4bdff-1002-4841-a565-1ae6d115cb53	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwibmFtZSI6Ik5hZ3kgw4l2YSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImVtcGxveWVlIn0sInN1YiI6IioiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImV4cCI6MTYwNzQyMzQzNy40NjEsIm5iZiI6MTYwNzM3MDM4OC4zOTI5MTIsInJvb20iOiJEOUQ0QkRGRi0xMDAyLTQ4NDEtQTU2NS0xQUU2RDExNUNCNTMifQ.5P0VjewDEhF7ITwbeJ3oEPOklPodck1gqfdqlNi80GU
ac3480e4-0eec-4c77-8a05-9d23451427ec	d9d4bdff-1002-4841-a565-1ae6d115cb53	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6ImFuZHJlYS5wb2xsMDdAZ21haWwuY29tIiwiaWQiOiJCRTRDM0RBRC1CODM2LTQxNjQtQTlBMS1ENzE2OTc2NDkzRUEiLCJuYW1lIjoiUG9sbCBBbmRyZWEiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJjbGllbnQifSwic3ViIjoiKiIsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiZXhwIjoxNjA3NDIzNDM3LjQ2MSwibmJmIjoxNjA3MzcwMzg4LjM5MzgyMiwicm9vbSI6IkQ5RDRCREZGLTEwMDItNDg0MS1BNTY1LTFBRTZEMTE1Q0I1MyJ9.MpYERA0jkNRQR-9Rj2kGGhMDnr5otrJZVLNmtEUxcpA
753e13f8-9937-46fd-851e-30a6cd52edf6	c1a2a0a2-92b8-47b0-9f25-21c7170032cc	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJleHAiOjE2MDgyMzQ2MTUuNDE3LCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDc0NTM0MjAuNTUyNTc5LCJyb29tIjoiQzFBMkEwQTItOTJCOC00N0IwLTlGMjUtMjFDNzE3MDAzMkNDIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.Q2KQtEDdmawmM_PeLKBbR2nCR7SNNQKjUSQEB_UsCxA
fb46c4dd-4f0f-4cf1-bfd7-db34b0cfd029	a080091d-e2f4-4ea8-ab5b-104d23f0050a	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNTYzMjQwNC4wMywibmJmIjoxNjA1NTMzMzY2LjYwMDMwNywiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eStra0BnbWFpbC5jb20iLCJuYW1lIjoiS292w6FjcyBLYXRhbGluIiwiaWQiOiI3RDVFQTBEQS1FM0ZDLTQ1NjAtOUYyMC0zM0E2MkQwOUFDOTQifX0sInN1YiI6IioiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInJvb20iOiJBMDgwMDkxRC1FMkY0LTRFQTgtQUI1Qi0xMDREMjNGMDA1MEEifQ.O0VFuxuxR--_gFzS4TuCfj2vNya19ZguR5DFQu3csqI
098fd3c4-ba84-47cf-bf57-23cb55202414	88fcdae3-1e3e-4e05-8fe0-103911b5e99c	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJuYmYiOjE2MDcyNjU5MzcuNzEwNjIxOCwicm9vbSI6Ijg4RkNEQUUzLTFFM0UtNEUwNS04RkUwLTEwMzkxMUI1RTk5QyIsImV4cCI6MTYwNzMzNTIyOC40NjQsImNvbnRleHQiOnsidXNlciI6eyJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwibmFtZSI6Ik5hZ3kgw4l2YSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImVtcGxveWVlIn0sImF1ZCI6InRpbWV0aWMtY2xpZW50In0.csFbz34kwVvPk4hi0nbT-k1-irkxHiislB5MoVAS5fc
61e22409-5303-4a7a-8905-a48cc0ed0913	88fcdae3-1e3e-4e05-8fe0-103911b5e99c	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJuYmYiOjE2MDcyNjU5MzcuNzExNTc3LCJyb29tIjoiODhGQ0RBRTMtMUUzRS00RTA1LThGRTAtMTAzOTExQjVFOTlDIiwiZXhwIjoxNjA3MzM1MjI4LjQ2NCwiY29udGV4dCI6eyJ1c2VyIjp7ImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsIm5hbWUiOiJLaXNzIEFubmEiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJjbGllbnQifSwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.yzUehJYxa2Ood9I-j54fwVYIHTi9FL1KGeW2u45c0fk
23f90fcd-cbbd-4b34-b2ec-02c650e9ee13	8d3f9109-f18d-4260-b8be-affc06fc0a9f	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDU1NzcwMDAuNjM1LCJzdWIiOiIqIiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSDDiXZhIn0sImdyb3VwIjoiZW1wbG95ZWUifSwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDU1Mzc0MjEuNTQyMzkzLCJyb29tIjoiOEQzRjkxMDktRjE4RC00MjYwLUI4QkUtQUZGQzA2RkMwQTlGIiwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.ZSJqaF6rntqKANGcLResybXutt5hJD8c4ZOO8nTjSQo
51b163e4-3aa5-44b9-83f1-ad8913c26582	8d3f9109-f18d-4260-b8be-affc06fc0a9f	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDU1NzcwMDAuNjM1LCJzdWIiOiIqIiwiY29udGV4dCI6eyJ1c2VyIjp7ImF2YXRhciI6IiIsImlkIjoiQkE1ODlBQjItMTI5Ny00ODFGLTgwQ0UtQTJGQkMxRkYxNzNGIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eStubUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSBNYWdkb2xuYSJ9LCJncm91cCI6ImNsaWVudCJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNTUzNzQyMS41NDMzMjYsInJvb20iOiI4RDNGOTEwOS1GMThELTQyNjAtQjhCRS1BRkZDMDZGQzBBOUYiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCJ9.7tWnH2QDR2zzryUh8zpRsSMJyMsOlt76Cw2HK1Lspck
43b38760-fcc9-4bc2-9323-c84af8751b22	e7da0570-e781-48a8-8dbf-30508a6f47e1	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImV4cCI6MTYwNjAwODc5Mi43ODYsInN1YiI6IioiLCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Ik5hZ3kgw4l2YSIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJyb29tIjoiRTdEQTA1NzAtRTc4MS00OEE4LThEQkYtMzA1MDhBNkY0N0UxIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJuYmYiOjE2MDU1NDAwNDUuNDY2MjF9.LIyhH6Ti4LyJiSZ9LhuSWRzCGFQyv4dW604S0KXzFeY
707f010e-fc36-428b-b1c5-445d12b0e3f4	e7da0570-e781-48a8-8dbf-30508a6f47e1	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDU1NDAwNDUuNDY3MTg4LCJleHAiOjE2MDYwMDg3OTIuNzg2LCJzdWIiOiIqIiwiY29udGV4dCI6eyJ1c2VyIjp7Im5hbWUiOiJLaXNzIEFubmEiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJjbGllbnQifSwicm9vbSI6IkU3REEwNTcwLUU3ODEtNDhBOC04REJGLTMwNTA4QTZGNDdFMSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.pXSiVQ86J9O8j_O5GRyN0sOcAvkrXPKatPBggjVaaf8
a90beac5-1385-4fdd-add5-b6b8fa31f510	26b29473-32ec-4b5c-be73-7fe7730982b2	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20ifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJuYmYiOjE2MDU1MzgwNTEuMjk0NzI2LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJyb29tIjoiMjZCMjk0NzMtMzJFQy00QjVDLUJFNzMtN0ZFNzczMDk4MkIyIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDYwMTk5NzEuNjk4fQ.gEElycRFm6L7x1FJ9y9Glu8Z_Cv7yQvI6bwwLVhHxIk
9f746a0a-cf0e-4732-848b-eef419e133b2	26b29473-32ec-4b5c-be73-7fe7730982b2	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJuYW1lIjoiS2lzcyBBbm5hIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSJ9LCJncm91cCI6ImNsaWVudCJ9LCJuYmYiOjE2MDU1MzgwNTEuMjk1NzMxLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJyb29tIjoiMjZCMjk0NzMtMzJFQy00QjVDLUJFNzMtN0ZFNzczMDk4MkIyIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJleHAiOjE2MDYwMTk5NzEuNjk4fQ.xekSC-BVGYELxDR5IAeh42PeZ7Lh96LkgR2iW8ayV9s
c4ffc89a-aafe-4eed-9fee-4c822a158b66	679f9c96-085c-48af-b90d-7a6cb791154f	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDczNTY5NzYuNzgzNzUyLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20ifX0sInJvb20iOiI2NzlGOUM5Ni0wODVDLTQ4QUYtQjkwRC03QTZDQjc5MTE1NEYiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImV4cCI6MTYwNzQ1MjIyMy41OTEsInN1YiI6IioifQ.SvUVaHQpk0h48aLfsjbHuE9EIlEpHZUiyCUJ4-CSsWg
59d6352c-b41c-4251-b8c7-2d20c2eab9f2	679f9c96-085c-48af-b90d-7a6cb791154f	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDczNTY5NzYuNzg0NzUyOCwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJpZCI6IjdENUVBMERBLUUzRkMtNDU2MC05RjIwLTMzQTYyRDA5QUM5NCIsIm5hbWUiOiJLb3bDoWNzIEthdGFsaW4iLCJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5K2trQGdtYWlsLmNvbSJ9fSwicm9vbSI6IjY3OUY5Qzk2LTA4NUMtNDhBRi1COTBELTdBNkNCNzkxMTU0RiIsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiZXhwIjoxNjA3NDUyMjIzLjU5MSwic3ViIjoiKiJ9.zcJN3GAwVxU53inlYxTswz0hkWv64RNW1VhhzT6naq0
0cfcd6dd-e9ba-4907-b0dc-3a39b264d9fb	0f2902de-8a85-48ea-b85d-26e04dd3cfa9	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiMEYyOTAyREUtOEE4NS00OEVBLUI4NUQtMjZFMDRERDNDRkE5IiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Ik5hZ3kgw4l2YSIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJzdWIiOiIqIiwiZXhwIjoxNjA3MzkyODMzLjIxLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzM3MDQzNy44NzE2OTg5fQ.n-_wT3Lr6drGHs89YlTGp23ZnuOje5wDg2Zj6_5io8U
519f55a1-3347-4ff4-a9d5-5330c6a5885e	0f2902de-8a85-48ea-b85d-26e04dd3cfa9	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiMEYyOTAyREUtOEE4NS00OEVBLUI4NUQtMjZFMDRERDNDRkE5IiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6IlBvbGwgQW5kcmVhIiwiZW1haWwiOiJhbmRyZWEucG9sbDA3QCBnbWFpbC5jb20iLCJpZCI6IjQwMDlBM0JELTI0MjktNDAzOC1CNjZBLTMwREQzODBCMERFQyIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJzdWIiOiIqIiwiZXhwIjoxNjA3MzkyODMzLjIxLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzM3MDQzNy44NzI1Nn0.33PR5FD_q4HcY_kmIYGL9Qluy1C1Uc-WtdWi6jGiyng
d2719e9b-695b-4bf0-b6cf-74cb60aef019	607992bd-4fdb-41d8-b2b4-93e509f021dd	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSDDiXZhIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJyb29tIjoiNjA3OTkyQkQtNEZEQi00MUQ4LUIyQjQtOTNFNTA5RjAyMUREIiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiZXhwIjoxNjA2MDEwNDQ0LjQxMywibmJmIjoxNjA1OTczMjE5Ljg5NjEyNiwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.ZJpc6ZrS-xZHz1dX5ESLg8cclONxXiZG4w4Xcmd1p5I
fa20788e-9227-438d-9f31-29457d53e46e	607992bd-4fdb-41d8-b2b4-93e509f021dd	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsIm5hbWUiOiJLaXNzIEFubmEiLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCJ9LCJncm91cCI6ImNsaWVudCJ9LCJyb29tIjoiNjA3OTkyQkQtNEZEQi00MUQ4LUIyQjQtOTNFNTA5RjAyMUREIiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiZXhwIjoxNjA2MDEwNDQ0LjQxMywibmJmIjoxNjA1OTczMjE5Ljg5OTkzNCwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.B9hl_z3tt2ZXeHOLN4LSIBpy9DvFg8E_TCsFEl58wHM
dcbeb61f-0acb-46c1-b1c5-74f0ca45cb72	d8e67bc2-b263-414f-99d1-81d7cc92b02f	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiJEOEU2N0JDMi1CMjYzLTQxNEYtOTlEMS04MUQ3Q0M5MkIwMkYiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJuYmYiOjE2MDU5NzMyNDYuMzIxMTQ4LCJleHAiOjE2MDYwMTI4MzcuMTYyLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJhdmF0YXIiOiIifSwiZ3JvdXAiOiJlbXBsb3llZSJ9fQ.-wTPsamwP5EDkB0hAuCiFjk8hsw-aqiIjoB-n7-lyK4
514ee1c6-4f8c-4f1e-a74d-4f512585da64	d8e67bc2-b263-414f-99d1-81d7cc92b02f	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiJEOEU2N0JDMi1CMjYzLTQxNEYtOTlEMS04MUQ3Q0M5MkIwMkYiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJuYmYiOjE2MDU5NzMyNDYuMzIyNjI4LCJleHAiOjE2MDYwMTI4MzcuMTYyLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJuYW1lIjoiS2lzcyBBbm5hIiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9fQ.L-3oWVmg-9tTNcXkklb_ApLGp7VWUehP54EBETthXE8
168bcf0f-279a-4a37-853a-9fedb5bdd8fa	f5af30cd-5450-4819-8e19-3c3a241fa7b1	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7ImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwibmFtZSI6Ik5hZ3kgw4l2YSIsImF2YXRhciI6IiIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIn19LCJzdWIiOiIqIiwibmJmIjoxNjA1OTczNTM1Ljk3MDcyNywiZXhwIjoxNjA2MDkzMjI3LjEzOSwicm9vbSI6IkY1QUYzMENELTU0NTAtNDgxOS04RTE5LTNDM0EyNDFGQTdCMSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.R-RRhu5S5C3U6BlvBcFiPWm8S8AEoWq_ct5ObfsYJjg
936df796-93ee-4cbe-a079-fa86d5c4842a	f5af30cd-5450-4819-8e19-3c3a241fa7b1	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCIsIm5hbWUiOiJLaXNzIEFubmEiLCJhdmF0YXIiOiIiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIn19LCJzdWIiOiIqIiwibmJmIjoxNjA1OTczNTM1Ljk3MjI3OCwiZXhwIjoxNjA2MDkzMjI3LjEzOSwicm9vbSI6IkY1QUYzMENELTU0NTAtNDgxOS04RTE5LTNDM0EyNDFGQTdCMSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.SVaGgb0ORnfhytjDlkhhY_Yj6QyLnViaCHWJ2if89FQ
ac456d9b-1aa0-4356-b12e-a94a188817c4	0f18962a-bdd2-4d66-9a3d-c048682fb7a3	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDU5NzM1NzIuOTcxNjU5LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImV4cCI6MTYwNjA5NjgwMC42ODQsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IjBGMTg5NjJBLUJERDItNEQ2Ni05QTNELUMwNDg2ODJGQjdBMyIsInN1YiI6IioiLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20ifSwiZ3JvdXAiOiJlbXBsb3llZSJ9fQ._bl8PXSuukJLfJCTXjpGIwlZ1KftLfoip8m91KhMBFo
78f7c771-deda-49fc-9331-720031393df3	0f18962a-bdd2-4d66-9a3d-c048682fb7a3	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDU5NzM1NzIuOTczMjI3LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImV4cCI6MTYwNjA5NjgwMC42ODQsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IjBGMTg5NjJBLUJERDItNEQ2Ni05QTNELUMwNDg2ODJGQjdBMyIsInN1YiI6IioiLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJuYW1lIjoiS2lzcyBBbm5hIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJuYWd5ZXZhQGdtYWlsLmNvbSJ9LCJncm91cCI6ImNsaWVudCJ9fQ.FdubN9wRXNpIOzXnCwbn3X81GMzMufnOgEdXax_-nkw
a3628431-558f-4759-a4eb-d0568a5838ac	f3b151ad-b110-4269-b21d-3c4ff070d635	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiRjNCMTUxQUQtQjExMC00MjY5LUIyMUQtM0M0RkYwNzBENjM1Iiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiY29udGV4dCI6eyJ1c2VyIjp7ImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIn0sImdyb3VwIjoiZW1wbG95ZWUifSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDYwOTUzODEuMDg0LCJuYmYiOjE2MDYwMDE3OTIuOTUwMjIxfQ.09NyZW3tUM432rkOboAeQPckEqoY7FoAXNq1r7ckQeI
b997e8a0-fc83-4c89-9880-6bd6591b4abb	f3b151ad-b110-4269-b21d-3c4ff070d635	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiRjNCMTUxQUQtQjExMC00MjY5LUIyMUQtM0M0RkYwNzBENjM1Iiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiY29udGV4dCI6eyJ1c2VyIjp7ImVtYWlsIjoiZXN6dHkuYmFqbW9jenkrbm1AZ21haWwuY29tIiwiaWQiOiJCQTU4OUFCMi0xMjk3LTQ4MUYtODBDRS1BMkZCQzFGRjE3M0YiLCJuYW1lIjoiTmFneSBNYWdkb2xuYSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImV4cCI6MTYwNjA5NTM4MS4wODQsIm5iZiI6MTYwNjAwMTc5Mi45NTE2OTc4fQ.TdANK_Y38hyqzOOrdu9pUBx32edRst0GuAAKo2k6sQc
2b96f328-418d-405d-acf9-f2d1fa7a26a6	12336279-c3df-4e1e-9d4d-cb37108b91c3	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImF2YXRhciI6IiIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwibmFtZSI6Ik5hZ3kgw4l2YSJ9LCJncm91cCI6ImVtcGxveWVlIn0sImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwic3ViIjoiKiIsIm5iZiI6MTYwNzM1NzIzOC42NTU1NzcsInJvb20iOiIxMjMzNjI3OS1DM0RGLTRFMUUtOUQ0RC1DQjM3MTA4QjkxQzMiLCJleHAiOjE2MDc0NTU4NDMuNDMxfQ.lTNpIYrgujsfEpvhWUCv0gwPfibIldEVbeThNkEVmZ8
b6664fd7-a1bc-4594-89e3-7c01a873a578	12336279-c3df-4e1e-9d4d-cb37108b91c3	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImNvbnRleHQiOnsidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5K2trQGdtYWlsLmNvbSIsImlkIjoiN0Q1RUEwREEtRTNGQy00NTYwLTlGMjAtMzNBNjJEMDlBQzk0IiwibmFtZSI6IktvdsOhY3MgS2F0YWxpbiJ9LCJncm91cCI6ImNsaWVudCJ9LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJuYmYiOjE2MDczNTcyMzguNjU2NTQ1Miwicm9vbSI6IjEyMzM2Mjc5LUMzREYtNEUxRS05RDRELUNCMzcxMDhCOTFDMyIsImV4cCI6MTYwNzQ1NTg0My40MzF9.0Cot6SUoIWQwJSrb41gpsLnIYTZZg4FlknDJK8JiK9s
49cbb164-769a-43f8-91bf-0e60ca5db9a4	71857144-75dd-4239-b76f-566936233189	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImNvbnRleHQiOnsidXNlciI6eyJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwibmFtZSI6Ik5hZ3kgw4l2YSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImVtcGxveWVlIn0sImV4cCI6MTYwODAzNzI1Ny4yODM5OTksImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IjcxODU3MTQ0LTc1REQtNDIzOS1CNzZGLTU2NjkzNjIzMzE4OSIsInN1YiI6IioiLCJuYmYiOjE2MDczNzgyODguNjgzNTYwOH0.WpY7YnS1niZ4KdYbbvsiKn1GzAKN2V-FQvHBPSVcC9g
313c3f65-0a1d-4747-8260-5aa888b23b43	1284b575-a8d8-46d9-bcc1-e7c0e790c57a	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzM4NzI2Ny4wNTk3MTUsInN1YiI6IioiLCJjb250ZXh0Ijp7InVzZXIiOnsiZW1haWwiOiJ4aWtvcGVzMjMzQHBpZG91bm8uY29tIiwiaWQiOiIzNTBDREY3Qi1EQkY4LTQyQUMtODRCNi1DMDE2MDU4RjU0MjMiLCJhdmF0YXIiOiIiLCJuYW1lIjoiVGVzenQgRWxlayJ9LCJncm91cCI6ImVtcGxveWVlIn0sImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwicm9vbSI6IjEyODRCNTc1LUE4RDgtNDZEOS1CQ0MxLUU3QzBFNzkwQzU3QSIsImV4cCI6MTYwOTQxNjAwMH0.h6t-EEcM4xCq4ftHY5Iqh5XuKVrqxUA02t3Kd8yWb_s
aff4ebc5-5575-403f-bf89-4afac46c17a5	71857144-75dd-4239-b76f-566936233189	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJjb250ZXh0Ijp7InVzZXIiOnsiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSIsImF2YXRhciI6IiJ9LCJncm91cCI6ImNsaWVudCJ9LCJleHAiOjE2MDgwMzcyNTcuMjgzOTk5LCJyb29tIjoiNzE4NTcxNDQtNzVERC00MjM5LUI3NkYtNTY2OTM2MjMzMTg5IiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDczNzgyODguNjg0NDk3OH0.7OhEJAytA-44f_FjSU7NucLzWnJoSLAdlnnyfNiFViw
398379a1-9b2d-4b5c-ba33-ab2d54e072de	1284b575-a8d8-46d9-bcc1-e7c0e790c57a	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzM4NzI2Ny4wNjEyODg4LCJzdWIiOiIqIiwiY29udGV4dCI6eyJ1c2VyIjp7ImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiaWQiOiJDNjkwNjZFNC0xNzhDLTRCODctQUNGMy1FMzI3NTg2Q0M1RDYiLCJhdmF0YXIiOiIiLCJuYW1lIjoiU2ltb24gQWTDqWwifSwiZ3JvdXAiOiJjbGllbnQifSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiMTI4NEI1NzUtQThEOC00NkQ5LUJDQzEtRTdDMEU3OTBDNTdBIiwiZXhwIjoxNjA5NDE2MDAwfQ.U_yJZ1QaSkJWIZaxHpVCG22kT2flmw6I4Yix7yfOD5E
0c93608b-e2b0-4164-976b-36bd1fba5f2b	c1a2a0a2-92b8-47b0-9f25-21c7170032cc	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSJ9LCJncm91cCI6ImNsaWVudCJ9LCJleHAiOjE2MDgyMzQ2MTUuNDE3LCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJuYmYiOjE2MDc0NTM0MjAuNTUzNDc5LCJyb29tIjoiQzFBMkEwQTItOTJCOC00N0IwLTlGMjUtMjFDNzE3MDAzMkNDIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.NNFfPDHwp28Y68KIzZvbz2CmyN0M31PmWK3x1GYXGnE
8cc64357-a421-4a2b-a21d-8eab576d17fb	5033af94-1d1b-4b36-8c0d-90b42cf2fbd7	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDc0NTYzNzEuMzEyNjA4LCJzdWIiOiIqIiwicm9vbSI6IjUwMzNBRjk0LTFEMUItNEIzNi04QzBELTkwQjQyQ0YyRkJENyIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJhdmF0YXIiOiIiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9fSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc0NzU2MjUuNjU1fQ.-Bizwos_DqMiVTgGw7BJ2r8fbPkbKK3bSXgiAEKQAEo
d0b8f449-df94-4452-bcd2-6afd68ab5db9	97101d1d-e99c-4667-93a1-3a4f639b04ec	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDYxNDg3MDcuMzg2ODU4LCJleHAiOjE2MDY0NDYwNDkuNDcxLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI5NzEwMUQxRC1FOTlDLTQ2NjctOTNBMS0zQTRGNjM5QjA0RUMiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Ik5hZ3kgw4l2YSIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiYXZhdGFyIjoiIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifSwiZ3JvdXAiOiJlbXBsb3llZSJ9fQ.7107dr06wn-uqvvLvddpkGOvH6bBgAkgvpqkGdn7qTE
f484218e-65a6-4232-a330-94dff6a9c924	97101d1d-e99c-4667-93a1-3a4f639b04ec	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDYxNDg3MDcuMzg4NDM3LCJleHAiOjE2MDY0NDYwNDkuNDcxLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI5NzEwMUQxRC1FOTlDLTQ2NjctOTNBMS0zQTRGNjM5QjA0RUMiLCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsInN1YiI6IioiLCJjb250ZXh0Ijp7InVzZXIiOnsibmFtZSI6Iktpc3MgQW5uYSIsImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJhdmF0YXIiOiIiLCJpZCI6IkUxNDRGM0FBLTdFNjUtNENGMC1CMDQ0LThEOTlENzkyRDNFOCJ9LCJncm91cCI6ImNsaWVudCJ9fQ.mSgn2irTLXcCIWoXG1ySxbTuTAeK7rfJyZx0gnSjsR0
b5797c97-6d92-4dbc-84c7-086ce3359162	9c4f93f1-b495-4f51-ba72-5e8a7fb42a5c	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDczNTcyMTMuODIwNDA3LCJyb29tIjoiOUM0RjkzRjEtQjQ5NS00RjUxLUJBNzItNUU4QTdGQjQyQTVDIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJzdWIiOiIqIiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJhdmF0YXIiOiIiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwibmFtZSI6Ik5hZ3kgw4l2YSJ9fSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc0NjMwMTguMjU2fQ.kpiJFZML03X-3CWoDrN5YTkFKwm1KKzfanBlpp9sLL8
f219e1a1-f689-4eba-b7ce-0abe3e3bb40f	9c4f93f1-b495-4f51-ba72-5e8a7fb42a5c	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDczNTcyMTMuODIxMzQ0LCJyb29tIjoiOUM0RjkzRjEtQjQ5NS00RjUxLUJBNzItNUU4QTdGQjQyQTVDIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJzdWIiOiIqIiwiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiI3RDVFQTBEQS1FM0ZDLTQ1NjAtOUYyMC0zM0E2MkQwOUFDOTQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5K2trQGdtYWlsLmNvbSIsIm5hbWUiOiJLb3bDoWNzIEthdGFsaW4ifX0sImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiZXhwIjoxNjA3NDYzMDE4LjI1Nn0.azrFTOw6wcZ_PwcfHLznvV8tUBfIVeuZ0GpZ0kXdtDQ
6f166623-d502-4311-8755-3e5c192d8707	82d1be0e-30f2-4b21-8df7-ad6e7ff2d013	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDczNzgxMDQuNDI0OTU0LCJleHAiOjE2MDc0MzI0NDcuNTg2OTk5LCJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7Im5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwiYXZhdGFyIjoiIn19LCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI4MkQxQkUwRS0zMEYyLTRCMjEtOERGNy1BRDZFN0ZGMkQwMTMifQ.9PpGwbJV9HU57y1rRFFDWNaTxQn2PYgiyVyyIbc2M2M
1d09a012-51e5-4323-babe-27ad2dbb02e2	82d1be0e-30f2-4b21-8df7-ad6e7ff2d013	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYmYiOjE2MDczNzgxMDQuNDI1ODk5LCJleHAiOjE2MDc0MzI0NDcuNTg2OTk5LCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJuYW1lIjoiS2lzcyBBbm5hIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwiYXZhdGFyIjoiIn19LCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInJvb20iOiI4MkQxQkUwRS0zMEYyLTRCMjEtOERGNy1BRDZFN0ZGMkQwMTMifQ.JHY2UbDrZ48Auu6H_4SuT_G8zVyFjRKdykKFvfbiNPM
67f92442-8dda-4dca-9461-1d0187ae2ef4	5033af94-1d1b-4b36-8c0d-90b42cf2fbd7	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDc0NzU2MjUuNjU1LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJuYmYiOjE2MDc0NTYzNzEuMzEzNTMxLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5K25zekBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSBTemlsdmlhIiwiYXZhdGFyIjoiIiwiaWQiOiJCNzk2REM3Mi1CMTE2LTQyODEtOEFGNi0zOTdEN0MyOUFGNjAifX0sImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwicm9vbSI6IjUwMzNBRjk0LTFEMUItNEIzNi04QzBELTkwQjQyQ0YyRkJENyJ9.dtijTD7QREY1-cmsM-vY1ciYbyreYX6X8xacdjxVy3Y
f7fdc172-468c-4263-ac31-2a93aeb33c3d	a2c7d27d-6e08-4581-8c60-7ac4c49364ef	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiQTJDN0QyN0QtNkUwOC00NTgxLThDNjAtN0FDNEM0OTM2NEVGIiwic3ViIjoiKiIsImV4cCI6MTYwOTQ4NDcwMCwiY29udGV4dCI6eyJ1c2VyIjp7ImVtYWlsIjoieGlrb3BlczIzM0BwaWRvdW5vLmNvbSIsImlkIjoiMzUwQ0RGN0ItREJGOC00MkFDLTg0QjYtQzAxNjA1OEY1NDIzIiwiYXZhdGFyIjoiIiwibmFtZSI6IlRlc3p0IEVsZWsifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzQ1Nzg3MC4wOTc5MDgsImF1ZCI6InRpbWV0aWMtY2xpZW50In0.7Sl_YT1GLx0jplfcoN1ZeKMEjZohgWJqZ5Iofj0QE4E
475ced1d-328a-4a29-8b24-8ef1cf142c52	a2c7d27d-6e08-4581-8c60-7ac4c49364ef	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiQTJDN0QyN0QtNkUwOC00NTgxLThDNjAtN0FDNEM0OTM2NEVGIiwic3ViIjoiKiIsImV4cCI6MTYwOTQ4NDcwMCwiY29udGV4dCI6eyJ1c2VyIjp7ImVtYWlsIjoiYW5kcmVhLnBvbGwwNythQGdtYWlsLmNvbSIsImlkIjoiNzIwNzMxNEYtOTE4RS00MEQxLTlFNTgtN0Q0MkZCMzI4OTQwIiwiYXZhdGFyIjoiIiwibmFtZSI6IlBvbGwgQW5kcmlzIn0sImdyb3VwIjoiY2xpZW50In0sImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwibmJmIjoxNjA3NDU3ODcwLjA5OTAxNCwiYXVkIjoidGltZXRpYy1jbGllbnQifQ.3lCGGIRdrRqkJThDpq3CVWq4y6VRMibrXAfXDDIRDBg
2ab50bb4-7858-46bf-9439-bdc2e04daf64	3d8e21f7-846a-4525-a347-9fc1890e5dc8	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc0NjY2NDAuNjg4OTk5Miwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiM0Q4RTIxRjctODQ2QS00NTI1LUEzNDctOUZDMTg5MEU1REM4IiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIiwiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9fSwibmJmIjoxNjA3MzU3MjA2LjczOTE3OH0.2lSNO5GBSrrMvy5mrLH0kHPj-mAVXZFdV9I8DnbPzcc
3813cb49-d320-428c-91d0-7fc487242904	3d8e21f7-846a-4525-a347-9fc1890e5dc8	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc0NjY2NDAuNjg4OTk5Miwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiM0Q4RTIxRjctODQ2QS00NTI1LUEzNDctOUZDMTg5MEU1REM4IiwiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsibmFtZSI6IktvdsOhY3MgS2F0YWxpbiIsImF2YXRhciI6IiIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenkra2tAZ21haWwuY29tIiwiaWQiOiI3RDVFQTBEQS1FM0ZDLTQ1NjAtOUYyMC0zM0E2MkQwOUFDOTQifX0sIm5iZiI6MTYwNzM1NzIwNi43NDAwNDd9.qNakKdkQ2XCmKRqozB89lpEI4zc5NhoU63Ziy073wo8
e1f51fb3-3c0d-4f77-9597-e80d894fff66	ca85656b-80a6-4353-bb2f-bbf17e71ca3a	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsIm5iZiI6MTYwNzM3ODM2OC40NzIyNDgsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9fSwic3ViIjoiKiIsImV4cCI6MTYwODEyNzIxNC44NTksInJvb20iOiJDQTg1NjU2Qi04MEE2LTQzNTMtQkIyRi1CQkYxN0U3MUNBM0EifQ.rzmqaIg6nv2cHzGtYl0MavnLxTRugIy9wqsLf6jWbnk
0288a2ac-1d1d-42dc-8430-00b303863931	ca85656b-80a6-4353-bb2f-bbf17e71ca3a	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsInN1YiI6IioiLCJleHAiOjE2MDgxMjcyMTQuODU5LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImNvbnRleHQiOnsiZ3JvdXAiOiJjbGllbnQiLCJ1c2VyIjp7ImF2YXRhciI6IiIsImVtYWlsIjoibmFneWV2YUBnbWFpbC5jb20iLCJuYW1lIjoiS2lzcyBBbm5hIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgifX0sInJvb20iOiJDQTg1NjU2Qi04MEE2LTQzNTMtQkIyRi1CQkYxN0U3MUNBM0EiLCJuYmYiOjE2MDczNzgzNjguNDczMjE1fQ.BXN88J97TCvByJki503E5CrnDy_c3qh6DTERFnOmudw
b80d2fd2-f701-421e-b7a1-592a70ebc683	eed8538d-745d-4ef0-b122-993c2175a6e4	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiRUVEODUzOEQtNzQ1RC00RUYwLUIxMjItOTkzQzIxNzVBNkU0Iiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwibmJmIjoxNjA3Mzg3NzQwLjQxOTYxODEsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCJ9fSwiZXhwIjoxNjA3NTY5MjMyLjM4Mzk5OTh9.uY4CtcuKCezRDtG1FEmrsga5edyQQIpDaRU1GD9sIWs
58281a11-dada-4031-9201-44b302f85f27	eed8538d-745d-4ef0-b122-993c2175a6e4	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb29tIjoiRUVEODUzOEQtNzQ1RC00RUYwLUIxMjItOTkzQzIxNzVBNkU0Iiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwibmJmIjoxNjA3Mzg3NzQwLjQyMDUxNywiYXVkIjoidGltZXRpYy1jbGllbnQiLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJhdmF0YXIiOiIiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4In19LCJleHAiOjE2MDc1NjkyMzIuMzgzOTk5OH0.akYH7yL5u_oWQ3ByqmU2SXQOnSYVHzl06xg-Ic5cV64
53bd83a1-0bfb-4230-8d16-a320cf3747ab	e4e88951-998f-4176-937d-1c8811a16897	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwicm9vbSI6IkU0RTg4OTUxLTk5OEYtNDE3Ni05MzdELTFDODgxMUExNjg5NyIsIm5iZiI6MTYwNzQyNDM5MC42MTk0NTIsImNvbnRleHQiOnsiZ3JvdXAiOiJlbXBsb3llZSIsInVzZXIiOnsiZW1haWwiOiJlc3p0eS5iYWptb2N6eUBnbWFpbC5jb20iLCJuYW1lIjoiTmFneSDDiXZhIiwiYXZhdGFyIjoiIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQifX0sImV4cCI6MTYwNzQzOTYwMCwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiJ9.zEuiiPAwJcti9sV6AfakyF5aBqwfGyOfJ9B4ko7yBjg
b93b05df-c0a1-47bd-901d-1c4bf16405f3	e4e88951-998f-4176-937d-1c8811a16897	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIqIiwicm9vbSI6IkU0RTg4OTUxLTk5OEYtNDE3Ni05MzdELTFDODgxMUExNjg5NyIsIm5iZiI6MTYwNzQyNDM5MC42MjA5NjQsImNvbnRleHQiOnsiZ3JvdXAiOiJjbGllbnQiLCJ1c2VyIjp7ImVtYWlsIjoiYW5kcmVhLnBvbGwwNythQGdtYWlsLmNvbSIsIm5hbWUiOiJQb2xsIEFuZHJpcyIsImF2YXRhciI6IiIsImlkIjoiNzIwNzMxNEYtOTE4RS00MEQxLTlFNTgtN0Q0MkZCMzI4OTQwIn19LCJleHAiOjE2MDc0Mzk2MDAsImF1ZCI6InRpbWV0aWMtY2xpZW50IiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24ifQ.OazPqP3iK2WZrxSS4RMAYCVzlhNjTiCHxbQcw_xQpTg
a8635d89-aaa4-4ca9-bfd3-b3bc2c38118a	11730323-c156-42d8-b8b4-8cd238bc2d9e	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDczNTczNzUuMTM3MzIxLCJyb29tIjoiMTE3MzAzMjMtQzE1Ni00MkQ4LUI4QjQtOENEMjM4QkMyRDlFIiwic3ViIjoiKiIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEiLCJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImF2YXRhciI6IiJ9fSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc0NTk0MzAuNTE0OTk5OX0.bMG46w04t24adYEvXL0HhKwkBfEuDB1R7hJdaTTLYtw
a44e6302-2780-40e6-a031-8e72e47e43a5	f10e7cb1-a019-4aa6-ab7f-e3b368ef9177	employee	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDYxNDc0MjYuNzYxMDQ3OCwiZXhwIjoxNjA2MTc5ODIzLjczMywiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiRjEwRTdDQjEtQTAxOS00QUE2LUFCN0YtRTNCMzY4RUY5MTc3IiwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJpZCI6IkI3MERFNTdFLThFMDctNDc3Qi1BMjZFLTEyQTBCQ0Q0N0Q1NCIsImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwibmFtZSI6Ik5hZ3kgw4l2YSIsImF2YXRhciI6IiJ9fX0.JVScbtcFcg-5F_8WwJuu_MduYSUss4jE0admoSsAy5k
3de41c7b-62c2-410a-bef4-6dfe6cfb44fa	f10e7cb1-a019-4aa6-ab7f-e3b368ef9177	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDYxNDc0MjYuNzYzNzE3MiwiZXhwIjoxNjA2MTc5ODIzLjczMywiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJzdWIiOiIqIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJyb29tIjoiRjEwRTdDQjEtQTAxOS00QUE2LUFCN0YtRTNCMzY4RUY5MTc3IiwiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSIsImF2YXRhciI6IiJ9fX0.NSHP8nJ3EqIWRuPASuORI0g8hfu2vzb3odTDNxJUdbI
87433191-e726-46f7-a16e-ad59522857f6	e72f7b46-9285-4abd-94c9-b8c52bf4a5d9	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDYzNTk4MzcuMjc3OTk5OSwiY29udGV4dCI6eyJncm91cCI6ImVtcGxveWVlIiwidXNlciI6eyJhdmF0YXIiOiIiLCJuYW1lIjoiTmFneSDDiXZhIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSJ9fSwic3ViIjoiKiIsImF1ZCI6InRpbWV0aWMtY2xpZW50Iiwicm9vbSI6IkU3MkY3QjQ2LTkyODUtNEFCRC05NEM5LUI4QzUyQkY0QTVEOSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwibmJmIjoxNjA2MTQ3NDQyLjExODg5MzF9.xEqDpMP6GY75g0-pj61jV9LyAq9RHWAXniVbpT6wWJA
6424613f-8f1a-4875-a737-5df7a0cdef9b	e72f7b46-9285-4abd-94c9-b8c52bf4a5d9	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb29tIjoiRTcyRjdCNDYtOTI4NS00QUJELTk0QzktQjhDNTJCRjRBNUQ5IiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJpc3MiOiJ0aW1ldGljLWNvbnN1bHRhdGlvbiIsImV4cCI6MTYwNjM1OTgzNy4yNzc5OTk5LCJzdWIiOiIqIiwiY29udGV4dCI6eyJncm91cCI6ImNsaWVudCIsInVzZXIiOnsiYXZhdGFyIjoiIiwibmFtZSI6Ik1vbG7DoXIgRnJ1enNpIiwiaWQiOiJGQTQ4QUUyRS03NzU2LTQyQjUtQUNCQi1BMDYwMjUxMkY2MTAiLCJlbWFpbCI6Im5hZ3lldmEyQGdtYWlsLmNvbSJ9fSwibmJmIjoxNjA2MTQ3NDQyLjEyMTQ0MTh9.gV3RsTm1MADPLPWSjdKDSWYiZh3AiRengXFTwirLRXE
e04a5920-aad5-41cb-b95e-c27739941bec	11730323-c156-42d8-b8b4-8cd238bc2d9e	client	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE2MDczNTczNzUuMTM4MTksInJvb20iOiIxMTczMDMyMy1DMTU2LTQyRDgtQjhCNC04Q0QyMzhCQzJEOUUiLCJzdWIiOiIqIiwiaXNzIjoidGltZXRpYy1jb25zdWx0YXRpb24iLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJlbWFpbCI6ImVzenR5LmJham1vY3p5K2trQGdtYWlsLmNvbSIsIm5hbWUiOiJLb3bDoWNzIEthdGFsaW4iLCJpZCI6IjdENUVBMERBLUUzRkMtNDU2MC05RjIwLTMzQTYyRDA5QUM5NCIsImF2YXRhciI6IiJ9fSwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc0NTk0MzAuNTE0OTk5OX0.lrDA3B4VEFh2194mwcvEMdjTQR2XHmTWN_YNDxDlK3o
67ffb03f-3afb-4ff8-9f93-f059e61e61cb	b78f644c-49d5-4167-b85c-bc889fc3c946	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc0NTIyNTkuNTc5OTk5LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IkI3OEY2NDRDLTQ5RDUtNDE2Ny1CODVDLUJDODg5RkMzQzk0NiIsInN1YiI6IioiLCJjb250ZXh0Ijp7Imdyb3VwIjoiZW1wbG95ZWUiLCJ1c2VyIjp7ImVtYWlsIjoiZXN6dHkuYmFqbW9jenlAZ21haWwuY29tIiwibmFtZSI6Ik5hZ3kgw4l2YSIsImlkIjoiQjcwREU1N0UtOEUwNy00NzdCLUEyNkUtMTJBMEJDRDQ3RDU0IiwiYXZhdGFyIjoiIn19LCJuYmYiOjE2MDczNzgyMzAuMzAyNTI4fQ.M74fJ_WTFJHRw51YzWkWiCVDNmEmET3-M_Qc2KBLf3M
65a2142b-ffb2-4e1a-97e8-318097f9e531	b78f644c-49d5-4167-b85c-bc889fc3c946	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDc0NTIyNTkuNTc5OTk5LCJhdWQiOiJ0aW1ldGljLWNsaWVudCIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwicm9vbSI6IkI3OEY2NDRDLTQ5RDUtNDE2Ny1CODVDLUJDODg5RkMzQzk0NiIsInN1YiI6IioiLCJjb250ZXh0Ijp7Imdyb3VwIjoiY2xpZW50IiwidXNlciI6eyJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSIsImlkIjoiRTE0NEYzQUEtN0U2NS00Q0YwLUIwNDQtOEQ5OUQ3OTJEM0U4IiwiYXZhdGFyIjoiIn19LCJuYmYiOjE2MDczNzgyMzAuMzAzNzU2fQ.Y5acKUxF7_eKwIOn3LJ6y3WvnGApO0HkXU2txUQIIgo
16e4f6c7-1193-4e4d-a22f-1f5e3f33a458	d57e56eb-3d4e-42c0-8b73-b1abe3915d89	employee	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiJCNzBERTU3RS04RTA3LTQ3N0ItQTI2RS0xMkEwQkNENDdENTQiLCJlbWFpbCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsIm5hbWUiOiJOYWd5IMOJdmEifSwiZ3JvdXAiOiJlbXBsb3llZSJ9LCJzdWIiOiIqIiwicm9vbSI6IkQ1N0U1NkVCLTNENEUtNDJDMC04QjczLUIxQUJFMzkxNUQ4OSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc1ODk2NzAuNDA1LCJuYmYiOjE2MDc0MTMyNzYuNTk3NDQ1fQ.ngst1Opl-ax5cLEX123gURsHQO0tidCF314G-P5VNZU
1f122383-e1be-4043-a0ba-ab5b54ef5bf1	d57e56eb-3d4e-42c0-8b73-b1abe3915d89	client	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiIiwiaWQiOiJFMTQ0RjNBQS03RTY1LTRDRjAtQjA0NC04RDk5RDc5MkQzRTgiLCJlbWFpbCI6Im5hZ3lldmFAZ21haWwuY29tIiwibmFtZSI6Iktpc3MgQW5uYSJ9LCJncm91cCI6ImNsaWVudCJ9LCJzdWIiOiIqIiwicm9vbSI6IkQ1N0U1NkVCLTNENEUtNDJDMC04QjczLUIxQUJFMzkxNUQ4OSIsImlzcyI6InRpbWV0aWMtY29uc3VsdGF0aW9uIiwiYXVkIjoidGltZXRpYy1jbGllbnQiLCJleHAiOjE2MDc1ODk2NzAuNDA1LCJuYmYiOjE2MDc0MTMyNzYuNTk4MzYyfQ.3RqU3jf5PgWNRk-lzZs2HL1GA1LLjDdo2k0U976Th1Q
\.


--
-- TOC entry 3035 (class 0 OID 16395)
-- Dependencies: 203
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.organizations (id, created_at, name, addresses, details, can_client_contact_employees, client_personal_info_fields, jitsi_url) FROM stdin;
a93faa86-ae9e-4dc2-a8a9-9c861d2821c0	1604225295.36817	Kozmetika	{"1117 Budapest, Béke út 24.",Ügyfélnél,Online}	Részletek a cégről	t	{"Taj szám",Gyógyszerallergia}	https://optipus.ddns.net:8071
\.


--
-- TOC entry 3042 (class 0 OID 16504)
-- Dependencies: 210
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.password_resets (id, subject_email, validation_code) FROM stdin;
88dcc5eb-8d66-425a-a693-2a546f472984	eszty.bajmoczy@gmail.com	263464
\.


--
-- TOC entry 3041 (class 0 OID 16491)
-- Dependencies: 209
-- Data for Name: personal_infos; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.personal_infos (id, key, value, client_id) FROM stdin;
591611b8-d1ed-4d8d-a03e-4b28a0824834	Taj szám	123654987	c69066e4-178c-4b87-acf3-e327586cc5d6
19b8a800-2867-4051-b785-ae32acf07a73	Taj szám	123654987	e144f3aa-7e65-4cf0-b044-8d99d792d3e8
9bd05c6f-6a49-44c5-8341-09751bb8876a	Taj szám	123654987	fa48ae2e-7756-42b5-acbb-a0602512f610
8e94b2a8-2a1d-4ec1-8b99-b29bc86e2262	Taj szám	123654987	cbc30cd5-886b-4b94-8364-a407288edee2
b341d99c-0fb7-4c08-a216-3bf6be8e1bda	Taj szám	123654987	851a13c7-1888-44c2-bb30-e7e3a6def27b
b988e94e-4919-43d3-a430-1b919cb855bc	Taj szám	123654987	1a7907db-1c07-491d-8293-dff57e574f09
745d6d74-4ac3-4422-a61b-e34a32ecbc78	Taj szám	123654987	36853cb0-fd0e-4c4c-b799-590736bba43c
2a66e3b9-9786-426a-892a-6667ff1ef56e	Taj szám	123654987	7d5ea0da-e3fc-4560-9f20-33a62d09ac94
e4787cfd-8854-4bc0-bf4b-f5a16bcafe9c	Taj szám	123654987	876e646e-8108-4dba-baa5-67af6ba4928a
b5f54b8e-134b-4cf0-9031-b1fd26356444	Taj szám	123654987	ba589ab2-1297-481f-80ce-a2fbc1ff173f
7b8276ee-f1ca-4cf9-aaef-6dddfd435939	Gyógyszerallergia	Nincs	c69066e4-178c-4b87-acf3-e327586cc5d6
6fbc2ea9-85d1-4f3a-9091-18646668ab58	Gyógyszerallergia	Nincs	e144f3aa-7e65-4cf0-b044-8d99d792d3e8
989df031-307e-4712-a0f5-f82c641e2080	Gyógyszerallergia	Nincs	fa48ae2e-7756-42b5-acbb-a0602512f610
9c2e1a97-2378-4ea2-a03c-9b0a9a599488	Gyógyszerallergia	Nincs	cbc30cd5-886b-4b94-8364-a407288edee2
7b96905d-29fb-4c45-b44b-6d81113ce21f	Gyógyszerallergia	Nincs	851a13c7-1888-44c2-bb30-e7e3a6def27b
e652b67b-7fcd-4341-9d16-7b2a275d0cdf	Gyógyszerallergia	Nincs	1a7907db-1c07-491d-8293-dff57e574f09
d6e528d2-f4bd-4ca4-8291-d7fa56412360	Gyógyszerallergia	Nincs	36853cb0-fd0e-4c4c-b799-590736bba43c
6eda20f6-68aa-47d6-bf5c-26f9a241b97b	Gyógyszerallergia	Nincs	7d5ea0da-e3fc-4560-9f20-33a62d09ac94
9ebf7435-e41e-4b56-9154-760b7031a150	Gyógyszerallergia	Nincs	876e646e-8108-4dba-baa5-67af6ba4928a
454f349f-c204-4087-a6b6-eb9f45d90a61	Gyógyszerallergia	Nincs	ba589ab2-1297-481f-80ce-a2fbc1ff173f
5c3b79af-d55e-4598-83af-547f1880c52c	Gyógyszerallergia	Nincs	087c16c0-5cb9-408c-bf6a-2faf88acf35d
3fb910b3-a35f-4793-941a-da5e576eef23	Gyógyszerallergia	Nincs	059a3378-b0ea-4919-bd5c-bb99500f1194
efaaf0d6-4794-4e20-b59b-d250666d3f88	Gyógyszerallergia	Nincs	0041bb64-67cf-4109-b65e-a14255f08726
6365d2d0-e9ce-4367-89de-d02d548f4f34	Gyógyszerallergia	Nincs	39359c8c-5994-4ffc-90e3-bc8067a00d8a
2358f0e9-cce9-4be2-8147-c894fa21fefe	Gyógyszerallergia	Nincs	99e51c00-5c33-480a-a836-e0bce4077c9b
a62414da-1171-4e55-b458-7a132815b9bf	Gyógyszerallergia	Nincs	4009a3bd-2429-4038-b66a-30dd380b0dec
f657eaee-e470-4fba-8f0c-baa6d1d218fd	Gyógyszerallergia	Nincs	7e1e1ca8-7a03-4493-808b-e0606c04f630
c092c6b3-e010-4160-9056-50bd31b8fc62	Gyógyszerallergia	Nincs	be4c3dad-b836-4164-a9a1-d716976493ea
dc5fa893-eef1-4522-a4cf-4ebabf21e496	Gyógyszerallergia	Nincs	7207314f-918e-40d1-9e58-7d42fb328940
9844ef8b-c915-4ed7-b107-3e92b365594e	Gyógyszerallergia	Nincs	6a0bf0c8-b096-494d-bf31-3939bfb14c85
e5f220ec-3ddf-4aa9-85de-cef05ced823d	Gyógyszerallergia	Nincs	cbc30cd5-886b-4b94-8364-a407288edee2
f4e4e3a4-3d4f-4435-8837-402c6a89f996	Gyógyszerallergia	Nincs	e144f3aa-7e65-4cf0-b044-8d99d792d3e8
5db59ebf-3f0d-4234-b18f-d868e7dd2310	Gyógyszerallergia	Nincs	b796dc72-b116-4281-8af6-397d7c29af60
0f6c0fe4-cd97-41e4-ab13-60ffb6fa355c	Gyógyszerallergia	Nincs	6c71253b-a200-4782-8685-eca6396b49b3
f69b6d3d-9e20-4e76-b3d9-add648297959	Taj szám	123654987	087c16c0-5cb9-408c-bf6a-2faf88acf35d
79e4fffb-9d16-4c98-864d-309ca8be1f14	Taj szám	123654987	059a3378-b0ea-4919-bd5c-bb99500f1194
ba67a0a1-5091-4465-8bd6-93af302bc0d2	Taj szám	123654987	0041bb64-67cf-4109-b65e-a14255f08726
61abc40c-ebd7-47f0-af04-e9813a5acc5f	Taj szám	123654987	39359c8c-5994-4ffc-90e3-bc8067a00d8a
2ce7dd62-91d9-4985-a60c-cc1715b22096	Taj szám	123654987	99e51c00-5c33-480a-a836-e0bce4077c9b
0ed51f01-0a9b-4fc0-9c2d-81c6907143df	Taj szám	123654987	4009a3bd-2429-4038-b66a-30dd380b0dec
c4e9ea68-77a2-4a21-b6b7-acd546cca268	Taj szám	123654987	7e1e1ca8-7a03-4493-808b-e0606c04f630
1d119499-25f6-442f-b2a3-1d14593d7d53	Taj szám	123654987	be4c3dad-b836-4164-a9a1-d716976493ea
45d85f89-bf56-4bed-9fa9-059ace20b10c	Taj szám	123654987	7207314f-918e-40d1-9e58-7d42fb328940
454f3f62-c8a6-48c2-882d-eca398e99715	Taj szám	123654987	6a0bf0c8-b096-494d-bf31-3939bfb14c85
684f878a-09bf-4c18-b5b4-8208f0adc3a2	Taj szám	123654987	cbc30cd5-886b-4b94-8364-a407288edee2
e913be64-9564-4dc2-a13b-838d2e215d40	Taj szám	123654987	e144f3aa-7e65-4cf0-b044-8d99d792d3e8
33c175ac-0102-41c5-a0da-d71784af6243	Taj szám	123654987	b796dc72-b116-4281-8af6-397d7c29af60
fb83948c-a39a-4a3a-af5f-57cde3fd46bd	Taj szám	123654987	6c71253b-a200-4782-8685-eca6396b49b3
\.


--
-- TOC entry 2871 (class 2606 OID 16392)
-- Name: _fluent_migrations _fluent_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public._fluent_migrations
    ADD CONSTRAINT _fluent_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 2877 (class 2606 OID 16410)
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- TOC entry 2887 (class 2606 OID 16453)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- TOC entry 2879 (class 2606 OID 16423)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 2889 (class 2606 OID 16478)
-- Name: employee+activity employee+activity_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."employee+activity"
    ADD CONSTRAINT "employee+activity_pkey" PRIMARY KEY (id);


--
-- TOC entry 2883 (class 2606 OID 16438)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- TOC entry 2897 (class 2606 OID 16522)
-- Name: jitsi_consultations jitsi_consultations_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.jitsi_consultations
    ADD CONSTRAINT jitsi_consultations_pkey PRIMARY KEY (id);


--
-- TOC entry 2875 (class 2606 OID 16402)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 2895 (class 2606 OID 16511)
-- Name: password_resets password_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_pkey PRIMARY KEY (id);


--
-- TOC entry 2893 (class 2606 OID 16498)
-- Name: personal_infos personal_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.personal_infos
    ADD CONSTRAINT personal_infos_pkey PRIMARY KEY (id);


--
-- TOC entry 2873 (class 2606 OID 16394)
-- Name: _fluent_migrations uq:_fluent_migrations.name; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public._fluent_migrations
    ADD CONSTRAINT "uq:_fluent_migrations.name" UNIQUE (name);


--
-- TOC entry 2881 (class 2606 OID 16425)
-- Name: clients uq:clients.email; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT "uq:clients.email" UNIQUE (email);


--
-- TOC entry 2891 (class 2606 OID 16480)
-- Name: employee+activity uq:employee+activity.activity_id+employee+activity.employee_id; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."employee+activity"
    ADD CONSTRAINT "uq:employee+activity.activity_id+employee+activity.employee_id" UNIQUE (activity_id, employee_id);


--
-- TOC entry 2885 (class 2606 OID 16440)
-- Name: employees uq:employees.email; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT "uq:employees.email" UNIQUE (email);


--
-- TOC entry 2898 (class 2606 OID 16411)
-- Name: activities activities_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 2903 (class 2606 OID 16464)
-- Name: appointments appointments_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 2901 (class 2606 OID 16454)
-- Name: appointments appointments_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- TOC entry 2902 (class 2606 OID 16459)
-- Name: appointments appointments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- TOC entry 2904 (class 2606 OID 16469)
-- Name: appointments appointments_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 2899 (class 2606 OID 16426)
-- Name: clients clients_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 2905 (class 2606 OID 16481)
-- Name: employee+activity employee+activity_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."employee+activity"
    ADD CONSTRAINT "employee+activity_activity_id_fkey" FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 2906 (class 2606 OID 16486)
-- Name: employee+activity employee+activity_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."employee+activity"
    ADD CONSTRAINT "employee+activity_employee_id_fkey" FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- TOC entry 2900 (class 2606 OID 16441)
-- Name: employees employees_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 2907 (class 2606 OID 16499)
-- Name: personal_infos personal_infos_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.personal_infos
    ADD CONSTRAINT personal_infos_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


-- Completed on 2020-12-08 22:47:02 CET

--
-- PostgreSQL database dump complete
--

