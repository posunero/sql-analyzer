Sweet — here’s a comprehensive, repo-ready TODO that you can drop into an issue or a PR description. It’s split into (A) grammar/lexer work, (B) semantic checks, and (C) a Golden SQL test suite grouped by feature (with both positive and negative cases).

---

# SQL Analyzer — Snowflake Coverage TODO (with Golden SQL)

## A) Grammar / Lexer

* [ ] **JOIN variants**

  * [ ] Add `ASOF JOIN` to the `join_type` alternatives; allow `ON` with key equality and timestamp inequality.
  * [ ] Accept `NATURAL` with `INNER|LEFT|RIGHT|FULL` joins; support `USING (col, ...)` (no `ON` allowed with `NATURAL`).
  * [ ] Parse optional `DIRECTED` keyword in `INNER/LEFT/RIGHT/FULL ... DIRECTED JOIN`.
* [ ] **Hierarchical queries**

  * [ ] Support `START WITH <predicate> CONNECT BY [PRIOR] <expr> = [PRIOR] <expr> [, ...]`.
  * [ ] Add pseudo-column `LEVEL`, function‐like `CONNECT_BY_ROOT <expr>`, and `SYS_CONNECT_BY_PATH(expr, delimiter)`.
* [ ] **Table functions & LATERAL**

  * [ ] Allow `LATERAL` and `TABLE(function_call)` as `from_item`s.
  * [ ] Add named args with fat arrow token `=>` (e.g., `FLATTEN(INPUT=>..., PATH=>'...')`).
* [ ] **VALUES in FROM & `$n` refs**

  * [ ] Accept `FROM ( VALUES (expr[, ...])[, ...] ) [AS alias (col_alias[, ...])]`.
  * [ ] Permit positional refs `$1`, `$2`, … as column identifiers **only** when the source is a `VALUES` table (or where Snowflake allows).
* [ ] **PIVOT / UNPIVOT**

  * [ ] Implement both constructs as table operators following a table source; support aliasing and nested usage.
* [ ] **QUALIFY**

  * [ ] Add `QUALIFY <boolean_expr>` after `WHERE/GROUP BY/HAVING` & `WINDOW`/`ORDER BY` but before `LIMIT/TOP/FETCH`.
* [ ] **SAMPLE / TABLESAMPLE**

  * [ ] Support `SAMPLE` and `TABLESAMPLE` with `BERNOULLI|SYSTEM`, percentage/rows, and optional `REPEATABLE (seed)`.
* [ ] **Time Travel / Change Tracking**

  * [ ] On table references, support `AT ( TIMESTAMP => <expr> | OFFSET => <num> | STATEMENT => <id> )`.
  * [ ] Support `BEFORE ( TIMESTAMP => ... | STATEMENT => ... )`.
  * [ ] Support `CHANGES ( INFORMATION => ... )` forms (table sampling of change data).
* [ ] **LIMIT synonyms**

  * [ ] `TOP <n> [PERCENT] [WITH TIES]` (both in `SELECT` head and after `ORDER BY`).
  * [ ] `FETCH { FIRST | NEXT } <n> { ROW | ROWS } { ONLY | WITH TIES }`.
* [ ] **SELECT … FOR UPDATE**

  * [ ] Add trailing `FOR UPDATE` clause to `SELECT`.
* [ ] **MATCH\_RECOGNIZE**

  * [ ] Implement `MATCH_RECOGNIZE ( PARTITION BY ... ORDER BY ... MEASURES ... ONE|ALL ROWS PER MATCH AFTER MATCH SKIP ... PATTERN (...) DEFINE ... )`.
* [ ] **GROUP BY extensions**

  * [ ] Add `GROUPING SETS ( ... )`, `ROLLUP ( ... )`, `CUBE ( ... )`.
  * [ ] Ensure `GROUPING()` and `GROUPING_ID()` are tokenized as functions.
* [ ] **SEMANTIC VIEW**

  * [ ] Add DDL: `CREATE SEMANTIC VIEW <name> ...`.
  * [ ] Allow querying via `FROM SEMANTIC_VIEW(<identifier_or_fqn>)`.
