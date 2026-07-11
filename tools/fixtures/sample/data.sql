--
-- PostgreSQL database dump
--

\restrict wbE63DEWRyCawwcm1Kq1F301J8GdNW4yuY58sBzdycus6vaDUZXi2Z1LUqSIq6b

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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

--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.accounts (id, account_name, created_at, closed_on, import_transactions) FROM stdin;
0	Total	2023-09-03	\N	0
1	Bank of America Checking Account	2005-08-01	9999-12-31	1
2	Chase Southwest Rewards Credit Card	2012-05-01	9999-12-31	1
3	Ally Bank - General Savings	2012-06-15	2199-12-31	1
4	Ally Bank - Tax Withholding	2014-11-05	2199-12-31	0
\.


--
-- Data for Name: payees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payees (id, canonical_name, created_at) FROM stdin;
1	7-eleven	2026-07-10 17:49:40.521029
2	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	2026-07-10 17:49:40.521029
3	ADT Security	2026-07-10 17:49:40.521029
4	AMAZON RETA* 0A89Q3OJ3 09/11 PURCHASE WWW.AMAZON.CO WA	2026-07-10 17:49:40.521029
5	AT&T	2026-07-10 17:49:40.521029
6	AT.com	2026-07-10 17:49:40.521029
7	Academy of Managed Care Pharmacy	2026-07-10 17:49:40.521029
8	Act Too Players	2026-07-10 17:49:40.521029
9	AdhereHealth	2026-07-10 17:49:40.521029
10	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	2026-07-10 17:49:40.521029
11	Adobe	2026-07-10 17:49:40.521029
12	Adt Security Services	2026-07-10 17:49:40.521029
13	Adventure Science	2026-07-10 17:49:40.521029
14	Alltrails	2026-07-10 17:49:40.521029
15	Amazon	2026-07-10 17:49:40.521029
16	Amazon Digital Services	2026-07-10 17:49:40.521029
17	Amazon Kids+	2026-07-10 17:49:40.521029
18	Amazon Marketplace	2026-07-10 17:49:40.521029
19	Amazon Music	2026-07-10 17:49:40.521029
20	Amazon Prime Video	2026-07-10 17:49:40.521029
21	Amazon Web Services	2026-07-10 17:49:40.521029
22	Amazon.com	2026-07-10 17:49:40.521029
23	Amc Theatres	2026-07-10 17:49:40.521029
24	Ann Taylor	2026-07-10 17:49:40.521029
25	Annual Membership Fee	2026-07-10 17:49:40.521029
26	Apple	2026-07-10 17:49:40.521029
27	Apple.com	2026-07-10 17:49:40.521029
28	Association for Computing Machinery	2026-07-10 17:49:40.521029
29	At&t	2026-07-10 17:49:40.521029
30	Atmos Energy	2026-07-10 17:49:40.521029
31	Audible	2026-07-10 17:49:40.521029
32	Automatic Payment - Thank	2026-07-10 17:49:40.521029
33	Autozone	2026-07-10 17:49:40.521029
34	Bank Of America	2026-07-10 17:49:40.521029
35	Barnes & Noble	2026-07-10 17:49:40.521029
36	Beam Smile Design	2026-07-10 17:49:40.521029
37	Beast	2026-07-10 17:49:40.521029
38	Bed Bath & Beyond	2026-07-10 17:49:40.521029
39	Boyd Mill Estate Des:funding Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	2026-07-10 17:49:40.521029
40	Boyd Mill Estate Des:vendor Pay Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	2026-07-10 17:49:40.521029
41	Brentwood Counseling	2026-07-10 17:49:40.521029
42	Brentwood Skate Center	2026-07-10 17:49:40.521029
43	Brewhouse South	2026-07-10 17:49:40.521029
44	Brightstone	2026-07-10 17:49:40.521029
45	Buc-ee's	2026-07-10 17:49:40.521029
46	Burger Up	2026-07-10 17:49:40.521029
47	CB Sports Photography	2026-07-10 17:49:40.521029
48	CRM Lawn Care	2026-07-10 17:49:40.521029
49	CRMLAWN.COM DES:CRMLAWN.CO ID:ST-Y4Y4X7X0W0R0 INDN:CRM LAWN CARE LANDSCAP CO ID:XXXXX65600 CCD	2026-07-10 17:49:40.521029
50	Car Max	2026-07-10 17:49:40.521029
51	CarMax	2026-07-10 17:49:40.521029
52	Char Green Hills	2026-07-10 17:49:40.521029
53	Chatgpt	2026-07-10 17:49:40.521029
54	Check 1750	2026-07-10 17:49:40.521029
55	Check 1984	2026-07-10 17:49:40.521029
56	Check Xxxxxxx2031	2026-07-10 17:49:40.521029
57	Checkcard 0215 Frist Art Museum Xxx-xxx3325 Tn Xxxxx6650xxxxxxxxxx1570	2026-07-10 17:49:40.521029
58	Checkcard 0219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3050xxxxxxxxxx4469 Recurring	2026-07-10 17:49:40.521029
59	Checkcard 0308 Swr*franklindermatology Xxx-xxx-1881 Tn Xxxxx0050xxxxxxxxxx6652	2026-07-10 17:49:40.521029
60	Checkcard 0309 Cac* Childrens Art Www.childrenstn Xxxxx6650xxxxxxxxxx4241 Recurring	2026-07-10 17:49:40.521029
61	Checkcard 0322 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx0906	2026-07-10 17:49:40.521029
62	Checkcard 0329 Gloss* Trimmed & Tail. Httpskaylavautn Xxxxx4540xxxxxxxxxx7226 Recurring	2026-07-10 17:49:40.521029
63	Checkcard 0406 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3940xxxxxxxxxx6770	2026-07-10 17:49:40.521029
64	Checkcard 0410 Sirvezas At Skyharbor Xxx-xxx8226 Az Xxxxx4541xxxxxxxxxx1171	2026-07-10 17:49:40.521029
65	Checkcard 0414 Sq *hop House Tennessee Franklin Tn Xxxxx1641xxxxxxxxxx4368	2026-07-10 17:49:40.521029
66	Checkcard 0422 Moab Bicycle Shop-frank Franklin Tn Xxxxx5941xxxxxxxxxx2165	2026-07-10 17:49:40.521029
67	Checkcard 0425 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4151xxxxxxxxxx7360	2026-07-10 17:49:40.521029
68	Checkcard 0427 Tst* Salsa Franklin Tac Franklin Tn Xxxxx4651xxxxxxxxxx7277	2026-07-10 17:49:40.521029
69	Checkcard 0523 Liberty Concession 1 Branson Mo Xxxxx7351xxxxxxxxxx2122	2026-07-10 17:49:40.521029
70	Checkcard 0531 Sq *hop House Tennessee Franklin Tn Xxxxx1651xxxxxxxxxx4843	2026-07-10 17:49:40.521029
71	Checkcard 0704 Google *all In Hole Xxx-xxx-3987 Ca Xxxxx1651xxxxxxxxxx7866	2026-07-10 17:49:40.521029
72	Checkcard 0706 Mlnp, Llc Xxx-xxx0440 Ny Xxxxx7941xxxxxxxxxx8751	2026-07-10 17:49:40.521029
73	Checkcard 0713 Red Parka Pub Xxx-xxx4344 Nh Xxxxx9741xxxxxxxxxx1382	2026-07-10 17:49:40.521029
74	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966	2026-07-10 17:49:40.521029
75	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966 International Transaction Fee	2026-07-10 17:49:40.521029
76	Checkcard 0721 Iga 8217 Montreal Qc Xxxxx0042xxxxxxxxxx2209 International Transaction Fee	2026-07-10 17:49:40.521029
77	Checkcard 0721 La Grande Roue De Mont Montreal Qc Xxxxx0142xxxxxxxxxx0165 International Transaction Fee	2026-07-10 17:49:40.521029
78	Checkcard 0722 Agence De Mobilite Dura Montreal Qc Xxxxx4942xxxxxxxxxx4569	2026-07-10 17:49:40.521029
79	Checkcard 0724 Toccoa Riverside Restau Blue Ridge Ga Xxxxx6152xxxxxxxxxx0442	2026-07-10 17:49:40.521029
80	Checkcard 0731 Sq *southeastern Swim S Franklin Tn Xxxxx1652xxxxxxxxxx1147	2026-07-10 17:49:40.521029
81	Checkcard 0806 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx7294 Recurring	2026-07-10 17:49:40.521029
82	Checkcard 0813 Sq *primitive Coffee Co Nashville Tn Xxxxx1652xxxxxxxxxx2496	2026-07-10 17:49:40.521029
83	Checkcard 0819 Shuffs Music Xxx-xxx6139 Tn Xxxxx3042xxxxxxxxxx8557 Recurring	2026-07-10 17:49:40.521029
84	Checkcard 0828 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx9882 Recurring	2026-07-10 17:49:40.521029
85	Checkcard 0829 Gdp*greekcafeg Franklin Tn	2026-07-10 17:49:40.521029
86	Checkcard 0921 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3942xxxxxxxxxx3732	2026-07-10 17:49:40.521029
87	Checkcard 0926 Vcn*cofpaymentsdept Xxx-xxx-1857 Tn Xxxxx0042xxxxxxxxxx5458	2026-07-10 17:49:40.521029
88	Checkcard 0929 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx0597 Recurring	2026-07-10 17:49:40.521029
89	Checkcard 1022 Culamar Franklin Tn Xxxxx8542xxxxxxxxxx1662	2026-07-10 17:49:40.521029
90	Checkcard 1026 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3943xxxxxxxxxx2238	2026-07-10 17:49:40.521029
91	Checkcard 1116 Tst* M.l. Rose Craft Be Franklin Tn Xxxxx4643xxxxxxxxxx7965	2026-07-10 17:49:40.521029
92	Checkcard 1207 Duke Mailorder Web Xxx-xxx3764 Nc Xxxxx4233xxxxxxxxxx5349	2026-07-10 17:49:40.521029
93	Checkcard 1219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3043xxxxxxxxxx1487 Recurring	2026-07-10 17:49:40.521029
94	Checkcard Xxxx 4017 Jnn Germantown Cordova Tn Xxxxx3933xxxxxxxxxx3803	2026-07-10 17:49:40.521029
95	Checkcard Xxxx Xxxx 4693 Quebec Inc Montreal Qc Xxxxx7142xxxxxxxxxx4926 International Transaction Fee	2026-07-10 17:49:40.521029
96	Chewy	2026-07-10 17:49:40.521029
97	Chicago Transit Authority	2026-07-10 17:49:40.521029
98	Chick-fil-A	2026-07-10 17:49:40.521029
99	Chick-fil-a	2026-07-10 17:49:40.521029
100	Cigna	2026-07-10 17:49:40.521029
101	Circle K	2026-07-10 17:49:40.521029
102	City of Franklin	2026-07-10 17:49:40.521029
103	Cns The Childr 11/09 #xxxxx7636 Purchase 1800 Galleria Blv Franklin Tn	2026-07-10 17:49:40.521029
104	Cns The Childr 12/18 #xxxxx5097 Purchase 1800 Galleria Blv Franklin Tn	2026-07-10 17:49:40.521029
105	Coa Parking Passport	2026-07-10 17:49:40.521029
106	Coal Town Pizza	2026-07-10 17:49:40.521029
107	Coffeehouse Northwest	2026-07-10 17:49:40.521029
108	Comcast	2026-07-10 17:49:40.521029
109	Cook's Pest Control	2026-07-10 17:49:40.521029
110	Cook's Pest Nash Des:cooks Pest Id: Indn:nicole Woods Co Id:xxxxxx1064 Ppd	2026-07-10 17:49:40.521029
111	Cool Springs Wines and Spirits	2026-07-10 17:49:40.521029
112	Coursera	2026-07-10 17:49:40.521029
113	Credit Card Payment	2026-07-10 17:49:40.521029
114	Crmlawn.com Des:crmlawn.co Id:st-h2i8t7a8n4z6 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	2026-07-10 17:49:40.521029
115	Cvs Pharmacy	2026-07-10 17:49:40.521029
116	DD *DOORDASH URBANCOOK 06/06 PURCHASE DOORDASH.COM CA	2026-07-10 17:49:40.521029
117	DEPT EDUCATION DES:STUDENT LN ID:0000 INDN:NICOLE M CHARLEBOIS CO ID:XXXXX02007 PPD	2026-07-10 17:49:40.521029
118	DUNKIN #349816 Q35 01/20 PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
119	Dairy Queen	2026-07-10 17:49:40.521029
120	Dc Govt	2026-07-10 17:49:40.521029
121	Dillard's	2026-07-10 17:49:40.521029
122	Disney Plus	2026-07-10 17:49:40.521029
123	Dollar General	2026-07-10 17:49:40.521029
124	Dollar Shave Club	2026-07-10 17:49:40.521029
125	Dollar Tree	2026-07-10 17:49:40.521029
126	Donut Den	2026-07-10 17:49:40.521029
127	Double Good Popcorn	2026-07-10 17:49:40.521029
128	Dr.hammondswhite	2026-07-10 17:49:40.521029
129	Dsw	2026-07-10 17:49:40.521029
130	Dunkin' Donuts	2026-07-10 17:49:40.521029
131	Ebay	2026-07-10 17:49:40.521029
132	Elevate Labs	2026-07-10 17:49:40.521029
133	Experian	2026-07-10 17:49:40.521029
134	FARMWAY I 286 06/27 PURCHASE BRADFORD VT	2026-07-10 17:49:40.521029
135	FOCUS XXXXX25750 06/18 PURCHASE FOCUS.ORG CO	2026-07-10 17:49:40.521029
136	FRANKLIN BAKEHOUSE 09/14 PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
137	Facebook	2026-07-10 17:49:40.521029
138	Fandango	2026-07-10 17:49:40.521029
139	Firestone Auto Center	2026-07-10 17:49:40.521029
140	Firestone Credit Card	2026-07-10 17:49:40.521029
141	First American Financial Corporation	2026-07-10 17:49:40.521029
142	First Fidelity 04/10 #xxxxx4695 Withdrwl 7401 E Camelback Scottsdale Az Fee	2026-07-10 17:49:40.521029
143	Focus	2026-07-10 17:49:40.521029
144	Focusxxxxxx7373 Des:payments Id:a101a1d8d Indn:jake Woods Co Id:xxxxxx2248 Ppd	2026-07-10 17:49:40.521029
145	Focusxxxxxx7373 Des:payments Id:a107dce99 Indn:jake Woods Co Id:xxxxxx2248 Ppd	2026-07-10 17:49:40.521029
146	Focusxxxxxx7373 Des:payments Id:a10a5c269 Indn:jake Woods Co Id:xxxxxx2248 Ppd	2026-07-10 17:49:40.521029
147	Foxtrot Market	2026-07-10 17:49:40.521029
148	Franklin Bakehouse	2026-07-10 17:49:40.521029
149	Franklin Cleaners	2026-07-10 17:49:40.521029
150	Franklin Dermatology Group	2026-07-10 17:49:40.521029
151	Full Circle Counseling	2026-07-10 17:49:40.521029
152	GLOSS* TRIMMED & TAILO 09/17 PURCHASE KAYLAVAUGHN.G TN	2026-07-10 17:49:40.521029
153	GOOGLE *Bend Stretchin 06/13 PURCHASE 855-836-3987 CA	2026-07-10 17:49:40.521029
154	Gabe's	2026-07-10 17:49:40.521029
155	Garmin	2026-07-10 17:49:40.521029
156	Goblin And The Grocer	2026-07-10 17:49:40.521029
157	Goodwill	2026-07-10 17:49:40.521029
158	Google Cloud Storage	2026-07-10 17:49:40.521029
159	Google One	2026-07-10 17:49:40.521029
160	Google Play	2026-07-10 17:49:40.521029
161	Grailr	2026-07-10 17:49:40.521029
162	Gray's On Main	2026-07-10 17:49:40.521029
163	Great Clips	2026-07-10 17:49:40.521029
164	Greenlight Financial Technology	2026-07-10 17:49:40.521029
165	Gumroad	2026-07-10 17:49:40.521029
166	HANNAFORD #842 06/18 PURCHASE BRADFORD VT	2026-07-10 17:49:40.521029
167	Hannah Anders	2026-07-10 17:49:40.521029
168	Happily	2026-07-10 17:49:40.521029
169	Harpeth School of Gymnastics	2026-07-10 17:49:40.521029
170	Heifer International	2026-07-10 17:49:40.521029
171	Home Grown	2026-07-10 17:49:40.521029
172	Hop House	2026-07-10 17:49:40.521029
173	Hunters Bend Elementary	2026-07-10 17:49:40.521029
174	Hunters Bend Elementary School	2026-07-10 17:49:40.521029
175	Hunters Bend PTO	2026-07-10 17:49:40.521029
176	IKEA MEMPHIS 08/30 MOBILE PURCHASE CORDOVA TN	2026-07-10 17:49:40.521029
177	Icp*let It Shine Gymnasti	2026-07-10 17:49:40.521029
178	Ikea	2026-07-10 17:49:40.521029
179	Instacart	2026-07-10 17:49:40.521029
180	Interest Paid	2026-07-10 17:49:40.521029
181	International Transaction Fee	2026-07-10 17:49:40.521029
182	Jersey Mike's Subs	2026-07-10 17:49:40.521029
183	Jewel Osco	2026-07-10 17:49:40.521029
184	Jpmorgan	2026-07-10 17:49:40.521029
185	Justice Industries	2026-07-10 17:49:40.521029
186	KNIGHTS OF COLUM DES:INS. PREM ID: INDN:JAKE WOODS CO ID:XXXXX16470 PPD	2026-07-10 17:49:40.521029
187	Kaffe.org	2026-07-10 17:49:40.521029
188	Keurig	2026-07-10 17:49:40.521029
189	Kickstarter	2026-07-10 17:49:40.521029
190	Klarna	2026-07-10 17:49:40.521029
191	Knights Of Columbus Insurance	2026-07-10 17:49:40.521029
192	Knights of Columbus Bill Payment	2026-07-10 17:49:40.521029
193	Knights of Columbus Insurance	2026-07-10 17:49:40.521029
194	Krispy Kreme	2026-07-10 17:49:40.521029
195	Kroger	2026-07-10 17:49:40.521029
196	LIFE360.COM 06/09 PURCHASE LIFE360.COM CA	2026-07-10 17:49:40.521029
197	Landmark	2026-07-10 17:49:40.521029
198	Lands' End	2026-07-10 17:49:40.521029
199	Les 3 Brasseurs	2026-07-10 17:49:40.521029
200	Let it Shine Gymnastics	2026-07-10 17:49:40.521029
201	Leveret Clothing	2026-07-10 17:49:40.521029
202	Life360	2026-07-10 17:49:40.521029
203	Lifetouch	2026-07-10 17:49:40.521029
204	Lowe's	2026-07-10 17:49:40.521029
205	M22	2026-07-10 17:49:40.521029
206	MCDONALD'S F35703 06/19 PURCHASE PLYMOUTH NH	2026-07-10 17:49:40.521029
207	MIDDLE TENN EMC DES:BKDraft ID:XXXXX80424 INDN:NICOLE WOODS CO ID:XXXXX93472 PPD	2026-07-10 17:49:40.521029
208	Macadoodles	2026-07-10 17:49:40.521029
209	Macy's	2026-07-10 17:49:40.521029
210	Main Street Market	2026-07-10 17:49:40.521029
211	Mapco Express	2026-07-10 17:49:40.521029
212	Marcin Wasielews	2026-07-10 17:49:40.521029
213	Marco's Pizza	2026-07-10 17:49:40.521029
214	Market Basket	2026-07-10 17:49:40.521029
215	Marriott International	2026-07-10 17:49:40.521029
216	Mcdonald's	2026-07-10 17:49:40.521029
217	Medium	2026-07-10 17:49:40.521029
218	Meijer	2026-07-10 17:49:40.521029
219	Metropolis Parking	2026-07-10 17:49:40.521029
220	Microsoft	2026-07-10 17:49:40.521029
221	Middle Tennessee Electric	2026-07-10 17:49:40.521029
222	Mobile Purchase 0222 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx6981	2026-07-10 17:49:40.521029
223	Mobile Purchase 0228 Corkys Bbq - Brentwood Brentwood Tn Xxxxx0450xxxxxxxxxx1516	2026-07-10 17:49:40.521029
224	Mobile Purchase 0719 Levy@2nashfairgrnd Nashville Tn Xxxxx9752xxxxxxxxxx1748	2026-07-10 17:49:40.521029
225	Mobile Purchase 1020 Nnt Franklin B Franklin Tn	2026-07-10 17:49:40.521029
226	Mohela	2026-07-10 17:49:40.521029
227	Muah Cotton Candy	2026-07-10 17:49:40.521029
228	Musicnotes.com	2026-07-10 17:49:40.521029
229	My School Bucks Lunch Account	2026-07-10 17:49:40.521029
230	NSC*bobljop4s 05/10 MOBILE PURCHASE NASHVILLE TN	2026-07-10 17:49:40.521029
231	NWS A MOMENTS 06/09 PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
232	Nash Public Radi Des:donations Id:xx-xxxxxxxx-011 Indn:woods Jake Co Id:xxxxxx1652 Ppd	2026-07-10 17:49:40.521029
233	Nashville Public Radio	2026-07-10 17:49:40.521029
234	Nashville Violins	2026-07-10 17:49:40.521029
235	Navient	2026-07-10 17:49:40.521029
236	Navient Corporation	2026-07-10 17:49:40.521029
237	Netflix	2026-07-10 17:49:40.521029
238	New York Times	2026-07-10 17:49:40.521029
239	Newrez	2026-07-10 17:49:40.521029
240	Nintendo	2026-07-10 17:49:40.521029
241	Nnt Franklin B 10/13 #xxxxx1004 Purchase 100 E Main St Franklin Tn	2026-07-10 17:49:40.521029
242	Northwestern Mutual	2026-07-10 17:49:40.521029
243	Nuts.com	2026-07-10 17:49:40.521029
244	Office Depot	2026-07-10 17:49:40.521029
245	PAYPAL *ATLANTA BRI ATL 06/09 PURCHASE XXXXX57733 CA	2026-07-10 17:49:40.521029
246	PAYPAL DES:INST XFER ID:DISCORD INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	2026-07-10 17:49:40.521029
247	PAYPAL DES:INST XFER ID:SPOTIFY*P3A4B31 INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	2026-07-10 17:49:40.521029
248	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	2026-07-10 17:49:40.521029
249	PUBLIX #160 08/31 MOBILE PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
250	Panera Bread	2026-07-10 17:49:40.521029
251	Parkmobile	2026-07-10 17:49:40.521029
252	Parnassus Books	2026-07-10 17:49:40.521029
253	Party City	2026-07-10 17:49:40.521029
254	Patreon	2026-07-10 17:49:40.521029
255	Payment Thank You-mobile	2026-07-10 17:49:40.521029
256	Paypal	2026-07-10 17:49:40.521029
257	Paypal *berne App	2026-07-10 17:49:40.521029
258	Paypal *felacia	2026-07-10 17:49:40.521029
259	Paypal *globalfundf	2026-07-10 17:49:40.521029
260	Paypal Des:inst Xfer Id:specialolym Indn:jake Woods Co Id:paypalsi77 Web	2026-07-10 17:49:40.521029
261	Paypal Des:inst Xfer Id:ticketmaste Tic Indn:jake Woods Co Id:paypalsi77 Web	2026-07-10 17:49:40.521029
262	Peloton Cycles	2026-07-10 17:49:40.521029
263	Pilot Flying J	2026-07-10 17:49:40.521029
264	Pixowl Inc	2026-07-10 17:49:40.521029
265	Pods	2026-07-10 17:49:40.521029
266	Property Tax - City of Franklin/Williamson County	2026-07-10 17:49:40.521029
267	Protective Life	2026-07-10 17:49:40.521029
268	Publix	2026-07-10 17:49:40.521029
269	Puckett's	2026-07-10 17:49:40.521029
270	Puma	2026-07-10 17:49:40.521029
271	Purchase 0115 Amazon Reta* Zd9lz67s1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0821	2026-07-10 17:49:40.521029
272	Purchase 0202 Amazon Reta* Zc2jm9ku1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0299	2026-07-10 17:49:40.521029
273	Purchase 0218 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1640xxxxxxxxxx7421 Recurring	2026-07-10 17:49:40.521029
274	Purchase 0302 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx0049	2026-07-10 17:49:40.521029
275	Purchase 0303 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1640xxxxxxxxxx9504 Recurring	2026-07-10 17:49:40.521029
276	Purchase 0314 Amazon Reta* Pr3zy5v23 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0742	2026-07-10 17:49:40.521029
277	Purchase 0317 Franciscan Missions Franciscanmiswi Xxxxx1650xxxxxxxxxx1939	2026-07-10 17:49:40.521029
278	Purchase 0318 Focus Xxxxxx5750 Httpswww.focuco Xxxxx3440xxxxxxxxxx4912 Recurring	2026-07-10 17:49:40.521029
279	Purchase 0402 Amazon Reta* 555r91mi3 Www.amazon.cowa Xxxxx3450xxxxxxxxxx5271	2026-07-10 17:49:40.521029
280	Purchase 0402 Cb* Hunters Bend Eleme Chooseboosterga Xxxxx7740xxxxxxxxxx6160 Recurring	2026-07-10 17:49:40.521029
281	Purchase 0402 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx8044	2026-07-10 17:49:40.521029
282	Purchase 0514 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx3067 Recurring	2026-07-10 17:49:40.521029
283	Purchase 0518 Sp Readingglasses Readingglassetx Xxxxx3451xxxxxxxxxx7261	2026-07-10 17:49:40.521029
284	Purchase 0521 Aurora First, Inc. Aurorafirst.afl Xxxxx7751xxxxxxxxxx1202 Recurring	2026-07-10 17:49:40.521029
285	Purchase 0603 Amazon Reta* N67b41ig2 Www.amazon.cowa Xxxxx3451xxxxxxxxxx7984	2026-07-10 17:49:40.521029
286	Purchase 0614 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx2883 Recurring	2026-07-10 17:49:40.521029
287	Purchase 0617 Pp*ticketfulfi Nashvill Xxx-xxx-5661 De Xxxxx3841xxxxxxxxxx1876	2026-07-10 17:49:40.521029
288	Purchase 0711 Gloss* Trimmed & Tailo Kaylavaughn.gtn Xxxxx6651xxxxxxxxxx5269 Recurring	2026-07-10 17:49:40.521029
289	Purchase 0714 Change.org Change.org Ca Xxxxx7751xxxxxxxxxx1143 Recurring	2026-07-10 17:49:40.521029
290	Purchase 0718 Focus Xxxxxx5750 Focus.org Co Xxxxx1651xxxxxxxxxx9852 Recurring	2026-07-10 17:49:40.521029
291	Purchase 0718 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx9636 Recurring	2026-07-10 17:49:40.521029
292	Purchase 0806 Amazon Digi* Ne8mi14m2 Www.amazon.cowa Xxxxx3452xxxxxxxxxx4846	2026-07-10 17:49:40.521029
293	Purchase 0817 Sp Zquiet Zquiet.com Vt Xxxxx1652xxxxxxxxxx2068	2026-07-10 17:49:40.521029
294	Purchase 0818 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx5484 Recurring	2026-07-10 17:49:40.521029
295	Purchase 0823 Wyndy Wyndy.com Al Xxxxx6652xxxxxxxxxx2463	2026-07-10 17:49:40.521029
296	Purchase 0903 Amazon Reta* Zt5pn7aa2 Www.amazon.cowa Xxxxx3442xxxxxxxxxx1919	2026-07-10 17:49:40.521029
297	Purchase 1004 Docker, Inc. Httpswww.dockca Xxxxx3442xxxxxxxxxx3774 Recurring	2026-07-10 17:49:40.521029
298	Purchase 1112 Sp Built.com Built.com Ut Xxxxx3443xxxxxxxxxx0960	2026-07-10 17:49:40.521029
299	Purchase 1114 Sp Lewisblack.com Httpslewisblaca Xxxxx1633xxxxxxxxxx8465	2026-07-10 17:49:40.521029
300	Purchase 1121 Amazon Reta* Y54wd1xb3 Www.amazon.cowa Xxxxx3443xxxxxxxxxx3916	2026-07-10 17:49:40.521029
301	Purchase 1126 Amznfreetime*zx9576nl2 Xxx-xxx-3080 Wa Xxxxx1643xxxxxxxxxx9876	2026-07-10 17:49:40.521029
302	Purchase 1214 Change.org Change.org Ca Xxxxx7743xxxxxxxxxx9625 Recurring	2026-07-10 17:49:40.521029
303	Purchase Interest Charge	2026-07-10 17:49:40.521029
304	Quality Tree Surgery	2026-07-10 17:49:40.521029
305	Quip	2026-07-10 17:49:40.521029
306	Reader's Digest	2026-07-10 17:49:40.521029
307	Recisio	2026-07-10 17:49:40.521029
308	Redbubble	2026-07-10 17:49:40.521029
309	Reed's Produce	2026-07-10 17:49:40.521029
310	Relay for Reddit	2026-07-10 17:49:40.521029
311	SHELL OIL XXXXX738336 06/19 PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
312	SHUFFS MUSIC 06/20 PURCHASE XXX-XX06139 TN	2026-07-10 17:49:40.521029
313	SQ *THE FAINTING GOAT C 09/07 MOBILE PURCHASE Franklin TN	2026-07-10 17:49:40.521029
314	SafeSplash	2026-07-10 17:49:40.521029
315	Sam's Club	2026-07-10 17:49:40.521029
316	Sams's Club Gas Station	2026-07-10 17:49:40.521029
317	Savory Spice	2026-07-10 17:49:40.521029
318	Savory Spice Shop	2026-07-10 17:49:40.521029
319	Second Harvest Food Bank	2026-07-10 17:49:40.521029
320	Shedd Aquarium	2026-07-10 17:49:40.521029
321	Shell	2026-07-10 17:49:40.521029
322	Silver Dollar City Candle Shop	2026-07-10 17:49:40.521029
323	Smithstore	2026-07-10 17:49:40.521029
324	Socks And Soles	2026-07-10 17:49:40.521029
325	Sonic Drive-in	2026-07-10 17:49:40.521029
326	Source	2026-07-10 17:49:40.521029
327	Southern Men's Showcase	2026-07-10 17:49:40.521029
328	Southwest Airlines	2026-07-10 17:49:40.521029
329	Sp * Two Blind Brother	2026-07-10 17:49:40.521029
330	Spotify	2026-07-10 17:49:40.521029
331	Sq *dog Gone Good Time Fa	2026-07-10 17:49:40.521029
332	Sq *freelife Soap Co.	2026-07-10 17:49:40.521029
333	St Joseph's Indian School	2026-07-10 17:49:40.521029
334	St. Joseph's Indian School	2026-07-10 17:49:40.521029
335	St. Philip Church	2026-07-10 17:49:40.521029
336	Starbucks	2026-07-10 17:49:40.521029
337	State Farm	2026-07-10 17:49:40.521029
338	Stroud's	2026-07-10 17:49:40.521029
339	Subway	2026-07-10 17:49:40.521029
340	Sugarwish.com Gifts	2026-07-10 17:49:40.521029
341	Susan Hammonds-White	2026-07-10 17:49:40.521029
342	Sweet Haven	2026-07-10 17:49:40.521029
343	Synchrony Bank	2026-07-10 17:49:40.521029
344	TARGET T- 1701 06/04 PURCHASE Franklin TN	2026-07-10 17:49:40.521029
345	THE FRANKLIN THEATRE 01/17 PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
346	THE FRANKLIN THEATRE 05/09 PURCHASE FRANKLIN TN	2026-07-10 17:49:40.521029
347	TILE / LIFE360 09/09 PURCHASE LIFE360.COM CA	2026-07-10 17:49:40.521029
348	TN Stars	2026-07-10 17:49:40.521029
349	Target	2026-07-10 17:49:40.521029
350	The Berry Bar	2026-07-10 17:49:40.521029
351	The Coffee House	2026-07-10 17:49:40.521029
352	The Dunkin Theatre	2026-07-10 17:49:40.521029
353	The Good Cup	2026-07-10 17:49:40.521029
354	The Home Depot	2026-07-10 17:49:40.521029
355	The Ice Cream Store	2026-07-10 17:49:40.521029
356	The Protein Bar	2026-07-10 17:49:40.521029
357	The UPS Store	2026-07-10 17:49:40.521029
358	The Ups Store	2026-07-10 17:49:40.521029
359	Thevocalacademy. Des:thevocalac Id:st-n1l0q6e2q7z9 Indn:jake Woods Co Id:xxxxxx5600 Web	2026-07-10 17:49:40.521029
360	Tile	2026-07-10 17:49:40.521029
361	Tile Inc	2026-07-10 17:49:40.521029
362	Tivo	2026-07-10 17:49:40.521029
363	Tj Maxx	2026-07-10 17:49:40.521029
364	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx4085 Indn:146 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	2026-07-10 17:49:40.521029
365	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6018 Indn:150 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	2026-07-10 17:49:40.521029
366	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6024 Indn:571 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	2026-07-10 17:49:40.521029
367	Trader Joe's	2026-07-10 17:49:40.521029
368	Travel Credit $75/year	2026-07-10 17:49:40.521029
369	Us Department Of Education	2026-07-10 17:49:40.521029
370	Valon Mortgage	2026-07-10 17:49:40.521029
371	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	2026-07-10 17:49:40.521029
372	Vending Charge	2026-07-10 17:49:40.521029
373	Venmo	2026-07-10 17:49:40.521029
374	WTF Just Happened Today	2026-07-10 17:49:40.521029
375	WTFJHT NEWSLETTER 09/02 PURCHASE WHATTHEFUCKJU WA	2026-07-10 17:49:40.521029
376	Waggy Tails	2026-07-10 17:49:40.521029
377	Walgreens	2026-07-10 17:49:40.521029
378	Wall Street Journal	2026-07-10 17:49:40.521029
379	Walmart	2026-07-10 17:49:40.521029
380	Walmart.com 06/15 PURCHASE Bentonville AR	2026-07-10 17:49:40.521029
381	Wasabi Restaurant	2026-07-10 17:49:40.521029
382	Wasabi Technologies	2026-07-10 17:49:40.521029
383	Wayfair	2026-07-10 17:49:40.521029
384	Whole Foods Market	2026-07-10 17:49:40.521029
385	Wikimedia Foundation	2026-07-10 17:49:40.521029
386	Williamson County	2026-07-10 17:49:40.521029
387	Williamson County Animal Hospital	2026-07-10 17:49:40.521029
388	Williamson County Schools - SACC	2026-07-10 17:49:40.521029
389	Williamson Medical Center	2026-07-10 17:49:40.521029
390	Wolfgang Puck	2026-07-10 17:49:40.521029
391	World Vision International	2026-07-10 17:49:40.521029
392	Wyndy	2026-07-10 17:49:40.521029
393	Yearbook Market	2026-07-10 17:49:40.521029
394	Yeti	2026-07-10 17:49:40.521029
395	Zelle	2026-07-10 17:49:40.521029
396	Zoom Video Communications	2026-07-10 17:49:40.521029
\.


--
-- Data for Name: spending_category_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spending_category_groups (id, group_name) FROM stdin;
4	Debt Incurral
3	Debt Reduction
2	Expenses
1	Income
6	Investments
5	Savings
-1	SplitTransactions
0	Ungrouped Transactions
\.


--
-- Data for Name: spending_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.spending_categories (id, category_name, spending_category_group_id) FROM stdin;
-2	Placeholder	-1
-1	Split	-1
1	Automotive - Fuel	2
2	Debt Servicing - Student Loans	2
3	Donations - Exempt Secular	2
4	Entertainment - Food	2
5	Entertainment - Events	2
6	Entertainment - Stuff	2
8	Home - Home Office	2
9	Home - Services	2
16	Other Spending - Gifts	2
18	Pet - Veterinary	2
19	Utilities - Energy	2
20	Utilities - Services	2
21	Entertainment - Services	2
22	N Spending - Personal Care	2
23	Other Spending - Groceries	2
24	Debt Servicing - Home	2
25	Donations - Exempt Nonsecular	2
29	Medical - Doctor	2
30	Medical - Drugs Rx	2
32	Paychecks/Salary	1
33	Retirement	5
34	Insurance - Auto	2
35	Insurance - Life	2
57	Debt Servicing - Line of Credit	2
58	Home - Furnishings	2
60	Loans - Family	2
62	Travel - Transit	2
64	Travel - Other	2
65	Automotive - Other	2
66	Automotive - Service	2
67	Donations - Nonexempt	2
69	N Spending - Clothing	2
70	N Spending - Unspecified	2
71	J Spending - Electronics	2
72	J Spending - Zymurgy	2
73	J Spending - Food	2
74	J Spending - Woodworking	2
75	J Spending - Unspecified	2
81	Medical - Counseling	2
82	Medical - Dentist	2
83	Medical - Drugs Non Rx	2
84	Medical - Fitness	2
85	Medical - Supplies	2
86	Home - Appliances	2
88	Home - Maintenance	2
89	Home - Professional Expenses	2
90	Home - Service Charges and Fees	2
91	Home - Supplies	2
92	Insurance - Disability	2
93	Insurance - Health	2
94	Insurance - Home	2
95	Insurance - Property	2
96	Loans - Other	2
97	Pet - Food	2
98	Pet - Other	2
100	Travel - Food	2
101	Travel - Lodging	2
102	Travel - Shopping	2
103	Utilities - Communications	2
104	Interest	1
105	Reimbursement	1
106	Loan Repayment	1
107	Other Income	1
108	Debt Servicing - Auto	2
109	Debt Servicing - Service Contracts	2
110	Deferred Expense	5
111	Depreciation	5
112	Reserve	5
114	N Spending - Food	2
115	Other Spending - Unspecified	2
117	Other Spending - Reimbursable Expense	2
119	Kids - Education	2
120	J Spending - Books and Magazines	2
121	J Spending - Clothing	2
123	Taxes - Income Tax	2
124	Capital Investment	5
125	Property	6
126	Property Income	1
127	Withdrawal	5
128	Kids - Child Care	2
129	Taxes - Employee Withholding	2
130	Taxes - Unemployment	2
131	Taxes - FICA	2
132	Travel - Entertainment	2
1133	J Spending - Music	2
1134	Debt Servicing - Investment Home	2
1135	Kids - Toys	2
1137	Property - Services	2
1138	Property - Appliances	2
1139	Property - Maintenance	2
1140	Property - Supplies	2
1141	Property - Furnishings	2
1142	Other Spending - Other Food	2
1143	Education	5
1144	Kids - Clothing	2
1146	Taxes - Payroll	2
1147	Insurance - Long Term Care	2
1148	J Spending - Personal Care	2
1149	Music - X Uke	2
1150	Music - X Piano	2
1151	Music - L Piano	2
1152	Music - J Voice	2
1153	Music - N Voice	2
1154	Music - J Piano	2
1155	Music - N Violin	2
1156	Activities - X Gymnastics	2
1157	Activities - L Gymnastics	2
1158	Activities - X Basketball	2
1159	Activities - L Soccer	2
1160	Kids - Other Activities	2
1161	Kids - Books and Magazines	2
1162	J Spending - Photography	2
1163	Activities - L Other	2
1164	Activities - X Other	2
1165	Activities - L Theater	2
1166	Activities - X Theater	2
1167	Kids - Events	2
1168	Taxes - Property	2
1169	J Spending - Stuff	2
\.


