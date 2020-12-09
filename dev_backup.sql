--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

-- Started on 2020-12-08 21:31:54 CET

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
-- TOC entry 204 (class 1259 OID 16405)
-- Name: organizations; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.organizations (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    name text NOT NULL,
    server_url text NOT NULL
);


ALTER TABLE public.organizations OWNER TO vaporuser;

--
-- TOC entry 205 (class 1259 OID 16413)
-- Name: password_resets; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.password_resets (
    id uuid NOT NULL,
    subject_email text NOT NULL,
    validation_code bigint NOT NULL
);


ALTER TABLE public.password_resets OWNER TO vaporuser;

--
-- TOC entry 206 (class 1259 OID 16421)
-- Name: user+organization; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public."user+organization" (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    organization_id uuid NOT NULL
);


ALTER TABLE public."user+organization" OWNER TO vaporuser;

--
-- TOC entry 203 (class 1259 OID 16395)
-- Name: users; Type: TABLE; Schema: public; Owner: vaporuser
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    created_at double precision NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    hashed_password text NOT NULL,
    is_admin boolean NOT NULL,
    refresh_token text
);


ALTER TABLE public.users OWNER TO vaporuser;

--
-- TOC entry 2986 (class 0 OID 16385)
-- Dependencies: 202
-- Data for Name: _fluent_migrations; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public._fluent_migrations (id, name, batch, created_at, updated_at) FROM stdin;
9e187f93-9ddf-454f-81b7-d5fa8bf1e074	App.CreateUser	1	2020-10-15 18:45:14.195441+00	2020-10-15 18:45:14.195441+00
48ba9c18-371e-4a23-9039-7354fc159e50	App.CreateOrganization	1	2020-10-15 18:45:14.270744+00	2020-10-15 18:45:14.270744+00
89b04264-a3e6-4fff-951d-d6c3a6d4887a	App.CreateTestData	1	2020-10-15 18:45:14.587226+00	2020-10-15 18:45:14.587226+00
539a8eff-729b-4b0a-abfd-9f92757e1caa	App.CreatePasswordReset	2	2020-11-09 20:30:10.886711+00	2020-11-09 20:30:10.886711+00
af8c6312-9f68-4479-819d-47e322551406	App.CreateUserOrganization	3	2020-11-11 17:09:23.311412+00	2020-11-11 17:09:23.311412+00
\.


--
-- TOC entry 2988 (class 0 OID 16405)
-- Dependencies: 204
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.organizations (id, created_at, name, server_url) FROM stdin;
559fe09a-c71f-4540-868f-d4ac3d7f74c7	1603039338.3143191	Kozmetika	https://optipus.ddns.net:8888
88892c1e-b4e2-4d94-a5f5-cd399405e4ed	1603298777.575366	Karate (nem létező szerver)	https://optipus.ddns.net:8899
\.


--
-- TOC entry 2989 (class 0 OID 16413)
-- Dependencies: 205
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.password_resets (id, subject_email, validation_code) FROM stdin;
58753dd3-26a0-40df-b0c7-74b303317884	eszty.bajmoczy+kk@gmail.com	516737
\.