* [ ] **New data types**

  * [ ] Add `VECTOR(<elem_type>, <dimension>)`.
  * [ ] Add `GEOGRAPHY` and `GEOMETRY`.
* [ ] **Window frames**

  * [ ] Ensure full frame grammar: `ROWS | RANGE | GROUPS` with `BETWEEN ... AND ...`, `UNBOUNDED PRECEDING|FOLLOWING`, `CURRENT ROW`, and exclusion clauses if applicable.
* [ ] **Lexer: tokens & identifiers**

  * [ ] Add `=>` fat-arrow token (distinct from `=` and `->`).
  * [ ] Ensure `$` + digits recognized as positional column *identifier* (scoped; see above).
  * [ ] Confirm keywords added: `ASOF`, `DIRECTED`, `QUALIFY`, `PIVOT`, `UNPIVOT`, `MATCH_RECOGNIZE`, `ROLLUP`, `CUBE`, `GROUPING`, `VECTOR`, `GEOGRAPHY`, `GEOMETRY`, `SEMANTIC_VIEW`, `LEVEL`, `CONNECT_BY_ROOT`.

## B) Semantic checks (analyzer / lints)

* [ ] **JOIN rules**

  * [ ] Disallow `ON` with `NATURAL` joins; enforce `USING` dedup projection: columns in `USING` appear once.
  * [ ] (Optional) Warn if `DIRECTED` appears on unsupported editions/regions (parser accepts; analyzer can flag).
* [ ] **FOR UPDATE constraints**

  * [ ] Diagnostic if query contains `DISTINCT`, aggregates, set ops, `GROUP BY`, `HAVING`, `QUALIFY`, `ORDER BY`, or joins that Snowflake forbids with `FOR UPDATE` (semantic rule; parser still accepts).
* [ ] **QUALIFY usage**

  * [ ] Warn if `QUALIFY` references non-window expressions only (i.e., no window function dependence).
* [ ] **VALUES `$n` leakage**

  * [ ] Error if `$n` appears without a `VALUES` source (or context where Snowflake allows positional columns).
* [ ] **Time travel / changes**

  * [ ] Lint if `CHANGES` used on objects without change tracking (if catalog is available).
  * [ ] Normalize/record time-travel spec on each table node in AST for downstream rules.
* [ ] **MATCH\_RECOGNIZE sanity**

  * [ ] Validate that names in `DEFINE`/`PATTERN` align; ensure measures reference defined variables.
* [ ] **CONNECT BY rules**

  * [ ] Warn if both sides of `CONNECT BY` lack `PRIOR` where intended (common authoring bug).
  * [ ] Allow `LEVEL`/`CONNECT_BY_ROOT` only within hierarchical query scope.

## C) Golden SQL (grouped by feature)

> Suggested layout (rename as you like):
>
> * `tests/golden/01_connect_by.sql`
> * `tests/golden/02_asof_join.sql`
> * `tests/golden/03_lateral_table_functions.sql`
> * `tests/golden/04_values_and_dollar_cols.sql`
> * `tests/golden/05_pivot_unpivot.sql`
> * `tests/golden/06_qualify.sql`
> * `tests/golden/07_sampling.sql`
> * `tests/golden/08_time_travel_changes.sql`
> * `tests/golden/09_join_matrix.sql`
> * `tests/golden/10_limit_top_fetch.sql`
> * `tests/golden/11_for_update.sql`
> * `tests/golden/12_match_recognize.sql`
> * `tests/golden/13_grouping_sets_rollup_cube.sql`
> * `tests/golden/14_semantic_view.sql`
> * `tests/golden/15_types_vector_geo.sql`
> * `tests/golden/99_negative_cases.sql`

Each file mixes **POSITIVE** (should parse) and **NEGATIVE** (should fail) with inline comments. If your harness separates these, split into `*_ok.sql` and `*_err.sql`.

---

### 01\_connect\_by.sql