--
-- Data for Name: bank_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bank_transactions (id, external_id, transaction_date, loaded_date, description, import_category, amount, spending_category_id, orig_description, category_status, bank_orig_description, account_id, accounting_date, payee_id) FROM stdin;
189	100140414	2022-07-11	2022-09-12 00:09:34.777	Meijer	Groceries	-2.7300	\N	Meijer	0	Meijer	1	2022-07-11	218
1	100129258	2021-09-20	2022-02-05 23:34:23.223	Tivo	Cable/Satellite	-16.4500	21	Tivo	0	Tivo	1	2021-09-20	362
2	100129251	2021-09-21	2022-02-05 23:34:23.223	Amazon Marketplace	General Merchandise	-9.0400	\N	Amazon Marketplace	0	Amazon Marketplace	1	2021-09-21	18
3	100129248	2021-09-22	2022-02-05 23:34:23.223	Check Xxxxxxx2031	Checks	-29.0000	\N	Check Xxxxxxx2031	0	Check Xxxxxxx2031	1	2021-09-22	56
4	100129236	2021-09-24	2022-02-05 23:34:23.223	AdhereHealth	Deposits	4164.2400	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx6740es Indn:woods,jake Co Id:9111	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx6740es Indn:woods,jake Co Id:9111	1	2021-09-24	9
5	100129222	2021-09-27	2022-02-05 23:34:23.223	Disney Plus	Entertainment	-8.7500	21	Disney Plus	-1	Disney Plus	1	2021-09-27	122
6	100129234	2021-09-27	2022-02-05 23:34:23.223	Knights of Columbus Insurance	Charitable Giving	-1100.0000	\N	Knights Of Columbus	0	Knights Of Columbus	1	2021-09-27	193
7	100129204	2021-09-30	2022-02-05 23:34:23.223	Amazon Digital Services	Entertainment	-3.2700	\N	Amazon Digital Services	0	Amazon Digital Services	1	2021-09-30	16
8	100130867	2021-10-01	2022-04-14 15:41:10.537	Nashville Violins	Hobbies	-440.0000	\N	Nashville Violins	0	Nashville Violins	2	2021-10-01	234
9	100129186	2021-10-04	2022-02-05 23:34:23.223	Marco's Pizza	Restaurants	-20.4500	4	Marco's Pizza	-1	Marco's Pizza	1	2021-10-04	213
10	100129197	2021-10-04	2022-02-05 23:34:23.223	Venmo	Transfers	-35.0000	\N	Venmo	0	Venmo	1	2021-10-04	373
11	100129172	2021-10-06	2022-02-05 23:34:23.223	Navient	Loans	-148.7800	\N	Navient Corporation	0	Navient Corporation	1	2021-10-06	235
12	100129152	2021-10-08	2022-02-05 23:34:23.223	Cigna	Deposits	4004.4500	32	Cigna	0	Cigna	1	2021-10-08	100
13	100129135	2021-10-12	2022-02-05 23:34:23.223	Target	General Merchandise	-42.7800	\N	Target	0	Target	1	2021-10-12	349
14	100129146	2021-10-12	2022-02-05 23:34:23.223	CRM Lawn Care	Home Maintenance	-120.0000	1137	Crmlawn.com Des:crmlawn.co Id:st-k0k5j1l7e9p4 Indn:crm Lawn Care Landscap Co Id:1800	-1	Crmlawn.com Des:crmlawn.co Id:st-k0k5j1l7e9p4 Indn:crm Lawn Care Landscap Co Id:1800	1	2021-10-12	48
15	100129133	2021-10-13	2022-02-05 23:34:23.223	Keurig	Transfers	-99.2300	\N	Keurig	0	Keurig	1	2021-10-13	188
16	100129111	2021-10-15	2022-02-05 23:34:23.223	Tivo	Cable/Satellite	-14.2600	21	Tivo	0	Tivo	1	2021-10-15	362
17	100129123	2021-10-15	2022-02-05 23:34:23.223	City of Franklin	Utilities	-70.9700	1137	Cof Water Des:bank Draft Id:xxxxxxx2005 Indn:jake Woods Co Id:3626	-1	Cof Water Des:bank Draft Id:xxxxxxx2005 Indn:jake Woods Co Id:3626	1	2021-10-15	102
18	100129095	2021-10-18	2022-02-05 23:34:23.223	Coa Parking Passport	Travel	-3.0000	\N	Checkcard 1015 Coa Parking Passport Xxx-xxx4557 Nc Xxxxxxxxxxxxxxxxxxx9699	0	Checkcard 1015 Coa Parking Passport Xxx-xxx4557 Nc Xxxxxxxxxxxxxxxxxxx9699	1	2021-10-18	105
19	100129106	2021-10-18	2022-02-05 23:34:23.223	Medium	Online Services	-50.0000	\N	Medium	0	Medium	1	2021-10-18	217
20	100129082	2021-10-20	2022-02-05 23:34:23.223	Williamson County Schools - SACC	Utilities	-127.1800	128	Checkcard 1019 4te*williamson County S Xxx-xxx-4719 Tn Xxxxxxxxxxxxxxxxxxx7853	-1	Checkcard 1019 4te*williamson County S Xxx-xxx-4719 Tn Xxxxxxxxxxxxxxxxxxx7853	1	2021-10-20	388
21	100129073	2021-10-22	2022-02-05 23:34:23.223	Marco's Pizza	Restaurants	-34.3700	4	Marco's Pizza	-1	Marco's Pizza	1	2021-10-22	213
22	100130837	2021-10-24	2022-04-14 15:41:10.537	Lowe's	Home Improvement	-2.8100	\N	Lowe's	0	Lowe's	2	2021-10-24	204
23	100129068	2021-10-25	2022-02-05 23:34:23.223	Publix	Groceries	-18.7300	\N	Publix	0	Publix	1	2021-10-25	268
24	100129052	2021-10-27	2022-02-05 23:34:23.223	Amazon	General Merchandise	-7.6500	\N	Amazon	0	Amazon	1	2021-10-27	15
25	100130831	2021-10-29	2022-04-14 15:41:10.537	Sp * Two Blind Brother	Restaurants	-135.0000	\N	Sp * Two Blind Brother	0	Sp * Two Blind Brother	2	2021-10-29	329
26	100129030	2021-11-01	2022-02-05 23:34:23.223	Publix	Groceries	-193.2900	\N	Publix	0	Publix	1	2021-11-01	268
27	100130828	2021-11-01	2022-04-14 15:41:10.537	Nashville Violins	Hobbies	-440.0000	\N	Nashville Violins	0	Nashville Violins	2	2021-11-01	234
28	100129014	2021-11-03	2022-02-05 23:34:23.223	Amazon	General Merchandise	-13.9800	\N	Amazon	0	Amazon	1	2021-11-03	15
29	100129000	2021-11-05	2022-02-05 23:34:23.223	Franklin Cleaners	Personal Care	-38.9000	\N	Franklin Cleaners	0	Franklin Cleaners	1	2021-11-05	149
30	100128984	2021-11-08	2022-02-05 23:34:23.223	Barnes & Noble	Hobbies	-78.8300	\N	Barnes & Noble	0	Barnes & Noble	1	2021-11-08	35
31	100128996	2021-11-08	2022-02-05 23:34:23.223	Spotify	Entertainment	-17.5100	21	Spotify	0	Spotify	1	2021-11-08	330
32	100128967	2021-11-10	2022-02-05 23:34:23.223	Amazon Marketplace	General Merchandise	-14.2500	\N	Amazon Marketplace	0	Amazon Marketplace	1	2021-11-10	18
33	100128956	2021-11-12	2022-02-05 23:34:23.223	Williamson County Animal Hospital	Groceries	-158.9800	\N	Checkcard 1110 Williamson County Anim Franklin Tn Xxxxxxxxxxxxxxxxxxx5028	0	Checkcard 1110 Williamson County Anim Franklin Tn Xxxxxxxxxxxxxxxxxxx5028	1	2021-11-12	387
34	100130818	2021-11-13	2022-04-14 15:41:10.537	Dillard's	General Merchandise	-46.6400	\N	Dillard's	0	Dillard's	2	2021-11-13	121
35	100128931	2021-11-15	2022-02-05 23:34:23.223	The UPS Store	Postage & Shipping	-23.2700	\N	The Ups Store	0	The Ups Store	1	2021-11-15	357
36	100128943	2021-11-15	2022-02-05 23:34:23.223	Publix	Groceries	-8.4500	\N	Publix	0	Publix	1	2021-11-15	268
37	100130812	2021-11-15	2022-04-14 15:41:10.537	Char Green Hills	Other Expenses	-106.7300	\N	Char Green Hills	0	Char Green Hills	2	2021-11-15	52
38	100128915	2021-11-17	2022-02-05 23:34:23.223	Williamson County Schools - SACC	Utilities	-127.1800	128	Checkcard 1116 4te*williamson County S Xxx-xxx-4719 Tn Xxxxxxxxxxxxxxxxxxx8550	-1	Checkcard 1116 4te*williamson County S Xxx-xxx-4719 Tn Xxxxxxxxxxxxxxxxxxx8550	1	2021-11-17	388
39	100128913	2021-11-18	2022-02-05 23:34:23.223	Comcast	Cable/Satellite	-251.5100	\N	Comcast	0	Comcast	1	2021-11-18	108
40	100130803	2021-11-19	2022-04-14 15:41:10.537	Sam's Club	General Merchandise	-95.5900	\N	Sam's Club	0	Sam's Club	2	2021-11-19	315
41	100128894	2021-11-22	2022-02-05 23:34:23.223	Chick-fil-A	Restaurants	-24.7300	\N	Chick-fil-a	0	Chick-fil-a	1	2021-11-22	98
42	100128884	2021-11-23	2022-02-05 23:34:23.223	Northwestern Mutual	Insurance	-312.0000	92	Northwestern Mutual	0	Northwestern Mutual	1	2021-11-23	242
43	100128863	2021-11-26	2022-02-05 23:34:23.223	Publix	Groceries	-36.1000	\N	Publix	0	Publix	1	2021-11-26	268
44	100130796	2021-11-27	2022-04-14 15:41:10.537	Paypal *felacia	Transfers	-139.9500	\N	Paypal *felacia	0	Paypal *felacia	2	2021-11-27	258
92	100130690	2022-02-13	2022-04-14 15:41:10.537	Target	General Merchandise	-247.2000	\N	Target	0	Target	2	2022-02-13	349
45	100128861	2021-11-29	2022-02-05 23:34:23.223	Coursera	Transfers	-49.0000	\N	Paypal Des:inst Xfer Id:helpcourser 8y5 Indn:jake Woods Co Id:payp	0	Paypal Des:inst Xfer Id:helpcourser 8y5 Indn:jake Woods Co Id:payp	1	2021-11-29	112
46	100130792	2021-11-29	2022-04-14 15:41:10.537	Paypal *globalfundf	Transfers	-35.0000	\N	Paypal *globalfundf	0	Paypal *globalfundf	2	2021-11-29	259
47	100128844	2021-12-01	2022-02-05 23:34:23.223	Newrez	Credit Card Payments	-3500.0000	\N	Newrez	0	Newrez	1	2021-12-01	239
48	100128835	2021-12-02	2022-02-05 23:34:23.223	Yearbook Market	Entertainment	-38.0000	\N	Checkcard 1201 Ssy* Yearbook Market Studiosourceywi Xxxxxxxxxxxxxxxxxxx1546	0	Checkcard 1201 Ssy* Yearbook Market Studiosourceywi Xxxxxxxxxxxxxxxxxxx1546	1	2021-12-02	393
49	100128825	2021-12-03	2022-02-05 23:34:23.223	Amazon Marketplace	General Merchandise	-31.4100	\N	Amazon Marketplace	0	Amazon Marketplace	1	2021-12-03	18
50	100130769	2021-12-03	2022-04-14 15:41:10.537	Brightstone	Education	-25.0000	1143	Brightstone	0	Brightstone	2	2021-12-03	44
51	100128817	2021-12-06	2022-02-05 23:34:23.223	Navient	Loans	-148.7800	\N	Navient Corporation	0	Navient Corporation	1	2021-12-06	235
52	100130763	2021-12-07	2022-04-14 15:41:10.537	Paypal *berne App	Transfers	-69.0500	\N	Paypal *berne App	0	Paypal *berne App	2	2021-12-07	257
53	100128794	2021-12-09	2022-02-05 23:34:23.223	Microsoft	Online Services	-5.4900	\N	Microsoft	0	Microsoft	1	2021-12-09	220
54	100128785	2021-12-10	2022-02-05 23:34:23.223	Tile	Home Improvement	-2.9900	\N	Checkcard 1209 Tile Premium Httpswww.tileca Xxxxxxxxxxxxxxxxxxx5481	0	Checkcard 1209 Tile Premium Httpswww.tileca Xxxxxxxxxxxxxxxxxxx5481	1	2021-12-10	360
55	100130750	2021-12-12	2022-04-14 15:41:10.537	Marriott International	Travel	-36.5900	\N	Marriott International	0	Marriott International	2	2021-12-12	215
56	100128776	2021-12-13	2022-02-05 23:34:23.223	Publix	Groceries	-102.6600	\N	Publix	0	Publix	1	2021-12-13	268
57	100128764	2021-12-14	2022-02-05 23:34:23.223	Sonic Drive-in	Restaurants	-15.5800	\N	Sonic Drive-in	0	Sonic Drive-in	1	2021-12-14	325
58	100128751	2021-12-15	2022-02-05 23:34:23.223	Amazon	General Merchandise	-27.4300	\N	Amazon	0	Amazon	1	2021-12-15	15
59	100130746	2021-12-15	2022-04-14 15:41:10.537	Ebay	General Merchandise	-56.0800	\N	Ebay	0	Ebay	2	2021-12-15	131
60	100128738	2021-12-17	2022-02-05 23:34:23.223	Publix	Groceries	-33.3300	\N	Publix	0	Publix	1	2021-12-17	268
61	100128714	2021-12-20	2022-02-05 23:34:23.223	Waggy Tails	Pets/Pet Care	-67.0000	\N	Checkcard 1217 Sq *waggy Tails Pet Cen Franklin Tn Xxxxxxxxxxxxxxxxxxx5828	0	Checkcard 1217 Sq *waggy Tails Pet Cen Franklin Tn Xxxxxxxxxxxxxxxxxxx5828	1	2021-12-20	376
62	100128725	2021-12-20	2022-02-05 23:34:23.223	Amazon	General Merchandise	-18.6500	\N	Amazon	0	Amazon	1	2021-12-20	15
63	100130736	2021-12-20	2022-04-14 15:41:10.537	Target	General Merchandise	-40.3700	\N	Target	0	Target	2	2021-12-20	349
64	100128703	2021-12-22	2022-02-05 23:34:23.223	Socks And Soles	Restaurants	-39.5100	\N	Socks And Sole 12/22 #xxxxx7516 Mobile Purchase Socks And Soles Franklin Tn	0	Socks And Sole 12/22 #xxxxx7516 Mobile Purchase Socks And Soles Franklin Tn	1	2021-12-22	324
65	100128696	2021-12-24	2022-02-05 23:34:23.223	Apple	Electronics	-10.9400	\N	Apple	0	Apple	1	2021-12-24	26
66	100128684	2021-12-27	2022-02-05 23:34:23.223	Franklin Cleaners	Personal Care	-35.9000	\N	Franklin Cleaners	0	Franklin Cleaners	1	2021-12-27	149
67	100128673	2021-12-28	2022-02-05 23:34:23.223	Audible	Hobbies	-25.1300	21	Audible	-1	Audible	1	2021-12-28	31
68	100128658	2021-12-30	2022-02-05 23:34:23.223	AdhereHealth	Deposits	4164.2400	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx2980es Indn:woods,jake Co Id:9111	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx2980es Indn:woods,jake Co Id:9111	1	2021-12-30	9
69	100128654	2021-12-31	2022-02-05 23:34:23.223	Marco's Pizza	Restaurants	-34.8200	4	Marco's Pizza	-1	Marco's Pizza	1	2021-12-31	213
70	100128633	2022-01-03	2022-02-05 23:34:23.223	Mcdonald's	Restaurants	-8.4400	\N	Mcdonald's	0	Mcdonald's	1	2022-01-03	216
71	100128644	2022-01-03	2022-02-05 23:34:23.223	Kroger	Groceries	-5.8600	\N	Kroger	0	Kroger	1	2022-01-03	195
72	100130712	2022-01-04	2022-04-14 15:41:10.537	Mapco Express	Gasoline/Fuel	-34.9400	\N	Mapco Express	0	Mapco Express	2	2022-01-04	211
73	100128621	2022-01-06	2022-02-05 23:34:23.223	Navient	Loans	-148.7800	\N	Navient Corporation	0	Navient Corporation	1	2022-01-06	235
74	100128604	2022-01-10	2022-02-05 23:34:23.223	Microsoft	Online Services	-5.4900	\N	Microsoft	0	Microsoft	1	2022-01-10	220
75	100128594	2022-01-11	2022-02-05 23:34:23.223	Starbucks	Restaurants	-1.1200	\N	Starbucks	0	Starbucks	1	2022-01-11	336
76	100128584	2022-01-14	2022-02-05 23:34:23.223	Cigna	Deposits	3927.0400	32	Cigna	0	Cigna	1	2022-01-14	100
77	100130700	2022-01-17	2022-04-14 15:41:10.537	Main Street Market	Groceries	-6.7800	\N	Main Street Market	0	Main Street Market	2	2022-01-17	210
78	100128571	2022-01-18	2022-02-05 23:34:23.223	Amazon	General Merchandise	-138.7900	\N	Amazon	0	Amazon	1	2022-01-18	15
79	100130699	2022-01-18	2022-04-14 15:41:10.537	Sq *dog Gone Good Time Fa	Restaurants	-140.0000	\N	Sq *dog Gone Good Time Fa	0	Sq *dog Gone Good Time Fa	2	2022-01-18	331
80	100128557	2022-01-19	2022-02-05 23:34:23.223	Publix	Groceries	-280.9500	\N	Publix	0	Publix	1	2022-01-19	268
81	100128543	2022-01-21	2022-02-05 23:34:23.223	Firestone Credit Card	Online Services	-2030.7700	66	Credit First National Association	-1	Credit First National Association	1	2022-01-21	140
82	100128533	2022-01-24	2022-02-05 23:34:23.223	Apple	Electronics	-10.9400	\N	Apple	0	Apple	1	2022-01-24	26
83	100128518	2022-01-26	2022-02-05 23:34:23.223	Williamson County Schools - SACC	Utilities	-101.7400	128	Checkcard 0125 4te*williamson County S Xxx-xxx-4719 Tn Xxxxxxxxxxxxxxxxxxx2192 Recurring	-1	Checkcard 0125 4te*williamson County S Xxx-xxx-4719 Tn Xxxxxxxxxxxxxxxxxxx2192 Recurring	1	2022-01-26	388
84	100130693	2022-01-28	2022-04-14 15:41:10.537	Williamson County Animal Hospital	Groceries	-292.1200	\N	Williamson County Anim	0	Williamson County Anim	2	2022-01-28	387
85	100130258	2022-01-31	2022-04-14 15:34:22.787	Quip	Healthcare/Medical	-10.0000	\N	Quip Nyc Inc	0	Quip Nyc Inc	1	2022-01-31	305
86	100130270	2022-01-31	2022-04-14 15:34:22.787	Bank Of America	Deposits	620.5300	\N	Bank Of America	0	Bank Of America	1	2022-01-31	34
87	100130231	2022-02-02	2022-04-14 15:34:22.787	International Transaction Fee	Service Charges/Fees	-2.2500	\N	Checkcard 0201 Www.map.org.uk Xxxxxxxxxxx Xxxxxxxxxxxxxxxxxxx2549 International Transaction Fee	0	Checkcard 0201 Www.map.org.uk Xxxxxxxxxxx Xxxxxxxxxxxxxxxxxxx2549 International Transaction Fee	1	2022-02-02	181
88	100130229	2022-02-03	2022-04-14 15:34:22.787	Zoom Video Communications	Online Services	-16.4500	\N	Zoom Video Communications	0	Zoom Video Communications	1	2022-02-03	396
89	100130209	2022-02-07	2022-04-14 15:34:22.787	Walgreens	Healthcare/Medical	-26.2100	\N	Walgreens	0	Walgreens	1	2022-02-07	377
90	100146339	2022-02-07	2023-09-02 21:03:13.013	Zelle	Transfers	975.0000	\N	Zelle	0	Zelle	3	2022-02-07	395
91	100130195	2022-02-09	2022-04-14 15:34:22.787	AT.com	Cable/Satellite	-19.9500	8	Checkcard 0208 Adltime1.com Xxxxxxxxxxx Xxxxxxxxxxxxxxxxxxx6825 Recurring	-1	Checkcard 0208 Adltime1.com Xxxxxxxxxxx Xxxxxxxxxxxxxxxxxxx6825 Recurring	1	2022-02-09	6
93	100130181	2022-02-14	2022-04-14 15:34:22.787	Pixowl Inc	Online Services	-5.4800	\N	Pixowl Inc	0	Pixowl Inc	1	2022-02-14	264
94	100130161	2022-02-16	2022-04-14 15:34:22.787	Publix	Groceries	-55.4800	\N	Publix	0	Publix	1	2022-02-16	268
95	100130148	2022-02-18	2022-04-14 15:34:22.787	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-02-18	336
96	100130679	2022-02-21	2022-04-14 15:41:10.537	Lowe's	Home Improvement	-15.3700	\N	Lowe's	0	Lowe's	2	2022-02-21	204
97	100130132	2022-02-22	2022-04-14 15:34:22.787	Franklin Bakehouse	Restaurants	-13.8700	\N	Franklin Bakehouse	0	Franklin Bakehouse	1	2022-02-22	148
144	100140845	2022-05-09	2022-09-12 00:09:34.777	Target	General Merchandise	-20.0000	\N	Target	0	Target	1	2022-05-09	349
98	100130143	2022-02-22	2022-04-14 15:34:22.787	Cool Springs Wines and Spirits	Travel	-43.8600	1142	Cool Springs Wines & Spirits	-1	Cool Springs Wines & Spirits	1	2022-02-22	111
99	100130119	2022-02-24	2022-04-14 15:34:22.787	Gumroad	Other Expenses	-6.7700	\N	Checkcard 0223 Gum.co/cc* Razer1911 Xxxxxx3486 Ca Xxxxxxxxxxxxxxxxxxx7383	0	Checkcard 0223 Gum.co/cc* Razer1911 Xxxxxx3486 Ca Xxxxxxxxxxxxxxxxxxx7383	1	2022-02-24	165
100	100130091	2022-02-28	2022-04-14 15:34:22.787	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-02-28	336
101	100130103	2022-02-28	2022-04-14 15:34:22.787	Chick-fil-A	Restaurants	-25.0000	\N	Chick-fil-a	0	Chick-fil-a	1	2022-02-28	98
102	100130086	2022-03-01	2022-04-14 15:34:22.787	Middle Tennessee Electric	Utilities	-120.4600	19	Middle Tennessee Electric	-1	Middle Tennessee Electric	1	2022-03-01	221
103	100130078	2022-03-02	2022-04-14 15:34:22.787	ADT Security	Home Improvement	-57.1100	20	Adt Security Services	-1	Adt Security Services	1	2022-03-02	3
104	100130066	2022-03-03	2022-04-14 15:34:22.787	Amazon	General Merchandise	-8.1700	\N	Amazon	0	Amazon	1	2022-03-03	15
105	100130056	2022-03-04	2022-04-14 15:34:22.787	CRM Lawn Care	Insurance	-152.0000	20	Crm Lawn Care Bill Payment	-1	Crm Lawn Care Bill Payment	1	2022-03-04	48
106	100130038	2022-03-07	2022-04-14 15:34:22.787	The Coffee House	Restaurants	-10.6300	\N	The Coffee House	0	The Coffee House	1	2022-03-07	351
107	100130049	2022-03-07	2022-04-14 15:34:22.787	SafeSplash	Groceries	-260.9200	\N	Checkcard 0305 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxxxxxxxxxxxxxxxx5109	0	Checkcard 0305 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxxxxxxxxxxxxxxxx5109	1	2022-03-07	314
108	100130024	2022-03-09	2022-04-14 15:34:22.787	Microsoft	Online Services	-5.4900	\N	Microsoft	0	Microsoft	1	2022-03-09	220
109	100130010	2022-03-11	2022-04-14 15:34:22.787	AT.com	Service Charges/Fees	-0.6000	90	Checkcard 0310 Adltime1.com Xxxxxxxxxxx Xxxxxxxxxxxxxxxxxxx0560 Recurring International Transaction Fee	-1	Checkcard 0310 Adltime1.com Xxxxxxxxxxx Xxxxxxxxxxxxxxxxxxx0560 Recurring International Transaction Fee	1	2022-03-11	6
110	100129996	2022-03-14	2022-04-14 15:34:22.787	Reader's Digest	Transfers	-22.9800	\N	Paypal	0	Paypal	1	2022-03-14	306
111	100130008	2022-03-14	2022-04-14 15:34:22.787	CB Sports Photography	Personal Care	-43.9100	\N	Checkcard 0311 Cb Sports Photography Legacyphotocotn Xxxxx1620xxxxxxxxxx2377 Recurring	0	Checkcard 0311 Cb Sports Photography Legacyphotocotn Xxxxx1620xxxxxxxxxx2377 Recurring	1	2022-03-14	47
112	100129984	2022-03-16	2022-04-14 15:34:22.787	Nashville Public Radio	Insurance	-20.0000	\N	Nash Public Radi Des:donations Id:xx-xxxxxxxx-008 Indn:woods Jake Co Id:xxxxxx1652 Ppd	0	Nash Public Radi Des:donations Id:xx-xxxxxxxx-008 Indn:woods Jake Co Id:xxxxxx1652 Ppd	1	2022-03-16	233
113	100129967	2022-03-18	2022-04-14 15:34:22.787	Marcin Wasielews	Transfers	-110.8000	\N	Marcin Wasielews Des:iat Paypal Id:xxxxxxxxx7822 Indn:jake Woods Co Id:xxxxx0487c Iat Pmt Info: Web Xxxxxxxxxxxxxx1080	0	Marcin Wasielews Des:iat Paypal Id:xxxxxxxxx7822 Indn:jake Woods Co Id:xxxxx0487c Iat Pmt Info: Web Xxxxxxxxxxxxxx1080	1	2022-03-18	212
114	100131040	2022-03-19	2022-04-14 15:50:42.51	Lowe's	Home Improvement	-32.8800	\N	Lowe's	0	Lowe's	2	2022-03-19	204
115	100129956	2022-03-21	2022-04-14 15:34:22.787	Microsoft	Online Services	-9.5800	\N	Microsoft	0	Microsoft	1	2022-03-21	220
116	100131039	2022-03-21	2022-04-14 15:50:42.51	Peloton Cycles	Personal Care	-42.8000	\N	Peloton Cycles	0	Peloton Cycles	2	2022-03-21	262
117	100129933	2022-03-24	2022-04-14 15:34:22.787	Publix	Groceries	-14.0500	\N	Publix	0	Publix	1	2022-03-24	268
118	100131033	2022-03-26	2022-04-14 15:50:42.51	Icp*let It Shine Gymnasti	Personal Care	-1589.5000	\N	Icp*let It Shine Gymnasti	0	Icp*let It Shine Gymnasti	2	2022-03-26	177
119	100129917	2022-03-28	2022-04-14 15:34:22.787	Amazon Kids+	General Merchandise	-7.6500	21	Amazon	-1	Amazon	1	2022-03-28	17
120	100129906	2022-03-29	2022-04-14 15:34:22.787	Walgreens	Healthcare/Medical	-7.6600	\N	Walgreens	0	Walgreens	1	2022-03-29	377
121	100129897	2022-03-31	2022-04-14 15:34:22.787	Lands' End	Clothing/Shoes	-57.5300	\N	Lands' End	0	Lands' End	1	2022-03-31	198
122	100129878	2022-04-04	2022-04-14 15:34:22.787	Publix	Groceries	-20.5500	\N	Publix	0	Publix	1	2022-04-04	268
123	100129889	2022-04-04	2022-04-14 15:34:22.787	Publix	Groceries	-248.7700	\N	Publix	0	Publix	1	2022-04-04	268
124	100129865	2022-04-06	2022-04-14 15:34:22.787	Party City	Entertainment	-45.1600	\N	Party City	0	Party City	1	2022-04-06	253
125	100129847	2022-04-08	2022-04-14 15:34:22.787	Hunters Bend Elementary School	Checks	-15.0000	1161	Check 2048	-1	Check 2048	1	2022-04-08	174
126	100129835	2022-04-11	2022-04-14 15:34:22.787	AT.com	Service Charges/Fees	-0.6000	90	Checkcard 0409 Adltime1.com Xxxxxxx1887 Xxxxx7120xxxxxxxxxx9948 Recurring International Transaction Fee	-1	Checkcard 0409 Adltime1.com Xxxxxxx1887 Xxxxx7120xxxxxxxxxx9948 Recurring International Transaction Fee	1	2022-04-11	6
127	100129829	2022-04-12	2022-04-14 15:34:22.787	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2022-04-12	336
128	100140999	2022-04-14	2022-09-12 00:09:34.777	Amazon Web Services	Online Services	-67.4000	9	Amazon Web Services	-1	Amazon Web Services	1	2022-04-14	21
129	100141202	2022-04-15	2022-09-12 00:14:36.22	The Home Depot	Home Improvement	-205.1000	\N	The Home Depot	0	The Home Depot	2	2022-04-15	354
130	100140986	2022-04-18	2022-09-12 00:09:34.777	Sonic Drive-in	Restaurants	-5.0400	\N	Sonic Drive-in	0	Sonic Drive-in	1	2022-04-18	325
131	100140970	2022-04-19	2022-09-12 00:09:34.777	Chick-fil-A	Restaurants	-25.0000	\N	Chick-fil-a	0	Chick-fil-a	1	2022-04-19	98
132	100140960	2022-04-20	2022-09-12 00:09:34.777	TN Stars	Transfers	-250.0000	\N	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx7046 Indn:785 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	0	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx7046 Indn:785 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	1	2022-04-20	348
133	100140949	2022-04-22	2022-09-12 00:09:34.777	Publix	Groceries	-47.8600	\N	Publix	0	Publix	1	2022-04-22	268
134	100140937	2022-04-25	2022-09-12 00:09:34.777	Knights Of Columbus Insurance	Charitable Giving	-1100.0000	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2022-04-25	191
135	100140930	2022-04-26	2022-09-12 00:09:34.777	Amazon	General Merchandise	-20.6300	\N	Amazon	0	Amazon	1	2022-04-26	15
136	100140921	2022-04-28	2022-09-12 00:09:34.777	Audible	Hobbies	-25.1300	21	Audible	-1	Audible	1	2022-04-28	31
137	100140898	2022-05-02	2022-09-12 00:09:34.777	ADT Security	Home Improvement	-57.1100	20	Adt Security Services	-1	Adt Security Services	1	2022-05-02	3
138	100140910	2022-05-02	2022-09-12 00:09:34.777	Sonic Drive-in	Restaurants	-5.0000	\N	Sonic Drive-in	0	Sonic Drive-in	1	2022-05-02	325
139	100140888	2022-05-03	2022-09-12 00:09:34.777	Zoom Video Communications	Online Services	-16.4500	\N	Zoom Video Communications	0	Zoom Video Communications	1	2022-05-03	396
140	100140878	2022-05-04	2022-09-12 00:09:34.777	Navient	Loans	-68.2600	\N	Navient Corporation	0	Navient Corporation	1	2022-05-04	235
141	100140857	2022-05-06	2022-09-12 00:09:34.777	Navient	Loans	-148.7800	\N	Navient Corporation	0	Navient Corporation	1	2022-05-06	235
142	100140869	2022-05-06	2022-09-12 00:09:34.777	Cigna	Deposits	3999.9400	32	Cigna	0	Cigna	1	2022-05-06	100
143	100140834	2022-05-09	2022-09-12 00:09:34.777	Spotify	Entertainment	-17.5100	21	Spotify	0	Spotify	1	2022-05-09	330
145	100141178	2022-05-09	2022-09-12 00:14:36.22	Kickstarter	Online Services	-156.0300	\N	Kickstarter	0	Kickstarter	2	2022-05-09	189
146	100141177	2022-05-11	2022-09-12 00:14:36.22	Elevate Labs	Online Services	-43.8900	\N	Elevate Labs	0	Elevate Labs	2	2022-05-11	132
147	100141172	2022-05-13	2022-09-12 00:14:36.22	Shell	Gasoline/Fuel	-130.0500	\N	Shell	0	Shell	2	2022-05-13	321
148	100140810	2022-05-16	2022-09-12 00:09:34.777	Publix	Groceries	-26.0700	\N	Publix	0	Publix	1	2022-05-16	268
149	100140800	2022-05-17	2022-09-12 00:09:34.777	Quip	Healthcare/Medical	-10.0000	\N	Quip Nyc Inc	0	Quip Nyc Inc	1	2022-05-17	305
150	100141167	2022-05-18	2022-09-12 00:14:36.22	Walgreens	Healthcare/Medical	-119.1000	\N	Walgreens	0	Walgreens	2	2022-05-18	377
151	100141163	2022-05-19	2022-09-12 00:14:36.22	Full Circle Counseling	Gasoline/Fuel	-145.0000	\N	Full Circle Counseling	0	Full Circle Counseling	2	2022-05-19	151
152	100140775	2022-05-20	2022-09-12 00:09:34.777	Ikea	General Merchandise	-12.1300	\N	Ikea	0	Ikea	1	2022-05-20	178
153	100141156	2022-05-21	2022-09-12 00:14:36.22	The Home Depot	Home Improvement	-183.0300	\N	The Home Depot	0	The Home Depot	2	2022-05-21	354
154	100140767	2022-05-23	2022-09-12 00:09:34.777	Experian	Online Services	-24.9900	\N	Experian	0	Experian	1	2022-05-23	133
155	100140742	2022-05-26	2022-09-12 00:09:34.777	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-05-26	336
156	100140735	2022-05-27	2022-09-12 00:09:34.777	Amazon Kids+	General Merchandise	-7.6500	21	Amazon	-1	Amazon	1	2022-05-27	17
157	100140707	2022-05-31	2022-09-12 00:09:34.777	Coursera	Transfers	-49.0000	\N	Paypal	0	Paypal	1	2022-05-31	112
158	100140719	2022-05-31	2022-09-12 00:09:34.777	Amazon Marketplace	General Merchandise	-29.3500	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-05-31	18
159	100140730	2022-05-31	2022-09-12 00:09:34.777	Audible	Hobbies	-25.1300	21	Audible	-1	Audible	1	2022-05-31	31
160	100140690	2022-06-02	2022-09-12 00:09:34.777	Protective Life	Insurance	-23.8000	35	Protective Life	-1	Protective Life	1	2022-06-02	267
161	100140679	2022-06-03	2022-09-12 00:09:34.777	Amazon	General Merchandise	-19.7400	\N	Amazon	0	Amazon	1	2022-06-03	15
162	100141144	2022-06-04	2022-09-12 00:14:36.22	Lowe's	Home Improvement	27.4400	\N	Lowe's	0	Lowe's	2	2022-06-04	204
163	100140665	2022-06-06	2022-09-12 00:09:34.777	World Vision International	Charitable Giving	-105.0000	3	World Vision	-1	World Vision	1	2022-06-06	391
164	100140645	2022-06-07	2022-09-12 00:09:34.777	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-06-07	336
165	100140641	2022-06-08	2022-09-12 00:09:34.777	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-06-08	336
166	100140639	2022-06-09	2022-09-12 00:09:34.777	Amazon Marketplace	General Merchandise	-31.4100	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-06-09	18
167	100141139	2022-06-10	2022-09-12 00:14:36.22	Cool Springs Wines and Spirits	Groceries	-73.2900	1142	Cool Springs Wines & Spirits	-1	Cool Springs Wines & Spirits	2	2022-06-10	111
168	100140622	2022-06-13	2022-09-12 00:09:34.777	Panera Bread	Restaurants	-32.9800	\N	Panera Bread	0	Panera Bread	1	2022-06-13	250
169	100141133	2022-06-14	2022-09-12 00:14:36.22	Credit Card Payment	Credit Card Payments	2550.0000	57	Payment Thank You-mobile	-1	Payment Thank You-mobile	2	2022-06-14	113
170	100141132	2022-06-16	2022-09-12 00:14:36.22	Amazon	General Merchandise	-62.0500	\N	Amazon	0	Amazon	2	2022-06-16	15
171	100140562	2022-06-21	2022-09-12 00:09:34.777	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-06-21	336
172	100140574	2022-06-21	2022-09-12 00:09:34.777	Publix	Groceries	-3.3300	\N	Publix	0	Publix	1	2022-06-21	268
173	100140585	2022-06-21	2022-09-12 00:09:34.777	Amazon Prime Video	Entertainment	-5.4600	1160	Amazon Prime Video	-1	Amazon Prime Video	1	2022-06-21	20
174	100140556	2022-06-22	2022-09-12 00:09:34.777	Northwestern Mutual	Insurance	-312.0000	92	Northwestern Mutual	0	Northwestern Mutual	1	2022-06-22	242
175	100140543	2022-06-24	2022-09-12 00:09:34.777	Knights Of Columbus Insurance	Charitable Giving	-702.3400	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2022-06-24	191
176	100141121	2022-06-24	2022-09-12 00:14:36.22	Williamson County Animal Hospital	Pets/Pet Care	-252.8200	\N	Williamson County Animal	0	Williamson County Animal	2	2022-06-24	387
177	100140530	2022-06-27	2022-09-12 00:09:34.777	Panera Bread	Restaurants	-34.3800	\N	Panera Bread	0	Panera Bread	1	2022-06-27	250
178	100140519	2022-06-28	2022-09-12 00:09:34.777	Subway	Restaurants	-30.2500	\N	Subway	0	Subway	1	2022-06-28	339
179	100141118	2022-06-30	2022-09-12 00:14:36.22	Full Circle Counseling	Gasoline/Fuel	-145.0000	\N	Full Circle Counseling	0	Full Circle Counseling	2	2022-06-30	151
180	100140502	2022-07-01	2022-09-12 00:09:34.777	Amazon	General Merchandise	-18.0100	\N	Amazon	0	Amazon	1	2022-07-01	15
181	100140452	2022-07-05	2022-09-12 00:09:34.777	First American Financial Corporation	ATM/Cash	-2.5000	\N	First American Financial Corporation	0	First American Financial Corporation	1	2022-07-05	141
182	100140463	2022-07-05	2022-09-12 00:09:34.777	First American Financial Corporation	ATM/Cash	-103.5000	\N	First American Financial Corporation	0	First American Financial Corporation	1	2022-07-05	141
183	100140475	2022-07-05	2022-09-12 00:09:34.777	WTF Just Happened Today	Clothing/Shoes	-5.0000	67	Purchase 0703 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1621xxxxxxxxxx4147 Recurring	-1	Purchase 0703 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1621xxxxxxxxxx4147 Recurring	1	2022-07-05	374
184	100140486	2022-07-05	2022-09-12 00:09:34.777	Vending Charge	Groceries	-3.0000	\N	Cms Vending	0	Cms Vending	1	2022-07-05	372
185	100140443	2022-07-06	2022-09-12 00:09:34.777	M22	Clothing/Shoes	-69.9600	\N	Checkcard 0705 Sp M22 Llc Xxx-xxxx9090 Mi Xxxxx1621xxxxxxxxxx0717	0	Checkcard 0705 Sp M22 Llc Xxx-xxxx9090 Mi Xxxxx1621xxxxxxxxxx0717	1	2022-07-06	205
186	100140434	2022-07-07	2022-09-12 00:09:34.777	Amazon Music	General Merchandise	-16.4100	21	Amazon Music	-1	Amazon Music	1	2022-07-07	19
187	100140430	2022-07-08	2022-09-12 00:09:34.777	Harpeth School of Gymnastics	Education	-149.4000	1143	Checkcard 0707 Icp*harpeth School Of G Xxx-xxx7825 Tn Xxxxx4121xxxxxxxxxx2289 Recurring	0	Checkcard 0707 Icp*harpeth School Of G Xxx-xxx7825 Tn Xxxxx4121xxxxxxxxxx2289 Recurring	1	2022-07-08	169
188	100140403	2022-07-11	2022-09-12 00:09:34.777	Subway	Restaurants	-34.8700	\N	Subway	0	Subway	1	2022-07-11	339
190	100140384	2022-07-12	2022-09-12 00:09:34.777	Publix	Groceries	-66.7800	\N	Publix	0	Publix	1	2022-07-12	268
191	100146352	2022-07-12	2023-09-02 21:03:13.013	Bank Of America	Transfers	-3500.0000	\N	Bank Of America	0	Bank Of America	3	2022-07-12	34
192	100140374	2022-07-14	2022-09-12 00:09:34.777	Publix	Groceries	-46.2900	\N	Publix	0	Publix	1	2022-07-14	268
193	100141107	2022-07-16	2022-09-12 00:14:36.22	Academy of Managed Care Pharmacy	Healthcare/Medical	-275.0000	89	Acad Man Care Pharm	-1	Acad Man Care Pharm	2	2022-07-16	7
194	100140347	2022-07-18	2022-09-12 00:09:34.777	Panera Bread	Restaurants	-10.5400	\N	Panera Bread	0	Panera Bread	1	2022-07-18	250
195	100140359	2022-07-18	2022-09-12 00:09:34.777	Amazon Marketplace	General Merchandise	-24.3700	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-07-18	18
196	100140335	2022-07-19	2022-09-12 00:09:34.777	Focus	Charitable Giving	-5.0000	\N	Focus	0	Focus	1	2022-07-19	143
197	100140321	2022-07-21	2022-09-12 00:09:34.777	Publix	Groceries	-273.2400	\N	Publix	0	Publix	1	2022-07-21	268
198	100140310	2022-07-25	2022-09-12 00:09:34.777	Leveret Clothing	Transfers	-44.9800	1144	Paypal	0	Paypal	1	2022-07-25	201
199	100140302	2022-07-26	2022-09-12 00:09:34.777	Let it Shine Gymnastics	Personal Care	-13.1800	\N	Checkcard 0725 Icp*let It Shine Gymnas Xxx-xxx3547 Tn Xxxxx4122xxxxxxxxxx0778	0	Checkcard 0725 Icp*let It Shine Gymnas Xxx-xxx3547 Tn Xxxxx4122xxxxxxxxxx0778	1	2022-07-26	200
200	100140299	2022-07-27	2022-09-12 00:09:34.777	Amazon Digital Services	Entertainment	2.1100	21	Amazon Digital Services	-1	Amazon Digital Services	1	2022-07-27	16
201	100140272	2022-07-29	2022-09-12 00:09:34.777	Coursera	Transfers	-49.0000	\N	Paypal	0	Paypal	1	2022-07-29	112
202	100140283	2022-07-29	2022-09-12 00:09:34.777	AdhereHealth	Deposits	4896.8000	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx6520es Indn:woods,jake Co Id:xxxxxx1101 Ppd	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx6520es Indn:woods,jake Co Id:xxxxxx1101 Ppd	1	2022-07-29	9
203	100140258	2022-08-01	2022-09-12 00:09:34.777	Great Clips	Personal Care	-42.0000	22	Great Clips	0	Great Clips	1	2022-08-01	163
204	100140270	2022-08-01	2022-09-12 00:09:34.777	The UPS Store	Postage & Shipping	-17.0300	\N	The Ups Store	0	The Ups Store	1	2022-08-01	357
205	100141093	2022-08-02	2022-09-12 00:14:36.22	Apple	Electronics	-2116.1000	\N	Apple	0	Apple	2	2022-08-02	26
206	100140231	2022-08-04	2022-09-12 00:09:34.777	The Good Cup	Restaurants	-7.0400	\N	The Good Cup	0	The Good Cup	1	2022-08-04	353
207	100140202	2022-08-08	2022-09-12 00:09:34.777	International Transaction Fee	Service Charges/Fees	-0.1800	90	Checkcard 0805 Buymeacoffee.com London Xxxxx4722xxxxxxxxxx8363 International Transaction Fee	-1	Checkcard 0805 Buymeacoffee.com London Xxxxx4722xxxxxxxxxx8363 International Transaction Fee	1	2022-08-08	181
208	100140214	2022-08-08	2022-09-12 00:09:34.777	Amazon Music	General Merchandise	-16.4100	21	Amazon Music	-1	Amazon Music	1	2022-08-08	19
209	100140201	2022-08-09	2022-09-12 00:09:34.777	Amazon Marketplace	General Merchandise	-60.0500	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-08-09	18
210	100140193	2022-08-11	2022-09-12 00:09:34.777	Starbucks	Restaurants	-6.4800	\N	Starbucks	0	Starbucks	1	2022-08-11	336
211	100140166	2022-08-15	2022-09-12 00:09:34.777	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-08-15	336
212	100140177	2022-08-15	2022-09-12 00:09:34.777	My School Bucks Lunch Account	Groceries	-42.7500	\N	Checkcard 0814 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3922xxxxxxxxxx4709	0	Checkcard 0814 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3922xxxxxxxxxx4709	1	2022-08-15	229
213	100140149	2022-08-17	2022-09-12 00:09:34.777	Nashville Public Radio	Insurance	-20.0000	\N	Nash Public Radi Des:donations Id:xx-xxxxxxxx-009 Indn:woods Jake Co Id:xxxxxx1652 Ppd	0	Nash Public Radi Des:donations Id:xx-xxxxxxxx-009 Indn:woods Jake Co Id:xxxxxx1652 Ppd	1	2022-08-17	233
214	100140146	2022-08-18	2022-09-12 00:09:34.777	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-08-18	336
215	100141083	2022-08-19	2022-09-12 00:14:36.22	Purchase Interest Charge	Service Charges/Fees	-248.2800	\N	Purchase Interest Charge	0	Purchase Interest Charge	2	2022-08-19	303
216	100140128	2022-08-22	2022-09-12 00:09:34.777	Dunkin' Donuts	Restaurants	-8.3700	\N	Dunkin' Donuts	0	Dunkin' Donuts	1	2022-08-22	130
217	100140110	2022-08-23	2022-09-12 00:09:34.777	Northwestern Mutual	Insurance	-319.6100	92	Northwestern Mutual	0	Northwestern Mutual	1	2022-08-23	242
218	100140102	2022-08-24	2022-09-12 00:09:34.777	Wikimedia Foundation	Transfers	-3.0000	3	Paypal	-1	Paypal	1	2022-08-24	385
219	100140098	2022-08-25	2022-09-12 00:09:34.777	Nashville Violins	Hobbies	-15.7200	\N	Nashville Violins	0	Nashville Violins	1	2022-08-25	234
220	100140090	2022-08-26	2022-09-12 00:09:34.777	AT.com	Other Expenses	-19.9500	8	Checkcard 0821 Adltime1.com Haarlem Xxxxx7122xxxxxxxxxx4147 Recurring	-1	Checkcard 0821 Adltime1.com Haarlem Xxxxx7122xxxxxxxxxx4147 Recurring	1	2022-08-26	6
221	100140074	2022-08-29	2022-09-12 00:09:34.777	Patreon	Dues & Subscriptions	-5.4800	\N	Checkcard 0827 Cko*patreon* Membership Xxx-xxx8766 Ca Xxxxx4122xxxxxxxxxx8293 Recurring	0	Checkcard 0827 Cko*patreon* Membership Xxx-xxx8766 Ca Xxxxx4122xxxxxxxxxx8293 Recurring	1	2022-08-29	254
222	100140065	2022-08-30	2022-09-12 00:09:34.777	My School Bucks Lunch Account	Groceries	-42.7500	\N	Checkcard 0829 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3922xxxxxxxxxx8906	0	Checkcard 0829 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3922xxxxxxxxxx8906	1	2022-08-30	229
223	100140054	2022-09-01	2022-09-12 00:09:34.777	Amazon Marketplace	General Merchandise	-21.9900	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-09-01	18
224	100140049	2022-09-02	2022-09-12 00:09:34.777	Patreon	Dues & Subscriptions	-130.9700	\N	Checkcard 0901 Cko*patreon* Membership Xxx-xxx8766 Ca Xxxxx4122xxxxxxxxxx7812 Recurring	0	Checkcard 0901 Cko*patreon* Membership Xxx-xxx8766 Ca Xxxxx4122xxxxxxxxxx7812 Recurring	1	2022-09-02	254
225	100140029	2022-09-06	2022-09-12 00:09:34.777	Apple	Electronics	-1.0800	\N	Apple	0	Apple	1	2022-09-06	26
226	100140016	2022-09-07	2022-09-12 00:09:34.777	Spotify	Entertainment	-17.5100	21	Spotify	0	Spotify	1	2022-09-07	330
227	100140008	2022-09-08	2022-09-12 00:09:34.777	Keurig	Transfers	-145.8600	\N	Keurig	0	Keurig	1	2022-09-08	188
228	100140004	2022-09-09	2022-09-12 00:09:34.777	AdhereHealth	Deposits	4946.8000	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx6960es Indn:woods,jake Co Id:xxxxxx1101 Ppd	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx6960es Indn:woods,jake Co Id:xxxxxx1101 Ppd	1	2022-09-09	9
229	100143485	2022-09-12	2023-09-02 18:16:34.123	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2022-09-12	336
230	100143475	2022-09-14	2023-09-02 18:16:34.123	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-09-14	336
231	100143453	2022-09-16	2023-09-02 18:16:34.123	Southern Men's Showcase	Telephone	-83.5000	\N	Checkcard 0915 Smshowcase Www.southernmtn Xxxxx1622xxxxxxxxxx2594 Recurring	0	Checkcard 0915 Smshowcase Www.southernmtn Xxxxx1622xxxxxxxxxx2594 Recurring	1	2022-09-16	327
232	100143433	2022-09-19	2023-09-02 18:16:34.123	Goodwill	Charitable Giving	-7.0000	\N	Goodwill	0	Goodwill	1	2022-09-19	157
233	100143445	2022-09-19	2023-09-02 18:16:34.123	Greenlight Financial Technology	Online Services	-50.0000	\N	Greenlight Financial Technology	0	Greenlight Financial Technology	1	2022-09-19	164
234	100143429	2022-09-20	2023-09-02 18:16:34.123	Dollar Shave Club	Transfers	-13.1700	\N	Dollar Shave Club	0	Dollar Shave Club	1	2022-09-20	124
235	100143426	2022-09-21	2023-09-02 18:16:34.123	AT.com	Service Charges/Fees	-0.6000	90	Checkcard 0920 Adltime1.com Haarlem Xxxxx7122xxxxxxxxxx8650 Recurring International Transaction Fee	-1	Checkcard 0920 Adltime1.com Haarlem Xxxxx7122xxxxxxxxxx8650 Recurring International Transaction Fee	1	2022-09-21	6
236	100146203	2022-09-24	2023-09-02 20:36:47.633	Marco's Pizza	Restaurants	-13.0500	4	Marco's Pizza	0	Marco's Pizza	2	2022-09-24	213
237	100143403	2022-09-26	2023-09-02 18:16:34.123	Sam's Club	General Merchandise	-229.6000	\N	Sam's Club	0	Sam's Club	1	2022-09-26	315
238	100143391	2022-09-27	2023-09-02 18:16:34.123	Apple	Electronics	-2.9900	\N	Apple	0	Apple	1	2022-09-27	26
338	100143827	2023-02-21	2023-09-02 18:43:14.16	Publix	Groceries	-8.2000	\N	Publix	0	Publix	1	2023-02-21	268
239	100143387	2022-09-28	2023-09-02 18:16:34.123	Sonic Drive-in	Restaurants	-5.9600	\N	Sonic Drive-in	0	Sonic Drive-in	1	2022-09-28	325
240	100143372	2022-09-30	2023-09-02 18:16:34.123	State Farm	Insurance	-231.0700	\N	State Farm	0	State Farm	1	2022-09-30	337
241	100146198	2022-09-30	2023-09-02 20:36:47.633	Southwest Airlines	Travel	-11.2000	\N	Southwest Airlines	0	Southwest Airlines	2	2022-09-30	328
242	100143358	2022-10-03	2023-09-02 18:16:34.123	Amazon	General Merchandise	-57.0800	\N	Amazon	0	Amazon	1	2022-10-03	15
243	100146187	2022-10-03	2023-09-02 20:36:47.633	Beam Smile Design	Healthcare/Medical	-1790.0000	\N	Beam Smile Design	0	Beam Smile Design	2	2022-10-03	36
244	100143337	2022-10-05	2023-09-02 18:16:34.123	Williamson County Schools - SACC	Utilities	-127.1800	128	Checkcard 1004 4te*williamson County S Xxx-xxx-4719 Tn Xxxxx0022xxxxxxxxxx4133 Recurring	-1	Checkcard 1004 4te*williamson County S Xxx-xxx-4719 Tn Xxxxx0022xxxxxxxxxx4133 Recurring	1	2022-10-05	388
245	100143336	2022-10-06	2023-09-02 18:16:34.123	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-10-06	336
246	100146184	2022-10-07	2023-09-02 20:36:47.633	The Home Depot	Home Improvement	-108.5000	\N	The Home Depot	0	The Home Depot	2	2022-10-07	354
247	100143307	2022-10-11	2023-09-02 18:16:34.123	Double Good Popcorn	Groceries	-28.1800	\N	Double Good Popcorn	0	Double Good Popcorn	1	2022-10-11	127
248	100143318	2022-10-11	2023-09-02 18:16:34.123	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-10-11	336
249	100146179	2022-10-13	2023-09-02 20:36:47.633	The Home Depot	Home Improvement	-430.0700	\N	The Home Depot	0	The Home Depot	2	2022-10-13	354
250	100143290	2022-10-14	2023-09-02 18:16:34.123	Savory Spice Shop	Groceries	-42.6500	\N	Savory Spice Shop	0	Savory Spice Shop	1	2022-10-14	318
251	100143263	2022-10-17	2023-09-02 18:16:34.123	Home Grown	Home Improvement	-119.2700	\N	Home Grown	0	Home Grown	1	2022-10-17	171
252	100143274	2022-10-17	2023-09-02 18:16:34.123	Shell	Gasoline/Fuel	-50.3700	\N	Shell	0	Shell	1	2022-10-17	321
253	100143253	2022-10-18	2023-09-02 18:16:34.123	Comcast	Cable/Satellite	-258.2900	\N	Comcast	0	Comcast	1	2022-10-18	108
254	100146174	2022-10-19	2023-09-02 20:36:47.633	Purchase Interest Charge	Service Charges/Fees	-316.9900	\N	Purchase Interest Charge	0	Purchase Interest Charge	2	2022-10-19	303
255	100146173	2022-10-20	2023-09-02 20:36:47.633	Dr.hammondswhite	Clothing/Shoes	-140.0000	\N	Dr.hammondswhite	0	Dr.hammondswhite	2	2022-10-20	128
256	100143211	2022-10-24	2023-09-02 18:16:34.123	Brewhouse South	Restaurants	-71.2300	\N	Brewhouse South	0	Brewhouse South	1	2022-10-24	43
257	100143222	2022-10-24	2023-09-02 18:16:34.123	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2022-10-24	336
258	100143192	2022-10-27	2023-09-02 18:16:34.123	Apple	Electronics	-2.9900	\N	Apple	0	Apple	1	2022-10-27	26
259	100143188	2022-10-28	2023-09-02 18:16:34.123	Audible	Hobbies	-25.1300	21	Audible	-1	Audible	1	2022-10-28	31
260	100143177	2022-10-31	2023-09-02 18:16:34.123	Google Play	Online Services	-1.0800	\N	Google Play	0	Google Play	1	2022-10-31	160
261	100143161	2022-11-01	2023-09-02 18:16:34.123	7-eleven	Groceries	-33.5100	1	7-eleven	-1	7-eleven	1	2022-11-01	1
262	100143153	2022-11-02	2023-09-02 18:16:34.123	Happily	Restaurants	-110.9700	\N	Purchase 1101 Happily (prev Datebox) Thehappily.cook Xxxxx3423xxxxxxxxxx7212 Recurring	0	Purchase 1101 Happily (prev Datebox) Thehappily.cook Xxxxx3423xxxxxxxxxx7212 Recurring	1	2022-11-02	168
263	100143145	2022-11-03	2023-09-02 18:16:34.123	Zoom Video Communications	Online Services	-16.4500	\N	Zoom Video Communications	0	Zoom Video Communications	1	2022-11-03	396
264	100143134	2022-11-04	2023-09-02 18:16:34.123	Redbubble	General Merchandise	-58.3700	121	Redbubble	0	Redbubble	1	2022-11-04	308
265	100143112	2022-11-07	2023-09-02 18:16:34.123	Hop House	Restaurants	-52.6400	\N	Checkcard 1104 Sq *hop House Tennessee Franklin Tn Xxxxx1623xxxxxxxxxx1408	0	Checkcard 1104 Sq *hop House Tennessee Franklin Tn Xxxxx1623xxxxxxxxxx1408	1	2022-11-07	172
266	100143123	2022-11-07	2023-09-02 18:16:34.123	Franklin Bakehouse	Restaurants	-13.3900	\N	Checkcard 1106 Franklin Bakehouse Franklin Tn Xxxxx2323xxxxxxxxxx0478	0	Checkcard 1106 Franklin Bakehouse Franklin Tn Xxxxx2323xxxxxxxxxx0478	1	2022-11-07	148
267	100143104	2022-11-08	2023-09-02 18:16:34.123	Sonic Drive-in	Restaurants	-1.9600	\N	Sonic Drive-in	0	Sonic Drive-in	1	2022-11-08	325
268	100143100	2022-11-09	2023-09-02 18:16:34.123	Microsoft	Online Services	-5.4900	\N	Microsoft	0	Microsoft	1	2022-11-09	220
269	100146148	2022-11-12	2023-09-02 20:36:47.633	Sq *freelife Soap Co.	Other Expenses	-35.0000	\N	Sq *freelife Soap Co.	0	Sq *freelife Soap Co.	2	2022-11-12	332
270	100143079	2022-11-14	2023-09-02 18:16:34.123	Amazon Marketplace	General Merchandise	-21.9400	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-11-14	18
271	100143090	2022-11-14	2023-09-02 18:16:34.123	Google One	Online Services	-2.1800	\N	Google One	0	Google One	1	2022-11-14	159
272	100143070	2022-11-15	2023-09-02 18:16:34.123	Hannah Anders	Transfers	-860.0000	\N	Venmo	0	Venmo	1	2022-11-15	167
273	100143057	2022-11-16	2023-09-02 18:16:34.123	Williamson Medical Center	Transfers	-463.7200	\N	Paypal Des:inst Xfer Id:medical William Indn:jake Woods Co Id:paypalsi77 Web	0	Paypal Des:inst Xfer Id:medical William Indn:jake Woods Co Id:paypalsi77 Web	1	2022-11-16	389
274	100143038	2022-11-18	2023-09-02 18:16:34.123	AdhereHealth	Deposits	4895.3200	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx8690es Indn:woods,jake Co Id:xxxxxx1101 Ppd	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx8690es Indn:woods,jake Co Id:xxxxxx1101 Ppd	1	2022-11-18	9
275	100146138	2022-11-18	2023-09-02 20:36:47.633	Purchase Interest Charge	Service Charges/Fees	-390.6500	\N	Purchase Interest Charge	0	Purchase Interest Charge	2	2022-11-18	303
276	100143023	2022-11-21	2023-09-02 18:16:34.123	Facebook	Transfers	-10.0000	\N	Facebook Pay	0	Facebook Pay	1	2022-11-21	137
277	100143034	2022-11-21	2023-09-02 18:16:34.123	Dollar Shave Club	Transfers	-13.1700	\N	Dollar Shave Club	0	Dollar Shave Club	1	2022-11-21	124
278	100143011	2022-11-23	2023-09-02 18:16:34.123	Paypal	Other Expenses	-29.9500	115	Checkcard 1122 Pwiadvice.com Xxx-xxx1887 Ca Xxxxx8123xxxxxxxxxx9414	-1	Checkcard 1122 Pwiadvice.com Xxx-xxx1887 Ca Xxxxx8123xxxxxxxxxx9414	1	2022-11-23	256
430	100145944	2023-07-03	2023-09-02 20:11:24.177	Publix	Groceries	-28.0900	\N	Publix	0	Publix	1	2023-07-03	268
279	100146129	2022-11-25	2023-09-02 20:36:47.633	Barnes & Noble	Hobbies	-230.9700	\N	Barnes & Noble	0	Barnes & Noble	2	2022-11-25	35
280	100142987	2022-11-28	2023-09-02 18:16:34.123	Publix	Groceries	-14.6900	\N	Publix	0	Publix	1	2022-11-28	268
281	100142999	2022-11-28	2023-09-02 18:16:34.123	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-11-28	336
282	100142969	2022-11-30	2023-09-02 18:16:34.123	State Farm	Insurance	-231.0700	\N	State Farm	0	State Farm	1	2022-11-30	337
283	100142965	2022-12-01	2023-09-02 18:16:34.123	Netflix	Entertainment	-21.8900	\N	Netflix	0	Netflix	1	2022-12-01	237
284	100142961	2022-12-02	2023-09-02 18:16:34.123	Valon Mortgage	Mortgages	-3702.5000	24	Valon Mortgage, Des:payment Id:xxxx3834bcx3463 Indn:pyac8af25cxx5883dx7931 Co Id:xxxxxx1366 Ccd	-1	Valon Mortgage, Des:payment Id:xxxx3834bcx3463 Indn:pyac8af25cxx5883dx7931 Co Id:xxxxxx1366 Ccd	1	2022-12-02	370
285	100142936	2022-12-05	2023-09-02 18:16:34.123	Lowe's	Home Improvement	-164.6100	\N	Lowe's	0	Lowe's	1	2022-12-05	204
286	100142948	2022-12-05	2023-09-02 18:16:34.123	Gray's On Main	Restaurants	-30.0000	\N	Grays On Main	0	Grays On Main	1	2022-12-05	162
287	100142925	2022-12-06	2023-09-02 18:16:34.123	Act Too Players	Education	-50.0000	1160	Act Too Players	-1	Act Too Players	1	2022-12-06	8
288	100142916	2022-12-07	2023-09-02 18:16:34.123	Amazon Music	General Merchandise	-17.5100	21	Amazon Music	-1	Amazon Music	1	2022-12-07	19
289	100142914	2022-12-08	2023-09-02 18:16:34.123	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2022-12-08	336
290	100146103	2022-12-10	2023-09-02 20:36:47.633	Hunters Bend PTO	Other Expenses	-21.0000	\N	Pp*hbes Pto	0	Pp*hbes Pto	2	2022-12-10	175
291	100142901	2022-12-12	2023-09-02 18:16:34.123	Publix	Groceries	-8.1000	\N	Publix	0	Publix	1	2022-12-12	268
292	100142887	2022-12-13	2023-09-02 18:16:34.123	Publix	Groceries	-32.2700	\N	Publix	0	Publix	1	2022-12-13	268
293	100142875	2022-12-14	2023-09-02 18:16:34.123	Williamson County Schools - SACC	Utilities	-127.1800	128	Checkcard 1213 4te*williamson County S Xxx-xxx-4719 Tn Xxxxx0023xxxxxxxxxx2229 Recurring	-1	Checkcard 1213 4te*williamson County S Xxx-xxx-4719 Tn Xxxxx0023xxxxxxxxxx2229 Recurring	1	2022-12-14	388
294	100142867	2022-12-15	2023-09-02 18:16:34.123	Barnes & Noble	Hobbies	-24.6800	\N	Barnes & Noble	0	Barnes & Noble	1	2022-12-15	35
295	100142857	2022-12-16	2023-09-02 18:16:34.123	Publix	Groceries	-54.1400	\N	Publix	0	Publix	1	2022-12-16	268
296	100142813	2022-12-19	2023-09-02 18:16:34.123	Bank Of America	Deposits	704.5000	\N	Bank Of America	0	Bank Of America	1	2022-12-19	34
297	100142825	2022-12-19	2023-09-02 18:16:34.123	Amazon Marketplace	General Merchandise	-26.9800	\N	Amazon Marketplace	0	Amazon Marketplace	1	2022-12-19	18
298	100142836	2022-12-19	2023-09-02 18:16:34.123	Barnes & Noble	Hobbies	-44.3800	\N	Barnes & Noble	0	Barnes & Noble	1	2022-12-19	35
299	100142848	2022-12-19	2023-09-02 18:16:34.123	Publix	Groceries	-46.1800	\N	Publix	0	Publix	1	2022-12-19	268
300	100142809	2022-12-20	2023-09-02 18:16:34.123	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2022-12-20	336
301	100146083	2022-12-21	2023-09-02 20:36:47.633	Peloton Cycles	Personal Care	-48.2900	\N	Peloton Cycles	0	Peloton Cycles	2	2022-12-21	262
302	100146082	2022-12-24	2023-09-02 20:36:47.633	Sugarwish.com Gifts	Gifts	-99.0000	\N	Sugarwish.com Gifts	0	Sugarwish.com Gifts	2	2022-12-24	340
303	100142778	2022-12-27	2023-09-02 18:16:34.123	Publix	Groceries	-38.7100	\N	Publix	0	Publix	1	2022-12-27	268
304	100142763	2022-12-28	2023-09-02 18:16:34.123	Chick-fil-A	Restaurants	-25.0000	\N	Chick-fil-a	0	Chick-fil-a	1	2022-12-28	98
305	100142755	2022-12-29	2023-09-02 18:16:34.123	Market Basket	Groceries	-25.0000	\N	Market Basket	0	Market Basket	1	2022-12-29	214
306	100142748	2022-12-30	2023-09-02 18:16:34.123	Focus	Utilities	-75.0000	\N	Focusxxxxxx7373 Des:payments Id:aee7f538 Indn:jake Woods Co Id:xxxxxx2248 Ppd	0	Focusxxxxxx7373 Des:payments Id:aee7f538 Indn:jake Woods Co Id:xxxxxx2248 Ppd	1	2022-12-30	143
307	100144146	2023-01-03	2023-09-02 18:43:14.16	Walgreens	Healthcare/Medical	-19.1000	\N	Walgreens	0	Walgreens	1	2023-01-03	377
308	100144158	2023-01-03	2023-09-02 18:43:14.16	Zoom Video Communications	Online Services	-16.4500	\N	Zoom Video Communications	0	Zoom Video Communications	1	2023-01-03	396
309	100144169	2023-01-03	2023-09-02 18:43:14.16	Shell	Gasoline/Fuel	-49.5400	\N	Shell	0	Shell	1	2023-01-03	321
310	100144180	2023-01-03	2023-09-02 18:43:14.16	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-01-03	336
311	100146071	2023-01-04	2023-09-02 20:36:47.633	Southwest Airlines	Travel	11.2000	\N	Southwest Airlines	0	Southwest Airlines	2	2023-01-04	328
312	100144128	2023-01-06	2023-09-02 18:43:14.16	Navient	Loans	-88.9400	\N	Navient Corporation	0	Navient Corporation	1	2023-01-06	235
313	100144124	2023-01-09	2023-09-02 18:43:14.16	Spotify	Entertainment	-17.5100	21	Spotify	0	Spotify	1	2023-01-09	330
314	100144106	2023-01-11	2023-09-02 18:43:14.16	New York Times	Dues & Subscriptions	-28.0000	\N	New York Times	0	New York Times	1	2023-01-11	238
315	100144092	2023-01-13	2023-09-02 18:43:14.16	Publix	Groceries	-38.3000	\N	Publix	0	Publix	1	2023-01-13	268
316	100144066	2023-01-17	2023-09-02 18:43:14.16	Stroud's	Restaurants	-20.3900	\N	Stroud's	0	Stroud's	1	2023-01-17	338
317	100144078	2023-01-17	2023-09-02 18:43:14.16	Paypal	Transfers	-25.7100	115	Paypal	0	Paypal	1	2023-01-17	256
318	100144059	2023-01-18	2023-09-02 18:43:14.16	Tivo	Cable/Satellite	-16.4500	21	Tivo	0	Tivo	1	2023-01-18	362
319	100144056	2023-01-19	2023-09-02 18:43:14.16	AT.com	Service Charges/Fees	-0.6000	90	Checkcard 0118 Adltime1.com Haarlem Xxxxx7130xxxxxxxxxx2475 Recurring International Transaction Fee	-1	Checkcard 0118 Adltime1.com Haarlem Xxxxx7130xxxxxxxxxx2475 Recurring International Transaction Fee	1	2023-01-19	6
320	100144025	2023-01-23	2023-09-02 18:43:14.16	Experian	Online Services	-24.9900	\N	Experian	0	Experian	1	2023-01-23	133
321	100144036	2023-01-23	2023-09-02 18:43:14.16	Property Tax - City of Franklin/Williamson County	Paychecks/Salary	-1922.0000	1168	Forte	0	Forte	1	2023-01-23	266
322	100144023	2023-01-24	2023-09-02 18:43:14.16	Paypal	Transfers	-3.0000	115	Paypal	0	Paypal	1	2023-01-24	256
323	100144003	2023-01-27	2023-09-02 18:43:14.16	SafeSplash	Groceries	-274.4000	\N	Checkcard 0126 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4130xxxxxxxxxx1315 Recurring	0	Checkcard 0126 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4130xxxxxxxxxx1315 Recurring	1	2023-01-27	314
324	100143990	2023-01-30	2023-09-02 18:43:14.16	Publix	Groceries	-5.5000	\N	Publix	0	Publix	1	2023-01-30	268
325	100146060	2023-01-30	2023-09-02 20:36:47.633	Credit Card Payment	Credit Card Payments	3000.0000	57	Payment Thank You-mobile	-1	Payment Thank You-mobile	2	2023-01-30	113
326	100143978	2023-02-01	2023-09-02 18:43:14.16	Middle Tennessee Electric	Utilities	-194.6100	19	Middle Tennessee Electric	-1	Middle Tennessee Electric	1	2023-02-01	221
327	100143966	2023-02-03	2023-09-02 18:43:14.16	Amazon	General Merchandise	-13.5900	\N	Amazon	0	Amazon	1	2023-02-03	15
328	100143943	2023-02-06	2023-09-02 18:43:14.16	Burger Up	Restaurants	-52.7100	\N	Burger Up	0	Burger Up	1	2023-02-06	46
329	100143955	2023-02-06	2023-09-02 18:43:14.16	Navient	Loans	-88.9400	\N	Navient Corporation	0	Navient Corporation	1	2023-02-06	235
330	100143937	2023-02-07	2023-09-02 18:43:14.16	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2023-02-07	336
331	100143921	2023-02-09	2023-09-02 18:43:14.16	Check 1984	Checks	-70.0000	\N	Check 1984	0	Check 1984	1	2023-02-09	55
332	100143917	2023-02-10	2023-09-02 18:43:14.16	Instacart	Groceries	-99.0000	\N	Instacart	0	Instacart	1	2023-02-10	179
333	100143892	2023-02-13	2023-09-02 18:43:14.16	Microsoft	Online Services	-10.6200	\N	Microsoft	0	Microsoft	1	2023-02-13	220
334	100143903	2023-02-13	2023-09-02 18:43:14.16	CRM Lawn Care	Home Maintenance	-84.0000	\N	Crmlawn.com Des:crmlawn.co Id:st-e0l6h7s9p6y3 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	0	Crmlawn.com Des:crmlawn.co Id:st-e0l6h7s9p6y3 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	1	2023-02-13	48
335	100143880	2023-02-14	2023-09-02 18:43:14.16	The UPS Store	Postage & Shipping	-21.3600	\N	The Ups Store	0	The Ups Store	1	2023-02-14	357
336	100143871	2023-02-15	2023-09-02 18:43:14.16	City of Franklin	Utilities	-64.8600	1137	Cafe Water	0	Cafe Water	1	2023-02-15	102
337	100143853	2023-02-17	2023-09-02 18:43:14.16	Wall Street Journal	Hobbies	-40.9900	\N	Wall Street Journal	0	Wall Street Journal	1	2023-02-17	378
339	100143838	2023-02-21	2023-09-02 18:43:14.16	Justice Industries	Clothing/Shoes	-18.5000	\N	Justice	0	Justice	1	2023-02-21	185
340	100143850	2023-02-21	2023-09-02 18:43:14.16	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-02-21	336
341	100146051	2023-02-22	2023-09-02 20:36:47.633	Full Circle Counseling	Online Services	-150.0000	\N	Full Circle Counseling	0	Full Circle Counseling	2	2023-02-22	151
342	100146050	2023-02-26	2023-09-02 20:36:47.633	Ann Taylor	Clothing/Shoes	-238.4200	\N	Ann Taylor	0	Ann Taylor	2	2023-02-26	24
343	100143796	2023-02-27	2023-09-02 18:43:14.16	Apple	Electronics	-2.9900	\N	Apple	0	Apple	1	2023-02-27	26
344	100143782	2023-02-28	2023-09-02 18:43:14.16	Audible	Hobbies	-25.1300	21	Audible	-1	Audible	1	2023-02-28	31
345	100143776	2023-03-01	2023-09-02 18:43:14.16	Netflix	Entertainment	-21.8900	\N	Netflix	0	Netflix	1	2023-03-01	237
346	100143759	2023-03-02	2023-09-02 18:43:14.16	Shell	Gasoline/Fuel	-40.0100	\N	Shell	0	Shell	1	2023-03-02	321
347	100143747	2023-03-03	2023-09-02 18:43:14.16	Amazon	General Merchandise	-39.9100	\N	Amazon	0	Amazon	1	2023-03-03	15
348	100143720	2023-03-06	2023-09-02 18:43:14.16	Beast	Travel	-16.6100	\N	Purchase 0303 Getbeast.com Httpswww.getbtn Xxxxx1630xxxxxxxxxx9464 Recurring	0	Purchase 0303 Getbeast.com Httpswww.getbtn Xxxxx1630xxxxxxxxxx9464 Recurring	1	2023-03-06	37
349	100143732	2023-03-06	2023-09-02 18:43:14.16	Publix	Groceries	-35.2200	\N	Publix	0	Publix	1	2023-03-06	268
350	100143743	2023-03-06	2023-09-02 18:43:14.16	Paypal	Transfers	-26.9300	115	Paypal	0	Paypal	1	2023-03-06	256
351	100143705	2023-03-08	2023-09-02 18:43:14.16	Williamson County Schools - SACC	Online Services	-101.7400	128	Checkcard 0307 4te*williamson County S Xxx-xxx-4719 Tn Xxxxx0030xxxxxxxxxx9117 Recurring	-1	Checkcard 0307 4te*williamson County S Xxx-xxx-4719 Tn Xxxxx0030xxxxxxxxxx9117 Recurring	1	2023-03-08	388
352	100143698	2023-03-09	2023-09-02 18:43:14.16	My School Bucks Lunch Account	Other Expenses	-82.7500	\N	Checkcard 0308 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3930xxxxxxxxxx6518	0	Checkcard 0308 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3930xxxxxxxxxx6518	1	2023-03-09	229
353	100143691	2023-03-10	2023-09-02 18:43:14.16	Publix	Groceries	-16.3500	\N	Publix	0	Publix	1	2023-03-10	268
354	100143675	2023-03-13	2023-09-02 18:43:14.16	Marco's Pizza	Restaurants	-14.9200	4	Marco's Pizza	0	Marco's Pizza	1	2023-03-13	213
355	100146040	2023-03-13	2023-09-02 20:36:47.633	Adventure Science	Entertainment	-116.0000	\N	Adventure Science	0	Adventure Science	2	2023-03-13	13
356	100143660	2023-03-15	2023-09-02 18:43:14.16	Publix	Groceries	-12.6000	\N	Publix	0	Publix	1	2023-03-15	268
357	100143648	2023-03-17	2023-09-02 18:43:14.16	Wall Street Journal	Hobbies	-40.9900	\N	Wall Street Journal	0	Wall Street Journal	1	2023-03-17	378
358	100143623	2023-03-20	2023-09-02 18:43:14.16	Paypal	Transfers	-50.0000	115	Paypal	0	Paypal	1	2023-03-20	256
359	100143634	2023-03-20	2023-09-02 18:43:14.16	Bed Bath & Beyond	General Merchandise	-43.8900	\N	Bed Bath & Beyond	0	Bed Bath & Beyond	1	2023-03-20	38
360	100143645	2023-03-20	2023-09-02 18:43:14.16	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-03-20	336
361	100146034	2023-03-21	2023-09-02 20:36:47.633	Credit Card Payment	Credit Card Payments	3500.0000	57	Payment Thank You-mobile	-1	Payment Thank You-mobile	2	2023-03-21	113
362	100143595	2023-03-23	2023-09-02 18:43:14.16	Second Harvest Food Bank	Restaurants	-50.0000	\N	Checkcard 0322 Second Harvest Fb Xxx-xxx3491 Tn Xxxxx1630xxxxxxxxxx6695	0	Checkcard 0322 Second Harvest Fb Xxx-xxx3491 Tn Xxxxx1630xxxxxxxxxx6695	1	2023-03-23	319
363	100143592	2023-03-24	2023-09-02 18:43:14.16	Paypal	Transfers	-3.0000	115	Paypal	0	Paypal	1	2023-03-24	256
364	100143575	2023-03-27	2023-09-02 18:43:14.16	Publix	Groceries	-287.5200	\N	Publix	0	Publix	1	2023-03-27	268
365	100143564	2023-03-28	2023-09-02 18:43:14.16	Quip	Healthcare/Medical	-7.6800	\N	Quip Nyc Inc	0	Quip Nyc Inc	1	2023-03-28	305
366	100143563	2023-03-29	2023-09-02 18:43:14.16	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-03-29	336
367	100143544	2023-03-31	2023-09-02 18:43:14.16	Netflix	Entertainment	-21.8900	\N	Netflix	0	Netflix	1	2023-03-31	237
368	100145462	2023-04-03	2023-09-02 20:06:47.44	Burger Up	Restaurants	-162.1100	\N	Burger Up	0	Burger Up	1	2023-04-03	46
369	100145473	2023-04-03	2023-09-02 20:06:47.44	Middle Tennessee Electric	Utilities	-114.2100	19	Middle Tennessee Electric	-1	Middle Tennessee Electric	1	2023-04-03	221
370	100145453	2023-04-04	2023-09-02 20:06:47.44	Venmo	Transfers	-120.0000	\N	Venmo	0	Venmo	1	2023-04-04	373
371	100145444	2023-04-05	2023-09-02 20:06:47.44	New York Times	Dues & Subscriptions	-28.0000	\N	New York Times	0	New York Times	1	2023-04-05	238
372	100145436	2023-04-06	2023-09-02 20:06:47.44	Navient	Loans	-88.9400	\N	Navient Corporation	0	Navient Corporation	1	2023-04-06	235
373	100145426	2023-04-07	2023-09-02 20:06:47.44	Spotify	Entertainment	-17.5100	21	Spotify	0	Spotify	1	2023-04-07	330
374	100145411	2023-04-10	2023-09-02 20:06:47.44	Amazon Marketplace	General Merchandise	-53.0800	\N	Amazon Marketplace	0	Amazon Marketplace	1	2023-04-10	18
375	100146370	2023-04-10	2023-09-02 21:03:13.013	Interest Paid	Interest	49.2400	104	Interest Paid	0	Interest Paid	3	2023-04-10	180
376	100145390	2023-04-12	2023-09-02 20:06:47.44	Brentwood Skate Center	Entertainment	-17.6800	\N	Brentwood Skate Center	0	Brentwood Skate Center	1	2023-04-12	42
377	100146013	2023-04-15	2023-09-02 20:36:47.633	Google Play	Online Services	-10.9400	\N	Google Play	0	Google Play	2	2023-04-15	160
378	100145372	2023-04-17	2023-09-02 20:06:47.44	Publix	Groceries	-90.2100	\N	Publix	0	Publix	1	2023-04-17	268
379	100145362	2023-04-18	2023-09-02 20:06:47.44	Comcast	Cable/Satellite	-271.5100	\N	Comcast	0	Comcast	1	2023-04-18	108
380	100145353	2023-04-19	2023-09-02 20:06:47.44	Walgreens	Healthcare/Medical	-5.4800	\N	Walgreens	0	Walgreens	1	2023-04-19	377
431	100145919	2023-07-05	2023-09-02 20:11:24.177	Publix	Groceries	-4.7800	\N	Publix	0	Publix	1	2023-07-05	268
381	100145331	2023-04-21	2023-09-02 20:06:47.44	AdhereHealth	Deposits	4935.8400	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx7900es Indn:woods,jake Co Id:xxxxxx1101 Ppd	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx7900es Indn:woods,jake Co Id:xxxxxx1101 Ppd	1	2023-04-21	9
382	100145313	2023-04-24	2023-09-02 20:06:47.44	Grailr	Online Services	-4.3800	\N	Checkcard 0422 Google *grailr Llc G.co/helppay#ca Xxxxx1631xxxxxxxxxx6945 Recurring	0	Checkcard 0422 Google *grailr Llc G.co/helppay#ca Xxxxx1631xxxxxxxxxx6945 Recurring	1	2023-04-24	161
383	100145325	2023-04-24	2023-09-02 20:06:47.44	Shell	Gasoline/Fuel	-3.4100	\N	Shell	0	Shell	1	2023-04-24	321
384	100145310	2023-04-25	2023-09-02 20:06:47.44	Keurig	Transfers	-107.6400	\N	Keurig	0	Keurig	1	2023-04-25	188
385	100145300	2023-04-27	2023-09-02 20:06:47.44	CarMax	Loans	-674.8200	108	Car Max	-1	Car Max	1	2023-04-27	51
386	100145274	2023-05-01	2023-09-02 20:06:47.44	Netflix	Entertainment	-21.8900	\N	Netflix	0	Netflix	1	2023-05-01	237
387	100145285	2023-05-01	2023-09-02 20:06:47.44	Dillard's	General Merchandise	-95.5900	\N	Dillard's	0	Dillard's	1	2023-05-01	121
388	100145261	2023-05-02	2023-09-02 20:06:47.44	Publix	Groceries	-32.1500	\N	Publix	0	Publix	1	2023-05-02	268
389	100145240	2023-05-03	2023-09-02 20:06:47.44	Amazon	General Merchandise	-15.6000	\N	Amazon	0	Amazon	1	2023-05-03	15
390	100145252	2023-05-03	2023-09-02 20:06:47.44	Venmo	Transfers	-120.0000	\N	Venmo	0	Venmo	1	2023-05-03	373
391	100145230	2023-05-05	2023-09-02 20:06:47.44	CRM Lawn Care	Home Maintenance	-177.3300	\N	Crm Lawn Care Bill Payment	0	Crm Lawn Care Bill Payment	1	2023-05-05	48
392	100145207	2023-05-08	2023-09-02 20:06:47.44	Amazon Music	Entertainment	-17.5100	21	Amazon Music	-1	Amazon Music	1	2023-05-08	19
393	100145218	2023-05-08	2023-09-02 20:06:47.44	Coal Town Pizza	Restaurants	-126.7900	\N	Checkcard 0507 Tst* Coal Town Pizza Franklin Tn Xxxxx1631xxxxxxxxxx0303	0	Checkcard 0507 Tst* Coal Town Pizza Franklin Tn Xxxxx1631xxxxxxxxxx0303	1	2023-05-08	106
394	100145193	2023-05-09	2023-09-02 20:06:47.44	Publix	Groceries	-8.9500	\N	Publix	0	Publix	1	2023-05-09	268
395	100145178	2023-05-11	2023-09-02 20:06:47.44	Jersey Mike's Subs	Restaurants	-34.3700	\N	Jersey Mike's Subs	0	Jersey Mike's Subs	1	2023-05-11	182
396	100145176	2023-05-12	2023-09-02 20:06:47.44	Mapco Express	Gasoline/Fuel	-60.3700	\N	Mapco Express	0	Mapco Express	1	2023-05-12	211
397	100145153	2023-05-15	2023-09-02 20:06:47.44	Sonic Drive-in	Restaurants	-8.7700	\N	Sonic Drive-in	0	Sonic Drive-in	1	2023-05-15	325
398	100145164	2023-05-15	2023-09-02 20:06:47.44	CarMax	Loans	-532.9800	108	Car Max	-1	Car Max	1	2023-05-15	51
399	100145132	2023-05-17	2023-09-02 20:06:47.44	Brentwood Counseling	Online Services	-150.0000	\N	Checkcard 0515 Brentwood Counseling As Xxx-xxx-1153 Tn Xxxxx8731xxxxxxxxxx1785	0	Checkcard 0515 Brentwood Counseling As Xxx-xxx-1153 Tn Xxxxx8731xxxxxxxxxx1785	1	2023-05-17	41
400	100145127	2023-05-18	2023-09-02 20:06:47.44	Justice Industries	Clothing/Shoes	-18.5000	\N	Justice	0	Justice	1	2023-05-18	185
401	100145122	2023-05-19	2023-09-02 20:06:47.44	Publix	Groceries	-8.5200	\N	Publix	0	Publix	1	2023-05-19	268
402	100145103	2023-05-22	2023-09-02 20:06:47.44	Amazon	General Merchandise	-31.2100	\N	Amazon	0	Amazon	1	2023-05-22	15
403	100145114	2023-05-22	2023-09-02 20:06:47.44	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-05-22	336
404	100145086	2023-05-24	2023-09-02 20:06:47.44	Mapco Express	Gasoline/Fuel	-61.6100	\N	Mapco Express	0	Mapco Express	1	2023-05-24	211
405	100145077	2023-05-25	2023-09-02 20:06:47.44	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-05-25	336
406	100145069	2023-05-26	2023-09-02 20:06:47.44	Macadoodles	Groceries	-56.1000	\N	Macadoodles	0	Macadoodles	1	2023-05-26	208
407	100145041	2023-05-30	2023-09-02 20:06:47.44	Silver Dollar City Candle Shop	Home Improvement	-32.2900	\N	Checkcard 0526 Candles Branson Mo Xxxxx7331xxxxxxxxxx0437	0	Checkcard 0526 Candles Branson Mo Xxxxx7331xxxxxxxxxx0437	1	2023-05-30	322
408	100145053	2023-05-30	2023-09-02 20:06:47.44	Greenlight Financial Technology	Online Services	-100.0000	\N	Greenlight Financial Technology	0	Greenlight Financial Technology	1	2023-05-30	164
409	100145032	2023-05-31	2023-09-02 20:06:47.44	Venmo	Transfers	-133.0000	\N	Venmo	0	Venmo	1	2023-05-31	373
410	100145013	2023-06-02	2023-09-02 20:06:47.44	AdhereHealth	Deposits	4985.8400	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx7010es Indn:woods,jake Co Id:xxxxxx1101 Ppd	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx7010es Indn:woods,jake Co Id:xxxxxx1101 Ppd	1	2023-06-02	9
411	100144983	2023-06-05	2023-09-02 20:06:47.44	Amazon	General Merchandise	-13.4700	\N	Amazon	0	Amazon	1	2023-06-05	15
412	100144994	2023-06-05	2023-09-02 20:06:47.44	Barnes & Noble	Hobbies	-39.4400	\N	Barnes & Noble	0	Barnes & Noble	1	2023-06-05	35
413	100145006	2023-06-05	2023-09-02 20:06:47.44	Sonic Drive-in	Restaurants	-2.0000	\N	Sonic Drive-in	0	Sonic Drive-in	1	2023-06-05	325
414	100144978	2023-06-06	2023-09-02 20:06:47.44	Navient	Loans	-88.9400	\N	Navient Corporation	0	Navient Corporation	1	2023-06-06	235
415	100146374	2023-06-10	2023-09-02 21:03:13.013	Interest Paid	Interest	57.8800	104	Interest Paid	0	Interest Paid	3	2023-06-10	180
416	100144955	2023-06-12	2023-09-02 20:06:47.44	Wall Street Journal	Entertainment	-40.9900	\N	Wall Street Journal	0	Wall Street Journal	1	2023-06-12	378
417	100144943	2023-06-13	2023-09-02 20:06:47.44	Amazon Web Services	Online Services	-79.6400	9	Amazon Web Services	0	Amazon Web Services	1	2023-06-13	21
418	100145998	2023-06-14	2023-09-02 20:36:47.633	Credit Card Payment	Credit Card Payments	1000.0000	57	Payment Thank You-mobile	-1	Payment Thank You-mobile	2	2023-06-14	113
419	100144912	2023-06-16	2023-09-02 20:06:47.44	AdhereHealth	Deposits	4935.8400	32	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx3950es Indn:woods,jake Co Id:xxxxxx1103 Ppd	-1	Adherehealth Llc Des:direct Dep Id:xxxxxxxxx3950es Indn:woods,jake Co Id:xxxxxx1103 Ppd	1	2023-06-16	9
420	100145996	2023-06-19	2023-09-02 20:36:47.633	Purchase Interest Charge	Service Charges/Fees	-511.2100	\N	Purchase Interest Charge	0	Purchase Interest Charge	2	2023-06-19	303
421	100144892	2023-06-20	2023-09-02 20:06:47.44	Walgreens	Healthcare/Medical	-18.4300	\N	Walgreens	0	Walgreens	1	2023-06-20	377
422	100144904	2023-06-20	2023-09-02 20:06:47.44	Publix	Groceries	-51.4300	\N	Publix	0	Publix	1	2023-06-20	268
423	100144880	2023-06-21	2023-09-02 20:06:47.44	Paypal	Transfers	-13.1800	115	Paypal	0	Paypal	1	2023-06-21	256
424	100144853	2023-06-26	2023-09-02 20:06:47.44	Apple	Electronics	-12.0300	\N	Apple	0	Apple	1	2023-06-26	26
425	100144864	2023-06-26	2023-09-02 20:06:47.44	Knights Of Columbus Insurance	Charitable Giving	-1231.1200	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2023-06-26	191
426	100144837	2023-06-28	2023-09-02 20:06:47.44	Starbucks	Restaurants	-18.6600	\N	Starbucks	0	Starbucks	1	2023-06-28	336
427	100144833	2023-06-29	2023-09-02 20:06:47.44	Publix	Groceries	-9.4500	\N	Publix	0	Publix	1	2023-06-29	268
428	100144828	2023-06-30	2023-09-02 20:06:47.44	Cook's Pest Control	Home Maintenance	-99.0000	\N	Cook's Pest Control	0	Cook's Pest Control	1	2023-06-30	109
429	100145933	2023-07-03	2023-09-02 20:11:24.177	Sonic Drive-in	Restaurants	-6.5600	\N	Sonic Drive-in	0	Sonic Drive-in	1	2023-07-03	325
432	100145905	2023-07-07	2023-09-02 20:11:24.177	Chewy	Pets/Pet Care	-43.4500	\N	Chewy	0	Chewy	1	2023-07-07	96
433	100145882	2023-07-10	2023-09-02 20:11:24.177	Chick-fil-A	Restaurants	-32.6500	\N	Chick-fil-a	0	Chick-fil-a	1	2023-07-10	98
434	100145893	2023-07-10	2023-09-02 20:11:24.177	Publix	Groceries	-20.9700	\N	Publix	0	Publix	1	2023-07-10	268
435	100145904	2023-07-10	2023-09-02 20:11:24.177	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-07-10	336
436	100145865	2023-07-13	2023-09-02 20:11:24.177	St. Joseph's Indian School	Education	-33.0000	3	Checkcard 0712 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4231xxxxxxxxxx0325	-1	Checkcard 0712 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4231xxxxxxxxxx0325	1	2023-07-13	334
437	100145863	2023-07-14	2023-09-02 20:11:24.177	Amazon Web Services	Online Services	-100.4300	9	Amazon Web Services	0	Amazon Web Services	1	2023-07-14	21
438	100145846	2023-07-17	2023-09-02 20:11:24.177	Target	General Merchandise	-55.2900	\N	Target	0	Target	1	2023-07-17	349
439	100145857	2023-07-17	2023-09-02 20:11:24.177	Paypal	Transfers	-9.9900	115	Paypal	0	Paypal	1	2023-07-17	256
440	100145820	2023-07-19	2023-09-02 20:11:24.177	Focus	Charitable Giving	-75.0000	\N	Focus	0	Focus	1	2023-07-19	143
592	100147973	2024-02-23	2024-03-17 22:56:54.213	Apple.com	Electronics	-12.0300	\N	Apple.com	0	Apple.com	1	2024-02-23	27
441	100145811	2023-07-21	2023-09-02 20:11:24.177	Brentwood Counseling	Online Services	-150.0000	\N	Checkcard 0719 Brentwood Counseling As Xxx-xxx-1153 Tn Xxxxx8732xxxxxxxxxx3877	0	Checkcard 0719 Brentwood Counseling As Xxx-xxx-1153 Tn Xxxxx8732xxxxxxxxxx3877	1	2023-07-21	41
442	100145792	2023-07-24	2023-09-02 20:11:24.177	Vending Charge	Groceries	-2.5000	\N	Coca-cola	0	Coca-cola	1	2023-07-24	372
443	100145803	2023-07-24	2023-09-02 20:11:24.177	Walgreens	Healthcare/Medical	-20.6200	\N	Walgreens	0	Walgreens	1	2023-07-24	377
444	100145778	2023-07-25	2023-09-02 20:11:24.177	Goblin And The Grocer	Restaurants	-100.5300	\N	Goblin And The Grocer	0	Goblin And The Grocer	1	2023-07-25	156
445	100145761	2023-07-26	2023-09-02 20:11:24.177	Dunkin' Donuts	Restaurants	-15.0000	\N	Dunkin' Donuts	0	Dunkin' Donuts	1	2023-07-26	130
446	100145772	2023-07-26	2023-09-02 20:11:24.177	Foxtrot Market	Groceries	-9.9200	\N	Foxtrot Market	0	Foxtrot Market	1	2023-07-26	147
447	100145741	2023-07-27	2023-09-02 20:11:24.177	Chicago Transit Authority	Travel	-2.5000	\N	Ventra	0	Ventra	1	2023-07-27	97
448	100145752	2023-07-27	2023-09-02 20:11:24.177	Amazon Kids+	Groceries	-5.4600	21	Amazonfresh	-1	Amazonfresh	1	2023-07-27	17
449	100145724	2023-07-28	2023-09-02 20:11:24.177	Muah Cotton Candy	Clothing/Shoes	-13.0300	\N	Checkcard 0727 Muah Cotton Candy Xxx-xxxx5592 Il Xxxxx1632xxxxxxxxxx7674	0	Checkcard 0727 Muah Cotton Candy Xxx-xxxx5592 Il Xxxxx1632xxxxxxxxxx7674	1	2023-07-28	227
450	100145696	2023-07-31	2023-09-02 20:11:24.177	Shedd Aquarium	Entertainment	-50.0600	\N	Shedd Aquarium	0	Shedd Aquarium	1	2023-07-31	320
451	100145708	2023-07-31	2023-09-02 20:11:24.177	Jewel Osco	Groceries	-18.2100	\N	Jewel-osco	0	Jewel-osco	1	2023-07-31	183
452	100145719	2023-07-31	2023-09-02 20:11:24.177	City of Franklin	Utilities	-113.0000	20	Cafe Water	0	Cafe Water	1	2023-07-31	102
453	100142720	2023-08-02	2023-09-02 03:33:08.86	Venmo	Transfers	-120.0000	\N	Venmo	0	Venmo	1	2023-08-02	373
454	100142732	2023-08-02	2023-09-02 03:33:08.86	Amazon Marketplace	General Merchandise	-95.7100	\N	Amazon Marketplace	0	Amazon Marketplace	1	2023-08-02	18
455	100142709	2023-08-04	2023-09-02 03:33:08.86	Atmos Energy	Utilities	-23.6600	19	Atmos Energy	-1	Atmos Energy	1	2023-08-04	30
456	100145964	2023-08-06	2023-09-02 20:36:47.633	Publix	Groceries	-150.3500	\N	Publix	0	Publix	2	2023-08-06	268
457	100142705	2023-08-07	2023-09-02 03:33:08.86	Publix	Groceries	-37.6300	\N	Publix	0	Publix	1	2023-08-07	268
458	100142685	2023-08-09	2023-09-02 03:33:08.86	Microsoft	Online Services	-10.6200	\N	Microsoft	0	Microsoft	1	2023-08-09	220
459	100142681	2023-08-10	2023-09-02 03:33:08.86	Alltrails	Online Services	-39.5000	\N	Alltrails	0	Alltrails	1	2023-08-10	14
460	100142672	2023-08-11	2023-09-02 03:33:08.86	Southwest Airlines	Travel	-11.2000	\N	Southwest Airlines	0	Southwest Airlines	1	2023-08-11	328
461	100142658	2023-08-14	2023-09-02 03:33:08.86	Publix	Groceries	-28.2600	\N	Publix	0	Publix	1	2023-08-14	268
462	100142648	2023-08-15	2023-09-02 03:33:08.86	Amazon Web Services	Online Services	-84.3600	9	Amazon Web Services	0	Amazon Web Services	1	2023-08-15	21
463	100142633	2023-08-17	2023-09-02 03:33:08.86	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-08-17	336
464	100142630	2023-08-18	2023-09-02 03:33:08.86	Susan Hammonds-White	Clothing/Shoes	-140.0000	81	Checkcard 0817 Dr.hammondswhite Www.susanhammtn Xxxxx1632xxxxxxxxxx6982 Recurring	0	Checkcard 0817 Dr.hammondswhite Www.susanhammtn Xxxxx1632xxxxxxxxxx6982 Recurring	1	2023-08-18	341
465	100142604	2023-08-21	2023-09-02 03:33:08.86	Lowe's	Home Improvement	-32.8800	\N	Lowe's	0	Lowe's	1	2023-08-21	204
466	100142615	2023-08-21	2023-09-02 03:33:08.86	Target	General Merchandise	-5.6900	\N	Target	0	Target	1	2023-08-21	349
467	100142592	2023-08-22	2023-09-02 03:33:08.86	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-08-22	336
468	100142591	2023-08-23	2023-09-02 03:33:08.86	My School Bucks Lunch Account	Other Expenses	-42.7500	\N	Checkcard 0822 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3932xxxxxxxxxx1516	0	Checkcard 0822 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3932xxxxxxxxxx1516	1	2023-08-23	229
469	100142575	2023-08-25	2023-09-02 03:33:08.86	Gabe's	Clothing/Shoes	-5.4800	\N	Gabe's	0	Gabe's	1	2023-08-25	154
470	100145511	2023-08-28	2023-09-02 20:11:24.177	Apple	Electronics	-12.0300	\N	Apple	0	Apple	1	2023-08-28	26
471	100145522	2023-08-28	2023-09-02 20:11:24.177	CarMax	Loans	-674.8200	108	Car Max	-1	Car Max	1	2023-08-28	51
472	100145492	2023-08-30	2023-09-02 20:11:24.177	State Farm	Insurance	-197.5500	\N	State Farm	0	State Farm	1	2023-08-30	337
473	100145486	2023-08-31	2023-09-02 20:11:24.177	Publix	Groceries	-55.1200	\N	Publix	0	Publix	1	2023-08-31	268
474	100146418	2023-09-05	2023-09-09 14:32:27.17	Venmo	Transfers	-40.0000	\N	Venmo	0	Venmo	1	2023-09-05	373
475	100146429	2023-09-05	2023-09-09 14:32:27.17	Trader Joe's	Groceries	-36.4300	23	Trader Joe's	0	Trader Joe's	1	2023-09-05	367
476	100146441	2023-09-05	2023-09-09 14:32:27.17	Autozone	Automotive	-15.9000	\N	Autozone	0	Autozone	1	2023-09-05	33
477	100146416	2023-09-06	2023-09-09 14:32:27.17	Amazon	General Merchandise	-25.3300	\N	Amazon.com	0	Amazon.com	1	2023-09-06	15
478	100146393	2023-09-08	2023-09-09 14:32:27.17	Kroger	Groceries	-21.9700	\N	Kroger	0	Kroger	1	2023-09-08	195
479	100146529	2023-09-11	2023-09-22 22:29:09.13	Shell	Gasoline/Fuel	-100.0000	\N	Shell	0	Shell	1	2023-09-11	321
480	100146540	2023-09-11	2023-09-22 22:29:09.13	Dsw	Clothing/Shoes	-49.3800	\N	Dsw	0	Dsw	1	2023-09-11	129
481	100146518	2023-09-13	2023-09-22 22:29:09.13	St. Joseph's Indian School	Education	-33.0000	3	Checkcard 0912 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4232xxxxxxxxxx0114	-1	Checkcard 0912 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4232xxxxxxxxxx0114	1	2023-09-13	334
482	100146503	2023-09-15	2023-09-22 22:29:09.13	Car Max	Loans	-532.9800	\N	Car Max	0	Car Max	1	2023-09-15	50
483	100146478	2023-09-18	2023-09-22 22:29:09.13	Venmo	Transfers	-80.0000	\N	Venmo	0	Venmo	1	2023-09-18	373
484	100146489	2023-09-18	2023-09-22 22:29:09.13	Amazon	General Merchandise	-14.8600	\N	Amazon	0	Amazon	1	2023-09-18	15
485	100146604	2023-09-18	2023-09-22 22:45:59.547	Sam's Club	General Merchandise	-61.2900	\N	Sam's Club	0	Sam's Club	2	2023-09-18	315
486	100146473	2023-09-19	2023-09-22 22:29:09.13	Shell	Gasoline/Fuel	-15.0000	\N	Shell	0	Shell	1	2023-09-19	321
487	100146456	2023-09-21	2023-09-22 22:29:09.13	Publix	Groceries	-191.5100	\N	Publix	0	Publix	1	2023-09-21	268
488	100146728	2023-09-25	2023-10-11 15:40:39.563	Microsoft	Online Services	-18.6500	\N	Microsoft	0	Microsoft	1	2023-09-25	220
489	100146739	2023-09-25	2023-10-11 15:40:39.563	Barnes & Noble	Hobbies	-0.8200	\N	Barnes & Noble	0	Barnes & Noble	1	2023-09-25	35
490	100146716	2023-09-26	2023-10-11 15:40:39.563	Cook's Pest Control	Home Maintenance	-99.0000	\N	Cook's Pest Control	0	Cook's Pest Control	1	2023-09-26	109
491	100146707	2023-09-27	2023-10-11 15:40:39.563	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-09-27	336
492	100146703	2023-09-28	2023-10-11 15:40:39.563	Walgreens	Healthcare/Medical	-5.8500	\N	Walgreens	0	Walgreens	1	2023-09-28	377
493	100146665	2023-10-02	2023-10-11 15:40:39.563	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-10-02	336
494	100146676	2023-10-02	2023-10-11 15:40:39.563	Sam's Club	General Merchandise	-75.0500	\N	Sam's Club	0	Sam's Club	1	2023-10-02	315
495	100146688	2023-10-02	2023-10-11 15:40:39.563	Sam's Club	General Merchandise	-27.9600	\N	Sam's Club	0	Sam's Club	1	2023-10-02	315
496	100146663	2023-10-03	2023-10-11 15:40:39.563	Act Too Players	Split	-190.0000	-1	Act Too Players	0	Act Too Players	1	2023-10-03	8
497	100146647	2023-10-05	2023-10-11 15:40:39.563	Mapco Express	Gasoline/Fuel	-66.6600	\N	Mapco Express	0	Mapco Express	1	2023-10-05	211
498	100146617	2023-10-10	2023-10-11 15:40:39.563	Publix	Groceries	-252.4500	\N	Publix	0	Publix	1	2023-10-10	268
499	100146629	2023-10-10	2023-10-11 15:40:39.563	Office Depot	Office Supplies	-15.5700	\N	Office Depot	0	Office Depot	1	2023-10-10	244
500	100146822	2023-10-11	2023-10-20 20:41:28.477	Metropolis Parking	Travel	-42.8000	\N	Purchase 1011 Metropolis Parking Httpswww.metrtn Xxxxx1632xxxxxxxxxx2777	0	Purchase 1011 Metropolis Parking Httpswww.metrtn Xxxxx1632xxxxxxxxxx2777	1	2023-10-11	219
501	100146810	2023-10-13	2023-10-20 20:41:28.477	Amazon Web Services	Online Services	-82.4200	9	Amazon Web Services	0	Amazon Web Services	1	2023-10-13	21
502	100146789	2023-10-16	2023-10-20 20:41:28.477	Paypal	Transfers	-9.9900	115	Paypal	0	Paypal	1	2023-10-16	256
503	100146800	2023-10-16	2023-10-20 20:41:28.477	Reed's Produce	Groceries	-45.5800	\N	Reed's Produce 10/14 #xxxxx2507 Purchase Reed's Produce Franklin Tn	0	Reed's Produce 10/14 #xxxxx2507 Purchase Reed's Produce Franklin Tn	1	2023-10-16	309
504	100146782	2023-10-17	2023-10-20 20:41:28.477	Williamson County	Paychecks/Salary	-66.5000	32	Williamson County	0	Williamson County	1	2023-10-17	386
505	100146774	2023-10-18	2023-10-20 20:41:28.477	Target	General Merchandise	-67.4400	\N	Target	0	Target	1	2023-10-18	349
506	100146826	2023-10-19	2023-10-27 16:48:26.373	Purchase Interest Charge	Service Charges/Fees	-502.1800	\N	Purchase Interest Charge	0	Purchase Interest Charge	2	2023-10-19	303
507	100146854	2023-10-23	2023-11-04 18:34:12.427	The Home Depot	Home Improvement	-71.1800	\N	The Home Depot	0	The Home Depot	1	2023-10-23	354
508	100146922	2023-10-23	2023-11-04 18:34:12.427	Paypal	Transfers	-8.1800	115	Paypal	0	Paypal	1	2023-10-23	256
509	100146980	2023-10-23	2023-11-04 18:34:12.427	Hop House	Restaurants	-54.0000	\N	Checkcard 1021 Sq *hop House Tennessee Franklin Tn Xxxxx1632xxxxxxxxxx2560	0	Checkcard 1021 Sq *hop House Tennessee Franklin Tn Xxxxx1632xxxxxxxxxx2560	1	2023-10-23	172
510	100146995	2023-10-24	2023-11-04 18:34:12.427	Apple	Electronics	-12.0300	\N	Apple	0	Apple	1	2023-10-24	26
511	100146840	2023-10-27	2023-11-04 18:34:12.427	Walgreens	Healthcare/Medical	-18.9400	\N	Walgreens	0	Walgreens	1	2023-10-27	377
512	100146994	2023-10-27	2023-11-04 18:34:12.427	Apple	Electronics	-2.9900	\N	Apple	0	Apple	1	2023-10-27	26
513	100146897	2023-10-30	2023-11-04 18:34:12.427	Publix	Groceries	-30.3900	\N	Publix	0	Publix	1	2023-10-30	268
514	100147002	2023-10-30	2023-11-04 18:34:12.427	Amazon	General Merchandise	-12.7300	\N	Amazon	0	Amazon	1	2023-10-30	15
515	100146915	2023-11-01	2023-11-04 18:34:12.427	Pilot Flying J	Gasoline/Fuel	-8.5600	\N	Pilot Flying J	0	Pilot Flying J	1	2023-11-01	263
516	100146896	2023-11-02	2023-11-04 18:34:12.427	Publix	Groceries	-2.6900	\N	Publix	0	Publix	1	2023-11-02	268
517	100146881	2023-11-03	2023-11-04 18:34:12.427	Shell	Gasoline/Fuel	-65.6500	\N	Shell	0	Shell	1	2023-11-03	321
518	100147009	2023-11-03	2023-11-04 18:34:12.427	Act Too Players	Split	-190.0000	-1	Act Too Players	0	Act Too Players	1	2023-11-03	8
519	100147206	2023-11-06	2023-12-01 23:19:04.363	Checkcard Xxxx 4017 Jnn Germantown Cordova Tn Xxxxx3933xxxxxxxxxx3803	Other Expenses	-13.8500	\N	Checkcard Xxxx 4017 Jnn Germantown Cordova Tn Xxxxx3933xxxxxxxxxx3803	0	Checkcard Xxxx 4017 Jnn Germantown Cordova Tn Xxxxx3933xxxxxxxxxx3803	1	2023-11-06	94
520	100147190	2023-11-07	2023-12-01 23:19:04.363	Williamson County	Paychecks/Salary	-44.5000	32	Williamson County	0	Williamson County	1	2023-11-07	386
521	100147183	2023-11-08	2023-12-01 23:19:04.363	Credit Card Payment	Credit Card Payments	-2500.0000	57	Jpmorgan	-1	Jpmorgan	1	2023-11-08	113
522	100147179	2023-11-09	2023-12-01 23:19:04.363	Publix	Groceries	-9.9000	\N	Publix	0	Publix	1	2023-11-09	268
523	100147240	2023-11-10	2023-12-01 23:33:50.453	Interest Paid	Interest	74.9700	104	Interest Paid	0	Interest Paid	3	2023-11-10	180
524	100147151	2023-11-13	2023-12-01 23:19:04.363	Parkmobile	Travel	-2.4500	\N	Parkmobile	0	Parkmobile	1	2023-11-13	251
525	100147162	2023-11-13	2023-12-01 23:19:04.363	Wasabi Restaurant	Restaurants	-10.5800	\N	Wasabi Restaurant	0	Wasabi Restaurant	1	2023-11-13	381
526	100147140	2023-11-14	2023-12-01 23:19:04.363	Google Cloud Storage	Online Services	-2.1800	\N	Google Cloud Storage	0	Google Cloud Storage	1	2023-11-14	158
527	100147127	2023-11-15	2023-12-01 23:19:04.363	Purchase 1114 Sp Lewisblack.com Httpslewisblaca Xxxxx1633xxxxxxxxxx8465	Travel	-238.0000	\N	Purchase 1114 Sp Lewisblack.com Httpslewisblaca Xxxxx1633xxxxxxxxxx8465	0	Purchase 1114 Sp Lewisblack.com Httpslewisblaca Xxxxx1633xxxxxxxxxx8465	1	2023-11-15	299
528	100147229	2023-11-16	2023-12-01 23:24:12.943	Credit Card Payment	Transfers	2000.0000	57	Automatic Payment - Thank	-1	Automatic Payment - Thank	2	2023-11-16	113
529	100147228	2023-11-19	2023-12-01 23:24:12.943	Audible	Hobbies	-16.3700	21	Audible	0	Audible	2	2023-11-19	31
530	100147097	2023-11-20	2023-12-01 23:19:04.363	Whole Foods Market	Groceries	-91.5000	\N	Whole Foods Market	0	Whole Foods Market	1	2023-11-20	384
531	100147086	2023-11-21	2023-12-01 23:19:04.363	Krispy Kreme	Restaurants	-13.0400	\N	Krispy Kreme	0	Krispy Kreme	1	2023-11-21	194
532	100147066	2023-11-24	2023-12-01 23:19:04.363	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2023-11-24	336
533	100147222	2023-11-24	2023-12-01 23:24:12.943	Paypal	Transfers	-200.0000	115	Paypal	0	Paypal	2	2023-11-24	256
534	100147046	2023-11-27	2023-12-01 23:19:04.363	Car Max	Loans	-674.8200	\N	Car Max	0	Car Max	1	2023-11-27	50
535	100147057	2023-11-27	2023-12-01 23:19:04.363	Trader Joe's	Groceries	-12.7700	\N	Trader Joe's	0	Trader Joe's	1	2023-11-27	367
536	100147028	2023-11-29	2023-12-01 23:19:04.363	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2023-11-29	336
537	100147022	2023-11-30	2023-12-01 23:19:04.363	Focus	Online Services	-75.0000	\N	Focusxxxxxx7373 Des:payments Id:afb0de1f Indn:jake Woods Co Id:xxxxxx2248 Ppd	0	Focusxxxxxx7373 Des:payments Id:afb0de1f Indn:jake Woods Co Id:xxxxxx2248 Ppd	1	2023-11-30	143
538	100147311	2023-12-01	2023-12-10 20:21:19.28	Amazon	General Merchandise	-11.3900	\N	Amazon	0	Amazon	1	2023-12-01	15
539	100147290	2023-12-04	2023-12-10 20:21:19.28	Landmark	Hobbies	-24.1300	\N	Landmark	0	Landmark	1	2023-12-04	197
540	100147302	2023-12-04	2023-12-10 20:21:19.28	Circle K	Groceries	-61.2600	\N	Circle K	0	Circle K	1	2023-12-04	101
541	100147274	2023-12-05	2023-12-10 20:21:19.28	St. Joseph's Indian School	Education	-150.0000	3	Checkcard 1204 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4233xxxxxxxxxx3823	-1	Checkcard 1204 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4233xxxxxxxxxx3823	1	2023-12-05	334
542	100147265	2023-12-06	2023-12-10 20:21:19.28	Venmo	Transfers	-25.0000	\N	Venmo	0	Venmo	1	2023-12-06	373
543	100147255	2023-12-07	2023-12-10 20:21:19.28	Office Depot	Office Supplies	-60.3500	\N	Office Depot	0	Office Depot	1	2023-12-07	244
591	100147986	2024-02-21	2024-03-17 22:56:54.213	Sam's Club	General Merchandise	-86.6300	\N	Sam's Club	0	Sam's Club	1	2024-02-21	315
544	100147248	2023-12-08	2023-12-10 20:21:19.28	Checkcard 1207 Duke Mailorder Web Xxx-xxx3764 Nc Xxxxx4233xxxxxxxxxx5349	Online Services	-46.9500	\N	Checkcard 1207 Duke Mailorder Web Xxx-xxx3764 Nc Xxxxx4233xxxxxxxxxx5349	0	Checkcard 1207 Duke Mailorder Web Xxx-xxx3764 Nc Xxxxx4233xxxxxxxxxx5349	1	2023-12-08	92
545	100147361	2023-12-11	2023-12-16 19:04:49.663	Publix	Groceries	-155.5700	\N	Publix	0	Publix	1	2023-12-11	268
546	100147372	2023-12-11	2023-12-16 19:04:49.663	Sam's Club	General Merchandise	-95.8300	\N	Sam's Club	0	Sam's Club	1	2023-12-11	315
547	100147328	2023-12-13	2023-12-16 19:04:49.663	New York Times	Dues & Subscriptions	-28.0000	\N	New York Times	0	New York Times	1	2023-12-13	238
548	100147339	2023-12-13	2023-12-16 19:04:49.663	St. Joseph's Indian School	Education	-33.0000	3	Checkcard 1212 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4233xxxxxxxxxx5855	-1	Checkcard 1212 St Josephs Indian Schoo Xxx-xxx2162 Sd Xxxxx4233xxxxxxxxxx5855	1	2023-12-13	334
549	100147323	2023-12-15	2023-12-16 19:04:49.663	AT&T	Telephone	-285.5100	\N	At&t	0	At&t	1	2023-12-15	5
550	100147448	2023-12-18	2023-12-30 03:03:20.42	Cns The Childr 12/18 #xxxxx5097 Purchase 1800 Galleria Blv Franklin Tn	Child/Dependent	-7.0000	\N	Cns The Childr 12/18 #xxxxx5097 Purchase 1800 Galleria Blv Franklin Tn	0	Cns The Childr 12/18 #xxxxx5097 Purchase 1800 Galleria Blv Franklin Tn	1	2023-12-18	104
551	100147460	2023-12-18	2023-12-30 03:03:20.42	The Ups Store	Postage & Shipping	-36.3600	\N	The Ups Store	0	The Ups Store	1	2023-12-18	358
552	100147471	2023-12-18	2023-12-30 03:03:20.42	Amazon	General Merchandise	-41.2400	\N	Amazon	0	Amazon	1	2023-12-18	15
553	100147435	2023-12-19	2023-12-30 03:03:20.42	Publix	Groceries	-20.4900	\N	Publix	0	Publix	1	2023-12-19	268
554	100147421	2023-12-21	2023-12-30 03:03:20.42	Target	General Merchandise	-135.2800	\N	Target	0	Target	1	2023-12-21	349
555	100147417	2023-12-22	2023-12-30 03:03:20.42	Publix	Groceries	-151.4400	\N	Publix	0	Publix	1	2023-12-22	268
556	100147403	2023-12-26	2023-12-30 03:03:20.42	Publix	Groceries	-5.5100	\N	Publix	0	Publix	1	2023-12-26	268
557	100147383	2023-12-27	2023-12-30 03:03:20.42	CarMax	Loans	-674.8200	108	Car Max	0	Car Max	1	2023-12-27	51
558	100147634	2023-12-28	2024-01-22 02:59:59.117	Walgreens	Healthcare/Medical	-12.7300	\N	Walgreens	0	Walgreens	2	2023-12-28	377
559	100147631	2024-01-01	2024-01-22 02:59:59.117	Annual Membership Fee	Dues & Subscriptions	-149.0000	90	Annual Membership Fee	-1	Annual Membership Fee	2	2024-01-01	25
560	100147598	2024-01-02	2024-01-22 02:51:21.343	Valon Mortgage	Mortgages	-3288.5100	24	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	0	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	1	2024-01-02	370
561	100147610	2024-01-02	2024-01-22 02:51:21.343	Instacart	Groceries	-58.4600	\N	Instacart	0	Instacart	1	2024-01-02	179
562	100147579	2024-01-03	2024-01-22 02:51:21.343	Amazon	General Merchandise	-7.6700	\N	Amazon	0	Amazon	1	2024-01-03	15
563	100147568	2024-01-04	2024-01-22 02:51:21.343	Franklin Dermatology Group	Healthcare/Medical	-75.0000	\N	Checkcard 0103 Franklin Dermatology G Xxx-xxx1881 Tn Xxxxx1640xxxxxxxxxx0439	0	Checkcard 0103 Franklin Dermatology G Xxx-xxx1881 Tn Xxxxx1640xxxxxxxxxx0439	1	2024-01-04	150
564	100147547	2024-01-08	2024-01-22 02:51:21.343	Paypal	Transfers	-10.0000	115	Paypal	0	Paypal	1	2024-01-08	256
565	100147559	2024-01-08	2024-01-22 02:51:21.343	Yeti	General Merchandise	-49.3900	\N	Yeti	0	Yeti	1	2024-01-08	394
566	100147540	2024-01-10	2024-01-22 02:51:21.343	Tile Inc	Online Services	-2.9900	\N	Tile Inc	0	Tile Inc	1	2024-01-10	361
567	100147490	2024-01-16	2024-01-22 02:51:21.343	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-01-16	336
568	100147501	2024-01-16	2024-01-22 02:51:21.343	Wolfgang Puck	Restaurants	-53.7600	\N	Wolfgang Puck	0	Wolfgang Puck	1	2024-01-16	390
569	100147512	2024-01-16	2024-01-22 02:51:21.343	Starbucks	Restaurants	-13.9900	\N	Starbucks	0	Starbucks	1	2024-01-16	336
570	100147524	2024-01-16	2024-01-22 02:51:21.343	Puckett's	Restaurants	-5.4600	\N	Checkcard 0112 Puckett`s Cc-d Nashville Tn Xxxxx8440xxxxxxxxxx8110	0	Checkcard 0112 Puckett`s Cc-d Nashville Tn Xxxxx8440xxxxxxxxxx8110	1	2024-01-16	269
571	100147478	2024-01-18	2024-01-22 02:51:21.343	Paypal	Transfers	-40.0000	115	Paypal	0	Paypal	1	2024-01-18	256
572	100147666	2024-01-19	2024-01-28 01:22:21.353	Association for Computing Machinery	Online Services	-268.0000	89	Association For Computing	-1	Association For Computing	2	2024-01-19	28
573	100147648	2024-01-23	2024-01-27 00:33:06.493	Microsoft	Online Services	-18.6500	\N	Microsoft	0	Microsoft	1	2024-01-23	220
574	100147647	2024-01-24	2024-01-27 00:33:06.493	Apple	Electronics	-12.0300	\N	Apple	0	Apple	1	2024-01-24	26
575	100147675	2024-01-26	2024-01-28 02:14:13.193	Publix	Groceries	-47.2500	\N	Publix	0	Publix	1	2024-01-26	268
576	100147771	2024-01-29	2024-02-10 17:51:50.213	Car Max	Loans	-674.8200	\N	Car Max	0	Car Max	1	2024-01-29	50
577	100147782	2024-01-29	2024-02-10 17:51:50.213	Publix	Groceries	-12.5000	\N	Publix	0	Publix	1	2024-01-29	268
578	100147763	2024-01-30	2024-02-10 17:51:50.213	Amazon	General Merchandise	-18.5200	\N	Amazon	0	Amazon	1	2024-01-30	15
579	100147742	2024-02-01	2024-02-10 17:51:50.213	Keurig	Transfers	-91.2200	\N	Keurig	0	Keurig	1	2024-02-01	188
580	100147740	2024-02-02	2024-02-10 17:51:50.213	Relay for Reddit	Online Services	-2.1800	\N	Checkcard 0201 Google *relayforreddit G.co/helppay#ca Xxxxx1640xxxxxxxxxx1951 Recurring	0	Checkcard 0201 Google *relayforreddit G.co/helppay#ca Xxxxx1640xxxxxxxxxx1951 Recurring	1	2024-02-02	310
581	100147723	2024-02-05	2024-02-10 17:51:50.213	Trader Joe's	Groceries	-45.3600	\N	Trader Joe's	0	Trader Joe's	1	2024-02-05	367
582	100147734	2024-02-05	2024-02-10 17:51:50.213	Hunters Bend Elementary	Online Services	-35.7500	\N	Checkcard 0202 Williamson County Board Xxx-xxx4000 Tn Xxxxx7540xxxxxxxxxx8818	0	Checkcard 0202 Williamson County Board Xxx-xxx4000 Tn Xxxxx7540xxxxxxxxxx8818	1	2024-02-05	173
583	100147694	2024-02-07	2024-02-10 17:51:50.213	Spotify	Entertainment	-18.6000	\N	Spotify	0	Spotify	1	2024-02-07	330
584	100147691	2024-02-08	2024-02-10 17:51:50.213	Subway	Restaurants	-11.0400	\N	Subway	0	Subway	1	2024-02-08	339
585	100148040	2024-02-12	2024-03-17 22:56:54.213	Knights Of Columbus Insurance	Charitable Giving	-366.0000	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2024-02-12	191
586	100148052	2024-02-12	2024-03-17 22:56:54.213	Sam's Club	General Merchandise	-31.5400	\N	Sam's Club	0	Sam's Club	1	2024-02-12	315
587	100148030	2024-02-14	2024-03-17 22:56:54.213	Paypal Des:inst Xfer Id:ticketmaste Tic Indn:jake Woods Co Id:paypalsi77 Web	Transfers	-578.7100	\N	Paypal Des:inst Xfer Id:ticketmaste Tic Indn:jake Woods Co Id:paypalsi77 Web	0	Paypal Des:inst Xfer Id:ticketmaste Tic Indn:jake Woods Co Id:paypalsi77 Web	1	2024-02-14	261
588	100148018	2024-02-16	2024-03-17 22:56:54.213	Publix	Groceries	-109.2500	\N	Publix	0	Publix	1	2024-02-16	268
589	100147998	2024-02-20	2024-03-17 22:56:54.213	Comcast	Cable/Satellite	-282.0100	\N	Comcast	0	Comcast	1	2024-02-20	108
590	100148010	2024-02-20	2024-03-17 22:56:54.213	Purchase 0218 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1640xxxxxxxxxx7421 Recurring	Online Services	-5.0000	\N	Purchase 0218 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1640xxxxxxxxxx7421 Recurring	0	Purchase 0218 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1640xxxxxxxxxx7421 Recurring	1	2024-02-20	273
593	100147960	2024-02-26	2024-03-17 22:56:54.213	Publix	Groceries	-143.5100	\N	Publix	0	Publix	1	2024-02-26	268
594	100147971	2024-02-26	2024-03-17 22:56:54.213	Pods	Rent	-239.3800	\N	Pods	0	Pods	1	2024-02-26	265
595	100147939	2024-02-28	2024-03-17 22:56:54.213	Paypal	Transfers	-383.0300	115	Paypal	0	Paypal	1	2024-02-28	256
596	100147924	2024-03-01	2024-03-17 22:56:54.213	Protective Life	Insurance	-23.8000	35	Protective Life	0	Protective Life	1	2024-03-01	267
597	100147891	2024-03-04	2024-03-17 22:56:54.213	Venmo	Transfers	-24.0000	\N	Venmo	0	Venmo	1	2024-03-04	373
598	100147902	2024-03-04	2024-03-17 22:56:54.213	Amazon	General Merchandise	-8.8600	\N	Amazon	0	Amazon	1	2024-03-04	15
599	100147914	2024-03-04	2024-03-17 22:56:54.213	Purchase 0303 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1640xxxxxxxxxx9504 Recurring	Clothing/Shoes	-5.0000	\N	Purchase 0303 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1640xxxxxxxxxx9504 Recurring	0	Purchase 0303 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1640xxxxxxxxxx9504 Recurring	1	2024-03-04	275
600	100147884	2024-03-05	2024-03-17 22:56:54.213	Williamson County	Paychecks/Salary	-66.5000	32	Williamson County	0	Williamson County	1	2024-03-05	386
601	100147878	2024-03-06	2024-03-17 22:56:54.213	Target	General Merchandise	-15.9800	\N	Target	0	Target	1	2024-03-06	349
602	100147868	2024-03-08	2024-03-17 22:56:54.213	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5018.0900	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2024-03-08	10
603	100147856	2024-03-11	2024-03-17 22:56:54.213	The Home Depot	Home Improvement	-30.0900	\N	The Home Depot	0	The Home Depot	1	2024-03-11	354
604	100147845	2024-03-12	2024-03-17 22:56:54.213	Publix	Groceries	-105.0000	\N	Publix	0	Publix	1	2024-03-12	268
605	100147828	2024-03-14	2024-03-17 22:56:54.213	Cook's Pest Nash Des:cooks Pest Id: Indn:nicole Woods Co Id:xxxxxx1064 Ppd	Home Maintenance	-99.0000	1137	Cook's Pest Nash Des:cooks Pest Id: Indn:nicole Woods Co Id:xxxxxx1064 Ppd	0	Cook's Pest Nash Des:cooks Pest Id: Indn:nicole Woods Co Id:xxxxxx1064 Ppd	1	2024-03-14	110
606	100147814	2024-03-15	2024-03-17 22:56:54.213	Car Max	Loans	-532.9800	\N	Car Max	0	Car Max	1	2024-03-15	50
607	100148151	2024-03-18	2024-03-24 20:05:39.72	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-03-18	336
608	100148163	2024-03-18	2024-03-24 20:05:39.72	Purchase 0318 Focus Xxxxxx5750 Httpswww.focuco Xxxxx3440xxxxxxxxxx4912 Recurring	Online Services	-5.0000	\N	Purchase 0318 Focus Xxxxxx5750 Httpswww.focuco Xxxxx3440xxxxxxxxxx4912 Recurring	0	Purchase 0318 Focus Xxxxxx5750 Httpswww.focuco Xxxxx3440xxxxxxxxxx4912 Recurring	1	2024-03-18	278
609	100148174	2024-03-18	2024-03-24 20:05:39.72	Dillard's	General Merchandise	-453.8200	\N	Dillard's	0	Dillard's	1	2024-03-18	121
610	100148185	2024-03-18	2024-03-24 20:05:39.72	Savory Spice	Healthcare/Medical	-39.4500	\N	Savory Spice	0	Savory Spice	1	2024-03-18	317
611	100148142	2024-03-20	2024-03-24 20:05:39.72	Quality Tree Surgery	Home Maintenance	-850.0000	\N	Quality Tree Surgery	0	Quality Tree Surgery	1	2024-03-20	304
612	100148137	2024-03-21	2024-03-24 20:05:39.72	Us Department Of Education	Loans	-120.9800	2	Us Department Of Education	0	Us Department Of Education	1	2024-03-21	369
613	100148277	2024-03-25	2024-04-08 22:39:10.343	Venmo	Transfers	-6.0000	\N	Venmo	0	Venmo	1	2024-03-25	373
614	100148288	2024-03-25	2024-04-08 22:39:10.343	Sweet Haven	Restaurants	-6.8600	\N	Sweet Haven	0	Sweet Haven	1	2024-03-25	342
615	100148275	2024-03-26	2024-04-08 22:39:10.343	Publix	Groceries	-68.2900	\N	Publix	0	Publix	1	2024-03-26	268
616	100148257	2024-03-29	2024-04-08 22:39:10.343	Paypal	Transfers	-49.0000	115	Paypal	0	Paypal	1	2024-03-29	256
617	100148245	2024-04-01	2024-04-08 22:39:10.343	State Farm	Insurance	-186.6500	\N	State Farm	0	State Farm	1	2024-04-01	337
618	100148256	2024-04-01	2024-04-08 22:39:10.343	Checkcard 0329 Gloss* Trimmed & Tail. Httpskaylavautn Xxxxx4540xxxxxxxxxx7226 Recurring	Personal Care	-86.1000	\N	Checkcard 0329 Gloss* Trimmed & Tail. Httpskaylavautn Xxxxx4540xxxxxxxxxx7226 Recurring	0	Checkcard 0329 Gloss* Trimmed & Tail. Httpskaylavautn Xxxxx4540xxxxxxxxxx7226 Recurring	1	2024-04-01	62
619	100148232	2024-04-02	2024-04-08 22:39:10.343	Amazon	General Merchandise	-39.5400	\N	Amazon	0	Amazon	1	2024-04-02	15
620	100148219	2024-04-03	2024-04-08 22:39:10.343	Purchase 0402 Cb* Hunters Bend Eleme Chooseboosterga Xxxxx7740xxxxxxxxxx6160 Recurring	Other Expenses	-214.9400	\N	Purchase 0402 Cb* Hunters Bend Eleme Chooseboosterga Xxxxx7740xxxxxxxxxx6160 Recurring	0	Purchase 0402 Cb* Hunters Bend Eleme Chooseboosterga Xxxxx7740xxxxxxxxxx6160 Recurring	1	2024-04-03	280
621	100148321	2024-04-04	2024-04-14 02:33:23.2	Zelle	Transfers	975.0000	\N	Zelle	0	Zelle	3	2024-04-04	395
622	100148775	2024-04-08	2024-06-02 14:49:03.613	Crmlawn.com Des:crmlawn.co Id:st-h2i8t7a8n4z6 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	Home Maintenance	-42.0000	\N	Crmlawn.com Des:crmlawn.co Id:st-h2i8t7a8n4z6 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	0	Crmlawn.com Des:crmlawn.co Id:st-h2i8t7a8n4z6 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	1	2024-04-08	114
623	100148786	2024-04-08	2024-06-02 14:49:03.613	Checkcard 0406 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3940xxxxxxxxxx6770	Groceries	-43.2500	\N	Checkcard 0406 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3940xxxxxxxxxx6770	0	Checkcard 0406 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3940xxxxxxxxxx6770	1	2024-04-08	63
667	100148936	2024-06-04	2024-06-15 15:53:08.84	Navient Corporation	Loans	-55.7600	\N	Navient Corporation	0	Navient Corporation	1	2024-06-04	236
624	100148756	2024-04-10	2024-06-02 14:49:03.613	First Fidelity 04/10 #xxxxx4695 Withdrwl 7401 E Camelback Scottsdale Az Fee	ATM/Cash	-2.5000	\N	First Fidelity 04/10 #xxxxx4695 Withdrwl 7401 E Camelback Scottsdale Az Fee	0	First Fidelity 04/10 #xxxxx4695 Withdrwl 7401 E Camelback Scottsdale Az Fee	1	2024-04-10	142
625	100148751	2024-04-11	2024-06-02 14:49:03.613	Checkcard 0410 Sirvezas At Skyharbor Xxx-xxx8226 Az Xxxxx4541xxxxxxxxxx1171	Travel	-17.6600	\N	Checkcard 0410 Sirvezas At Skyharbor Xxx-xxx8226 Az Xxxxx4541xxxxxxxxxx1171	0	Checkcard 0410 Sirvezas At Skyharbor Xxx-xxx8226 Az Xxxxx4541xxxxxxxxxx1171	1	2024-04-11	64
626	100148715	2024-04-15	2024-06-02 14:49:03.613	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-04-15	336
627	100148726	2024-04-15	2024-06-02 14:49:03.613	Checkcard 0414 Sq *hop House Tennessee Franklin Tn Xxxxx1641xxxxxxxxxx4368	Restaurants	-54.1900	\N	Checkcard 0414 Sq *hop House Tennessee Franklin Tn Xxxxx1641xxxxxxxxxx4368	0	Checkcard 0414 Sq *hop House Tennessee Franklin Tn Xxxxx1641xxxxxxxxxx4368	1	2024-04-15	65
628	100148737	2024-04-15	2024-06-02 14:49:03.613	Chick-fil-a	Restaurants	-32.8900	\N	Chick-fil-a	0	Chick-fil-a	1	2024-04-15	99
629	100148709	2024-04-16	2024-06-02 14:49:03.613	Cook's Pest Control	Home Maintenance	-80.4000	20	Cook's Pest Control	0	Cook's Pest Control	1	2024-04-16	109
630	100148704	2024-04-17	2024-06-02 14:49:03.613	Publix	Groceries	-10.8800	\N	Publix	0	Publix	1	2024-04-17	268
631	100148686	2024-04-19	2024-06-02 14:49:03.613	Macy's	Credit Card Payments	-84.4700	\N	Macy's	0	Macy's	1	2024-04-19	209
632	100148664	2024-04-22	2024-06-02 14:49:03.613	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2024-04-22	336
633	100148676	2024-04-22	2024-06-02 14:49:03.613	The Berry Bar	Restaurants	-41.2800	\N	The Berry Bar	0	The Berry Bar	1	2024-04-22	350
634	100148656	2024-04-23	2024-06-02 14:49:03.613	Williamson County	Paychecks/Salary	-66.5000	32	Williamson County	0	Williamson County	1	2024-04-23	386
635	100148652	2024-04-24	2024-06-02 14:49:03.613	Checkcard 0422 Moab Bicycle Shop-frank Franklin Tn Xxxxx5941xxxxxxxxxx2165	Automotive	-21.9500	\N	Checkcard 0422 Moab Bicycle Shop-frank Franklin Tn Xxxxx5941xxxxxxxxxx2165	0	Checkcard 0422 Moab Bicycle Shop-frank Franklin Tn Xxxxx5941xxxxxxxxxx2165	1	2024-04-24	66
636	100148857	2024-04-27	2024-06-02 14:56:54.937	Payment Thank You-mobile	Transfers	900.0000	\N	Payment Thank You-mobile	0	Payment Thank You-mobile	2	2024-04-27	255
637	100148625	2024-04-29	2024-06-02 14:49:03.613	Publix	Groceries	-191.9200	\N	Publix	0	Publix	1	2024-04-29	268
638	100148610	2024-04-30	2024-06-02 14:49:03.613	Williamson County	Paychecks/Salary	-66.5000	32	Williamson County	0	Williamson County	1	2024-04-30	386
639	100148602	2024-05-01	2024-06-02 14:49:03.613	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	Mortgages	-3288.5100	\N	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	0	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	1	2024-05-01	371
640	100148594	2024-05-02	2024-06-02 14:49:03.613	Walgreens	Healthcare/Medical	-16.4400	\N	Walgreens	0	Walgreens	1	2024-05-02	377
641	100148581	2024-05-03	2024-06-02 14:49:03.613	Amazon	General Merchandise	-39.9100	\N	Amazon	0	Amazon	1	2024-05-03	15
642	100148534	2024-05-06	2024-06-02 14:49:03.613	Paypal	Transfers	-10.0000	115	Paypal	0	Paypal	1	2024-05-06	256
643	100148545	2024-05-06	2024-06-02 14:49:03.613	Target	General Merchandise	-3.3500	\N	Target	0	Target	1	2024-05-06	349
644	100148556	2024-05-06	2024-06-02 14:49:03.613	Sam's Club	General Merchandise	-80.8600	\N	Sam's Club	0	Sam's Club	1	2024-05-06	315
645	100148568	2024-05-06	2024-06-02 14:49:03.613	Amazon Marketplace	General Merchandise	-33.7600	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-05-06	18
646	100148527	2024-05-07	2024-06-02 14:49:03.613	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6018 Indn:150 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	Savings	-250.0000	\N	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6018 Indn:150 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	0	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6018 Indn:150 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	1	2024-05-07	365
647	100148513	2024-05-09	2024-06-02 14:49:03.613	Amazon Prime Video	Entertainment	-9.8400	\N	Amazon Prime Video	0	Amazon Prime Video	1	2024-05-09	20
648	100148478	2024-05-13	2024-06-02 14:49:03.613	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-05-13	336
649	100148490	2024-05-13	2024-06-02 14:49:03.613	Parnassus Books	Hobbies	-54.6200	\N	Parnassus Books	0	Parnassus Books	1	2024-05-13	252
650	100148501	2024-05-13	2024-06-02 14:49:03.613	Subway	Restaurants	-7.5900	\N	Subway	0	Subway	1	2024-05-13	339
651	100148472	2024-05-14	2024-06-02 14:49:03.613	St Joseph's Indian School	Education	-33.0000	1143	St Joseph's Indian School	0	St Joseph's Indian School	1	2024-05-14	333
652	100148461	2024-05-15	2024-06-02 14:49:03.613	Purchase 0514 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx3067 Recurring	Online Services	-8.0000	\N	Purchase 0514 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx3067 Recurring	0	Purchase 0514 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx3067 Recurring	1	2024-05-15	282
653	100148855	2024-05-16	2024-06-02 14:56:54.937	Automatic Payment - Thank	Transfers	2000.0000	\N	Automatic Payment - Thank	0	Automatic Payment - Thank	2	2024-05-16	32
654	100148444	2024-05-17	2024-06-02 14:49:03.613	Bank Of America	Deposits	50.0000	\N	Bank Of America	0	Bank Of America	1	2024-05-17	34
655	100148412	2024-05-20	2024-06-02 14:49:03.613	Greenlight Financial Technology	Online Services	-50.0000	\N	Greenlight Financial Technology	0	Greenlight Financial Technology	1	2024-05-20	164
656	100148424	2024-05-20	2024-06-02 14:49:03.613	Publix	Groceries	-36.7600	\N	Publix	0	Publix	1	2024-05-20	268
657	100148403	2024-05-21	2024-06-02 14:49:03.613	Us Department Of Education	Loans	-120.9800	2	Us Department Of Education	0	Us Department Of Education	1	2024-05-21	369
658	100148388	2024-05-23	2024-06-02 14:49:03.613	Microsoft	Online Services	-18.6500	\N	Microsoft	0	Microsoft	1	2024-05-23	220
659	100148380	2024-05-24	2024-06-02 14:49:03.613	Macadoodles	Groceries	-52.2800	\N	Macadoodles	0	Macadoodles	1	2024-05-24	208
660	100148355	2024-05-28	2024-06-02 14:49:03.613	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2024-05-28	336
661	100148367	2024-05-28	2024-06-02 14:49:03.613	Dollar General	General Merchandise	-4.2600	\N	Dollar General	0	Dollar General	1	2024-05-28	123
662	100148341	2024-05-29	2024-06-02 14:49:03.613	Venmo	Transfers	-245.0000	\N	Venmo	0	Venmo	1	2024-05-29	373
663	100148329	2024-05-30	2024-06-02 14:49:03.613	Focusxxxxxx7373 Des:payments Id:a101a1d8d Indn:jake Woods Co Id:xxxxxx2248 Ppd	Online Services	-75.0000	\N	Focusxxxxxx7373 Des:payments Id:a101a1d8d Indn:jake Woods Co Id:xxxxxx2248 Ppd	0	Focusxxxxxx7373 Des:payments Id:a101a1d8d Indn:jake Woods Co Id:xxxxxx2248 Ppd	1	2024-05-30	144
664	100148323	2024-05-31	2024-06-02 14:49:03.613	State Farm	Insurance	-186.6500	\N	State Farm	0	State Farm	1	2024-05-31	337
665	100148953	2024-06-03	2024-06-15 15:53:08.84	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	Mortgages	-3288.5100	\N	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	0	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	1	2024-06-03	371
666	100148964	2024-06-03	2024-06-15 15:53:08.84	Publix	Groceries	-10.1000	\N	Publix	0	Publix	1	2024-06-03	268
668	100148925	2024-06-05	2024-06-15 15:53:08.84	Nintendo	Entertainment	-17.5900	\N	Nintendo	0	Nintendo	1	2024-06-05	240
669	100148922	2024-06-06	2024-06-15 15:53:08.84	Publix	Groceries	-86.9700	\N	Publix	0	Publix	1	2024-06-06	268
670	100148900	2024-06-10	2024-06-15 15:53:08.84	Knights Of Columbus Insurance	Charitable Giving	-366.0000	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2024-06-10	191
671	100148911	2024-06-10	2024-06-15 15:53:08.84	Chick-fil-a	Restaurants	-25.0000	\N	Chick-fil-a	0	Chick-fil-a	1	2024-06-10	99
672	100148887	2024-06-13	2024-06-15 15:53:08.84	Target	General Merchandise	-5.4800	\N	Target	0	Target	1	2024-06-13	349
673	100148884	2024-06-14	2024-06-15 15:53:08.84	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5249.4500	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2024-06-14	10
674	100149634	2024-06-17	2024-09-02 19:18:06.28	Jpmorgan	Transfers	-2000.0000	\N	Jpmorgan	0	Jpmorgan	1	2024-06-17	184
675	100149645	2024-06-17	2024-09-02 19:18:06.28	Purchase 0614 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx2883 Recurring	Online Services	-8.0000	\N	Purchase 0614 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx2883 Recurring	0	Purchase 0614 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx2883 Recurring	1	2024-06-17	286
676	100149620	2024-06-18	2024-09-02 19:18:06.28	Purchase 0617 Pp*ticketfulfi Nashvill Xxx-xxx-5661 De Xxxxx3841xxxxxxxxxx1876	Entertainment	-340.3100	\N	Purchase 0617 Pp*ticketfulfi Nashvill Xxx-xxx-5661 De Xxxxx3841xxxxxxxxxx1876	0	Purchase 0617 Pp*ticketfulfi Nashvill Xxx-xxx-5661 De Xxxxx3841xxxxxxxxxx1876	1	2024-06-18	287
677	100149607	2024-06-20	2024-09-02 19:18:06.28	Amazon	General Merchandise	-175.5800	\N	Amazon	0	Amazon	1	2024-06-20	15
678	100149722	2024-06-21	2024-09-02 20:05:20.03	Peloton Cycles	Personal Care	-48.1800	\N	Peloton Cycles	0	Peloton Cycles	2	2024-06-21	262
679	100149587	2024-06-24	2024-09-02 19:18:06.28	Apple	Electronics	-12.0300	\N	Apple	0	Apple	1	2024-06-24	26
680	100149571	2024-06-25	2024-09-02 19:18:06.28	Knights Of Columbus Insurance	Charitable Giving	-1231.1200	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2024-06-25	191
681	100149563	2024-06-27	2024-09-02 19:18:06.28	Amazon Digital Services	Entertainment	-5.4600	\N	Amazon Digital Services	0	Amazon Digital Services	1	2024-06-27	16
682	100149558	2024-06-28	2024-09-02 19:18:06.28	Apple	Electronics	-2.9900	\N	Apple	0	Apple	1	2024-06-28	26
683	100149517	2024-07-01	2024-09-02 19:18:06.28	Boyd Mill Estate Des:vendor Pay Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	Online Services	-203.2100	\N	Boyd Mill Estate Des:vendor Pay Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	0	Boyd Mill Estate Des:vendor Pay Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	1	2024-07-01	40
684	100149528	2024-07-01	2024-09-02 19:18:06.28	7-eleven	Groceries	-2.5400	\N	7-eleven	0	7-eleven	1	2024-07-01	1
685	100149539	2024-07-01	2024-09-02 19:18:06.28	Chick-fil-a	Restaurants	-25.0000	\N	Chick-fil-a	0	Chick-fil-a	1	2024-07-01	99
686	100149496	2024-07-02	2024-09-02 19:18:06.28	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-07-02	336
687	100149507	2024-07-02	2024-09-02 19:18:06.28	Buc-ee's	Groceries	-12.8500	\N	Buc-ee's	0	Buc-ee's	1	2024-07-02	45
688	100149476	2024-07-05	2024-09-02 19:18:06.28	Atmos Energy	Utilities	-28.2800	19	Atmos Energy	0	Atmos Energy	1	2024-07-05	30
689	100149487	2024-07-05	2024-09-02 19:18:06.28	Apple	Electronics	-0.9900	\N	Apple	0	Apple	1	2024-07-05	26
690	100149462	2024-07-08	2024-09-02 19:18:06.28	The Ice Cream Store	Restaurants	-25.2800	\N	The Ice Cream Store	0	The Ice Cream Store	1	2024-07-08	355
691	100149473	2024-07-08	2024-09-02 19:18:06.28	Checkcard 0706 Mlnp, Llc Xxx-xxx0440 Ny Xxxxx7941xxxxxxxxxx8751	Other Expenses	-10.0000	\N	Checkcard 0706 Mlnp, Llc Xxx-xxx0440 Ny Xxxxx7941xxxxxxxxxx8751	0	Checkcard 0706 Mlnp, Llc Xxx-xxx0440 Ny Xxxxx7941xxxxxxxxxx8751	1	2024-07-08	72
692	100149445	2024-07-10	2024-09-02 19:18:06.28	Tile Inc	Online Services	-2.9900	\N	Tile Inc	0	Tile Inc	1	2024-07-10	361
693	100149439	2024-07-12	2024-09-02 19:18:06.28	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5249.4400	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2024-07-12	10
694	100149422	2024-07-15	2024-09-02 19:18:06.28	Checkcard 0713 Red Parka Pub Xxx-xxx4344 Nh Xxxxx9741xxxxxxxxxx1382	Restaurants	-241.0000	\N	Checkcard 0713 Red Parka Pub Xxx-xxx4344 Nh Xxxxx9741xxxxxxxxxx1382	0	Checkcard 0713 Red Parka Pub Xxx-xxx4344 Nh Xxxxx9741xxxxxxxxxx1382	1	2024-07-15	73
695	100149406	2024-07-17	2024-09-02 19:18:06.28	Nash Public Radi Des:donations Id:xx-xxxxxxxx-011 Indn:woods Jake Co Id:xxxxxx1652 Ppd	Charitable Giving	-20.0000	\N	Nash Public Radi Des:donations Id:xx-xxxxxxxx-011 Indn:woods Jake Co Id:xxxxxx1652 Ppd	0	Nash Public Radi Des:donations Id:xx-xxxxxxxx-011 Indn:woods Jake Co Id:xxxxxx1652 Ppd	1	2024-07-17	232
696	100149404	2024-07-18	2024-09-02 19:18:06.28	Purchase 0718 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx9636 Recurring	Online Services	-5.0000	\N	Purchase 0718 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx9636 Recurring	0	Purchase 0718 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx9636 Recurring	1	2024-07-18	291
697	100149315	2024-07-22	2024-09-02 19:18:06.28	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966 International Transaction Fee	Service Charges/Fees	-0.1100	\N	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966 International Transaction Fee	0	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966 International Transaction Fee	1	2024-07-22	75
698	100149326	2024-07-22	2024-09-02 19:18:06.28	Checkcard Xxxx Xxxx 4693 Quebec Inc Montreal Qc Xxxxx7142xxxxxxxxxx4926 International Transaction Fee	Service Charges/Fees	-0.6500	\N	Checkcard Xxxx Xxxx 4693 Quebec Inc Montreal Qc Xxxxx7142xxxxxxxxxx4926 International Transaction Fee	0	Checkcard Xxxx Xxxx 4693 Quebec Inc Montreal Qc Xxxxx7142xxxxxxxxxx4926 International Transaction Fee	1	2024-07-22	95
699	100149338	2024-07-22	2024-09-02 19:18:06.28	Checkcard 0721 La Grande Roue De Mont Montreal Qc Xxxxx0142xxxxxxxxxx0165 International Transaction Fee	Service Charges/Fees	-2.1400	\N	Checkcard 0721 La Grande Roue De Mont Montreal Qc Xxxxx0142xxxxxxxxxx0165 International Transaction Fee	0	Checkcard 0721 La Grande Roue De Mont Montreal Qc Xxxxx0142xxxxxxxxxx0165 International Transaction Fee	1	2024-07-22	77
700	100149349	2024-07-22	2024-09-02 19:18:06.28	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx4085 Indn:146 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	Savings	-250.0000	\N	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx4085 Indn:146 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	0	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx4085 Indn:146 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	1	2024-07-22	364
701	100149361	2024-07-22	2024-09-02 19:18:06.28	Source	Clothing/Shoes	-42.5500	\N	Source	0	Source	1	2024-07-22	326
702	100149372	2024-07-22	2024-09-02 19:18:06.28	Les 3 Brasseurs	Restaurants	-78.0700	\N	Les 3 Brasseurs	0	Les 3 Brasseurs	1	2024-07-22	199
746	100151095	2024-09-23	2025-03-09 14:49:06.733	Sam's Club	General Merchandise	-190.9900	\N	Sam's Club	0	Sam's Club	1	2024-09-23	315
703	100149383	2024-07-22	2024-09-02 19:18:06.28	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966	Restaurants	-3.6500	\N	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966	0	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966	1	2024-07-22	74
704	100149297	2024-07-23	2024-09-02 19:18:06.28	Checkcard 0721 Iga 8217 Montreal Qc Xxxxx0042xxxxxxxxxx2209 International Transaction Fee	Service Charges/Fees	-0.2900	\N	Checkcard 0721 Iga 8217 Montreal Qc Xxxxx0042xxxxxxxxxx2209 International Transaction Fee	0	Checkcard 0721 Iga 8217 Montreal Qc Xxxxx0042xxxxxxxxxx2209 International Transaction Fee	1	2024-07-23	76
705	100149308	2024-07-23	2024-09-02 19:18:06.28	Checkcard 0722 Agence De Mobilite Dura Montreal Qc Xxxxx4942xxxxxxxxxx4569	Healthcare/Medical	-10.0400	\N	Checkcard 0722 Agence De Mobilite Dura Montreal Qc Xxxxx4942xxxxxxxxxx4569	0	Checkcard 0722 Agence De Mobilite Dura Montreal Qc Xxxxx4942xxxxxxxxxx4569	1	2024-07-23	78
706	100149295	2024-07-24	2024-09-02 19:18:06.28	Les 3 Brasseurs	Restaurants	-85.1200	\N	Les 3 Brasseurs	0	Les 3 Brasseurs	1	2024-07-24	199
707	100149275	2024-07-26	2024-09-02 19:18:06.28	Subway	Restaurants	-48.7000	\N	Subway	0	Subway	1	2024-07-26	339
708	100149246	2024-07-29	2024-09-02 19:18:06.28	Kroger	Groceries	-14.8300	\N	Kroger	0	Kroger	1	2024-07-29	195
709	100149257	2024-07-29	2024-09-02 19:18:06.28	Cvs Pharmacy	Healthcare/Medical	-17.6100	\N	Cvs Pharmacy	0	Cvs Pharmacy	1	2024-07-29	115
710	100149268	2024-07-29	2024-09-02 19:18:06.28	Smithstore	Online Services	-58.9900	\N	Smithstore	0	Smithstore	1	2024-07-29	323
711	100149239	2024-07-30	2024-09-02 19:18:06.28	Publix	Groceries	-62.7000	\N	Publix	0	Publix	1	2024-07-30	268
712	100149221	2024-08-01	2024-09-02 19:18:06.28	Middle Tennessee Electric	Utilities	-207.5900	19	Middle Tennessee Electric	0	Middle Tennessee Electric	1	2024-08-01	221
713	100149188	2024-08-05	2024-09-02 19:18:06.28	Navient Corporation	Loans	-55.7600	\N	Navient Corporation	0	Navient Corporation	1	2024-08-05	236
714	100149199	2024-08-05	2024-09-02 19:18:06.28	Puma	Clothing/Shoes	-155.0300	\N	Puma	0	Puma	1	2024-08-05	270
715	100149211	2024-08-05	2024-09-02 19:18:06.28	Amazon	General Merchandise	-39.9100	\N	Amazon	0	Amazon	1	2024-08-05	15
716	100149178	2024-08-06	2024-09-02 19:18:06.28	Sams's Club Gas Station	Gasoline/Fuel	-69.6100	\N	Sams's Club Gas Station	0	Sams's Club Gas Station	1	2024-08-06	316
717	100149169	2024-08-07	2024-09-02 19:18:06.28	Checkcard 0806 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx7294 Recurring	Personal Care	-40.0000	\N	Checkcard 0806 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx7294 Recurring	0	Checkcard 0806 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx7294 Recurring	1	2024-08-07	81
718	100149735	2024-08-10	2024-09-02 20:13:49.83	Interest Paid	Interest	68.4300	104	Interest Paid	0	Interest Paid	3	2024-08-10	180
719	100149149	2024-08-12	2024-09-02 19:18:06.28	Publix	Groceries	-270.9100	\N	Publix	0	Publix	1	2024-08-12	268
720	100149138	2024-08-13	2024-09-02 19:18:06.28	Bank Of America	Deposits	169.0000	\N	Bank Of America	0	Bank Of America	1	2024-08-13	34
721	100149118	2024-08-15	2024-09-02 19:18:06.28	Paypal	Transfers	-10.9600	115	Paypal	0	Paypal	1	2024-08-15	256
722	100149096	2024-08-19	2024-09-02 19:18:06.28	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-08-19	336
723	100149107	2024-08-19	2024-09-02 19:18:06.28	Purchase 0818 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx5484 Recurring	Online Services	-5.0000	\N	Purchase 0818 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx5484 Recurring	0	Purchase 0818 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx5484 Recurring	1	2024-08-19	294
724	100149092	2024-08-20	2024-09-02 19:18:06.28	Checkcard 0819 Shuffs Music Xxx-xxx6139 Tn Xxxxx3042xxxxxxxxxx8557 Recurring	Hobbies	-54.8800	\N	Checkcard 0819 Shuffs Music Xxx-xxx6139 Tn Xxxxx3042xxxxxxxxxx8557 Recurring	0	Checkcard 0819 Shuffs Music Xxx-xxx6139 Tn Xxxxx3042xxxxxxxxxx8557 Recurring	1	2024-08-20	83
725	100149085	2024-08-22	2024-09-02 19:18:06.28	Target	General Merchandise	-43.5300	\N	Target	0	Target	1	2024-08-22	349
726	100149061	2024-08-26	2024-09-02 19:18:06.28	Trader Joe's	Groceries	-16.0800	\N	Trader Joe's	0	Trader Joe's	1	2024-08-26	367
727	100149072	2024-08-26	2024-09-02 19:18:06.28	Amazon Marketplace	General Merchandise	-23.0400	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-08-26	18
728	100149045	2024-08-28	2024-09-02 19:18:06.28	Checkcard 0828 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx9882 Recurring	Personal Care	-120.0000	\N	Checkcard 0828 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx9882 Recurring	0	Checkcard 0828 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx9882 Recurring	1	2024-08-28	84
729	100149031	2024-08-30	2024-09-02 19:18:06.28	State Farm	Insurance	-19.0000	\N	State Farm	0	State Farm	1	2024-08-30	337
730	100149902	2024-09-03	2024-09-22 19:22:22.423	Adt Security Services	Home Improvement	-62.0600	\N	Adt Security Services	0	Adt Security Services	1	2024-09-03	12
731	100149914	2024-09-03	2024-09-22 19:22:22.423	Purchase 0903 Amazon Reta* Zt5pn7aa2 Www.amazon.cowa Xxxxx3442xxxxxxxxxx1919	General Merchandise	-24.2800	\N	Purchase 0903 Amazon Reta* Zt5pn7aa2 Www.amazon.cowa Xxxxx3442xxxxxxxxxx1919	0	Purchase 0903 Amazon Reta* Zt5pn7aa2 Www.amazon.cowa Xxxxx3442xxxxxxxxxx1919	1	2024-09-03	296
732	100149925	2024-09-03	2024-09-22 19:22:22.423	Sam's Club	General Merchandise	-89.0500	\N	Sam's Club	0	Sam's Club	1	2024-09-03	315
733	100149898	2024-09-04	2024-09-22 19:22:22.423	Apple	Electronics	-0.9900	\N	Apple	0	Apple	1	2024-09-04	26
734	100149874	2024-09-06	2024-09-22 19:22:22.423	Navient Corporation	Loans	-88.9400	\N	Navient Corporation	0	Navient Corporation	1	2024-09-06	236
735	100149840	2024-09-09	2024-09-22 19:22:22.423	Venmo	Transfers	-40.0000	\N	Venmo	0	Venmo	1	2024-09-09	373
736	100149852	2024-09-09	2024-09-22 19:22:22.423	Dc Govt	Online Services	-100.0000	\N	Dc Govt	0	Dc Govt	1	2024-09-09	120
737	100149863	2024-09-09	2024-09-22 19:22:22.423	Chick-fil-a	Restaurants	-11.8400	\N	Chick-fil-a	0	Chick-fil-a	1	2024-09-09	99
738	100149829	2024-09-10	2024-09-22 19:22:22.423	Venmo	Transfers	-860.0000	\N	Venmo	0	Venmo	1	2024-09-10	373
739	100149823	2024-09-12	2024-09-22 19:22:22.423	Walmart	General Merchandise	-32.8800	\N	Walmart	0	Walmart	1	2024-09-12	379
740	100149793	2024-09-16	2024-09-22 19:22:22.423	Starbucks	Restaurants	-25.0000	\N	Starbucks	0	Starbucks	1	2024-09-16	336
741	100149804	2024-09-16	2024-09-22 19:22:22.423	Trader Joe's	Groceries	-56.3600	\N	Trader Joe's	0	Trader Joe's	1	2024-09-16	367
742	100149785	2024-09-17	2024-09-22 19:22:22.423	Paypal	Transfers	-74.9900	115	Paypal	0	Paypal	1	2024-09-17	256
743	100149775	2024-09-18	2024-09-22 19:22:22.423	Knights Of Columbus Insurance	Charitable Giving	-300.0000	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2024-09-18	191
744	100149767	2024-09-19	2024-09-22 19:22:22.423	Subway	Restaurants	-17.5400	\N	Subway	0	Subway	1	2024-09-19	339
745	100149765	2024-09-20	2024-09-22 19:22:22.423	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5249.4400	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2024-09-20	10
747	100151107	2024-09-23	2025-03-09 14:49:06.733	Checkcard 0921 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3942xxxxxxxxxx3732	Groceries	-43.2500	\N	Checkcard 0921 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3942xxxxxxxxxx3732	0	Checkcard 0921 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3942xxxxxxxxxx3732	1	2024-09-23	86
748	100151083	2024-09-24	2025-03-09 14:49:06.733	Publix	Groceries	-104.2400	\N	Publix	0	Publix	1	2024-09-24	268
749	100151054	2024-09-27	2025-03-09 14:49:06.733	Paypal	Transfers	-3.0000	115	Paypal	0	Paypal	1	2024-09-27	256
750	100151065	2024-09-27	2025-03-09 14:49:06.733	Checkcard 0926 Vcn*cofpaymentsdept Xxx-xxx-1857 Tn Xxxxx0042xxxxxxxxxx5458	Online Services	-5.0000	\N	Checkcard 0926 Vcn*cofpaymentsdept Xxx-xxx-1857 Tn Xxxxx0042xxxxxxxxxx5458	0	Checkcard 0926 Vcn*cofpaymentsdept Xxx-xxx-1857 Tn Xxxxx0042xxxxxxxxxx5458	1	2024-09-27	87
751	100151045	2024-09-30	2025-03-09 14:49:06.733	Checkcard 0929 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx0597 Recurring	Personal Care	-120.0000	\N	Checkcard 0929 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx0597 Recurring	0	Checkcard 0929 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx0597 Recurring	1	2024-09-30	88
752	100151026	2024-10-01	2025-03-09 14:49:06.733	Boyd Mill Estate Des:funding Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	Other Expenses	-103.2100	\N	Boyd Mill Estate Des:funding Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	0	Boyd Mill Estate Des:funding Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	1	2024-10-01	39
753	100151017	2024-10-02	2025-03-09 14:49:06.733	Protective Life	Insurance	-23.8000	35	Protective Life	0	Protective Life	1	2024-10-02	267
754	100151010	2024-10-03	2025-03-09 14:49:06.733	Zoom Video Communications	Online Services	-17.5500	\N	Zoom Video Communications	0	Zoom Video Communications	1	2024-10-03	396
755	100150999	2024-10-04	2025-03-09 14:49:06.733	Circle K	Groceries	-100.0000	\N	Circle K	0	Circle K	1	2024-10-04	101
756	100150978	2024-10-07	2025-03-09 14:49:06.733	Greenlight Financial Technology	Online Services	-50.0000	\N	Greenlight Financial Technology	0	Greenlight Financial Technology	1	2024-10-07	164
798	100150532	2024-12-05	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-16.4500	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-12-05	18
757	100150989	2024-10-07	2025-03-09 14:49:06.733	Purchase 1004 Docker, Inc. Httpswww.dockca Xxxxx3442xxxxxxxxxx3774 Recurring	Clothing/Shoes	-65.8500	\N	Purchase 1004 Docker, Inc. Httpswww.dockca Xxxxx3442xxxxxxxxxx3774 Recurring	0	Purchase 1004 Docker, Inc. Httpswww.dockca Xxxxx3442xxxxxxxxxx3774 Recurring	1	2024-10-07	297
758	100150958	2024-10-09	2025-03-09 14:49:06.733	Check 1750	Checks	-550.0000	\N	Check 1750	0	Check 1750	1	2024-10-09	54
759	100150951	2024-10-10	2025-03-09 14:49:06.733	The Home Depot	Home Improvement	-299.4500	\N	The Home Depot	0	The Home Depot	1	2024-10-10	354
760	100150921	2024-10-15	2025-03-09 14:49:06.733	Paypal	Transfers	-10.9600	115	Paypal	0	Paypal	1	2024-10-15	256
761	100150933	2024-10-15	2025-03-09 14:49:06.733	Nnt Franklin B 10/13 #xxxxx1004 Purchase 100 E Main St Franklin Tn	Other Expenses	-14.9500	\N	Nnt Franklin B 10/13 #xxxxx1004 Purchase 100 E Main St Franklin Tn	0	Nnt Franklin B 10/13 #xxxxx1004 Purchase 100 E Main St Franklin Tn	1	2024-10-15	241
762	100150944	2024-10-15	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	91.7800	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-10-15	18
763	100150899	2024-10-18	2025-03-09 14:49:06.733	Recisio	Transfers	-1.9900	\N	Recisio	0	Recisio	1	2024-10-18	307
764	100150910	2024-10-18	2025-03-09 14:49:06.733	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5199.4400	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2024-10-18	10
765	100150889	2024-10-21	2025-03-09 14:49:06.733	Mobile Purchase 1020 Nnt Franklin B Franklin Tn	Clothing/Shoes	-14.0400	\N	Mobile Purchase 1020 Nnt Franklin B Franklin Tn	0	Mobile Purchase 1020 Nnt Franklin B Franklin Tn	1	2024-10-21	225
766	100150873	2024-10-22	2025-03-09 14:49:06.733	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2024-10-22	336
767	100150871	2024-10-23	2025-03-09 14:49:06.733	Checkcard 1022 Culamar Franklin Tn Xxxxx8542xxxxxxxxxx1662	Other Expenses	-134.3600	\N	Checkcard 1022 Culamar Franklin Tn Xxxxx8542xxxxxxxxxx1662	0	Checkcard 1022 Culamar Franklin Tn Xxxxx8542xxxxxxxxxx1662	1	2024-10-23	89
768	100150857	2024-10-25	2025-03-09 14:49:06.733	Parnassus Books	Hobbies	-19.6600	\N	Parnassus Books	0	Parnassus Books	1	2024-10-25	252
769	100150835	2024-10-28	2025-03-09 14:49:06.733	The Coffee House	Restaurants	-4.5700	\N	The Coffee House	0	The Coffee House	1	2024-10-28	351
770	100150847	2024-10-28	2025-03-09 14:49:06.733	Checkcard 1026 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3943xxxxxxxxxx2238	Groceries	-43.2500	\N	Checkcard 1026 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3943xxxxxxxxxx2238	0	Checkcard 1026 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3943xxxxxxxxxx2238	1	2024-10-28	90
771	100150825	2024-10-29	2025-03-09 14:49:06.733	Google Play	Online Services	-1.0800	\N	Google Play	0	Google Play	1	2024-10-29	160
772	100150806	2024-10-31	2025-03-09 14:49:06.733	Greenlight Financial Technology	Online Services	-50.0000	\N	Greenlight Financial Technology	0	Greenlight Financial Technology	1	2024-10-31	164
773	100150799	2024-11-01	2025-03-09 14:49:06.733	Wayfair	General Merchandise	-30.7300	\N	Wayfair	0	Wayfair	1	2024-11-01	383
774	100150780	2024-11-04	2025-03-09 14:49:06.733	Circle K	Groceries	-56.8300	\N	Circle K	0	Circle K	1	2024-11-04	101
775	100150791	2024-11-04	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-45.0100	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-11-04	18
776	100150762	2024-11-06	2025-03-09 14:49:06.733	Paypal	Transfers	-10.0000	115	Paypal	0	Paypal	1	2024-11-06	256
777	100150752	2024-11-08	2025-03-09 14:49:06.733	Microsoft	Online Services	-10.6200	\N	Microsoft	0	Microsoft	1	2024-11-08	220
778	100150733	2024-11-12	2025-03-09 14:49:06.733	Purchase 1112 Sp Built.com Built.com Ut Xxxxx3443xxxxxxxxxx0960	Home Improvement	-67.9900	\N	Purchase 1112 Sp Built.com Built.com Ut Xxxxx3443xxxxxxxxxx0960	0	Purchase 1112 Sp Built.com Built.com Ut Xxxxx3443xxxxxxxxxx0960	1	2024-11-12	298
779	100150745	2024-11-12	2025-03-09 14:49:06.733	Cns The Childr 11/09 #xxxxx7636 Purchase 1800 Galleria Blv Franklin Tn	Child/Dependent	-43.4000	\N	Cns The Childr 11/09 #xxxxx7636 Purchase 1800 Galleria Blv Franklin Tn	0	Cns The Childr 11/09 #xxxxx7636 Purchase 1800 Galleria Blv Franklin Tn	1	2024-11-12	103
780	100150721	2024-11-14	2025-03-09 14:49:06.733	Synchrony Bank	Credit Card Payments	-49.0000	\N	Synchrony Bank	0	Synchrony Bank	1	2024-11-14	343
781	100150716	2024-11-15	2025-03-09 14:49:06.733	Klarna	Loans	-30.7300	\N	Klarna	0	Klarna	1	2024-11-15	190
782	100150686	2024-11-18	2025-03-09 14:49:06.733	Ebay	General Merchandise	-208.3100	\N	Ebay	0	Ebay	1	2024-11-18	131
783	100150698	2024-11-18	2025-03-09 14:49:06.733	Checkcard 1116 Tst* M.l. Rose Craft Be Franklin Tn Xxxxx4643xxxxxxxxxx7965	Restaurants	-78.5900	\N	Checkcard 1116 Tst* M.l. Rose Craft Be Franklin Tn Xxxxx4643xxxxxxxxxx7965	0	Checkcard 1116 Tst* M.l. Rose Craft Be Franklin Tn Xxxxx4643xxxxxxxxxx7965	1	2024-11-18	91
784	100150677	2024-11-19	2025-03-09 14:49:06.733	Macy's	Credit Card Payments	-185.3200	\N	Macy's	0	Macy's	1	2024-11-19	209
785	100150673	2024-11-20	2025-03-09 14:49:06.733	Justice Industries	Charitable Giving	-19.5000	\N	Justice Industries	0	Justice Industries	1	2024-11-20	185
786	100150662	2024-11-22	2025-03-09 14:49:06.733	Purchase 1121 Amazon Reta* Y54wd1xb3 Www.amazon.cowa Xxxxx3443xxxxxxxxxx3916	General Merchandise	-7.8000	\N	Purchase 1121 Amazon Reta* Y54wd1xb3 Www.amazon.cowa Xxxxx3443xxxxxxxxxx3916	0	Purchase 1121 Amazon Reta* Y54wd1xb3 Www.amazon.cowa Xxxxx3443xxxxxxxxxx3916	1	2024-11-22	300
787	100150643	2024-11-25	2025-03-09 14:49:06.733	Disney Plus	Entertainment	-17.5100	21	Disney Plus	-1	Disney Plus	1	2024-11-25	122
788	100150655	2024-11-25	2025-03-09 14:49:06.733	Starbucks	Restaurants	-5.6600	\N	Starbucks	0	Starbucks	1	2024-11-25	336
789	100150633	2024-11-26	2025-03-09 14:49:06.733	Paypal	Transfers	-112.6000	115	Paypal	0	Paypal	1	2024-11-26	256
790	100151147	2024-11-27	2025-03-09 14:52:34.73	Firestone Auto Center	Automotive	-570.5100	66	Firestone Auto Center	0	Firestone Auto Center	2	2024-11-27	139
791	100150609	2024-11-29	2025-03-09 14:49:06.733	Purchase 1126 Amznfreetime*zx9576nl2 Xxx-xxx-3080 Wa Xxxxx1643xxxxxxxxxx9876	Entertainment	-6.5600	\N	Purchase 1126 Amznfreetime*zx9576nl2 Xxx-xxx-3080 Wa Xxxxx1643xxxxxxxxxx9876	0	Purchase 1126 Amznfreetime*zx9576nl2 Xxx-xxx-3080 Wa Xxxxx1643xxxxxxxxxx9876	1	2024-11-29	301
792	100150567	2024-12-02	2025-03-09 14:49:06.733	Focusxxxxxx7373 Des:payments Id:a107dce99 Indn:jake Woods Co Id:xxxxxx2248 Ppd	Online Services	-75.0000	\N	Focusxxxxxx7373 Des:payments Id:a107dce99 Indn:jake Woods Co Id:xxxxxx2248 Ppd	0	Focusxxxxxx7373 Des:payments Id:a107dce99 Indn:jake Woods Co Id:xxxxxx2248 Ppd	1	2024-12-02	145
793	100150578	2024-12-02	2025-03-09 14:49:06.733	Trader Joe's	Groceries	-24.2900	\N	Trader Joe's	0	Trader Joe's	1	2024-12-02	367
794	100150589	2024-12-02	2025-03-09 14:49:06.733	Amc Theatres	Entertainment	-66.8600	\N	Amc Theatres	0	Amc Theatres	1	2024-12-02	23
795	100150546	2024-12-03	2025-03-09 14:49:06.733	Protective Life	Insurance	-23.8000	35	Protective Life	0	Protective Life	1	2024-12-03	267
796	100150557	2024-12-03	2025-03-09 14:49:06.733	Savory Spice	Healthcare/Medical	-13.8600	\N	Savory Spice	0	Savory Spice	1	2024-12-03	317
797	100150541	2024-12-04	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-35.3400	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-12-04	18
799	100150476	2024-12-09	2025-03-09 14:49:06.733	Venmo	Transfers	-10.0000	\N	Venmo	0	Venmo	1	2024-12-09	373
800	100150487	2024-12-09	2025-03-09 14:49:06.733	Chick-fil-a	Restaurants	-20.3900	\N	Chick-fil-a	0	Chick-fil-a	1	2024-12-09	99
801	100150499	2024-12-09	2025-03-09 14:49:06.733	Heifer International	Charitable Giving	-200.0000	\N	Heifer International	0	Heifer International	1	2024-12-09	170
802	100150510	2024-12-09	2025-03-09 14:49:06.733	Paypal	Transfers	-100.0000	115	Paypal	0	Paypal	1	2024-12-09	256
803	100150471	2024-12-10	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-17.5400	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-12-10	18
804	100150463	2024-12-11	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-40.4900	\N	Amazon Marketplace	0	Amazon Marketplace	1	2024-12-11	18
805	100150448	2024-12-13	2025-03-09 14:49:06.733	Amazon Web Services	Online Services	-114.3800	9	Amazon Web Services	0	Amazon Web Services	1	2024-12-13	21
806	100150427	2024-12-16	2025-03-09 14:49:06.733	Whole Foods Market	Groceries	-22.4900	\N	Whole Foods Market	0	Whole Foods Market	1	2024-12-16	384
807	100150438	2024-12-16	2025-03-09 14:49:06.733	Purchase 1214 Change.org Change.org Ca Xxxxx7743xxxxxxxxxx9625 Recurring	Online Services	-8.0000	\N	Purchase 1214 Change.org Change.org Ca Xxxxx7743xxxxxxxxxx9625 Recurring	0	Purchase 1214 Change.org Change.org Ca Xxxxx7743xxxxxxxxxx9625 Recurring	1	2024-12-16	302
808	100150411	2024-12-17	2025-03-09 14:49:06.733	St. Philip Church	Other Expenses	-200.0000	\N	St. Philip Church	0	St. Philip Church	1	2024-12-17	335
809	100150401	2024-12-18	2025-03-09 14:49:06.733	Comcast	Cable/Satellite	-249.5700	\N	Comcast	0	Comcast	1	2024-12-18	108
810	100150391	2024-12-19	2025-03-09 14:49:06.733	Garmin	Electronics	-19.9800	\N	Garmin	0	Garmin	1	2024-12-19	155
811	100150386	2024-12-20	2025-03-09 14:49:06.733	Checkcard 1219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3043xxxxxxxxxx1487 Recurring	Hobbies	-54.8800	\N	Checkcard 1219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3043xxxxxxxxxx1487 Recurring	0	Checkcard 1219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3043xxxxxxxxxx1487 Recurring	1	2024-12-20	93
812	100150371	2024-12-23	2025-03-09 14:49:06.733	Target	General Merchandise	-58.1000	\N	Target	0	Target	1	2024-12-23	349
813	100150383	2024-12-23	2025-03-09 14:49:06.733	Amazon.com	General Merchandise	-27.4300	\N	Amazon.com	0	Amazon.com	1	2024-12-23	22
814	100150347	2024-12-26	2025-03-09 14:49:06.733	Knights Of Columbus Insurance	Charitable Giving	-1231.1200	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2024-12-26	191
815	100150340	2024-12-27	2025-03-09 14:49:06.733	Publix	Groceries	-94.2500	\N	Publix	0	Publix	1	2024-12-27	268
816	100150330	2024-12-30	2025-03-09 14:49:06.733	Google Play	Online Services	-1.0800	\N	Google Play	0	Google Play	1	2024-12-30	160
817	100150309	2025-01-02	2025-03-09 14:49:06.733	Paypal Des:inst Xfer Id:specialolym Indn:jake Woods Co Id:paypalsi77 Web	Transfers	-51.2500	\N	Paypal Des:inst Xfer Id:specialolym Indn:jake Woods Co Id:paypalsi77 Web	0	Paypal Des:inst Xfer Id:specialolym Indn:jake Woods Co Id:paypalsi77 Web	1	2025-01-02	260
818	100150320	2025-01-02	2025-03-09 14:49:06.733	Publix	Groceries	-25.3400	\N	Publix	0	Publix	1	2025-01-02	268
819	100150303	2025-01-03	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-39.5000	\N	Amazon Marketplace	0	Amazon Marketplace	1	2025-01-03	18
820	100150282	2025-01-06	2025-03-09 14:49:06.733	Mohela	Loans	-55.7600	\N	Mohela	0	Mohela	1	2025-01-06	226
821	100150293	2025-01-06	2025-03-09 14:49:06.733	Apple	Electronics	-0.9900	\N	Apple	0	Apple	1	2025-01-06	26
822	100150269	2025-01-09	2025-03-09 14:49:06.733	Amazon Digital Services	Entertainment	-9.8400	\N	Amazon Digital Services	0	Amazon Digital Services	1	2025-01-09	16
823	100150250	2025-01-13	2025-03-09 14:49:06.733	Publix	Groceries	-17.3300	\N	Publix	0	Publix	1	2025-01-13	268
824	100150244	2025-01-14	2025-03-09 14:49:06.733	Venmo	Transfers	-860.0000	\N	Venmo	0	Venmo	1	2025-01-14	373
825	100150241	2025-01-15	2025-03-09 14:49:06.733	Purchase 0115 Amazon Reta* Zd9lz67s1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0821	General Merchandise	-22.7400	\N	Purchase 0115 Amazon Reta* Zd9lz67s1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0821	0	Purchase 0115 Amazon Reta* Zd9lz67s1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0821	1	2025-01-15	271
826	100153377	2025-01-21	2025-09-23 03:07:29.72	THE FRANKLIN THEATRE 01/17 PURCHASE FRANKLIN TN	Unknown	-15.3400	\N	THE FRANKLIN THEATRE 01/17 PURCHASE FRANKLIN TN	0	THE FRANKLIN THEATRE 01/17 PURCHASE FRANKLIN TN	1	2025-01-21	345
827	100153388	2025-01-21	2025-09-23 03:07:29.72	DUNKIN #349816 Q35 01/20 PURCHASE FRANKLIN TN	Unknown	-12.8200	\N	DUNKIN #349816 Q35 01/20 PURCHASE FRANKLIN TN	0	DUNKIN #349816 Q35 01/20 PURCHASE FRANKLIN TN	1	2025-01-21	118
828	100151132	2025-01-22	2025-03-09 14:52:34.73	Full Circle Counseling	Online Services	-165.0000	\N	Full Circle Counseling	0	Full Circle Counseling	2	2025-01-22	151
829	100150220	2025-01-24	2025-03-09 14:49:06.733	Sam's Club	General Merchandise	-84.4500	\N	Sam's Club	0	Sam's Club	1	2025-01-24	315
830	100150208	2025-01-27	2025-03-09 14:49:06.733	Publix	Groceries	-247.1800	\N	Publix	0	Publix	1	2025-01-27	268
831	100150201	2025-01-28	2025-03-09 14:49:06.733	Publix	Groceries	-4.7900	\N	Publix	0	Publix	1	2025-01-28	268
832	100150187	2025-01-30	2025-03-09 14:49:06.733	Focusxxxxxx7373 Des:payments Id:a10a5c269 Indn:jake Woods Co Id:xxxxxx2248 Ppd	Online Services	-75.0000	\N	Focusxxxxxx7373 Des:payments Id:a10a5c269 Indn:jake Woods Co Id:xxxxxx2248 Ppd	0	Focusxxxxxx7373 Des:payments Id:a10a5c269 Indn:jake Woods Co Id:xxxxxx2248 Ppd	1	2025-01-30	146
833	100150164	2025-02-03	2025-03-09 14:49:06.733	Middle Tennessee Electric	Utilities	-160.0000	19	Middle Tennessee Electric	0	Middle Tennessee Electric	1	2025-02-03	221
834	100150175	2025-02-03	2025-03-09 14:49:06.733	Purchase 0202 Amazon Reta* Zc2jm9ku1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0299	General Merchandise	-12.4000	\N	Purchase 0202 Amazon Reta* Zc2jm9ku1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0299	0	Purchase 0202 Amazon Reta* Zc2jm9ku1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0299	1	2025-02-03	272
835	100150153	2025-02-04	2025-03-09 14:49:06.733	Publix	Groceries	-202.7900	\N	Publix	0	Publix	1	2025-02-04	268
836	100150142	2025-02-06	2025-03-09 14:49:06.733	Paypal	Transfers	-10.0000	115	Paypal	0	Paypal	1	2025-02-06	256
837	100150140	2025-02-07	2025-03-09 14:49:06.733	Cigna	Paychecks/Salary	4050.1400	32	Cigna	0	Cigna	1	2025-02-07	100
838	100150112	2025-02-10	2025-03-09 14:49:06.733	Sam's Club	General Merchandise	-102.6300	\N	Sam's Club	0	Sam's Club	1	2025-02-10	315
839	100150123	2025-02-10	2025-03-09 14:49:06.733	Dollar Tree	General Merchandise	-13.7200	\N	Dollar Tree	0	Dollar Tree	1	2025-02-10	125
840	100150097	2025-02-11	2025-03-09 14:49:06.733	CRM Lawn Care	Other Expenses	-176.0000	20	Crmlawn.com Des:crmlawn.co Id:st-a3y1i6n7x1e9 Indn:jake Woods Co Id:xxxxxx8598 Web	-1	Crmlawn.com Des:crmlawn.co Id:st-a3y1i6n7x1e9 Indn:jake Woods Co Id:xxxxxx8598 Web	1	2025-02-11	48
841	100150086	2025-02-13	2025-03-09 14:49:06.733	Venmo	Transfers	-35.0000	\N	Venmo	0	Venmo	1	2025-02-13	373
842	100151129	2025-02-16	2025-03-09 14:52:34.73	Wyndy	Travel	-122.1000	\N	Wyndy	0	Wyndy	2	2025-02-16	392
843	100150063	2025-02-18	2025-03-09 14:49:06.733	Publix	Groceries	-69.1500	\N	Publix	0	Publix	1	2025-02-18	268
882	100151832	2025-04-14	2025-04-23 03:51:53.75	Subway	Restaurants	-35.3200	\N	Subway	0	Subway	1	2025-04-14	339
883	100151813	2025-04-15	2025-04-23 03:51:53.75	At&t	Telephone	-299.2700	\N	At&t	0	At&t	1	2025-04-15	29
844	100150074	2025-02-18	2025-03-09 14:49:06.733	Checkcard 0215 Frist Art Museum Xxx-xxx3325 Tn Xxxxx6650xxxxxxxxxx1570	Entertainment	-20.0000	\N	Checkcard 0215 Frist Art Museum Xxx-xxx3325 Tn Xxxxx6650xxxxxxxxxx1570	0	Checkcard 0215 Frist Art Museum Xxx-xxx3325 Tn Xxxxx6650xxxxxxxxxx1570	1	2025-02-18	57
845	100150048	2025-02-20	2025-03-09 14:49:06.733	Checkcard 0219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3050xxxxxxxxxx4469 Recurring	Hobbies	-54.8800	\N	Checkcard 0219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3050xxxxxxxxxx4469 Recurring	0	Checkcard 0219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3050xxxxxxxxxx4469 Recurring	1	2025-02-20	58
846	100150046	2025-02-21	2025-03-09 14:49:06.733	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5216.9200	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2025-02-21	10
847	100150027	2025-02-24	2025-03-09 14:49:06.733	Publix	Groceries	-149.8900	\N	Publix	0	Publix	1	2025-02-24	268
848	100150016	2025-02-25	2025-03-09 14:49:06.733	Disney Plus	Entertainment	-17.5100	21	Disney Plus	-1	Disney Plus	1	2025-02-25	122
849	100150011	2025-02-27	2025-03-09 14:49:06.733	Mobile Purchase 0222 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx6981	Restaurants	-48.9500	\N	Mobile Purchase 0222 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx6981	0	Mobile Purchase 0222 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx6981	1	2025-02-27	222
850	100149972	2025-03-03	2025-03-09 14:49:06.733	ADT Security	Home Improvement	-67.0100	20	Adt Security Services	0	Adt Security Services	1	2025-03-03	3
851	100149984	2025-03-03	2025-03-09 14:49:06.733	Purchase 0302 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx0049	Entertainment	-17.5500	\N	Purchase 0302 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx0049	0	Purchase 0302 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx0049	1	2025-03-03	274
852	100149995	2025-03-03	2025-03-09 14:49:06.733	Mobile Purchase 0228 Corkys Bbq - Brentwood Brentwood Tn Xxxxx0450xxxxxxxxxx1516	Restaurants	-21.2100	\N	Mobile Purchase 0228 Corkys Bbq - Brentwood Brentwood Tn Xxxxx0450xxxxxxxxxx1516	0	Mobile Purchase 0228 Corkys Bbq - Brentwood Brentwood Tn Xxxxx0450xxxxxxxxxx1516	1	2025-03-03	223
853	100149956	2025-03-04	2025-03-09 14:49:06.733	State Farm	Insurance	-19.0000	\N	State Farm	0	State Farm	1	2025-03-04	337
854	100149968	2025-03-04	2025-03-09 14:49:06.733	Amazon Marketplace	General Merchandise	-46.2700	\N	Amazon Marketplace	0	Amazon Marketplace	1	2025-03-04	18
855	100149947	2025-03-05	2025-03-09 14:49:06.733	Sonic Drive-in	Restaurants	-2.0000	\N	Sonic Drive-in	0	Sonic Drive-in	1	2025-03-05	325
856	100149937	2025-03-06	2025-03-09 14:49:06.733	Tj Maxx	Clothing/Shoes	-9.8700	\N	Tj Maxx	0	Tj Maxx	1	2025-03-06	363
857	100151282	2025-03-10	2025-03-27 23:38:06.73	Cook's Pest Control	Home Maintenance	-108.0000	\N	Cook's Pest Control	0	Cook's Pest Control	1	2025-03-10	109
858	100151294	2025-03-10	2025-03-27 23:38:06.73	Checkcard 0309 Cac* Childrens Art Www.childrenstn Xxxxx6650xxxxxxxxxx4241 Recurring	Child/Dependent	-232.0000	\N	Checkcard 0309 Cac* Childrens Art Www.childrenstn Xxxxx6650xxxxxxxxxx4241 Recurring	0	Checkcard 0309 Cac* Childrens Art Www.childrenstn Xxxxx6650xxxxxxxxxx4241 Recurring	1	2025-03-10	60
859	100151305	2025-03-10	2025-03-27 23:38:06.73	Checkcard 0308 Swr*franklindermatology Xxx-xxx-1881 Tn Xxxxx0050xxxxxxxxxx6652	Healthcare/Medical	-50.9300	\N	Checkcard 0308 Swr*franklindermatology Xxx-xxx-1881 Tn Xxxxx0050xxxxxxxxxx6652	0	Checkcard 0308 Swr*franklindermatology Xxx-xxx-1881 Tn Xxxxx0050xxxxxxxxxx6652	1	2025-03-10	59
860	100151280	2025-03-11	2025-03-27 23:38:06.73	Publix	Groceries	-34.2600	\N	Publix	0	Publix	1	2025-03-11	268
861	100151262	2025-03-14	2025-03-27 23:38:06.73	Amazon Marketplace	General Merchandise	-21.9400	\N	Amazon Marketplace	0	Amazon Marketplace	1	2025-03-14	18
862	100151732	2025-03-15	2025-03-27 23:41:15.337	Travel Credit $75/year	Refunds & Reimbursements	11.2000	\N	Travel Credit $75/year	0	Travel Credit $75/year	2	2025-03-15	368
863	100151249	2025-03-17	2025-03-27 23:38:06.73	Purchase 0317 Franciscan Missions Franciscanmiswi Xxxxx1650xxxxxxxxxx1939	Other Expenses	-150.0000	\N	Purchase 0317 Franciscan Missions Franciscanmiswi Xxxxx1650xxxxxxxxxx1939	0	Purchase 0317 Franciscan Missions Franciscanmiswi Xxxxx1650xxxxxxxxxx1939	1	2025-03-17	277
864	100151260	2025-03-17	2025-03-27 23:38:06.73	Purchase 0314 Amazon Reta* Pr3zy5v23 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0742	General Merchandise	-38.4000	\N	Purchase 0314 Amazon Reta* Pr3zy5v23 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0742	0	Purchase 0314 Amazon Reta* Pr3zy5v23 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0742	1	2025-03-17	276
865	100151229	2025-03-19	2025-03-27 23:38:06.73	Dairy Queen	Restaurants	-5.4800	\N	Dairy Queen	0	Dairy Queen	1	2025-03-19	119
866	100151224	2025-03-20	2025-03-27 23:38:06.73	Amazon Marketplace	General Merchandise	-6.0300	\N	Amazon Marketplace	0	Amazon Marketplace	1	2025-03-20	18
867	100151193	2025-03-24	2025-03-27 23:38:06.73	Paypal	Transfers	-3.0000	115	Paypal	0	Paypal	1	2025-03-24	256
868	100151204	2025-03-24	2025-03-27 23:38:06.73	Checkcard 0322 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx0906	Restaurants	-14.3300	\N	Checkcard 0322 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx0906	0	Checkcard 0322 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx0906	1	2025-03-24	61
869	100151187	2025-03-25	2025-03-27 23:38:06.73	Circle K	Groceries	-25.0900	\N	Circle K	0	Circle K	1	2025-03-25	101
870	100151956	2025-03-27	2025-04-23 03:51:53.75	Circle K	Groceries	-6.5500	\N	Circle K	0	Circle K	1	2025-03-27	101
871	100151933	2025-03-31	2025-04-23 03:51:53.75	State Farm	Insurance	-19.0000	\N	State Farm	0	State Farm	1	2025-03-31	337
872	100151945	2025-03-31	2025-04-23 03:51:53.75	Apple	Electronics	-5.4800	\N	Apple	0	Apple	1	2025-03-31	26
873	100151930	2025-04-01	2025-04-23 03:51:53.75	Publix	Groceries	-112.0400	\N	Publix	0	Publix	1	2025-04-01	268
874	100151920	2025-04-02	2025-04-23 03:51:53.75	Purchase 0402 Amazon Reta* 555r91mi3 Www.amazon.cowa Xxxxx3450xxxxxxxxxx5271	General Merchandise	-14.4400	\N	Purchase 0402 Amazon Reta* 555r91mi3 Www.amazon.cowa Xxxxx3450xxxxxxxxxx5271	0	Purchase 0402 Amazon Reta* 555r91mi3 Www.amazon.cowa Xxxxx3450xxxxxxxxxx5271	1	2025-04-02	279
875	100151908	2025-04-03	2025-04-23 03:51:53.75	Purchase 0402 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx8044	Entertainment	-17.5500	\N	Purchase 0402 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx8044	0	Purchase 0402 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx8044	1	2025-04-03	281
876	100151900	2025-04-04	2025-04-23 03:51:53.75	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	Paychecks/Salary	5407.3300	32	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	0	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	1	2025-04-04	10
877	100151877	2025-04-07	2025-04-23 03:51:53.75	Publix	Groceries	-80.1700	\N	Publix	0	Publix	1	2025-04-07	268
878	100151888	2025-04-07	2025-04-23 03:51:53.75	Target	General Merchandise	-60.0900	\N	Target	0	Target	1	2025-04-07	349
879	100151855	2025-04-09	2025-04-23 03:51:53.75	Microsoft	Online Services	-10.6200	\N	Microsoft	0	Microsoft	1	2025-04-09	220
880	100151848	2025-04-10	2025-04-23 03:51:53.75	Sam's Club	General Merchandise	-130.9300	\N	Sam's Club	0	Sam's Club	1	2025-04-10	315
881	100151821	2025-04-14	2025-04-23 03:51:53.75	Venmo	Transfers	-30.0000	\N	Venmo	0	Venmo	1	2025-04-14	373
884	100151804	2025-04-16	2025-04-23 03:51:53.75	Venmo	Transfers	-150.0000	\N	Venmo	0	Venmo	1	2025-04-16	373
885	100151789	2025-04-18	2025-04-23 03:51:53.75	Cook's Pest Control	Home Maintenance	-86.3900	\N	Cook's Pest Control	0	Cook's Pest Control	1	2025-04-18	109
886	100151766	2025-04-21	2025-04-23 03:51:53.75	Us Department Of Education	Loans	-120.9800	2	Us Department Of Education	0	Us Department Of Education	1	2025-04-21	369
887	100151777	2025-04-21	2025-04-23 03:51:53.75	Williamson County	Paychecks/Salary	-6.0000	32	Williamson County	0	Williamson County	1	2025-04-21	386
888	100152500	2025-04-21	2025-08-31 12:51:55.633	Peloton Cycles	Personal Care	-48.1800	\N	Peloton Cycles	0	Peloton Cycles	2	2025-04-21	262
889	100153336	2025-04-25	2025-08-31 13:03:28.28	Knights Of Columbus Insurance	Charitable Giving	-1231.1200	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2025-04-25	191
890	100153312	2025-04-28	2025-08-31 13:03:28.28	Checkcard 0427 Tst* Salsa Franklin Tac Franklin Tn Xxxxx4651xxxxxxxxxx7277	Restaurants	-21.2100	\N	Checkcard 0427 Tst* Salsa Franklin Tac Franklin Tn Xxxxx4651xxxxxxxxxx7277	0	Checkcard 0427 Tst* Salsa Franklin Tac Franklin Tn Xxxxx4651xxxxxxxxxx7277	1	2025-04-28	68
891	100153323	2025-04-28	2025-08-31 13:03:28.28	Donut Den	Restaurants	-8.9800	\N	Donut Den	0	Donut Den	1	2025-04-28	126
892	100153335	2025-04-28	2025-08-31 13:03:28.28	Checkcard 0425 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4151xxxxxxxxxx7360	Entertainment	-187.5000	\N	Checkcard 0425 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4151xxxxxxxxxx7360	0	Checkcard 0425 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4151xxxxxxxxxx7360	1	2025-04-28	67
893	100153282	2025-04-30	2025-08-31 13:03:28.28	State Farm	Insurance	-19.0000	\N	State Farm	0	State Farm	1	2025-04-30	337
894	100153293	2025-04-30	2025-08-31 13:03:28.28	Nuts.com	Groceries	-91.8700	\N	Nuts.com	0	Nuts.com	1	2025-04-30	243
895	100153269	2025-05-02	2025-08-31 13:03:28.28	Parnassus Books	Hobbies	-76.7900	\N	Parnassus Books	0	Parnassus Books	1	2025-05-02	252
896	100153243	2025-05-05	2025-08-31 13:03:28.28	Mohela	Loans	-55.7600	\N	Mohela	0	Mohela	1	2025-05-05	226
897	100153255	2025-05-05	2025-08-31 13:03:28.28	Publix	Groceries	-228.1500	\N	Publix	0	Publix	1	2025-05-05	268
898	100153234	2025-05-06	2025-08-31 13:03:28.28	Paypal	Transfers	-10.0000	115	Paypal	0	Paypal	1	2025-05-06	256
899	100153231	2025-05-07	2025-08-31 13:03:28.28	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6024 Indn:571 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	Savings	-250.0000	\N	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6024 Indn:571 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	0	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6024 Indn:571 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	1	2025-05-07	366
900	100153227	2025-05-08	2025-08-31 13:03:28.28	Shell	Gasoline/Fuel	-59.1900	\N	Shell	0	Shell	1	2025-05-08	321
901	100153417	2025-05-12	2025-09-23 03:43:24.5	THE FRANKLIN THEATRE 05/09 PURCHASE FRANKLIN TN	Unknown	-18.8800	\N	THE FRANKLIN THEATRE 05/09 PURCHASE FRANKLIN TN	0	THE FRANKLIN THEATRE 05/09 PURCHASE FRANKLIN TN	1	2025-05-12	346
902	100153428	2025-05-12	2025-09-23 03:43:24.5	NSC*bobljop4s 05/10 MOBILE PURCHASE NASHVILLE TN	Unknown	-25.2100	\N	NSC*bobljop4s 05/10 MOBILE PURCHASE NASHVILLE TN	0	NSC*bobljop4s 05/10 MOBILE PURCHASE NASHVILLE TN	1	2025-05-12	230
903	100153211	2025-05-13	2025-08-31 13:03:28.28	The Dunkin Theatre	Entertainment	-11.8000	\N	The Dunkin Theatre	0	The Dunkin Theatre	1	2025-05-13	352
904	100153201	2025-05-15	2025-08-31 13:03:28.28	Circle K	Groceries	-100.0000	\N	Circle K	0	Circle K	1	2025-05-15	101
905	100153192	2025-05-16	2025-08-31 13:03:28.28	Cigna	Paychecks/Salary	4175.3800	32	Cigna	0	Cigna	1	2025-05-16	100
906	100153171	2025-05-19	2025-08-31 13:03:28.28	Purchase 0518 Sp Readingglasses Readingglassetx Xxxxx3451xxxxxxxxxx7261	Clothing/Shoes	-81.2100	\N	Purchase 0518 Sp Readingglasses Readingglassetx Xxxxx3451xxxxxxxxxx7261	0	Purchase 0518 Sp Readingglasses Readingglassetx Xxxxx3451xxxxxxxxxx7261	1	2025-05-19	283
907	100153182	2025-05-19	2025-08-31 13:03:28.28	Shell	Gasoline/Fuel	-5.0600	\N	Shell	0	Shell	1	2025-05-19	321
908	100153156	2025-05-21	2025-08-31 13:03:28.28	Purchase 0521 Aurora First, Inc. Aurorafirst.afl Xxxxx7751xxxxxxxxxx1202 Recurring	Online Services	-59.9900	\N	Purchase 0521 Aurora First, Inc. Aurorafirst.afl Xxxxx7751xxxxxxxxxx1202 Recurring	0	Purchase 0521 Aurora First, Inc. Aurorafirst.afl Xxxxx7751xxxxxxxxxx1202 Recurring	1	2025-05-21	284
909	100153150	2025-05-22	2025-08-31 13:03:28.28	Marco's Pizza	Restaurants	-34.9600	4	Marco's Pizza	0	Marco's Pizza	1	2025-05-22	213
910	100153106	2025-05-27	2025-08-31 13:03:28.28	Paypal	Transfers	-3.0000	115	Paypal	0	Paypal	1	2025-05-27	256
911	100153118	2025-05-27	2025-08-31 13:03:28.28	Amazon Digital Services	Entertainment	-14.2200	\N	Amazon Digital Services	0	Amazon Digital Services	1	2025-05-27	16
912	100153129	2025-05-27	2025-08-31 13:03:28.28	Checkcard 0523 Liberty Concession 1 Branson Mo Xxxxx7351xxxxxxxxxx2122	Travel	-15.8300	\N	Checkcard 0523 Liberty Concession 1 Branson Mo Xxxxx7351xxxxxxxxxx2122	0	Checkcard 0523 Liberty Concession 1 Branson Mo Xxxxx7351xxxxxxxxxx2122	1	2025-05-27	69
913	100153103	2025-05-28	2025-08-31 13:03:28.28	Publix	Groceries	-69.2900	\N	Publix	0	Publix	1	2025-05-28	268
914	100153098	2025-05-29	2025-08-31 13:03:28.28	Amazon Marketplace	General Merchandise	-10.9600	\N	Amazon Marketplace	0	Amazon Marketplace	1	2025-05-29	18
915	100153058	2025-06-02	2025-08-31 13:03:28.28	Lifetouch	Personal Care	-67.3500	\N	Lifetouch	0	Lifetouch	1	2025-06-02	203
916	100153069	2025-06-02	2025-08-31 13:03:28.28	Checkcard 0531 Sq *hop House Tennessee Franklin Tn Xxxxx1651xxxxxxxxxx4843	Restaurants	-137.2000	\N	Checkcard 0531 Sq *hop House Tennessee Franklin Tn Xxxxx1651xxxxxxxxxx4843	0	Checkcard 0531 Sq *hop House Tennessee Franklin Tn Xxxxx1651xxxxxxxxxx4843	1	2025-06-02	70
917	100153081	2025-06-02	2025-08-31 13:03:28.28	Netflix	Entertainment	-27.3600	\N	Netflix	0	Netflix	1	2025-06-02	237
918	100153051	2025-06-03	2025-08-31 13:03:28.28	Purchase 0603 Amazon Reta* N67b41ig2 Www.amazon.cowa Xxxxx3451xxxxxxxxxx7984	General Merchandise	-39.9100	\N	Purchase 0603 Amazon Reta* N67b41ig2 Www.amazon.cowa Xxxxx3451xxxxxxxxxx7984	0	Purchase 0603 Amazon Reta* N67b41ig2 Www.amazon.cowa Xxxxx3451xxxxxxxxxx7984	1	2025-06-03	285
919	100153441	2025-06-04	2025-09-23 04:14:01.693	TARGET T- 1701 06/04 PURCHASE Franklin TN	Unknown	-42.4700	\N	TARGET T- 1701 06/04 PURCHASE Franklin TN	0	TARGET T- 1701 06/04 PURCHASE Franklin TN	1	2025-06-04	344
920	100153036	2025-06-06	2025-08-31 13:03:28.28	Paypal	Transfers	-10.0000	115	Paypal	0	Paypal	1	2025-06-06	256
921	100153468	2025-06-09	2025-09-23 11:49:40.943	DD *DOORDASH URBANCOOK 06/06 PURCHASE DOORDASH.COM CA	Unknown	-17.0600	\N	DD *DOORDASH URBANCOOK 06/06 PURCHASE DOORDASH.COM CA	0	DD *DOORDASH URBANCOOK 06/06 PURCHASE DOORDASH.COM CA	1	2025-06-09	116
922	100153480	2025-06-09	2025-09-23 11:49:40.943	NWS A MOMENTS 06/09 PURCHASE FRANKLIN TN	Unknown	-90.0000	\N	NWS A MOMENTS 06/09 PURCHASE FRANKLIN TN	0	NWS A MOMENTS 06/09 PURCHASE FRANKLIN TN	1	2025-06-09	231
923	100153490	2025-06-10	2025-09-23 11:49:40.943	LIFE360.COM 06/09 PURCHASE LIFE360.COM CA	Unknown	-2.9900	\N	LIFE360.COM 06/09 PURCHASE LIFE360.COM CA	0	LIFE360.COM 06/09 PURCHASE LIFE360.COM CA	1	2025-06-10	196
924	100153502	2025-06-12	2025-09-23 11:49:40.943	PAYPAL *ATLANTA BRI ATL 06/09 PURCHASE XXXXX57733 CA	Unknown	-12.7700	\N	PAYPAL *ATLANTA BRI ATL 06/09 PURCHASE XXXXX57733 CA	0	PAYPAL *ATLANTA BRI ATL 06/09 PURCHASE XXXXX57733 CA	1	2025-06-12	245
925	100153513	2025-06-13	2025-09-23 11:49:40.943	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	Unknown	5407.3400	\N	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	0	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	1	2025-06-13	2
926	100153524	2025-06-16	2025-09-23 11:49:40.943	GOOGLE *Bend Stretchin 06/13 PURCHASE 855-836-3987 CA	Unknown	-26.3300	\N	GOOGLE *Bend Stretchin 06/13 PURCHASE 855-836-3987 CA	0	GOOGLE *Bend Stretchin 06/13 PURCHASE 855-836-3987 CA	1	2025-06-16	153
927	100153535	2025-06-16	2025-09-23 11:49:40.943	Walmart.com 06/15 PURCHASE Bentonville AR	Unknown	-33.4300	\N	Walmart.com 06/15 PURCHASE Bentonville AR	0	Walmart.com 06/15 PURCHASE Bentonville AR	1	2025-06-16	380
928	100153546	2025-06-16	2025-09-23 11:49:40.943	PAYPAL DES:INST XFER ID:DISCORD INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	Unknown	-10.9600	\N	PAYPAL DES:INST XFER ID:DISCORD INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	0	PAYPAL DES:INST XFER ID:DISCORD INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	1	2025-06-16	246
929	100153558	2025-06-18	2025-09-23 11:49:40.943	HANNAFORD #842 06/18 PURCHASE BRADFORD VT	Unknown	-137.3600	\N	HANNAFORD #842 06/18 PURCHASE BRADFORD VT	0	HANNAFORD #842 06/18 PURCHASE BRADFORD VT	1	2025-06-18	166
930	100153565	2025-06-20	2025-09-23 11:49:40.943	FOCUS XXXXX25750 06/18 PURCHASE FOCUS.ORG CO	Unknown	-75.0000	\N	FOCUS XXXXX25750 06/18 PURCHASE FOCUS.ORG CO	0	FOCUS XXXXX25750 06/18 PURCHASE FOCUS.ORG CO	1	2025-06-20	135
931	100153577	2025-06-20	2025-09-23 11:49:40.943	MCDONALD'S F35703 06/19 PURCHASE PLYMOUTH NH	Unknown	-38.5800	\N	MCDONALD'S F35703 06/19 PURCHASE PLYMOUTH NH	0	MCDONALD'S F35703 06/19 PURCHASE PLYMOUTH NH	1	2025-06-20	206
932	100153587	2025-06-23	2025-09-23 11:49:40.943	SHELL OIL XXXXX738336 06/19 PURCHASE FRANKLIN TN	Unknown	-5.1000	\N	SHELL OIL XXXXX738336 06/19 PURCHASE FRANKLIN TN	0	SHELL OIL XXXXX738336 06/19 PURCHASE FRANKLIN TN	1	2025-06-23	311
933	100153599	2025-06-23	2025-09-23 11:49:40.943	SHUFFS MUSIC 06/20 PURCHASE XXX-XX06139 TN	Unknown	-54.8800	\N	SHUFFS MUSIC 06/20 PURCHASE XXX-XX06139 TN	0	SHUFFS MUSIC 06/20 PURCHASE XXX-XX06139 TN	1	2025-06-23	312
934	100153610	2025-06-23	2025-09-23 11:49:40.943	DEPT EDUCATION DES:STUDENT LN ID:0000 INDN:NICOLE M CHARLEBOIS CO ID:XXXXX02007 PPD	Unknown	-120.9800	\N	DEPT EDUCATION DES:STUDENT LN ID:0000 INDN:NICOLE M CHARLEBOIS CO ID:XXXXX02007 PPD	0	DEPT EDUCATION DES:STUDENT LN ID:0000 INDN:NICOLE M CHARLEBOIS CO ID:XXXXX02007 PPD	1	2025-06-23	117
935	100153621	2025-06-24	2025-09-23 11:49:40.943	Knights of Columbus Bill Payment	Unknown	-189.1600	\N	Knights of Columbus Bill Payment	0	Knights of Columbus Bill Payment	1	2025-06-24	192
936	100153632	2025-06-25	2025-09-23 11:49:40.943	KNIGHTS OF COLUM DES:INS. PREM ID: INDN:JAKE WOODS CO ID:XXXXX16470 PPD	Unknown	-1231.1200	\N	KNIGHTS OF COLUM DES:INS. PREM ID: INDN:JAKE WOODS CO ID:XXXXX16470 PPD	0	KNIGHTS OF COLUM DES:INS. PREM ID: INDN:JAKE WOODS CO ID:XXXXX16470 PPD	1	2025-06-25	186
937	100153642	2025-06-27	2025-09-23 11:49:40.943	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	Unknown	5357.3400	\N	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	0	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	1	2025-06-27	2
938	100153654	2025-06-27	2025-09-23 11:49:40.943	FARMWAY I 286 06/27 PURCHASE BRADFORD VT	Unknown	-42.3500	\N	FARMWAY I 286 06/27 PURCHASE BRADFORD VT	0	FARMWAY I 286 06/27 PURCHASE BRADFORD VT	1	2025-06-27	134
939	100153014	2025-06-30	2025-08-31 13:03:28.28	Adobe	Online Services	-131.5700	\N	Adobe	0	Adobe	1	2025-06-30	11
940	100153026	2025-06-30	2025-08-31 13:03:28.28	Shell	Gasoline/Fuel	-38.0000	\N	Shell	0	Shell	1	2025-06-30	321
941	100152477	2025-07-01	2025-08-31 12:51:55.633	Musicnotes.com	Hobbies	-8.2100	\N	Musicnotes.com	0	Musicnotes.com	2	2025-07-01	228
942	100152990	2025-07-02	2025-08-31 13:03:28.28	Adt Security Services	Home Improvement	-67.0100	\N	Adt Security Services	0	Adt Security Services	1	2025-07-02	12
943	100152975	2025-07-03	2025-08-31 13:03:28.28	Starbucks	Restaurants	-10.0000	\N	Starbucks	0	Starbucks	1	2025-07-03	336
944	100152986	2025-07-03	2025-08-31 13:03:28.28	Chick-fil-a	Restaurants	-11.2900	\N	Chick-fil-a	0	Chick-fil-a	1	2025-07-03	99
945	100152941	2025-07-07	2025-08-31 13:03:28.28	Venmo	Transfers	-30.0000	\N	Venmo	0	Venmo	1	2025-07-07	373
946	100152952	2025-07-07	2025-08-31 13:03:28.28	Autozone	Automotive	-7.6700	\N	Autozone	0	Autozone	1	2025-07-07	33
987	100152519	2025-08-29	2025-08-31 13:03:28.28	Checkcard 0829 Gdp*greekcafeg Franklin Tn	Restaurants	-18.4200	\N	Checkcard 0829 Gdp*greekcafeg Franklin Tn	0	Checkcard 0829 Gdp*greekcafeg Franklin Tn	1	2025-08-29	85
947	100152964	2025-07-07	2025-08-31 13:03:28.28	Checkcard 0704 Google *all In Hole Xxx-xxx-3987 Ca Xxxxx1651xxxxxxxxxx7866	Online Services	-32.9100	\N	Checkcard 0704 Google *all In Hole Xxx-xxx-3987 Ca Xxxxx1651xxxxxxxxxx7866	0	Checkcard 0704 Google *all In Hole Xxx-xxx-3987 Ca Xxxxx1651xxxxxxxxxx7866	1	2025-07-07	71
948	100152924	2025-07-08	2025-08-31 13:03:28.28	Publix	Groceries	-156.1800	\N	Publix	0	Publix	1	2025-07-08	268
949	100152921	2025-07-09	2025-08-31 13:03:28.28	Amazon Digital Services	Entertainment	-9.8400	\N	Amazon Digital Services	0	Amazon Digital Services	1	2025-07-09	16
950	100152903	2025-07-11	2025-08-31 13:03:28.28	Wasabi Technologies	Electronics	-10.0600	\N	Wasabi Technologies	0	Wasabi Technologies	1	2025-07-11	382
951	100152887	2025-07-14	2025-08-31 13:03:28.28	Paypal	Transfers	-178.8800	115	Paypal	0	Paypal	1	2025-07-14	256
952	100152898	2025-07-14	2025-08-31 13:03:28.28	Purchase 0711 Gloss* Trimmed & Tailo Kaylavaughn.gtn Xxxxx6651xxxxxxxxxx5269 Recurring	Personal Care	-67.6500	\N	Purchase 0711 Gloss* Trimmed & Tailo Kaylavaughn.gtn Xxxxx6651xxxxxxxxxx5269 Recurring	0	Purchase 0711 Gloss* Trimmed & Tailo Kaylavaughn.gtn Xxxxx6651xxxxxxxxxx5269 Recurring	1	2025-07-14	288
953	100152879	2025-07-15	2025-08-31 13:03:28.28	Purchase 0714 Change.org Change.org Ca Xxxxx7751xxxxxxxxxx1143 Recurring	Online Services	-8.0000	\N	Purchase 0714 Change.org Change.org Ca Xxxxx7751xxxxxxxxxx1143 Recurring	0	Purchase 0714 Change.org Change.org Ca Xxxxx7751xxxxxxxxxx1143 Recurring	1	2025-07-15	289
954	100152870	2025-07-16	2025-08-31 13:03:28.28	Amazon Marketplace	General Merchandise	-39.5000	\N	Amazon Marketplace	0	Amazon Marketplace	1	2025-07-16	18
955	100152862	2025-07-17	2025-08-31 13:03:28.28	Great Clips	Personal Care	-25.0000	\N	Great Clips	0	Great Clips	1	2025-07-17	163
956	100152469	2025-07-19	2025-08-31 12:51:55.633	Audible	Hobbies	-16.3700	21	Audible	0	Audible	2	2025-07-19	31
957	100152826	2025-07-21	2025-08-31 13:03:28.28	Dairy Queen	Restaurants	-7.1100	\N	Dairy Queen	0	Dairy Queen	1	2025-07-21	119
958	100152838	2025-07-21	2025-08-31 13:03:28.28	Mobile Purchase 0719 Levy@2nashfairgrnd Nashville Tn Xxxxx9752xxxxxxxxxx1748	Restaurants	-12.4600	\N	Mobile Purchase 0719 Levy@2nashfairgrnd Nashville Tn Xxxxx9752xxxxxxxxxx1748	0	Mobile Purchase 0719 Levy@2nashfairgrnd Nashville Tn Xxxxx9752xxxxxxxxxx1748	1	2025-07-21	224
959	100152849	2025-07-21	2025-08-31 13:03:28.28	Purchase 0718 Focus Xxxxxx5750 Focus.org Co Xxxxx1651xxxxxxxxxx9852 Recurring	Online Services	-75.0000	\N	Purchase 0718 Focus Xxxxxx5750 Focus.org Co Xxxxx1651xxxxxxxxxx9852 Recurring	0	Purchase 0718 Focus Xxxxxx5750 Focus.org Co Xxxxx1651xxxxxxxxxx9852 Recurring	1	2025-07-21	290
960	100152815	2025-07-22	2025-08-31 13:03:28.28	Kaffe.org	Cable/Satellite	-26.3400	\N	Kaffe.org	0	Kaffe.org	1	2025-07-22	187
961	100152794	2025-07-24	2025-08-31 13:03:28.28	The Protein Bar	Restaurants	-25.7900	\N	The Protein Bar	0	The Protein Bar	1	2025-07-24	356
962	100152786	2025-07-25	2025-08-31 13:03:28.28	Disney Plus	Entertainment	-17.5100	21	Disney Plus	0	Disney Plus	1	2025-07-25	122
963	100152747	2025-07-28	2025-08-31 13:03:28.28	Synchrony Bank	Credit Card Payments	-500.0000	\N	Synchrony Bank	0	Synchrony Bank	1	2025-07-28	343
964	100152758	2025-07-28	2025-08-31 13:03:28.28	Sam's Club	General Merchandise	-81.0800	\N	Sam's Club	0	Sam's Club	1	2025-07-28	315
965	100152770	2025-07-28	2025-08-31 13:03:28.28	Publix	Groceries	-5.0000	\N	Publix	0	Publix	1	2025-07-28	268
966	100152781	2025-07-28	2025-08-31 13:03:28.28	Checkcard 0724 Toccoa Riverside Restau Blue Ridge Ga Xxxxx6152xxxxxxxxxx0442	Restaurants	-6.6400	\N	Checkcard 0724 Toccoa Riverside Restau Blue Ridge Ga Xxxxx6152xxxxxxxxxx0442	0	Checkcard 0724 Toccoa Riverside Restau Blue Ridge Ga Xxxxx6152xxxxxxxxxx0442	1	2025-07-28	79
967	100152736	2025-07-30	2025-08-31 13:03:28.28	Publix	Groceries	-7.0300	\N	Publix	0	Publix	1	2025-07-30	268
968	100152722	2025-08-01	2025-08-31 13:03:28.28	Checkcard 0731 Sq *southeastern Swim S Franklin Tn Xxxxx1652xxxxxxxxxx1147	Other Expenses	-15.2800	\N	Checkcard 0731 Sq *southeastern Swim S Franklin Tn Xxxxx1652xxxxxxxxxx1147	0	Checkcard 0731 Sq *southeastern Swim S Franklin Tn Xxxxx1652xxxxxxxxxx1147	1	2025-08-01	80
969	100152693	2025-08-04	2025-08-31 13:03:28.28	Fandango	Entertainment	-74.5500	\N	Fandango	0	Fandango	1	2025-08-04	138
970	100152705	2025-08-04	2025-08-31 13:03:28.28	Circle K	Groceries	-50.9100	\N	Circle K	0	Circle K	1	2025-08-04	101
971	100152716	2025-08-04	2025-08-31 13:03:28.28	Amazon	General Merchandise	-51.7100	\N	Amazon	0	Amazon	1	2025-08-04	15
972	100152678	2025-08-06	2025-08-31 13:03:28.28	Thevocalacademy. Des:thevocalac Id:st-n1l0q6e2q7z9 Indn:jake Woods Co Id:xxxxxx5600 Web	Clothing/Shoes	-120.0000	\N	Thevocalacademy. Des:thevocalac Id:st-n1l0q6e2q7z9 Indn:jake Woods Co Id:xxxxxx5600 Web	0	Thevocalacademy. Des:thevocalac Id:st-n1l0q6e2q7z9 Indn:jake Woods Co Id:xxxxxx5600 Web	1	2025-08-06	359
973	100152672	2025-08-07	2025-08-31 13:03:28.28	Purchase 0806 Amazon Digi* Ne8mi14m2 Www.amazon.cowa Xxxxx3452xxxxxxxxxx4846	General Merchandise	-21.8900	\N	Purchase 0806 Amazon Digi* Ne8mi14m2 Www.amazon.cowa Xxxxx3452xxxxxxxxxx4846	0	Purchase 0806 Amazon Digi* Ne8mi14m2 Www.amazon.cowa Xxxxx3452xxxxxxxxxx4846	1	2025-08-07	292
974	100152642	2025-08-11	2025-08-31 13:03:28.28	Knights Of Columbus Insurance	Charitable Giving	-366.0000	\N	Knights Of Columbus Insurance	0	Knights Of Columbus Insurance	1	2025-08-11	191
975	100152653	2025-08-11	2025-08-31 13:03:28.28	Life360	Home Maintenance	-2.9900	\N	Life360	0	Life360	1	2025-08-11	202
976	100152638	2025-08-12	2025-08-31 13:03:28.28	Bank Of America	Deposits	50.0000	\N	Bank Of America	0	Bank Of America	1	2025-08-12	34
977	100152626	2025-08-14	2025-08-31 13:03:28.28	Checkcard 0813 Sq *primitive Coffee Co Nashville Tn Xxxxx1652xxxxxxxxxx2496	Restaurants	-5.3900	\N	Checkcard 0813 Sq *primitive Coffee Co Nashville Tn Xxxxx1652xxxxxxxxxx2496	0	Checkcard 0813 Sq *primitive Coffee Co Nashville Tn Xxxxx1652xxxxxxxxxx2496	1	2025-08-14	82
978	100152620	2025-08-15	2025-08-31 13:03:28.28	Coffeehouse Northwest	Restaurants	-8.1300	\N	Coffeehouse Northwest	0	Coffeehouse Northwest	1	2025-08-15	107
979	100152600	2025-08-18	2025-08-31 13:03:28.28	Purchase 0817 Sp Zquiet Zquiet.com Vt Xxxxx1652xxxxxxxxxx2068	Other Expenses	-55.9300	\N	Purchase 0817 Sp Zquiet Zquiet.com Vt Xxxxx1652xxxxxxxxxx2068	0	Purchase 0817 Sp Zquiet Zquiet.com Vt Xxxxx1652xxxxxxxxxx2068	1	2025-08-18	293
980	100152611	2025-08-18	2025-08-31 13:03:28.28	Chatgpt	Online Services	-21.9400	\N	Chatgpt	0	Chatgpt	1	2025-08-18	53
981	100152581	2025-08-20	2025-08-31 13:03:28.28	Sam's Club	General Merchandise	-21.8400	\N	Sam's Club	0	Sam's Club	1	2025-08-20	315
982	100152577	2025-08-21	2025-08-31 13:03:28.28	Experian	Online Services	-24.9900	\N	Experian	0	Experian	1	2025-08-21	133
983	100152545	2025-08-25	2025-08-31 13:03:28.28	Publix	Groceries	-99.7300	\N	Publix	0	Publix	1	2025-08-25	268
984	100152556	2025-08-25	2025-08-31 13:03:28.28	Purchase 0823 Wyndy Wyndy.com Al Xxxxx6652xxxxxxxxxx2463	Other Expenses	-184.8000	\N	Purchase 0823 Wyndy Wyndy.com Al Xxxxx6652xxxxxxxxxx2463	0	Purchase 0823 Wyndy Wyndy.com Al Xxxxx6652xxxxxxxxxx2463	1	2025-08-25	295
985	100152537	2025-08-26	2025-08-31 13:03:28.28	Venmo	Transfers	-120.0000	\N	Venmo	0	Venmo	1	2025-08-26	373
986	100152533	2025-08-27	2025-08-31 13:03:28.28	Apple	Electronics	-2.9900	\N	Apple	0	Apple	1	2025-08-27	26
988	100153674	2025-09-02	2025-09-23 12:04:36.21	IKEA MEMPHIS 08/30 MOBILE PURCHASE CORDOVA TN	Unknown	-27.4700	\N	IKEA MEMPHIS 08/30 MOBILE PURCHASE CORDOVA TN	0	IKEA MEMPHIS 08/30 MOBILE PURCHASE CORDOVA TN	1	2025-09-02	176
989	100153685	2025-09-02	2025-09-23 12:04:36.21	PUBLIX #160 08/31 MOBILE PURCHASE FRANKLIN TN	Unknown	-84.8300	\N	PUBLIX #160 08/31 MOBILE PURCHASE FRANKLIN TN	0	PUBLIX #160 08/31 MOBILE PURCHASE FRANKLIN TN	1	2025-09-02	249
990	100153697	2025-09-02	2025-09-23 12:04:36.21	MIDDLE TENN EMC DES:BKDraft ID:XXXXX80424 INDN:NICOLE WOODS CO ID:XXXXX93472 PPD	Unknown	-266.0000	\N	MIDDLE TENN EMC DES:BKDraft ID:XXXXX80424 INDN:NICOLE WOODS CO ID:XXXXX93472 PPD	0	MIDDLE TENN EMC DES:BKDraft ID:XXXXX80424 INDN:NICOLE WOODS CO ID:XXXXX93472 PPD	1	2025-09-02	207
991	100153708	2025-09-02	2025-09-23 12:04:36.21	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	Unknown	-10.0000	\N	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	0	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	1	2025-09-02	248
992	100153720	2025-09-03	2025-09-23 12:04:36.21	WTFJHT NEWSLETTER 09/02 PURCHASE WHATTHEFUCKJU WA	Unknown	-5.0000	\N	WTFJHT NEWSLETTER 09/02 PURCHASE WHATTHEFUCKJU WA	0	WTFJHT NEWSLETTER 09/02 PURCHASE WHATTHEFUCKJU WA	1	2025-09-03	375
993	100153731	2025-09-05	2025-09-23 12:04:36.21	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	Unknown	-10.0000	\N	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	0	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	1	2025-09-05	248
994	100153742	2025-09-08	2025-09-23 12:04:36.21	SQ *THE FAINTING GOAT C 09/07 MOBILE PURCHASE Franklin TN	Unknown	-17.4900	\N	SQ *THE FAINTING GOAT C 09/07 MOBILE PURCHASE Franklin TN	0	SQ *THE FAINTING GOAT C 09/07 MOBILE PURCHASE Franklin TN	1	2025-09-08	313
995	100153754	2025-09-08	2025-09-23 12:04:36.21	PAYPAL DES:INST XFER ID:SPOTIFY*P3A4B31 INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	Unknown	-18.6000	\N	PAYPAL DES:INST XFER ID:SPOTIFY*P3A4B31 INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	0	PAYPAL DES:INST XFER ID:SPOTIFY*P3A4B31 INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	1	2025-09-08	247
996	100153765	2025-09-10	2025-09-23 12:04:36.21	TILE / LIFE360 09/09 PURCHASE LIFE360.COM CA	Unknown	-2.9900	\N	TILE / LIFE360 09/09 PURCHASE LIFE360.COM CA	0	TILE / LIFE360 09/09 PURCHASE LIFE360.COM CA	1	2025-09-10	347
997	100153777	2025-09-15	2025-09-23 12:04:36.21	AMAZON RETA* 0A89Q3OJ3 09/11 PURCHASE WWW.AMAZON.CO WA	Unknown	-38.4800	\N	AMAZON RETA* 0A89Q3OJ3 09/11 PURCHASE WWW.AMAZON.CO WA	0	AMAZON RETA* 0A89Q3OJ3 09/11 PURCHASE WWW.AMAZON.CO WA	1	2025-09-15	4
998	100153788	2025-09-15	2025-09-23 12:04:36.21	FRANKLIN BAKEHOUSE 09/14 PURCHASE FRANKLIN TN	Unknown	-10.2800	\N	FRANKLIN BAKEHOUSE 09/14 PURCHASE FRANKLIN TN	0	FRANKLIN BAKEHOUSE 09/14 PURCHASE FRANKLIN TN	1	2025-09-15	136
999	100153800	2025-09-16	2025-09-23 12:04:36.21	CRMLAWN.COM DES:CRMLAWN.CO ID:ST-Y4Y4X7X0W0R0 INDN:CRM LAWN CARE LANDSCAP CO ID:XXXXX65600 CCD	Unknown	-88.0000	\N	CRMLAWN.COM DES:CRMLAWN.CO ID:ST-Y4Y4X7X0W0R0 INDN:CRM LAWN CARE LANDSCAP CO ID:XXXXX65600 CCD	0	CRMLAWN.COM DES:CRMLAWN.CO ID:ST-Y4Y4X7X0W0R0 INDN:CRM LAWN CARE LANDSCAP CO ID:XXXXX65600 CCD	1	2025-09-16	49
1000	100153811	2025-09-18	2025-09-23 12:04:36.21	GLOSS* TRIMMED & TAILO 09/17 PURCHASE KAYLAVAUGHN.G TN	Unknown	-70.4700	\N	GLOSS* TRIMMED & TAILO 09/17 PURCHASE KAYLAVAUGHN.G TN	0	GLOSS* TRIMMED & TAILO 09/17 PURCHASE KAYLAVAUGHN.G TN	1	2025-09-18	152
\.


