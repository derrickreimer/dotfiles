---
name: new-relic-dashboard
description: >
  Create or update New Relic dashboards with the `newrelic` CLI and NerdGraph.
  Use when the user asks to add a New Relic dashboard, NRQL board, or
  visualize APM / custom events. Also use for /new-relic-dashboard.
---

# New Relic dashboards

Resolve the account first. Run `newrelic profile list`. If several accounts
are visible, pick the one the user named or ask. Substitute that numeric id
for `ACCOUNT_ID` in every command (`-a ACCOUNT_ID` and GraphQL `accountId` /
`accountIds`).

Search existing dashboards before creating. Match the account's naming
pattern (read a few `type = 'DASHBOARD'` names). Check `entitySearch` for
the exact name so you do not mint a duplicate.

Two different guids: the **dashboard** guid is the entity. The **page** guid
is `pages[].guid` from `actor.entity`. `dashboardCreate` / `dashboardDelete`
take the dashboard guid. `dashboardAddWidgetsToPage` takes the page guid.

## Do not use `--variables` or `--variablesFile`

The CLI often prints `{}` for those flags. The mutation may have **failed**,
**succeeded**, or **succeeded twice** if you retry. Never infer success from
empty stdout or a zero exit. After every create/add/delete, re-query
`actor.entity(guid:)` (or `entitySearch` by exact name) and proceed only from
that payload.

Use a **short inline GraphQL string** as the `newrelic nerdgraph query`
argument. Wrap it in single quotes; encode an inner single quote as `'\''`.
Do not write a JSON variables file and do not retry a write you have not
read back.

## Create

1. Search:

```bash
newrelic nerdgraph query 'query { actor { entitySearch(query: "name = '\''Dashboard Name'\''") { count results { entities { name guid } } } } }' -a ACCOUNT_ID
```

2. Create with an empty widget list (`pages[].widgets` is required; omit it and the mutation 400s):

```bash
newrelic nerdgraph query 'mutation { dashboardCreate(accountId: ACCOUNT_ID, dashboard: { name: "Dashboard Name", description: "…", permissions: PUBLIC_READ_WRITE, pages: [{ name: "Overview", widgets: [] }] }) { entityResult { guid name } errors { type description } } }' -a ACCOUNT_ID
```

`permalink` is **not** on `dashboardCreate.entityResult`. Fetch it after:

```bash
newrelic nerdgraph query 'query { actor { entity(guid: "DASHBOARD_GUID") { ... on DashboardEntity { permalink pages { guid name widgets { title } } } } } }' -a ACCOUNT_ID
```

3. Add widgets **one at a time** (or at most a 2–3 widget inline batch) via
   `dashboardAddWidgetsToPage`. After each call, re-query widget titles. If
   anything is duplicated, `dashboardDelete` that guid and start over — do not
   add more on top.

```bash
newrelic nerdgraph query 'mutation { dashboardAddWidgetsToPage(guid: "PAGE_GUID", widgets: [{ title: "…", visualization: { id: "viz.line" }, layout: { column: 1, row: 1, height: 3, width: 6 }, rawConfiguration: { nrqlQueries: [{ accountIds: [ACCOUNT_ID], query: "SELECT count(*) FROM Transaction TIMESERIES AUTO" }], yAxisLeft: { zero: true } } }]) { errors { type description } } }' -a ACCOUNT_ID
```

4. Give the user the `permalink` from the entity query.

## Delete

```bash
newrelic nerdgraph query 'mutation { dashboardDelete(guid: "DASHBOARD_GUID") { status errors { description type } } }' -a ACCOUNT_ID
```

`entitySearch` can still list a deleted board for a minute. Confirm with
`actor.entity(guid:)` — `null` means it is gone.

## Layout and viz

Grid is 12 columns. Copy `rawConfiguration` from an existing board in the
same account rather than inventing fields.

| `visualization.id` | Use |
| --- | --- |
| `viz.markdown` | Intro / how to read; `rawConfiguration.text` |
| `viz.billboard` | Single latest/avg number |
| `viz.line` | `TIMESERIES AUTO` |
| `viz.table` | `FACET` + `latest()` |

`layout`: `{ column, row, width, height }`. Start `row` at 1. Leave a gap
between rows (`row` 1 height 3 → next row 4).

## NRQL

Probe event types and property values before writing widgets. APM uses
`Transaction` / `TransactionError`. Custom events vary by app — do not assume
booleans, numbers, or enum strings until you have seen a sample row.

```bash
newrelic nrql query -a ACCOUNT_ID --query 'SELECT * FROM EventName LIMIT 1'
```

Do not do math on `percentile()` (`Sorry, we don't support math on that`).
Dashboards can be created before any events exist; widgets stay empty until
data arrives.

## Copy an existing board's widget shape

```bash
newrelic nerdgraph query 'query { actor { entity(guid: "EXISTING_DASH_GUID") { ... on DashboardEntity { name pages { name widgets { title visualization { id } layout { column row height width } rawConfiguration } } } } } }' -a ACCOUNT_ID
```

Find guids with `entitySearch` `type = 'DASHBOARD'` or `name = 'Exact Name'`.