```sql
-- POSITIVE
SELECT LEVEL, CONNECT_BY_ROOT title AS root_title
FROM employees
START WITH title = 'CEO'
CONNECT BY manager_id = PRIOR employee_id;

-- POSITIVE: multiple connect predicates
SELECT LEVEL, SYS_CONNECT_BY_PATH(name, '->') AS path
FROM org
START WITH id = 1
CONNECT BY PRIOR id = manager_id, dept = PRIOR dept;

-- POSITIVE: use PRIOR on either side
SELECT LEVEL FROM t
START WITH x IS NOT NULL
CONNECT BY PRIOR id = parent_id;

-- NEGATIVE: LEVEL outside hierarchical query
-- EXPECT: error (LEVEL not allowed here)
SELECT LEVEL FROM t;
```

### 02\_asof\_join.sql

```sql
-- POSITIVE: basic
SELECT l.id, r.value
FROM left_stream l
ASOF JOIN right_stream r
  ON l.id = r.id AND l.ts <= r.ts;

-- POSITIVE: with ORDER BY
SELECT * FROM a
ASOF JOIN b ON a.k = b.k AND a.ts <= b.ts
ORDER BY a.ts;

-- NEGATIVE: missing timestamp inequality
-- EXPECT: error or lint (Snowflake requires time condition)
SELECT * FROM a ASOF JOIN b ON a.k = b.k;
```

### 03\_lateral\_table\_functions.sql

```sql
-- POSITIVE: LATERAL + FLATTEN with named args
SELECT f.value
FROM events e,
LATERAL TABLE(FLATTEN(INPUT=>e.payload, PATH=>'$.items', OUTER=>TRUE)) AS f;

-- POSITIVE: multiple named args, correlation
SELECT e.id, f.index, f.value
FROM events e
LEFT JOIN LATERAL TABLE(FLATTEN(INPUT=>e.json, RECURSIVE=>FALSE)) f ON TRUE;

-- POSITIVE: generic TABLE(fn(...))
SELECT * FROM TABLE(GENERATOR(ROWCOUNT=>5));

-- NEGATIVE: use '=' instead of '=>'
-- EXPECT: error (fat-arrow required for named args)
SELECT * FROM TABLE(FLATTEN(INPUT=e.payload));
```

### 04\_values\_and\_dollar\_cols.sql

```sql
-- POSITIVE: VALUES in FROM with alias and column list
SELECT v.$2 AS name
FROM (VALUES (1,'one'), (2,'two')) AS v(id, name);

-- POSITIVE: VALUES without alias (implicit C1..Cn)
SELECT $1, $2 FROM (VALUES (10, 20));

-- NEGATIVE: $1 outside VALUES source
-- EXPECT: error
SELECT $1 FROM real_table;
```

### 05\_pivot\_unpivot.sql

```sql
-- POSITIVE: PIVOT with IN list
SELECT *
FROM sales
PIVOT(SUM(amount) FOR quarter IN ('Q1','Q2','Q3','Q4')) AS p;

-- POSITIVE: UNPIVOT
SELECT * FROM inventory
UNPIVOT( qty FOR category IN (books, music, games) );

-- POSITIVE: nested pivot on subquery
SELECT * FROM (
  SELECT region, quarter, amount FROM sales
) PIVOT(SUM(amount) FOR quarter IN ('Q1','Q2'));
```

### 06\_qualify.sql

```sql
-- POSITIVE: classic dedupe
SELECT *, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY ts DESC) AS rn
FROM clicks
QUALIFY rn = 1;

-- POSITIVE: multiple predicates
SELECT *
FROM t
QUALIFY ROW_NUMBER() OVER (ORDER BY ts) = 1
  AND RANK() OVER (PARTITION BY g ORDER BY s DESC) <= 3;

-- NEGATIVE: QUALIFY without window usage (lint)
SELECT * FROM t QUALIFY 1=1;
```

### 07\_sampling.sql