--
-- Data for Name: category_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category_rules (id, payee_id, spending_category_id, source, created_at) FROM stdin;
1	1	1	import	2026-07-10 17:49:40.521029
2	3	20	import	2026-07-10 17:49:40.521029
3	6	90	import	2026-07-10 17:49:40.521029
4	7	89	import	2026-07-10 17:49:40.521029
5	8	1160	import	2026-07-10 17:49:40.521029
6	9	32	import	2026-07-10 17:49:40.521029
7	16	21	import	2026-07-10 17:49:40.521029
8	17	21	import	2026-07-10 17:49:40.521029
9	19	21	import	2026-07-10 17:49:40.521029
10	20	1160	import	2026-07-10 17:49:40.521029
11	21	9	import	2026-07-10 17:49:40.521029
12	25	90	import	2026-07-10 17:49:40.521029
13	28	89	import	2026-07-10 17:49:40.521029
14	30	19	import	2026-07-10 17:49:40.521029
15	31	21	import	2026-07-10 17:49:40.521029
16	48	20	import	2026-07-10 17:49:40.521029
17	51	108	import	2026-07-10 17:49:40.521029
18	102	1137	import	2026-07-10 17:49:40.521029
19	111	1142	import	2026-07-10 17:49:40.521029
20	113	57	import	2026-07-10 17:49:40.521029
21	122	21	import	2026-07-10 17:49:40.521029
22	140	66	import	2026-07-10 17:49:40.521029
23	174	1161	import	2026-07-10 17:49:40.521029
24	181	90	import	2026-07-10 17:49:40.521029
25	213	4	import	2026-07-10 17:49:40.521029
26	221	19	import	2026-07-10 17:49:40.521029
27	256	115	import	2026-07-10 17:49:40.521029
28	267	35	import	2026-07-10 17:49:40.521029
29	334	3	import	2026-07-10 17:49:40.521029
30	370	24	import	2026-07-10 17:49:40.521029
31	374	67	import	2026-07-10 17:49:40.521029
32	385	3	import	2026-07-10 17:49:40.521029
33	388	128	import	2026-07-10 17:49:40.521029
34	391	3	import	2026-07-10 17:49:40.521029
\.


