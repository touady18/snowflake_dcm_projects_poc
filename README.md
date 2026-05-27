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
Settings -> Environments
Create DCM_DEV and add the Environment variables "SNOWFLAKE_USER" = " SVC_GITHUB_ACTIONS_DEV"
Create DCM_PROD and add the Environment variables "SNOWFLAKE_USER" = " SVC_GITHUB_ACTIONS_PROD"
