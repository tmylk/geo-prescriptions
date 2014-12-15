--
-- TOC entry 173 (class 1259 OID 16401)
-- Name: bnf; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE bnf (
    chaptercode character varying(2) NOT NULL,
    sectioncode character varying(2) NOT NULL,
    chaptername character varying(1000),
    sectionname character varying(1000)
);



ALTER TABLE public.bnf OWNER TO devl;

CREATE OR REPLACE VIEW bnf_padded AS
SELECT to_char(CAST(chaptercode AS integer),'00') AS chap_code,
to_char(CAST(sectioncode AS integer),'00') AS sect_code,
chaptername,
sectionname
 from bnf


--
-- TOC entry 174 (class 1259 OID 16435)
-- Name: gp_reg_patients; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE gp_reg_patients (
    "GP_PRACTICE_CODE" character varying(20),
    "POSTCODE" character varying(10),
    "TOTAL_ALL" integer,
    "TOP_LEVEL_POSTCODE" character varying(4)
);



ALTER TABLE public.gp_reg_patients OWNER TO devl;

--
-- TOC entry 177 (class 1259 OID 16466)
-- Name: gppractices; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE gppractices (
    practice_code character varying(6),
    depriv_score numeric,
    unemployed numeric,
    postcode character varying(10),
    top_level_postcode character varying(4)
);


ALTER TABLE public.gppractices OWNER TO devl;

--
-- TOC entry 183 (class 1259 OID 16513)
-- Name: bnf_practice_pop_agg_tbl; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE bnf_practice_pop_agg_tbl (
    practice text,
    chapter_code text,
    section_code text,
    cost double precision,
    num_prescriptions bigint,
    postcode character varying(10),
    population integer,
    top_level_postcode character varying(4),
    prescriptions_per_capita bigint,
    depriv_score numeric,
    unemployed numeric
);


ALTER TABLE public.bnf_practice_pop_agg_tbl OWNER TO devl;

--
-- TOC entry 182 (class 1259 OID 16497)
-- Name: postcode_population_tbl; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE postcode_population_tbl (
    "TOP_LEVEL_POSTCODE" character varying(4),
    top_level_postcode_population bigint
);


ALTER TABLE public.postcode_population_tbl OWNER TO devl;

--
-- TOC entry 181 (class 1259 OID 16491)
-- Name: weighted_demographic_tbl; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE weighted_demographic_tbl (
    top_level_postcode character varying(4),
    avg_depriv_score numeric,
    avg_unemployed numeric
);


ALTER TABLE public.weighted_demographic_tbl OWNER TO devl;

--
-- TOC entry 185 (class 1259 OID 16528)
-- Name: final_agg_tbl; Type: TABLE; Schema: public; Owner: devl; Tablespace: 
--

CREATE TABLE final_agg_tbl (
    top_level_postcode character varying(4),
    chapter_code text,
    section_code text,
    cost_per_capita_drjr double precision,
    prescriptions_per_capita_drjr numeric,
    avg_depriv_score_drjr numeric,
    avg_unemployed_drjr numeric
);


ALTER TABLE public.final_agg_tbl OWNER TO devl;

 
 
CREATE OR REPLACE VIEW
final_agg_kml AS

SELECT b.kml AS kml2,

a.top_level_postcode AS postcode,
  a.chapter_code AS chap_code,
  a.section_code AS sect_code,
  a.cost_per_capita_drjr AS  cost_per_capita,
  a.prescriptions_per_capita_drjr AS prescriptions_per_capita,
  a.avg_depriv_score_drjr AS avg_depriv_score,
  a.avg_unemployed_drjr AS avg_unemployed
 FROM final_agg_tbl a
 JOIN top_postcode_kml b
ON a.top_level_postcode::text = b.top_level_postcode::text;