--
-- Data for Name: category_split_details; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category_split_details (id, external_id, bank_transaction_id, spending_category_id, split_amount) FROM stdin;
1	10690	496	1160	-95.0000
2	10691	496	1160	-95.0000
3	10692	518	1160	-95.0000
4	10693	518	1160	-95.0000
\.


--
-- Data for Name: payee_aliases; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payee_aliases (id, payee_id, raw_text, source) FROM stdin;
1	1	7-eleven	import
2	2	ADHEREHEALTH SOL DES:PAYROLL ID:12V05 A0A50CJP1 INDN:WOODS, JAKE CO ID:XXXXX34033 PPD	import
3	3	ADT Security	import
4	4	AMAZON RETA* 0A89Q3OJ3 09/11 PURCHASE WWW.AMAZON.CO WA	import
5	5	AT&T	import
6	6	AT.com	import
7	7	Academy of Managed Care Pharmacy	import
8	8	Act Too Players	import
9	9	AdhereHealth	import
10	10	Adherehealth Sol Des:payroll Id:12v05 A0a50cjp1 Indn:woods, Jake Co Id:xxxxxx4033 Ppd	import
11	11	Adobe	import
12	12	Adt Security Services	import
13	13	Adventure Science	import
14	14	Alltrails	import
15	15	Amazon	import
16	16	Amazon Digital Services	import
17	17	Amazon Kids+	import
18	18	Amazon Marketplace	import
19	19	Amazon Music	import
20	20	Amazon Prime Video	import
21	21	Amazon Web Services	import
22	22	Amazon.com	import
23	23	Amc Theatres	import
24	24	Ann Taylor	import
25	25	Annual Membership Fee	import
26	26	Apple	import
27	27	Apple.com	import
28	28	Association for Computing Machinery	import
29	29	At&t	import
30	30	Atmos Energy	import
31	31	Audible	import
32	32	Automatic Payment - Thank	import
33	33	Autozone	import
34	34	Bank Of America	import
35	35	Barnes & Noble	import
36	36	Beam Smile Design	import
37	37	Beast	import
38	38	Bed Bath & Beyond	import
39	39	Boyd Mill Estate Des:funding Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	import
40	40	Boyd Mill Estate Des:vendor Pay Id:xxx-xxx-1411 Indn:jake & Nicole Woods Co Id:xxxxxx3633 Web	import
41	41	Brentwood Counseling	import
42	42	Brentwood Skate Center	import
43	43	Brewhouse South	import
44	44	Brightstone	import
45	45	Buc-ee's	import
46	46	Burger Up	import
47	47	CB Sports Photography	import
48	48	CRM Lawn Care	import
49	49	CRMLAWN.COM DES:CRMLAWN.CO ID:ST-Y4Y4X7X0W0R0 INDN:CRM LAWN CARE LANDSCAP CO ID:XXXXX65600 CCD	import
50	50	Car Max	import
51	51	CarMax	import
52	52	Char Green Hills	import
53	53	Chatgpt	import
54	54	Check 1750	import
55	55	Check 1984	import
56	56	Check Xxxxxxx2031	import
57	57	Checkcard 0215 Frist Art Museum Xxx-xxx3325 Tn Xxxxx6650xxxxxxxxxx1570	import
58	58	Checkcard 0219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3050xxxxxxxxxx4469 Recurring	import
59	59	Checkcard 0308 Swr*franklindermatology Xxx-xxx-1881 Tn Xxxxx0050xxxxxxxxxx6652	import
60	60	Checkcard 0309 Cac* Childrens Art Www.childrenstn Xxxxx6650xxxxxxxxxx4241 Recurring	import
61	61	Checkcard 0322 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx0906	import
62	62	Checkcard 0329 Gloss* Trimmed & Tail. Httpskaylavautn Xxxxx4540xxxxxxxxxx7226 Recurring	import
63	63	Checkcard 0406 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3940xxxxxxxxxx6770	import
64	64	Checkcard 0410 Sirvezas At Skyharbor Xxx-xxx8226 Az Xxxxx4541xxxxxxxxxx1171	import
65	65	Checkcard 0414 Sq *hop House Tennessee Franklin Tn Xxxxx1641xxxxxxxxxx4368	import
66	66	Checkcard 0422 Moab Bicycle Shop-frank Franklin Tn Xxxxx5941xxxxxxxxxx2165	import
67	67	Checkcard 0425 Icp*safesplash Swimlabs Xxx-xxx9001 Tn Xxxxx4151xxxxxxxxxx7360	import
68	68	Checkcard 0427 Tst* Salsa Franklin Tac Franklin Tn Xxxxx4651xxxxxxxxxx7277	import
69	69	Checkcard 0523 Liberty Concession 1 Branson Mo Xxxxx7351xxxxxxxxxx2122	import
70	70	Checkcard 0531 Sq *hop House Tennessee Franklin Tn Xxxxx1651xxxxxxxxxx4843	import
71	71	Checkcard 0704 Google *all In Hole Xxx-xxx-3987 Ca Xxxxx1651xxxxxxxxxx7866	import
72	72	Checkcard 0706 Mlnp, Llc Xxx-xxx0440 Ny Xxxxx7941xxxxxxxxxx8751	import
73	73	Checkcard 0713 Red Parka Pub Xxx-xxx4344 Nh Xxxxx9741xxxxxxxxxx1382	import
74	74	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966	import
75	75	Checkcard 0719 Sq *the Bagel Class Montreal Qc Xxxxx7420xxxxxxxxxx7966 International Transaction Fee	import
76	76	Checkcard 0721 Iga 8217 Montreal Qc Xxxxx0042xxxxxxxxxx2209 International Transaction Fee	import
77	77	Checkcard 0721 La Grande Roue De Mont Montreal Qc Xxxxx0142xxxxxxxxxx0165 International Transaction Fee	import
78	78	Checkcard 0722 Agence De Mobilite Dura Montreal Qc Xxxxx4942xxxxxxxxxx4569	import
79	79	Checkcard 0724 Toccoa Riverside Restau Blue Ridge Ga Xxxxx6152xxxxxxxxxx0442	import
80	80	Checkcard 0731 Sq *southeastern Swim S Franklin Tn Xxxxx1652xxxxxxxxxx1147	import
81	81	Checkcard 0806 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx7294 Recurring	import
82	82	Checkcard 0813 Sq *primitive Coffee Co Nashville Tn Xxxxx1652xxxxxxxxxx2496	import
83	83	Checkcard 0819 Shuffs Music Xxx-xxx6139 Tn Xxxxx3042xxxxxxxxxx8557 Recurring	import
84	84	Checkcard 0828 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx9882 Recurring	import
85	85	Checkcard 0829 Gdp*greekcafeg Franklin Tn	import
86	86	Checkcard 0921 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3942xxxxxxxxxx3732	import
87	87	Checkcard 0926 Vcn*cofpaymentsdept Xxx-xxx-1857 Tn Xxxxx0042xxxxxxxxxx5458	import
88	88	Checkcard 0929 Thevocalacademy.co Thevocalacadetn Xxxxx3442xxxxxxxxxx0597 Recurring	import
89	89	Checkcard 1022 Culamar Franklin Tn Xxxxx8542xxxxxxxxxx1662	import
90	90	Checkcard 1026 Williamson Co Sch Food Xxx-xxx4992 Tn Xxxxx3943xxxxxxxxxx2238	import
203	203	Lifetouch	import
204	204	Lowe's	import
91	91	Checkcard 1116 Tst* M.l. Rose Craft Be Franklin Tn Xxxxx4643xxxxxxxxxx7965	import
92	92	Checkcard 1207 Duke Mailorder Web Xxx-xxx3764 Nc Xxxxx4233xxxxxxxxxx5349	import
93	93	Checkcard 1219 Shuffs Music Xxx-xxx6139 Tn Xxxxx3043xxxxxxxxxx1487 Recurring	import
94	94	Checkcard Xxxx 4017 Jnn Germantown Cordova Tn Xxxxx3933xxxxxxxxxx3803	import
95	95	Checkcard Xxxx Xxxx 4693 Quebec Inc Montreal Qc Xxxxx7142xxxxxxxxxx4926 International Transaction Fee	import
96	96	Chewy	import
97	97	Chicago Transit Authority	import
98	98	Chick-fil-A	import
99	99	Chick-fil-a	import
100	100	Cigna	import
101	101	Circle K	import
102	102	City of Franklin	import
103	103	Cns The Childr 11/09 #xxxxx7636 Purchase 1800 Galleria Blv Franklin Tn	import
104	104	Cns The Childr 12/18 #xxxxx5097 Purchase 1800 Galleria Blv Franklin Tn	import
105	105	Coa Parking Passport	import
106	106	Coal Town Pizza	import
107	107	Coffeehouse Northwest	import
108	108	Comcast	import
109	109	Cook's Pest Control	import
110	110	Cook's Pest Nash Des:cooks Pest Id: Indn:nicole Woods Co Id:xxxxxx1064 Ppd	import
111	111	Cool Springs Wines and Spirits	import
112	112	Coursera	import
113	113	Credit Card Payment	import
114	114	Crmlawn.com Des:crmlawn.co Id:st-h2i8t7a8n4z6 Indn:crm Lawn Care Landscap Co Id:xxxxxx8598 Ccd	import
115	115	Cvs Pharmacy	import
116	116	DD *DOORDASH URBANCOOK 06/06 PURCHASE DOORDASH.COM CA	import
117	117	DEPT EDUCATION DES:STUDENT LN ID:0000 INDN:NICOLE M CHARLEBOIS CO ID:XXXXX02007 PPD	import
118	118	DUNKIN #349816 Q35 01/20 PURCHASE FRANKLIN TN	import
119	119	Dairy Queen	import
120	120	Dc Govt	import
121	121	Dillard's	import
122	122	Disney Plus	import
123	123	Dollar General	import
124	124	Dollar Shave Club	import
125	125	Dollar Tree	import
126	126	Donut Den	import
127	127	Double Good Popcorn	import
128	128	Dr.hammondswhite	import
129	129	Dsw	import
130	130	Dunkin' Donuts	import
131	131	Ebay	import
132	132	Elevate Labs	import
133	133	Experian	import
134	134	FARMWAY I 286 06/27 PURCHASE BRADFORD VT	import
135	135	FOCUS XXXXX25750 06/18 PURCHASE FOCUS.ORG CO	import
136	136	FRANKLIN BAKEHOUSE 09/14 PURCHASE FRANKLIN TN	import
137	137	Facebook	import
138	138	Fandango	import
139	139	Firestone Auto Center	import
140	140	Firestone Credit Card	import
141	141	First American Financial Corporation	import
142	142	First Fidelity 04/10 #xxxxx4695 Withdrwl 7401 E Camelback Scottsdale Az Fee	import
143	143	Focus	import
144	144	Focusxxxxxx7373 Des:payments Id:a101a1d8d Indn:jake Woods Co Id:xxxxxx2248 Ppd	import
145	145	Focusxxxxxx7373 Des:payments Id:a107dce99 Indn:jake Woods Co Id:xxxxxx2248 Ppd	import
146	146	Focusxxxxxx7373 Des:payments Id:a10a5c269 Indn:jake Woods Co Id:xxxxxx2248 Ppd	import
147	147	Foxtrot Market	import
148	148	Franklin Bakehouse	import
149	149	Franklin Cleaners	import
150	150	Franklin Dermatology Group	import
151	151	Full Circle Counseling	import
152	152	GLOSS* TRIMMED & TAILO 09/17 PURCHASE KAYLAVAUGHN.G TN	import
153	153	GOOGLE *Bend Stretchin 06/13 PURCHASE 855-836-3987 CA	import
154	154	Gabe's	import
155	155	Garmin	import
156	156	Goblin And The Grocer	import
157	157	Goodwill	import
158	158	Google Cloud Storage	import
159	159	Google One	import
160	160	Google Play	import
161	161	Grailr	import
162	162	Gray's On Main	import
163	163	Great Clips	import
164	164	Greenlight Financial Technology	import
165	165	Gumroad	import
166	166	HANNAFORD #842 06/18 PURCHASE BRADFORD VT	import
167	167	Hannah Anders	import
168	168	Happily	import
169	169	Harpeth School of Gymnastics	import
170	170	Heifer International	import
171	171	Home Grown	import
172	172	Hop House	import
173	173	Hunters Bend Elementary	import
174	174	Hunters Bend Elementary School	import
175	175	Hunters Bend PTO	import
176	176	IKEA MEMPHIS 08/30 MOBILE PURCHASE CORDOVA TN	import
177	177	Icp*let It Shine Gymnasti	import
178	178	Ikea	import
179	179	Instacart	import
180	180	Interest Paid	import
181	181	International Transaction Fee	import
182	182	Jersey Mike's Subs	import
183	183	Jewel Osco	import
184	184	Jpmorgan	import
185	185	Justice Industries	import
186	186	KNIGHTS OF COLUM DES:INS. PREM ID: INDN:JAKE WOODS CO ID:XXXXX16470 PPD	import
187	187	Kaffe.org	import
188	188	Keurig	import
189	189	Kickstarter	import
190	190	Klarna	import
191	191	Knights Of Columbus Insurance	import
192	192	Knights of Columbus Bill Payment	import
193	193	Knights of Columbus Insurance	import
194	194	Krispy Kreme	import
195	195	Kroger	import
196	196	LIFE360.COM 06/09 PURCHASE LIFE360.COM CA	import
197	197	Landmark	import
198	198	Lands' End	import
199	199	Les 3 Brasseurs	import
200	200	Let it Shine Gymnastics	import
201	201	Leveret Clothing	import
202	202	Life360	import
205	205	M22	import
206	206	MCDONALD'S F35703 06/19 PURCHASE PLYMOUTH NH	import
207	207	MIDDLE TENN EMC DES:BKDraft ID:XXXXX80424 INDN:NICOLE WOODS CO ID:XXXXX93472 PPD	import
208	208	Macadoodles	import
209	209	Macy's	import
210	210	Main Street Market	import
211	211	Mapco Express	import
212	212	Marcin Wasielews	import
213	213	Marco's Pizza	import
214	214	Market Basket	import
215	215	Marriott International	import
216	216	Mcdonald's	import
217	217	Medium	import
218	218	Meijer	import
219	219	Metropolis Parking	import
220	220	Microsoft	import
221	221	Middle Tennessee Electric	import
222	222	Mobile Purchase 0222 Levy@2nashfairgrnd Nashville Tn Xxxxx9750xxxxxxxxxx6981	import
223	223	Mobile Purchase 0228 Corkys Bbq - Brentwood Brentwood Tn Xxxxx0450xxxxxxxxxx1516	import
224	224	Mobile Purchase 0719 Levy@2nashfairgrnd Nashville Tn Xxxxx9752xxxxxxxxxx1748	import
225	225	Mobile Purchase 1020 Nnt Franklin B Franklin Tn	import
226	226	Mohela	import
227	227	Muah Cotton Candy	import
228	228	Musicnotes.com	import
229	229	My School Bucks Lunch Account	import
230	230	NSC*bobljop4s 05/10 MOBILE PURCHASE NASHVILLE TN	import
231	231	NWS A MOMENTS 06/09 PURCHASE FRANKLIN TN	import
232	232	Nash Public Radi Des:donations Id:xx-xxxxxxxx-011 Indn:woods Jake Co Id:xxxxxx1652 Ppd	import
233	233	Nashville Public Radio	import
234	234	Nashville Violins	import
235	235	Navient	import
236	236	Navient Corporation	import
237	237	Netflix	import
238	238	New York Times	import
239	239	Newrez	import
240	240	Nintendo	import
241	241	Nnt Franklin B 10/13 #xxxxx1004 Purchase 100 E Main St Franklin Tn	import
242	242	Northwestern Mutual	import
243	243	Nuts.com	import
244	244	Office Depot	import
245	245	PAYPAL *ATLANTA BRI ATL 06/09 PURCHASE XXXXX57733 CA	import
246	246	PAYPAL DES:INST XFER ID:DISCORD INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	import
247	247	PAYPAL DES:INST XFER ID:SPOTIFY*P3A4B31 INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	import
248	248	PAYPAL DES:INST XFER ID:STARBUCKS INDN:JAKE WOODS CO ID:PAYPALSI77 WEB	import
249	249	PUBLIX #160 08/31 MOBILE PURCHASE FRANKLIN TN	import
250	250	Panera Bread	import
251	251	Parkmobile	import
252	252	Parnassus Books	import
253	253	Party City	import
254	254	Patreon	import
255	255	Payment Thank You-mobile	import
256	256	Paypal	import
257	257	Paypal *berne App	import
258	258	Paypal *felacia	import
259	259	Paypal *globalfundf	import
260	260	Paypal Des:inst Xfer Id:specialolym Indn:jake Woods Co Id:paypalsi77 Web	import
261	261	Paypal Des:inst Xfer Id:ticketmaste Tic Indn:jake Woods Co Id:paypalsi77 Web	import
262	262	Peloton Cycles	import
263	263	Pilot Flying J	import
264	264	Pixowl Inc	import
265	265	Pods	import
266	266	Property Tax - City of Franklin/Williamson County	import
267	267	Protective Life	import
268	268	Publix	import
269	269	Puckett's	import
270	270	Puma	import
271	271	Purchase 0115 Amazon Reta* Zd9lz67s1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0821	import
272	272	Purchase 0202 Amazon Reta* Zc2jm9ku1 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0299	import
273	273	Purchase 0218 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1640xxxxxxxxxx7421 Recurring	import
274	274	Purchase 0302 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx0049	import
275	275	Purchase 0303 Wtf Just Happened Llc Httpswhatthefwa Xxxxx1640xxxxxxxxxx9504 Recurring	import
276	276	Purchase 0314 Amazon Reta* Pr3zy5v23 Www.amazon.cowa Xxxxx3450xxxxxxxxxx0742	import
277	277	Purchase 0317 Franciscan Missions Franciscanmiswi Xxxxx1650xxxxxxxxxx1939	import
278	278	Purchase 0318 Focus Xxxxxx5750 Httpswww.focuco Xxxxx3440xxxxxxxxxx4912 Recurring	import
279	279	Purchase 0402 Amazon Reta* 555r91mi3 Www.amazon.cowa Xxxxx3450xxxxxxxxxx5271	import
280	280	Purchase 0402 Cb* Hunters Bend Eleme Chooseboosterga Xxxxx7740xxxxxxxxxx6160 Recurring	import
281	281	Purchase 0402 Zoom.com Xxx-xxx-966 San Jose Ca Xxxxx3850xxxxxxxxxx8044	import
282	282	Purchase 0514 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx3067 Recurring	import
283	283	Purchase 0518 Sp Readingglasses Readingglassetx Xxxxx3451xxxxxxxxxx7261	import
284	284	Purchase 0521 Aurora First, Inc. Aurorafirst.afl Xxxxx7751xxxxxxxxxx1202 Recurring	import
285	285	Purchase 0603 Amazon Reta* N67b41ig2 Www.amazon.cowa Xxxxx3451xxxxxxxxxx7984	import
286	286	Purchase 0614 Change.org Change.org Ca Xxxxx7741xxxxxxxxxx2883 Recurring	import
287	287	Purchase 0617 Pp*ticketfulfi Nashvill Xxx-xxx-5661 De Xxxxx3841xxxxxxxxxx1876	import
288	288	Purchase 0711 Gloss* Trimmed & Tailo Kaylavaughn.gtn Xxxxx6651xxxxxxxxxx5269 Recurring	import
289	289	Purchase 0714 Change.org Change.org Ca Xxxxx7751xxxxxxxxxx1143 Recurring	import
290	290	Purchase 0718 Focus Xxxxxx5750 Focus.org Co Xxxxx1651xxxxxxxxxx9852 Recurring	import
291	291	Purchase 0718 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx9636 Recurring	import
292	292	Purchase 0806 Amazon Digi* Ne8mi14m2 Www.amazon.cowa Xxxxx3452xxxxxxxxxx4846	import
293	293	Purchase 0817 Sp Zquiet Zquiet.com Vt Xxxxx1652xxxxxxxxxx2068	import
294	294	Purchase 0818 Focus Xxxxxx5750 Httpswww.focuco Xxxxx1642xxxxxxxxxx5484 Recurring	import
295	295	Purchase 0823 Wyndy Wyndy.com Al Xxxxx6652xxxxxxxxxx2463	import
296	296	Purchase 0903 Amazon Reta* Zt5pn7aa2 Www.amazon.cowa Xxxxx3442xxxxxxxxxx1919	import
297	297	Purchase 1004 Docker, Inc. Httpswww.dockca Xxxxx3442xxxxxxxxxx3774 Recurring	import
298	298	Purchase 1112 Sp Built.com Built.com Ut Xxxxx3443xxxxxxxxxx0960	import
299	299	Purchase 1114 Sp Lewisblack.com Httpslewisblaca Xxxxx1633xxxxxxxxxx8465	import
300	300	Purchase 1121 Amazon Reta* Y54wd1xb3 Www.amazon.cowa Xxxxx3443xxxxxxxxxx3916	import
301	301	Purchase 1126 Amznfreetime*zx9576nl2 Xxx-xxx-3080 Wa Xxxxx1643xxxxxxxxxx9876	import
302	302	Purchase 1214 Change.org Change.org Ca Xxxxx7743xxxxxxxxxx9625 Recurring	import
303	303	Purchase Interest Charge	import
304	304	Quality Tree Surgery	import
305	305	Quip	import
306	306	Reader's Digest	import
307	307	Recisio	import
308	308	Redbubble	import
309	309	Reed's Produce	import
310	310	Relay for Reddit	import
311	311	SHELL OIL XXXXX738336 06/19 PURCHASE FRANKLIN TN	import
312	312	SHUFFS MUSIC 06/20 PURCHASE XXX-XX06139 TN	import
313	313	SQ *THE FAINTING GOAT C 09/07 MOBILE PURCHASE Franklin TN	import
314	314	SafeSplash	import
315	315	Sam's Club	import
316	316	Sams's Club Gas Station	import
317	317	Savory Spice	import
318	318	Savory Spice Shop	import
319	319	Second Harvest Food Bank	import
320	320	Shedd Aquarium	import
321	321	Shell	import
322	322	Silver Dollar City Candle Shop	import
323	323	Smithstore	import
324	324	Socks And Soles	import
325	325	Sonic Drive-in	import
326	326	Source	import
327	327	Southern Men's Showcase	import
328	328	Southwest Airlines	import
329	329	Sp * Two Blind Brother	import
330	330	Spotify	import
331	331	Sq *dog Gone Good Time Fa	import
332	332	Sq *freelife Soap Co.	import
333	333	St Joseph's Indian School	import
334	334	St. Joseph's Indian School	import
335	335	St. Philip Church	import
336	336	Starbucks	import
337	337	State Farm	import
338	338	Stroud's	import
339	339	Subway	import
340	340	Sugarwish.com Gifts	import
341	341	Susan Hammonds-White	import
342	342	Sweet Haven	import
343	343	Synchrony Bank	import
344	344	TARGET T- 1701 06/04 PURCHASE Franklin TN	import
345	345	THE FRANKLIN THEATRE 01/17 PURCHASE FRANKLIN TN	import
346	346	THE FRANKLIN THEATRE 05/09 PURCHASE FRANKLIN TN	import
347	347	TILE / LIFE360 09/09 PURCHASE LIFE360.COM CA	import
348	348	TN Stars	import
349	349	Target	import
350	350	The Berry Bar	import
351	351	The Coffee House	import
352	352	The Dunkin Theatre	import
353	353	The Good Cup	import
354	354	The Home Depot	import
355	355	The Ice Cream Store	import
356	356	The Protein Bar	import
357	357	The UPS Store	import
358	358	The Ups Store	import
359	359	Thevocalacademy. Des:thevocalac Id:st-n1l0q6e2q7z9 Indn:jake Woods Co Id:xxxxxx5600 Web	import
360	360	Tile	import
361	361	Tile Inc	import
362	362	Tivo	import
363	363	Tj Maxx	import
364	364	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx4085 Indn:146 Xxxxxxx4501 Co Id:xxxxxx1445 Ppd	import
365	365	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6018 Indn:150 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	import
366	366	Tn Dir Ach Des:contrib Id:xxxxxxxxxxx6024 Indn:571 Xxxxxxx4502 Co Id:xxxxxx1445 Ppd	import
367	367	Trader Joe's	import
368	368	Travel Credit $75/year	import
369	369	Us Department Of Education	import
370	370	Valon Mortgage	import
371	371	Valon Mortgage Des:payment Id: Indn:borrower Pyac8af25c635 Co Id:valon Web	import
372	372	Vending Charge	import
373	373	Venmo	import
374	374	WTF Just Happened Today	import
375	375	WTFJHT NEWSLETTER 09/02 PURCHASE WHATTHEFUCKJU WA	import
376	376	Waggy Tails	import
377	377	Walgreens	import
378	378	Wall Street Journal	import
379	379	Walmart	import
380	380	Walmart.com 06/15 PURCHASE Bentonville AR	import
381	381	Wasabi Restaurant	import
382	382	Wasabi Technologies	import
383	383	Wayfair	import
384	384	Whole Foods Market	import
385	385	Wikimedia Foundation	import
386	386	Williamson County	import
387	387	Williamson County Animal Hospital	import
388	388	Williamson County Schools - SACC	import
389	389	Williamson Medical Center	import
390	390	Wolfgang Puck	import
391	391	World Vision International	import
392	392	Wyndy	import
393	393	Yearbook Market	import
394	394	Yeti	import
395	395	Zelle	import
396	396	Zoom Video Communications	import
\.


