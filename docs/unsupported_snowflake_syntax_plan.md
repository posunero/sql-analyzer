# Implementation Plan: Extend Snowflake SQL Coverage

This plan builds on `docs/unsupported_snowflake_syntax.md` to add grammar coverage, basic AST support, and tests for the remaining Snowflake features. Scope is parse-time structure and compatibility for analysis/reporting; it does not execute SQL.

## Guiding Principles
- Prioritize broadly used, low-ambiguity features first.
- Keep Earley grammar performant by limiting backtracking hotspots and using explicit precedence.
- Prefer minimal AST nodes initially; extend analysis incrementally.
- Maintain current behavior for unknown constructs (graceful fallback, no hard crashes).

## Phase 1 — Core SQL Features
Target: common query constructs that unlock more SELECT coverage.

- QUALIFY clause
  - Grammar: `qualify_clause: QUALIFY expr` appended after `order_clause? limit_clause?` with rule relaxation to allow positioning similar to Snowflake (after HAVING and before ORDER/LIMIT). Adjust select_stmt: `... having_clause? qualify_clause? order_clause? limit_clause?`.
  - Tests: add examples with window functions filtered by QUALIFY.
  - Risks: interaction with existing window/ORDER/LIMIT precedence.

- SAMPLE/TABLESAMPLE
  - Grammar: tokens `SAMPLE`, `TABLESAMPLE`, `BERNOULLI`, `SYSTEM`, `PERCENT`, `ROWS`. Add to table references: `base_table_ref: qualified_name sample_clause? ...` and `sample_clause: (SAMPLE|TABLESAMPLE) (BERNOULLI|SYSTEM)? LPAREN (number | expr) (PERCENT|ROWS)? RPAREN`.
  - Tests: basic SAMPLE percent, TABLESAMPLE BERNOULLI/ROWS.

- PIVOT / UNPIVOT
  - Grammar: tokens `PIVOT`, `UNPIVOT`. Add `pivot_clause` and `unpivot_clause` after a `base_table_ref` with optional `ON`/`FOR`. Keep a simplified version first.
  - Tests: minimal pivot/unpivot forms from Snowflake docs.
  - Risks: nesting with joins; start simple (single pivot) and iterate.

- Window frame options (ROWS/RANGE BETWEEN)
  - Grammar: add frame tokens and `window_frame: (ROWS|RANGE) BETWEEN frame_bound AND frame_bound` plus `frame_bound: (UNBOUNDED PRECEDING | number PRECEDING | CURRENT ROW | number FOLLOWING | UNBOUNDED FOLLOWING)`. Extend `window_spec_contents` to accept `order_clause? window_frame?`.
  - Tests: row-number, sum over ranges with frames.

Acceptance criteria: new constructs parse; no regressions in existing tests; new tests green.

## Phase 2 — DDL & Data Types
Target: extend CREATE/ALTER/DESCRIBE/SHOW and type system for Snowflake.

- Data Types: full VARIANT/OBJECT/ARRAY, TIME/DATE/TIMESTAMP forms, GEOGRAPHY
  - Grammar: enrich `data_type` with canonical names and parameters: `VARIANT | OBJECT | ARRAY (LPAREN data_type RPAREN)? | TIME (LPAREN number RPAREN)? [TZ] | TIMESTAMP_[NTZ|LTZ|TZ] ... | GEOGRAPHY`. Add aliases per Snowflake.
  - Tests: definitions and casts.

- ALTER TABLE variants: PIVOT/UNPIVOT and advanced `CLUSTER BY` options
  - Grammar: add branches to `alter_table_action` for `PIVOT`/`UNPIVOT` (matching simplified Phase 1 rules) and for `CLUSTER BY expr (,... )` which already exists; extend options if needed.
  - Tests: simple alter-pivot/unpivot statements.

- GRANT/REVOKE expansions (privileges & grantees)
  - Grammar: extend `privilege` set and allow `grantee_type: ROLE | USER | SHARE | APPLICATION ROLE`. Support object-specific grants (FUNCTION signature supported already; add `PROCEDURE` signature similarly).
  - Tests: grant/revoke on views, procedures, functions with signatures, and to SHARE/USER.

- SHOW/DESCRIBE varieties
  - Grammar: add common object kinds: `FILE FORMATS`, `SEQUENCES`, `FUNCTIONS`, `PROCEDURES`, `NETWORK POLICIES`, `STORAGE INTEGRATIONS`, `NOTIFICATION INTEGRATIONS`, etc. Keep to simple forms initially.
  - Tests: a matrix of SHOW/DESC statements.

Acceptance criteria: DDL examples from docs parse; new tests green.

## Phase 3 — Procedural & Scripting Constructs
Target: pragmatic support for scripting blocks to parse typical examples.

- IF / ELSEIF / ELSE / CASE in scripting blocks
  - Grammar: introduce scripting statements inside `statement_list`: `if_stmt`, `case_stmt`. Example: `if_stmt: IF LPAREN expr RPAREN THEN statement_list (ELSEIF LPAREN expr RPAREN THEN statement_list)* (ELSE statement_list)? END IF`.
  - Tests: branching returning literals; nested in DECLARE/BEGIN blocks.

