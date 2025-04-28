# Importing Data into Neo4j

## Introduction

The source system may have a different data model than Neo4j, so we would transform the data into a graph model that fits Neo4j.

The source may expose data in different formats:
- Relational Database Management System (RDBMS)
- Web APIs
- Public data directories
- BI tools
- Excel
- Flat files (CSV, TSV, JSON, XML, etc.)

The method of importing data into Neo4j depends on:
- the source of the data
- the volume of data
- the frequency of the import
- the complexity of the data model
- the transformation required

The options available for importing data into Neo4j include:
- One-off batch import of all dat
- One-off load with a regular update
- Continuous import of data
- Real-time application updates
- ETL (Extract, Transform, Load) processes

### Tools

#### Data Importer
The [Neo4j Data Importer](https://neo4j.com/docs/data-importer/current/) is a "no-code" tool facilitating CSV data import into Neo4j. Data Importer allows us to
- visually define the graph data model, including nodes, relationships, and properties
- upload source data files
- map CSV columns to properties
- define unique ID constraints and indexes

#### Cypher and LOAD CSV
Cypher has built-in support for importing data from CSV files using the `LOAD CSV` clause. We can control the import process by writing Cypher queries to
- load data from CSV files
- create the data model
- transform and aggregate data
- control transactions

For example,
```sql
LOAD CSV WITH HEADERS FROM 'file:///transactions.csv' AS row

MERGE (t:Transactions {id: row.id})
SET
    t.reference = row.reference,
    t.amount = toInteger(row.amount),
    t.timestamp = datetime(row.timestamp)
```
This will read the CSV file `transactions.csv` from the Neo4j import folder. It treats the first row of the CSV file as **column names**. Each row is a transaction record with properties `id`, `reference`, `amount`, and `timestamp`. The `MERGE` clause creates a node with the label `Transactions` and the property `id`. The `SET` clause sets thre properties of the node. The `toInteger` function converts the `amount` property to an integer. The `datetime` function converts the `timestamp` property to a datetime object.

#### neo4j-admin
The [`neo4j-admin import`](https://neo4j.com/docs/operations-manual/current/import/) CLI supports importing large datasets. It converts CSV files into the internal binary format of Neo4j and can import millions of rows within minutes.

#### ETL Tools
An ETL tool, for example Apache Hop, is a good choice for importing data from multiple sources.

#### Custom Integration using Neo4j Drivers
Building a custom application to load data into the graph database is a good option if we have complex business rules or need to integrate with other systems.

## Neo4j Data Importer
Skipped for now...

## Source Data Considerations
Before importing data into Neo4j, we need to consider the following:
- How the data is formatted and structured, which may influence how we import the data into Neo4j and the complexity of the import process.
- How often the source data is updated, which may influence the import strategy and process.
- Whether we need to clean the data before importing, which depends on the quality of the source data, the data model we want to implement, and our business requirements.
- A Neo4j best practice is to use an ID as a unique property value for each node.

Neo4j is *schema-optional* and allows us to create data without a predefined schema. We should not let the source data structure dictate the graph data model. Instead, we should design the graph data model based on our project's objectives.

In addition to data modeling and import process, we should also consider data types. Neo4j supports:
- `BOOLEAN`
- `DATE`
- `DURATION`
- `FLOAT`
- `INTEGER`
- `LIST`
- `LOCAL DATETIME`
- `LOCAL TIME`
- `POINT`
- `STRING`
- `ZONED DATETIME`
- `ZONED TIME`