--
-- Data for Name: tagged_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tagged_events (id, tag, description, effective_date, retired_date) FROM stdin;
1243	Flex	Flex	2018-11-02	9999-12-31
1244	Core+	Core+	2018-11-02	9999-12-31
1245	Core	Core	2018-11-02	9999-12-31
2273	Exception	Exception	2022-09-12	9999-12-31
2274	Christmas2020	Christmas2020	2022-09-12	9999-12-31
2275	Summer2022	Summer2022	2022-09-12	9999-12-31
2277	NETripSummer2019	NETripSummer2019	2022-09-12	9999-12-31
2278	MITripSummer2022	MITripSummer2022	2022-09-12	9999-12-31
2279	JBirthday2020	JBirthday2020	2022-09-12	9999-12-31
2280	Sedona2019	Sedona2019	2022-09-12	9999-12-31
2282	MercyHealthcare	MercyHealthcare	2022-09-15	9999-12-31
2283	Haiti	Haiti	2022-09-15	9999-12-31
2284	Jake	Jake	2023-09-03	9999-12-31
2286	Nicole	 Nicole	2023-09-03	9999-12-31
2287	DateNight	DateNight	2023-09-03	9999-12-31
2288	EricChurchConcert	EricChurchConcert	2023-09-03	9999-12-31
2289	2021GetLuna	 2021GetLuna	2023-09-04	9999-12-31
2290	Luna	 Luna	2023-09-04	9999-12-31
2291	2023Chicago	2023Chicago	2023-09-04	9999-12-31
2293	2021FallBreakSmokies	2021FallBreakSmokies	2023-09-04	9999-12-31
2294	Magazine	Magazine	2023-09-04	9999-12-31
2297	Bonus	Bonus	2023-09-04	9999-12-31
2298	Christmas2021	Christmas2021	2023-09-09	9999-12-31
2299	Yvette	Yvette	2023-09-09	9999-12-31
2300	Christmas2019	Christmas2019	2023-09-10	9999-12-31
2301	JBirthday2022	JBirthday2022	2023-09-10	9999-12-31
2302	 	 	2023-09-10	9999-12-31
2303	NETripSummer2021	NETripSummer2021	2023-09-10	9999-12-31
2304	Software	Software	2023-09-10	9999-12-31
2307	Xavier	Xavier	2023-09-10	9999-12-31
2308	Christmas2022	Christmas2022	2023-09-10	9999-12-31
2310	2022GATraining	2022GATraining	2023-09-10	9999-12-31
2311	2022GetTheMuranoTrip	2022GetTheMuranoTrip	2023-09-10	9999-12-31
2312	2022MensShowcase	2022MensShowcase	2023-09-11	9999-12-31
2313	Check2044	Check2044	2023-09-11	9999-12-31
2314	Check2045	Check2045	2023-09-11	9999-12-31
2315	Logan	Logan	2023-09-11	9999-12-31
2316	Check2046	Check2046	2023-09-11	9999-12-31
2317	Check2047	Check2047	2023-09-11	9999-12-31
2318	Check2052	Check2052	2023-09-12	9999-12-31
2319	Evelyn	Evelyn	2023-09-12	9999-12-31
2320	Check2053	Check2053	2023-09-12	9999-12-31
2321	Highlander	Highlander	2023-09-12	9999-12-31
2322	Murano	Murano	2023-09-12	9999-12-31
2323	F150	F150	2023-09-12	9999-12-31
2324	Check2054	Check2054	2023-09-12	9999-12-31
2325	Check2055	Check2055	2023-09-12	9999-12-31
2326	Check2056	Check2056	2023-09-12	9999-12-31
2327	Check2048	Check2048	2023-09-12	9999-12-31
2328	Check2050	Check2050	2023-09-12	9999-12-31
2329	Joe	Joe	2023-09-13	9999-12-31
2330	LoganBirthday2022	LoganBirthday2022	2023-09-13	9999-12-31
2331	Gail	Gail	2023-09-13	9999-12-31
2332	Phill	Phill	2023-09-13	9999-12-31
2333	India	India	2023-09-14	9999-12-31
2334	ArchdioceseOfTheMilitary	ArchdioceseOfTheMilitary	2023-09-14	9999-12-31
2336	2022Anniversary	2022Anniversary	2023-09-14	9999-12-31
2337	JBirthday2023	JBirthday2023	2023-11-04	9999-12-31
2338	Halloween2023	Halloween2023	2023-11-04	9999-12-31
2339	RentalRefurb2023	RentalRefurb2023	2023-11-04	9999-12-31
2340	Christmas2023	Christmas2023	2023-12-30	9999-12-31
2341	IlianaWedding	IlianaWedding	2024-01-27	9999-12-31
2342	Summer2023	Summer2023	2024-01-27	9999-12-31
2344	202401IlianaWedding	202401IlianaWedding	2024-01-28	9999-12-31
\.