- Loops: LOOP / WHILE / FOR
  - Grammar: minimal shapes: `while_stmt: WHILE LPAREN expr RPAREN DO statement_list END WHILE`, `for_cursor_stmt: FOR IDENTIFIER IN CURSOR_NAME DO ... END FOR` or simplified iterator over `SELECT` results as present in examples.
  - Tests: simple loop skeletons with assignments; no execution implied.

- Exception handling
  - Grammar: support `EXCEPTION` section already present in examples (basic). Keep flexible to avoid over-constraining.
  - Tests: RAISE/WHEN forms from docs.

- Multi-statement blocks with variable scoping and RETURN
  - Current status: supported for DECLARE/BEGIN/RETURN/assignment; expand to include new control flow above.

Acceptance criteria: scripting examples in docs parse; no ambiguity explosions.

## Phase 4 — Semi-Structured & Table Functions
Target: expand table functions and semi-structured operations.

- FLATTEN full options
  - Grammar: extend `function_call` special-case for `FLATTEN` as table function with named args: `PATH`, `OUTER`, `RECURSIVE`, `INPUT` (already handled via named args with `FAT_ARROW`). Optionally add explicit `flatten_call` rule for clarity.
  - Tests: lateral flatten with path/outer/recursive combos.

- Additional table functions: OBJECT_KEYS, ARRAY_SIZE, RESULT_SCAN, LAST_QUERY_ID
  - Grammar: these can ride on current `function_call` if treated as identifiers; ensure they parse under `qualified_name` and allow nested casts as in docs.
  - Tests: minimal invocations and as SELECT expressions.

- UDTFs
  - Grammar: expand `create_function_stmt` for `RETURNS TABLE (...) LANGUAGE ... HANDLER ...` forms (already partly supported). Add examples.

Acceptance criteria: table function examples parse; current SELECT rules unaffected.

## Phase 5 — Ecosystem & Advanced Services (Parse-Only)
Target: grammar coverage (non-executable) for Snowflake services and ops.

- Snowpipe & Snowpipe Streaming
  - Grammar: add tokens `PIPE`, `NOTIFICATION`, `STORAGE_INTEGRATION` variants already present; expand COPY/CREATE PIPE options as needed.
  - Tests: create/alter pipe with typical options.

- Snowpark Container Services, External Access Integrations
  - Grammar: extend parameters for `create_service_stmt` (already present) and `create_security_integration_stmt`/`create_network_rule_stmt` tokens. Accept double-quoted strings & dollar-quoted YAML blocks (already supported via `DOLLAR_QUOTED_STRING`).
  - Tests: examples from docs parse.

- Machine Learning (`CREATE MODEL`, `PREDICT`)
  - Grammar: add tokens `MODEL`, `PREDICT`; stub simple forms to parse common examples.
  - Tests: minimal create/predict statements.

- Organization-wide features (privacy policies, listings, releases)
  - Grammar: continue incremental coverage (LISTING, RELEASE directives already partly supported). Add missing parameter forms.
  - Tests: listing/release examples parse.

Acceptance criteria: representative statements parse; no conflicts with core grammar.

## Cross-Cutting Tasks
- AST/Model updates
  - Add generic node tags for newly introduced statements to enable visitors to identify statement categories without full semantic elaboration.
- Reporter/Analyzer
  - Tolerate new nodes; list unhandled constructs in reports rather than failing.
- Error handling
  - Keep the heuristic fallback in `parser/core.py` as a last resort for doc-only artifacts; aim to reduce its triggers over time.
- Performance
  - Monitor parse times in CI; guard with fixtures for worst-case constructs; refactor hotspots if needed (e.g., avoid left recursion, narrow alternatives).

## Testing Strategy
- Add focused unit tests under `tests/grammar/test_snowflake_constructs.py` per feature group with minimal examples.
- Add end-to-end doc-derived fixtures sparingly to avoid bloat; keep heavy YAML/JS bodies inside `DOLLAR_QUOTED_STRING`.
- Maintain Windows/Linux path compatibility in file fixtures.

## Milestones & Order
1. Phase 1 (Core SQL) — highest ROI; unlocks QUALIFY, SAMPLE, PIVOT/UNPIVOT, frames.
2. Phase 2 (DDL & Types) — grants, describe/show extensions, types.
3. Phase 3 (Scripting) — control flow and loops.
4. Phase 4 (Semi-Structured & Table Functions) — FLATTEN options and common functions.
5. Phase 5 (Ecosystem) — parse-only coverage for services/integrations/ML.

Deliverables for each phase:
- Grammar edits with brief inline comments.
- Unit tests covering positive cases; a few negative tests for obvious syntax errors.
- Changelog entry and docs update to remove items from `unsupported_snowflake_syntax.md` as they land.

## Risks & Mitigations
- Ambiguity in grammar (Earley explosion): keep rules explicit, use precedence; isolate complex constructs (e.g., pivot) into dedicated subrules; add tokens to disambiguate.
- Backward compatibility: add new alternatives conservatively; extend existing rules rather than rewriting; rely on test suite for regressions.
- Maintenance load: prefer parse-only coverage for advanced services first; defer deep semantic analysis.

## Tracking
Create a checkbox issue per bullet in `unsupported_snowflake_syntax.md` with links to tests/PRs. Update the doc as features ship.

---
This plan is incremental. We can start Phase 1 immediately with small, reviewable PRs.
