# Snowflake DCM Projects — Proof of Concept

## 🎯 Purpose

This repository is a POC to understand how **Snowflake DCM (Database Change Management) Projects** work — how objects are defined, versioned, and deployed across multiple environments using a manifest-driven approach combined with a GitHub Actions CI/CD pipeline.

## Prerequisites

- A Snowflake account with sufficient privileges to create databases, schemas, roles, warehouses, and users.  
  > In this POC, a **free 30-day Snowflake trial account** was used.
- Two Snowflake service users (one per environment) configured for OIDC authentication with GitHub Actions — see step 2 below.
- A GitHub repository with Actions enabled.
- In Github create two environments DCM_DEV and DCM_PROD.

---

## Use Case 1 — Multi-environment object lifecycle

Understand how the same set of Snowflake objects (warehouses, databases, tables, views, roles, tasks, etc.) behaves across two environments (`DEV` and `PROD`), and how DCM Projects manages the differences through templating and target configuration.

---

## Setup Steps

### Step 1 — Create the database and schema that will host the DCM project

Run the following in Snowflake once, before anything else:

```sql
CREATE DATABASE IF NOT EXISTS DCM_DB_POC;
CREATE SCHEMA  IF NOT EXISTS DCM_DB_POC.PROJECTS;
```

### Step 2 — Create the GitHub Actions service users

Run the queries in [`pre_scripts/create_github_svc.sql`](pre_scripts/create_github_svc.sql) to create the two service accounts used by the CI/CD pipeline (one for `DCM_DEV`, one for `DCM_PROD`).

### Step 3 — Create the environments in your repository and add the variables

In your repository: **Settings → Environments**

| Environment | Variable | Value |
|---|---|---|
| `DCM_DEV` | `SNOWFLAKE_USER` | `SVC_GITHUB_ACTIONS_DEV` |
| `DCM_PROD` | `SNOWFLAKE_USER` | `SVC_GITHUB_ACTIONS_PROD` |

---


## Use Case 2 — Team self-service ecosystem (`selfservice/`)

### Goal

Validate how a DATA team can autonomously manage its entire Snowflake ecosystem via DCM Projects — without relying on a central platform team for every change. The idea is that a single DCM project groups everything the team needs: compute, storage, access control, and pipelines, within an isolated and self-contained perimeter.

### What is tested

| Layer | Objects |
|---|---|
| Infrastructure | Dedicated database, schemas, warehouse |
| Access control | Team roles with appropriate grants |
| Data pipeline | Tables, views, tasks |

### Key concepts explored

- **Isolated ecosystem** — the DCM project covers a strictly defined perimeter, independent from other teams and the rest of the Snowflake account.
- **Ownership model** — the project owner role deploys and owns all objects; grants delegate access to team roles.
- **Everything as code** — a single set of definition files captures the team's entire ecosystem, versioned and deployable in a repeatable way.
- **Incremental changes** — iterating on table schemas, adding columns, and updating pipeline logic without full redeployment.

## Use Case 3 — Tests (`play/`)

The purpose of this project is to test the features and identify the limitations of the DCM.
- Creating multiple objects.
- Evaluating behavior when deleting the project or objects.
- and many other tests.

## Key Learnings

- DCM Projects uses a **desired-state model** — you describe what you want, Snowflake figures out how to get there.
- The `DEFINE` statement behaves like `CREATE OR ALTER`: idempotent and order-independent.
- **Removing a `DEFINE`** from your files will cause DCM to **drop the object** on the next deploy — intentional but worth knowing.
- Grant types not supported by DCM (APPLICATION ROLE grants, CALLER grants) must be managed manually outside the project.
- The project owner role must hold OWNERSHIP of all managed objects — transferring ownership of pre-existing objects is a manual prerequisite.

---

## References

- [Snowflake DCM Projects Documentation](https://docs.snowflake.com/en/user-guide/dcm-projects/dcm-projects-overview)
- [Snowflake Labs DCM Repository](https://github.com/Snowflake-Labs/snowflake-dcm-projects)
- [Get Started with DCM Projects](https://www.snowflake.com/en/developers/guides/get-started-snowflake-dcm-projects/)