--
-- Data for Name: transaction_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction_accounts (id, name, account_id) FROM stdin;
1	Adv Plus Banking - Ending in 8971	1
2	Adv Tiered Interest Chkg - Ending in 8971	1
3	Bank of America - Adv Tiered Interest Chkg - Transactions	1
4	Bank of America - Bank - Adv Tiered Interest Chkg - Transactions	1
5	Bank of America - Bank - Classic Interest Checking - Transactions	1
6	Bank of America - Bank - Classic Interest Checking-8971 - Transactions	1
7	Bank of America - Bank - Interest Checking-8971	1
8	Bank of America - Bank - Interest Checking-8971 - Transactions	1
9	Bank of America - Interest Checking-8971	1
10	Bank Of America Core Checking - Ending in 8971	1
11	Chase - Credit Card - CREDIT CARD - Transactions	2
12	Credit Card - Ending in 2985	2
13	Credit Card ( ) - Ending in 2985	2
14	Online Savings Account - Ending in 8193	3
15	Southwest Airlines - Ending in 2985	2
16	Southwest_airlines - 2985	2
17	Adv Plus Banking- 8971 (8971)	1
18	Rapid Rewards Priority (2985)	2
19	Savings Account (8193)	3
20	Money Market Savings Account (2395)	4
\.