--
-- TOC entry 2990 (class 0 OID 16421)
-- Dependencies: 206
-- Data for Name: user+organization; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public."user+organization" (id, user_id, organization_id) FROM stdin;
7f856490-9d2f-40a2-8e2a-07006e2a5143	b81117c1-56f2-4f10-9d90-bd5be0cd06d8	559fe09a-c71f-4540-868f-d4ac3d7f74c7
21fc15d6-c646-4611-b4a3-d7d721853ef5	8f08def7-bae5-4790-bc2d-e69dd540ce14	559fe09a-c71f-4540-868f-d4ac3d7f74c7
59edf4f2-92ef-4f33-a596-d0ac9bbc42cc	de926c0f-6dd3-4fa0-8da5-51a3573e95dd	559fe09a-c71f-4540-868f-d4ac3d7f74c7
056e0b40-3d16-4205-9ae2-d5369bf53185	c82fb868-2b99-4fd4-aabb-c451caffb5a6	559fe09a-c71f-4540-868f-d4ac3d7f74c7
8b99938a-6393-424a-813f-501bdc791d7c	7db5e3e2-ea1c-4439-9be9-6587dc355c1a	559fe09a-c71f-4540-868f-d4ac3d7f74c7
c2b30b09-4715-4989-a5bf-b89fb51b14c5	0bfb3a1c-b761-4ecc-83f9-7b2a51b96a96	559fe09a-c71f-4540-868f-d4ac3d7f74c7
74d67542-1f18-470f-a6de-3670fdbadef2	938a62bc-2fd7-449c-a61a-fd499b81cb9e	559fe09a-c71f-4540-868f-d4ac3d7f74c7
424e4639-7db9-41e0-aa85-22fb5b5c7a7d	85ffeb86-9ae1-460f-ac37-233f0d407cc5	559fe09a-c71f-4540-868f-d4ac3d7f74c7
57a625f2-6548-49a8-85c4-47cdb06ddf41	7d8d87a0-97f6-4df6-81f9-cb57a4148e40	559fe09a-c71f-4540-868f-d4ac3d7f74c7
690a3ee1-9998-473f-a880-b761e2892430	14cd9162-3063-4551-b4a9-2601a40f217d	559fe09a-c71f-4540-868f-d4ac3d7f74c7
c4a417f6-2548-4f08-a21f-502bb09c367e	ad62a730-175d-437e-a432-645690ec5c56	559fe09a-c71f-4540-868f-d4ac3d7f74c7
eadb9fa5-3fff-4f5d-b4e2-f8da91a528a0	5eefc0b9-bae0-442a-85e6-8db5dd5dfac2	559fe09a-c71f-4540-868f-d4ac3d7f74c7
\.


--
-- TOC entry 2987 (class 0 OID 16395)
-- Dependencies: 203
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vaporuser
--