```sql
-- POSITIVE: TABLESAMPLE SYSTEM
SELECT * FROM big_table TABLESAMPLE SYSTEM (1);

-- POSITIVE: SAMPLE with REPEATABLE seed
SELECT * FROM big_table SAMPLE BERNOULLI (0.5) REPEATABLE (42);

-- NEGATIVE: both BERNOULLI and SYSTEM specified
-- EXPECT: error
SELECT * FROM t TABLESAMPLE BERNOULLI (10) SYSTEM (10);
```

### 08\_time\_travel\_changes.sql

```sql
-- POSITIVE: AT TIMESTAMP
SELECT * FROM t AT (TIMESTAMP => '2024-01-01 00:00:00');

-- POSITIVE: BEFORE STATEMENT
SELECT * FROM t BEFORE (STATEMENT => '01a2b3c-xyz');

-- POSITIVE: CHANGES (syntax acceptance)
SELECT * FROM t CHANGES (INFORMATION => DEFAULT);
```

### 09\_join\_matrix.sql

```sql
-- POSITIVE: NATURAL JOIN
SELECT * FROM a NATURAL LEFT JOIN b;

-- POSITIVE: USING
SELECT * FROM a INNER JOIN b USING (id, org_id);

-- POSITIVE: DIRECTED
SELECT * FROM a INNER DIRECTED JOIN b ON a.id = b.id;

-- NEGATIVE: NATURAL with ON (not allowed)
-- EXPECT: error
SELECT * FROM a NATURAL JOIN b ON a.id = b.id;
```

### 10\_limit\_top\_fetch.sql

```sql
-- POSITIVE: TOP
SELECT TOP 5 * FROM t;

-- POSITIVE: TOP WITH TIES with ORDER BY
SELECT TOP 10 WITH TIES * FROM t ORDER BY score DESC;

-- POSITIVE: FETCH FIRST
SELECT * FROM t FETCH FIRST 5 ROWS ONLY;

-- POSITIVE: FETCH NEXT ... WITH TIES
SELECT * FROM t ORDER BY price DESC FETCH NEXT 3 ROWS WITH TIES;

-- NEGATIVE: TOP PERCENT without ORDER BY + WITH TIES (lint)
SELECT TOP 10 PERCENT WITH TIES * FROM t;
```

### 11\_for\_update.sql

```sql
-- POSITIVE
SELECT id FROM accounts WHERE id = 42 FOR UPDATE;

-- NEGATIVE: forbidden patterns with FOR UPDATE (semantic errors)
-- EXPECT: analyzer errors (parser accepts)
SELECT DISTINCT id FROM accounts FOR UPDATE;

SELECT id, COUNT(*) FROM accounts GROUP BY id FOR UPDATE;

SELECT * FROM a JOIN b ON a.id=b.id FOR UPDATE;
```

### 12\_match\_recognize.sql

```sql
-- POSITIVE: basic pattern
SELECT *
FROM s MATCH_RECOGNIZE (
  PARTITION BY id
  ORDER BY ts
  MEASURES FIRST(val) AS start_val, LAST(val) AS end_val
  ONE ROW PER MATCH
  PATTERN (start change*)
  DEFINE change AS val <> LAG(val)
);

-- POSITIVE: ALL ROWS PER MATCH + AFTER MATCH SKIP
SELECT *
FROM s MATCH_RECOGNIZE (
  PARTITION BY id ORDER BY ts
  ALL ROWS PER MATCH
  AFTER MATCH SKIP TO NEXT ROW
  PATTERN (A B+)
  DEFINE A AS val > 0, B AS val <= 0
);

-- NEGATIVE: undefined variable in DEFINE
-- EXPECT: error
SELECT * FROM s MATCH_RECOGNIZE (
  ORDER BY ts
  PATTERN (A)
  DEFINE C AS val > 0
);
```

### 13\_grouping\_sets\_rollup\_cube.sql