--
-- Data for Name: transaction_tagged_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transaction_tagged_events (id, bank_transaction_id, tagged_event_id, category_split_detail_id, tagged_at) FROM stdin;
8253	228	1245	\N	2022-09-12 00:00:00
8256	202	1245	\N	2022-09-12 00:00:00
8273	68	1245	\N	2022-09-12 00:00:00
8276	4	1245	\N	2022-09-12 00:00:00
8348	193	1244	\N	2022-09-12 00:00:00
8405	137	1244	\N	2022-09-12 00:00:00
8413	103	1244	\N	2022-09-12 00:00:00
8492	136	1243	\N	2022-09-13 00:00:00
8497	67	1243	\N	2022-09-13 00:00:00
8502	159	1243	\N	2022-09-13 00:00:00
8640	81	1243	\N	2022-09-14 00:00:00
8812	17	1244	\N	2022-09-15 00:00:00
8943	183	1244	\N	2022-09-15 00:00:00
9026	284	1245	\N	2023-09-03 00:00:00
9031	419	1245	\N	2023-09-03 00:00:00
9034	410	1245	\N	2023-09-03 00:00:00
9036	381	1245	\N	2023-09-03 00:00:00
9046	274	1245	\N	2023-09-03 00:00:00
9067	326	1244	\N	2023-09-03 00:00:00
9090	369	1244	\N	2023-09-03 00:00:00
9110	102	1244	\N	2023-09-03 00:00:00
9172	351	1244	\N	2023-09-03 00:00:00
9175	244	1244	\N	2023-09-03 00:00:00
9191	293	1244	\N	2023-09-03 00:00:00
9216	83	1244	\N	2023-09-03 00:00:00
9232	38	1244	\N	2023-09-03 00:00:00
9238	20	1244	\N	2023-09-03 00:00:00
9353	259	1243	\N	2023-09-03 00:00:00
9355	344	1243	\N	2023-09-03 00:00:00
9366	455	1244	\N	2023-09-04 00:00:00
9416	336	1244	\N	2023-09-04 00:00:00
9429	452	1244	\N	2023-09-04 00:00:00
9605	76	2286	\N	2023-09-04 00:00:00
9606	76	1245	\N	2023-09-04 00:00:00
9657	142	2286	\N	2023-09-04 00:00:00
9658	142	1245	\N	2023-09-04 00:00:00
9703	12	2286	\N	2023-09-04 00:00:00
9704	12	1245	\N	2023-09-04 00:00:00
9817	320	1245	\N	2023-09-04 00:00:00
9834	154	1245	\N	2023-09-04 00:00:00
10035	160	1245	\N	2023-09-10 00:00:00
10104	278	1243	\N	2023-09-10 00:00:00
10114	264	2301	\N	2023-09-10 00:00:00
10122	185	2278	\N	2023-09-10 00:00:00
10139	464	2284	\N	2023-09-10 00:00:00
10140	464	2286	\N	2023-09-10 00:00:00
10171	472	1244	\N	2023-09-10 00:00:00
10193	282	1244	\N	2023-09-10 00:00:00
10198	240	1244	\N	2023-09-10 00:00:00
10229	436	1244	\N	2023-09-10 00:00:00
10302	447	2291	\N	2023-09-10 00:00:00
10303	447	1243	\N	2023-09-10 00:00:00
10443	193	2286	\N	2023-09-10 00:00:00
10451	261	1244	\N	2023-09-10 00:00:00
10461	287	1243	\N	2023-09-10 00:00:00
10462	287	2307	\N	2023-09-10 00:00:00
10480	186	1245	\N	2023-09-10 00:00:00
10481	208	1245	\N	2023-09-10 00:00:00
10485	288	1245	\N	2023-09-10 00:00:00
10512	98	1243	\N	2023-09-10 00:00:00
10516	167	1243	\N	2023-09-10 00:00:00
10546	128	1244	\N	2023-09-10 00:00:00
10547	128	2304	\N	2023-09-10 00:00:00
10577	207	1243	\N	2023-09-10 00:00:00
10578	207	2284	\N	2023-09-10 00:00:00
10626	392	1245	\N	2023-09-10 00:00:00
10640	119	1245	\N	2023-09-10 00:00:00
10642	156	1245	\N	2023-09-10 00:00:00
10652	448	1245	\N	2023-09-11 00:00:00
10657	173	1243	\N	2023-09-11 00:00:00
10661	200	1243	\N	2023-09-11 00:00:00
10689	125	1243	\N	2023-09-11 00:00:00
10690	125	2315	\N	2023-09-11 00:00:00
10715	125	2327	\N	2023-09-12 00:00:00
10739	105	1245	\N	2023-09-13 00:00:00
10758	169	1244	\N	2023-09-13 00:00:00
10841	218	1245	\N	2023-09-13 00:00:00
10864	198	1243	\N	2023-09-13 00:00:00
10865	198	2307	\N	2023-09-13 00:00:00
10907	163	1245	\N	2023-09-14 00:00:00
10908	163	2286	\N	2023-09-14 00:00:00
10938	503	2338	\N	2023-11-04 00:00:00
10954	528	1244	\N	2024-01-27 00:00:00
10975	521	1244	\N	2024-01-27 00:00:00
10984	325	1244	\N	2024-01-27 00:00:00
10985	361	1244	\N	2024-01-27 00:00:00
10989	418	1244	\N	2024-01-27 00:00:00
11031	496	1245	\N	2024-01-27 00:00:00
11033	496	2315	\N	2024-01-27 00:00:00
11034	518	1245	\N	2024-01-27 00:00:00
11036	518	2315	\N	2024-01-27 00:00:00
11048	559	1245	\N	2024-01-28 00:00:00
11049	559	2307	\N	2024-01-28 00:00:00
11063	572	1244	\N	2024-01-28 00:00:00
11073	548	1244	\N	2024-09-19 00:00:00
11074	481	1244	\N	2024-09-19 00:00:00
11075	541	1244	\N	2024-09-19 00:00:00
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.accounts_id_seq', 4, true);


--
-- Name: bank_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bank_transactions_id_seq', 1000, true);


--
-- Name: category_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_rules_id_seq', 34, true);


--
-- Name: category_split_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_split_details_id_seq', 4, true);


--
-- Name: payee_aliases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payee_aliases_id_seq', 396, true);


--
-- Name: payees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payees_id_seq', 396, true);


--
-- Name: spending_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.spending_categories_id_seq', 1169, true);


--
-- Name: spending_category_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.spending_category_groups_id_seq', 6, true);


--
-- Name: tagged_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tagged_events_id_seq', 2344, true);


--
-- Name: transaction_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transaction_accounts_id_seq', 16, true);


--
-- Name: transaction_tagged_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transaction_tagged_events_id_seq', 11075, true);


--
-- PostgreSQL database dump complete
--

\unrestrict wbE63DEWRyCawwcm1Kq1F301J8GdNW4yuY58sBzdycus6vaDUZXi2Z1LUqSIq6b

