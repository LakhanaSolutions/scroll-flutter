# API Checklist Instructions

When providing information for API endpoint creation/verification, please include the following details:

## Required Information
- **Screen file** (.dart) or **module name**
- **Brief description** of the functionality
- **Parameters** it should take (nothing, slug, ID, etc.)
- **Data fetching** - whether it needs to fetch data on load
- **Data updates** - whether it needs to update some data (e.g. profile form)
- **Sample API response data** - expected response format based on datapool schema
- **Status** - whether it's done or not (some actions are done in API, we still need to write it in the results file so the backend developer can keep track of it)

## Process
1. Check `/docs/swagger.md` whether the required endpoints exist in the API or not
2. Ensure the required data follows the schema in `/lib/data/datapool_schema.json`
3. Write all details in `/docs/api-checklist.json` file, grouped by screen
4. Format all details in JSON format

## Purpose
The result file will be provided to the backend developer to update database schema and API endpoints.