COPY public.users (id, created_at, name, email, hashed_password, is_admin, refresh_token) FROM stdin;
db24074c-d221-4ff2-bb0d-d3c08807b249	1602787514.5771232	Kristóf	mihaly.kristof97@gmail.com	$2b$12$DKS1HCdgnHo8QOLeoToyM.TsdmKyozNbFR7Ecdtme2tRGmCFMrmXm	t	\N
b81117c1-56f2-4f10-9d90-bd5be0cd06d8	1604935618.354862	Eszter B	eszty.bajmoczy@gmail.com	$2b$12$X/xYEWxnphqK1ZzxcyE.jOXEzF0IEMB1IkoFg0oESkOV/1CYnraOq	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5QGdtYWlsLmNvbSIsImV4cCI6MTYwNzkwNTE3My45NTgwNDc5LCJzdWIiOiJ1c2VyK3Rva2VuIiwicHVyIjoicmVmcmVzaCJ9.DGAvhXbGMXjbi1BRHR4kaCcN62q5kObScTAy0l6V9yE
5eefc0b9-bae0-442a-85e6-8db5dd5dfac2	1607456903.591022	Nagy Anna Sára	eszty.bajmoczy+nas@gmail.com	$2b$12$MdAn9d86lUu5uzg4XGoMo.51PmzAdHvG.T3iJswD9I1G.UJoaizGG	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjEwMDQ4OTA0LjI4MjIwNiwic3ViIjoidXNlcit0b2tlbiIsImlkIjoiZXN6dHkuYmFqbW9jenkrbmFzQGdtYWlsLmNvbSJ9.-bqgTc8hGdYsrDadR3bUCkqXY7Nvi_RHMrqh52cpAns
0ef00255-22dd-45f1-b817-b6e9ea1e2832	1605802142.326611	Nagy Anna Annamária	eszty.bajmoczy+naa@gmail.com	$2b$12$vgq1cNbYm6ygZIToqYi2eOzLMQZYYAQeGgYuQhaCdypsddxrUVUUu	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDgzOTQxNDQuNTgyODE0LCJpZCI6ImVzenR5LmJham1vY3p5K25hYUBnbWFpbC5jb20iLCJwdXIiOiJyZWZyZXNoIiwic3ViIjoidXNlcit0b2tlbiJ9.8VrIbWqJJ4XkYM-_GwCOKCLtcgY_yPV4wpEfMDOO7X0
78c72cb2-dbca-4594-9ee9-bc693d9ebab6	1605305512.926046	Nagy Anna	eszty.bajmoczy+1@gmsil.com	$2b$12$EqFitNpRIroh2Dz6K5xrTOUahVtifwDvYUa0mRfGFSxU0W74uO6Jm	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5KzFAZ21zaWwuY29tIiwic3ViIjoidXNlcit0b2tlbiIsImV4cCI6MTYwNzg5NzUxMy43MDYyNSwicHVyIjoicmVmcmVzaCJ9.NCWkC_IhWfq7M5mq0nqAL0_5x6gVl4_h79Ch2e6TlO4
1f06858b-6455-4bd2-a84e-a4cee4d6059d	1605306027.74586	Kiss Szilvia	eszty.bajmoczy+@gmail.com	$2b$12$0H6NmfmaXFFBbBq0SLh.jOrrdq5LweM1bgCH5aGPRRUvL36oocVde	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStAZ21haWwuY29tIiwiZXhwIjoxNjA3ODk4MDI4LjU1MTMwNywicHVyIjoicmVmcmVzaCJ9.JdSKePFxha32hwNJjfqV_nfPVoi2TXS5eBYPug5trz4
de926c0f-6dd3-4fa0-8da5-51a3573e95dd	1605536030.479192	Nagy Ildikó	eszty.bajmoczy+ni@gmail.com	$2b$12$FxgcaXKujAQYkw7kiWyuLe/ighBjK0Y4pWU9FoaAdmzEhQOYsL3VO	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDgxMjg1NzQuMDU2MjUyLCJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStuaUBnbWFpbC5jb20iLCJwdXIiOiJyZWZyZXNoIn0.VUtf5jf-dZk6Pl2rQAFk6IXI3XgUi-R17Q2Ds8fMCiA
c82fb868-2b99-4fd4-aabb-c451caffb5a6	1605537304.969944	Nagy Magdolna	eszty.bajmoczy+nm@gmail.com	$2b$12$twvpb/mVloSlgZXJ1oJpK.bxCe5I8MNPTX9uQNvLVsSC1h6oxIdzq	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStubUBnbWFpbC5jb20iLCJleHAiOjE2MDgxMjkzMDUuNjM5NjQ2LCJwdXIiOiJyZWZyZXNoIn0.bDz60Bh6wqQ0JCnCVi-TZgjhcDXaOgylX7RcEgXCwM8
7db5e3e2-ea1c-4439-9be9-6587dc355c1a	1605538522.322437	Szűcs Anna	eszty.bajmoczy+sza@gmail.com	$2b$12$.MRAFnQkMRCNavCI0ZYV8O6FkZiH1rL9rtRqUEBbN.YwoP5UEBZLO	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5K3N6YUBnbWFpbC5jb20iLCJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjA4MTMwNTIzLjE4OTgzMSwic3ViIjoidXNlcit0b2tlbiJ9.kHRRiYJidi_EUZxtRexnyA54YmeT1NWq-fk2h9aAZtQ
0bfb3a1c-b761-4ecc-83f9-7b2a51b96a96	1605539361.9223661	Nagy Dorottya	eszty.bajmoczy+nd@gmail.com	$2b$12$PCCGdCCBUDE2sv88D0Ff/.PSnhFXNFw6Ltuqk2pfthQszwjsOr65W	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImVzenR5LmJham1vY3p5K25kQGdtYWlsLmNvbSIsImV4cCI6MTYwODEzMTUxMC4wNTc4OTEsInN1YiI6InVzZXIrdG9rZW4iLCJwdXIiOiJyZWZyZXNoIn0.12EgisHrUVHn_IIAFnGBNRFL9ghR8msNgegUNQeyeBE
938a62bc-2fd7-449c-a61a-fd499b81cb9e	1605539915.393921	Nagy Nóra	eszty.bajmoczy+nn@gmail.com	$2b$12$Q8rSCRChaiOHa5mAhI7Th.mbG3NZ/SsYyEgqyTqLdhA8/Sd.BT1My	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6ImVzenR5LmJham1vY3p5K25uQGdtYWlsLmNvbSIsInB1ciI6InJlZnJlc2giLCJzdWIiOiJ1c2VyK3Rva2VuIiwiZXhwIjoxNjA4MTMxOTE2LjIwOTg3OX0.hqI_x1ilCukVadq3X4xx4eRd9gNP6VfSF1uLuSzKXK4
85ffeb86-9ae1-460f-ac37-233f0d407cc5	1605550781.117065	Nagy Andrea	eszty.bajmoczy+na@gmail.com	$2b$12$4YEgeO5ennh9a40a7p1YpeBBUgGgGg7SB.gzcHTHuKinnOqDjiA86	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MDgxNDMwOTEuMjQ2OTkyLCJzdWIiOiJ1c2VyK3Rva2VuIiwicHVyIjoicmVmcmVzaCIsImlkIjoiZXN6dHkuYmFqbW9jenkrbmFAZ21haWwuY29tIn0.9LtbT5-SNRfPaoNHCshjgidX8xXI66MC7z627mnK6c0
7d8d87a0-97f6-4df6-81f9-cb57a4148e40	1606471954.763891	Ács Anna	eszty.bajmoczy-aa@gmail.com	$2b$12$XdLwyfB0dn7sbb/yRDRFzeuOwFPqBFFvbcFFnyBnM8GuO1e9SIwcC	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjA5MDYzOTU1Ljg4MTU0NSwiaWQiOiJlc3p0eS5iYWptb2N6eS1hYUBnbWFpbC5jb20iLCJzdWIiOiJ1c2VyK3Rva2VuIn0.b_CtA4u8isIZ8QlGDZODAr44aSeqqsxwOKv3BDQ9vGA
3d1b23e8-166a-46e0-ba65-b4f17b538bd5	1605801810.8742762	Szűcs Annamária	eszty.bajmoczy+sa@gmail.com	$2b$12$cE6CZzJvvBkOd1Ur8xndRepGt6Ym9WeSQMXoe9PMBMP8cIJ4GhBEq	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdXIiOiJyZWZyZXNoIiwic3ViIjoidXNlcit0b2tlbiIsImlkIjoiZXN6dHkuYmFqbW9jenkrc2FAZ21haWwuY29tIiwiZXhwIjoxNjA4MzkzODUzLjAyNTAzNX0.dAS0Tvunn85e5uW1v66daLvrppDHkfC-0x9TZbgjMWg
c79cccf1-efb3-4d3c-9bc4-8d52310f32f2	1605802070.7653089	Nagy Nóra Andrea	eszty.bajmoczy+nna@gmail.com	$2b$12$8p6SnCB9m7Wiy4vakPzvRee5qrIqz7vjlHSlxyLJpwCv5yLMyQfY.	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyK3Rva2VuIiwiZXhwIjoxNjA4Mzk0MDgyLjYyNDYxOSwicHVyIjoicmVmcmVzaCIsImlkIjoiZXN6dHkuYmFqbW9jenkrbm5hQGdtYWlsLmNvbSJ9.O7MkIszzzUMIKwS0z2N68ZvJqflSQT4oomC-N2x9iwg
13860a66-6eb6-4eb7-9007-5004abb02777	1607369724.491232	Poll Andrea	poll.andrea07@gmail.com	$2b$12$P0Cb8purc4a15RKoTqCgS.G5hxvfyo8athDuo8kvgQ4jXFI0m5wKG	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6InBvbGwuYW5kcmVhMDdAZ21haWwuY29tIiwiZXhwIjoxNjA5OTYxNzI1LjMwNjE0MywicHVyIjoicmVmcmVzaCIsInN1YiI6InVzZXIrdG9rZW4ifQ.EXtIsKKsS-pZQaxIS3sGMRrtNyXhs3chhH8BkLsjJOc
8f08def7-bae5-4790-bc2d-e69dd540ce14	1605306678.908288	Kovács Katalin	eszty.bajmoczy+kk@gmail.com	$2b$12$dCAjrVl2YlokEKZObIAPJusYPKIfbwzdrQf9tIEZG90SouI79B5gy	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyK3Rva2VuIiwicHVyIjoicmVmcmVzaCIsImV4cCI6MTYwOTk2Mjc3NS44Mzg1NiwiaWQiOiJlc3p0eS5iYWptb2N6eStra0BnbWFpbC5jb20ifQ.ytPGbWvJx-jasm3iaUKqHqvt4RDbRK8MX_lyX5NN-70
14cd9162-3063-4551-b4a9-2601a40f217d	1607370592.553386	Poll Andris	andrea.poll07+a@gmail.com	$2b$12$lfCc4/XD4UK4vm3chFiJd.cFYJ70cIht1jDoGNuAq.LxZeVT6em6e	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImFuZHJlYS5wb2xsMDcrYUBnbWFpbC5jb20iLCJzdWIiOiJ1c2VyK3Rva2VuIiwiZXhwIjoxNjA5OTYyODM5LjQ4MjE1MSwicHVyIjoicmVmcmVzaCJ9.XOBnSyaa4xF0Zu9ovpn67wrygv5FSIRPr69k92aARsA
ad62a730-175d-437e-a432-645690ec5c56	1607456175.549017	Nagy Szilvia	eszty.bajmoczy+nsz@gmail.com	$2b$12$dsYr/dz9oRXVBTUON4IH6e1PpRFYe.s0gMQiqo88aIR3coMcV2oVW	f	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJwdXIiOiJyZWZyZXNoIiwiZXhwIjoxNjEwMDQ4MTc2LjM4MDA5LCJzdWIiOiJ1c2VyK3Rva2VuIiwiaWQiOiJlc3p0eS5iYWptb2N6eStuc3pAZ21haWwuY29tIn0.B44Hxhk9aSXorrju90shS-Q5oe9qS0LUdF_KYPn2i5w
\.


