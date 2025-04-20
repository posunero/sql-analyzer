# Snowflake Analyzer Missing Features Roadmap

This roadmap lays out a phased plan to implement the Snowflake SQL and ecosystem features not yet covered by our analyzer. Each phase groups related features, defines key deliverables, dependencies, and an estimated timeline.

---

## Table of Contents
1. [Overview](#overview)
2. [Phase 1 – Core Language Enhancements](#phase-1)
3. [Phase 2 – DDL & Data Types](#phase-2)
4. [Phase 3 – Procedural & Scripting](#phase-3)
5. [Phase 4 – Semi‑structured & Table Functions](#phase-4)
6. [Phase 5 – Ecosystem & Advanced Services](#phase-5)
7. [Cross‑Phase Tasks](#cross-phase)
8. [Acceptance & Testing](#testing)

---

## 1. Overview
We currently cover ~70% of Snowflake's public spec. To achieve full coverage, we must fill in gaps around advanced SQL constructs, data types, procedural scripting, semi‑structured operations, and newer Snowflake services (Snowpipe, Snowpark, ML, etc.).

Each phase assigns a feature set, owner(s), timeline, and dependencies:

| Phase | Focus                                    | ETA      | Owner       |
|-------|------------------------------------------|----------|-------------|
| 1     | Core Language Enhancements               | 4 weeks  | SQL Team    |
| 2     | DDL & Data Types                         | 4 weeks  | DDL Team    |
| 3     | Procedural & Scripting                   | 6 weeks  | Script Team |
| 4     | Semi‑structured & Table Functions        | 6 weeks  | SemiSQL Team|
| 5     | Ecosystem & Advanced Services            | 8 weeks  | Ecosystem Team|

---

## 2. Phase 1 – Core Language Enhancements <a name="phase-1"></a>
**Timeline:** Month 1 (Weeks 1–4)

### Missing Features
- QUALIFY clause support
- SAMPLE / TABLESAMPLE syntax
- PIVOT / UNPIVOT clauses
- RESULT_SCAN & LAST_QUERY_ID() handling
- Additional built‑in functions: DATEADD, DATEDIFF, PARSE_JSON, OBJECT_INSERT, ARRAY_AGG, etc.
- Windowing extensions: ROWS/RANGE BETWEEN

### Deliverables
1. Grammar updates in `snowflake.lark` for each new keyword and clause.  
2. AST visitor and model updates to capture new constructs.  
3. AnalysisEngine hooks to record these statements/functions.  
4. New unit tests in `tests/` covering syntax + analysis.  

### Dependencies
- Baseline grammar refactoring to support multi‑token clauses  
- Coordination with `analysis.models` to add new statement/function enums

---

## 3. Phase 2 – DDL & Data Types <a name="phase-2"></a>
**Timeline:** Month 2 (Weeks 5–8)

### Missing Features
- Comprehensive data types: VARIANT, OBJECT, ARRAY, TIME, TIMESTAMP_NTZ/TZ/LTZ, GEOGRAPHY, BINARY
- ALTER TABLE ... PIVOT/UNPIVOT on tables
- ALTER TABLE ... SET/DROP CLUSTERING KEYS (beyond current CLUSTER BY)
- Role management: USER, SHARE, more privileges in GRANT/REVOKE
- SHOW / DESCRIBE for additional objects (e.g. FUNCTIONS, PROCEDURES, DRILL SEQUENCE)

### Deliverables
1. Extend `data_type` rule in grammar and AST nodes for variant & geospatial types.  
2. Implement object-type–specific DDL grammar expansions.  
3. Support GRANT/REVOKE on new privilege scopes.  
4. Update report runner to list object metadata for new types.  
5. Add sample SQL fixtures & tests under `tests/fixtures/valid`

### Dependencies
- Phase 1 completion (function name collisions)  
- Mapping of Snowflake doc data type definitions into grammar patterns

---

## 4. Phase 3 – Procedural & Scripting <a name="phase-3"></a>
**Timeline:** Month 3–4 (Weeks 9–14)

### Missing Features
- IF..THEN..ELSE, CASE statements in scripting blocks  
- LOOP / WHILE / FOR constructs  
- EXCEPTION/TRY ... CATCH  
- EXECUTE AS USER/OWNER, COMMENT on PROCEDURE/FUNCTION  
- Multi‑statement blocks (BEGIN ... END), variable scoping, RETURN statements

### Deliverables
1. Grammar for control‑flow constructs in `snowflake.lark` under scripting (`_statement_wrapper`).  
2. AST nodes & visitor logic for SCRIPT blocks.  
3. Analysis rules: record DECLARE/SET, capture code‑location metadata.  
4. Example `.sql` scripts in `sample_sql/` + tests in `tests/` directory.  

### Dependencies
- Reliable support for DOLLAR_QUOTED_STRING  
- Upgraded `execute_immediate` handling from Phase 1

---

## 5. Phase 4 – Semi‑structured & Table Functions <a name="phase-4"></a>
**Timeline:** Month 4–5 (Weeks 15–20)

### Missing Features
- FLATTEN (enhancements: support `path`, `outer`, `recursive` args)  
- Other table functions: `OBJECT_KEYS`, `ARRAY_SIZE`, `SEMI_STRUCTURED_JQ`  
- PARSE_JSON, TO_JSON functions + nested object access  
- UDTF (user‑defined table functions) stubs

### Deliverables
1. Extend grammar for named/function‑specific args (FAT_ARROW) in FLATTEN & others.  
2. AnalysisEngine: track semi‑structured column references & table‑function calls.  
3. Add negative tests for ambiguous syntax.  
4. Update HTML/JSON reporters to render structured‑data insights.

### Dependencies
- Phase 1 built‑in function registration  
- Test fixtures for JSON payloads in `tests/fixtures/` 

---

## 6. Phase 5 – Ecosystem & Advanced Services <a name="phase-5"></a>
**Timeline:** Month 6–7 (Weeks 21–28)

### Missing Features
- Snowpipe: `CREATE PIPE` streaming WITH notifications (SNS/Queue):: detailed options  
- Snowpark Container Services & Python UDFs  
- Model operations: `CREATE MODEL`, `PREDICT` UDFs  
- Account-level governance: ORG ACCOUNTS, PRIVACY POLICIES, CLASSIFICATION

### Deliverables
1. Grammar expansions for new DDL commands (PIPE, MODEL, PREDICT)  
2. AST visitor enhancements + new `ObjectInfo` types  
3. Integration tests against real Snowflake JSON samples.  
4. Updated memory‑bank docs & diagram in `/memory_bank/` + a summary page linking each module.

### Dependencies
- Up‑to‑date Snowflake API documentation  
- Collaboration with Security & Data Science stakeholders

---

## 7. Cross‑Phase Tasks <a name="cross-phase"></a>
- **Test Coverage:** Aim for ≥ 90% grammar+analysis coverage.  
- **CI/CD Integration:** Add grammar‑lint, test pipelines in GitHub Actions.  
- **Documentation:** Maintain sample SQL and changelog in `memory_bank/`.  
- **Release Plan:** Draft incremental release notes, semantic versioning.  

---

## 8. Acceptance & Testing <a name="testing"></a>
- **Unit tests:** One test per grammar rule + analysis outcome.  
- **Integration tests:** Run full `sample_sql/` suite nightly.  
- **Performance:** Benchmark parse & analysis on large SQL codebases.  
- **User feedback:** Solicit real‑world SQL scripts from users to validate edge cases.


*Doc generated by project roadmap planner.*