```sql
-- POSITIVE: GROUPING SETS
SELECT region, product, SUM(sales) AS s
FROM facts
GROUP BY GROUPING SETS ((region, product), (region), ());

-- POSITIVE: ROLLUP
SELECT region, product, SUM(sales)
FROM facts
GROUP BY ROLLUP (region, product);

-- POSITIVE: CUBE
SELECT region, product, SUM(sales)
FROM facts
GROUP BY CUBE (region, product);

-- POSITIVE: GROUPING() usage
SELECT region, product, GROUPING(region) AS g_r, GROUPING_ID(region, product) AS gid, SUM(sales)
FROM facts
GROUP BY CUBE (region, product);
```

### 14\_semantic\_view\.sql

```sql
-- POSITIVE: DDL (shape only; contents elided)
CREATE SEMANTIC VIEW my_sem_view
AS SELECT * FROM base;

-- POSITIVE: query the semantic view construct
SELECT * FROM SEMANTIC_VIEW(my_sem_view);
```

### 15\_types\_vector\_geo.sql

```sql
-- POSITIVE: vector in DDL
CREATE TABLE items (
  id INT,
  embedding VECTOR(FLOAT, 768)
);

-- POSITIVE: geography/geometry in DDL
CREATE TABLE geo (
  id INT,
  g GEOGRAPHY,
  h GEOMETRY
);

-- POSITIVE: vector similarity functions in SELECT (tokenization)
SELECT id
FROM items
ORDER BY VECTOR_COSINE_SIMILARITY(embedding, :qvec) DESC
FETCH FIRST 10 ROWS ONLY;
```

### 99\_negative\_cases.sql

```sql
-- GENERAL: random bad combos to keep the parser honest

-- NATURAL + ON
SELECT * FROM a NATURAL JOIN b ON a.id=b.id;

-- QUALIFY in wrong position (before WHERE)
QUALIFY ROW_NUMBER() OVER (ORDER BY ts)=1;
SELECT * FROM t;

-- Bad fat-arrow
SELECT * FROM TABLE(GENERATOR(ROWCOUNT=10));

-- $n out of context
SELECT $3 FROM t;

-- ASOF without ON
SELECT * FROM a ASOF JOIN b;

-- DDL typo
CREATE SEMANTIC VIEW myv (bad) SELECT 1;
```

---

## D) AST / Node shape updates (so tests are useful)

* [ ] Add `join_kind: 'ASOF' | 'INNER' | ...` and `directed: bool` on join nodes.
* [ ] On table refs, add `time_travel: { kind: 'AT'|'BEFORE'|'CHANGES', spec: ... } | null`.
* [ ] Represent `LATERAL TABLE(...)` as a distinct `table_function_source` with `named_args: [{name, expr}]`.
* [ ] Represent `VALUES` as `values_source: [[expr,...], ...]` and mark `scope: 'values'` to allow `$n`.
* [ ] Encode `hierarchical: { start_with?: expr, connect_by: [expr], uses_prior: bool }` on select.
* [ ] For `MATCH_RECOGNIZE`, surface sub-clauses: `partition_by`, `order_by`, `measures`, `pattern`, `define`, `rows_per_match`, `after_match_skip`.

## E) Test harness wiring

* [ ] Add a `golden/README.md` explaining PASS/FAIL annotations (`-- EXPECT: error`) and how the harness treats them.
* [ ] Ensure CI runs parser over all `tests/golden/**/*.sql` and:

  * [ ] **Positive**: must parse with no syntax error.
  * [ ] **Negative**: must raise a syntax error (or a specific analyzer diagnostic if running semantic passes).
* [ ] (Optional) Snapshot ASTs for a handful of representative cases (ASOF, CONNECT BY, MATCH\_RECOGNIZE) for regression.

## F) Docs & examples

* [ ] Update repository README with a “Snowflake coverage” matrix listing each construct above, parser vs analyzer support, and links to the Golden SQL files.
* [ ] Add a short “Contributing” note: how to add grammar rules + a minimal Golden SQL to avoid regressions.

---

If you want, share your grammar file(s) and I’ll annotate exact production rules to add/change (e.g., where `from_item` vs `table_factor` lives, join precedence, where `qualify_clause` slots in, etc.).