--
-- TOC entry 2843 (class 2606 OID 16392)
-- Name: _fluent_migrations _fluent_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public._fluent_migrations
    ADD CONSTRAINT _fluent_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 2851 (class 2606 OID 16412)
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- TOC entry 2853 (class 2606 OID 16420)
-- Name: password_resets password_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_pkey PRIMARY KEY (id);


--
-- TOC entry 2845 (class 2606 OID 16394)
-- Name: _fluent_migrations uq:_fluent_migrations.name; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public._fluent_migrations
    ADD CONSTRAINT "uq:_fluent_migrations.name" UNIQUE (name);


--
-- TOC entry 2855 (class 2606 OID 16427)
-- Name: user+organization uq:user+organization.user_id+user+organization.organization_id; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."user+organization"
    ADD CONSTRAINT "uq:user+organization.user_id+user+organization.organization_id" UNIQUE (user_id, organization_id);


--
-- TOC entry 2847 (class 2606 OID 16404)
-- Name: users uq:users.email; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "uq:users.email" UNIQUE (email);


--
-- TOC entry 2857 (class 2606 OID 16425)
-- Name: user+organization user+organization_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."user+organization"
    ADD CONSTRAINT "user+organization_pkey" PRIMARY KEY (id);


--
-- TOC entry 2849 (class 2606 OID 16402)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2859 (class 2606 OID 16433)
-- Name: user+organization user+organization_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."user+organization"
    ADD CONSTRAINT "user+organization_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- TOC entry 2858 (class 2606 OID 16428)
-- Name: user+organization user+organization_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vaporuser
--

ALTER TABLE ONLY public."user+organization"
    ADD CONSTRAINT "user+organization_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2020-12-08 21:31:55 CET

--
-- PostgreSQL database dump complete
--

