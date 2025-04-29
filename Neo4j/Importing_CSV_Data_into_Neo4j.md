# Importing CSV Data into Neo4j

## Importing Data
We may import source data from
- Relational databases
- Web APIs
- Public data directories
- BI tools
- Spreadsheets (e.g., Excel, Google Sheets)

The data in the source files may not be in the format needed for our graph data model:
- The source files could contain more data than we need.
- There may not be a one-to-one mapping of the data in a CSV file to a node or relationship in the graph.
- The data types may not map directly onto those supported in Neo4j.

The data import process involves creating Cypher code to
- Read the source data
- Transform the data as needed
- Create nodes, relationships, and properties to create the graph

CSV files store data separated by a special character, usually a comma. For example,
```csv
personId,name,birthYear
23945,Gerard Pires,1942
553509,Helen Reddy,1941
113934,Susan Flannery,1939
```

The separator can also be a tab (`\t`) or a pipe (`|`). For example,
```csv
personId|name|birthYear
23945|Gerard Pires|1942
553509|Helen Reddy|1941
113934|Susan Flannery|1939
```
The character used to separate the values in a CSV file is called the **Delimiter** or **Field Terminator**.

Typically the first row of a CSV file is a header row, which contains the names of the columns:
```csv
personId,name,birthYear
```

If the data contains the field terminator character, the data must be enclosed in double quotes. For example,
```csv
personId,name,birthYear
23945,"Pires, Gerard",1942
553509,"Reddy, Helen",1941
113934,"Flannery, Susan",1939
```

### Normalized Data
If the source data is normalized (e.g., when exported from a relational data model), there will typically be multiple CSV files. Each CSV file will represent a table in the relational data model, and the files will be related to each other by unique IDs. For example, suppose there are three CSV files for people, movies, and roles, respectively:

`person.csv`
```csv
personId,name,birthYear
23945,Gerard Pires,1942
553509,Helen Reddy,1941
113934,Susan Flannery,1939
```
`movie.csv`
```csv
movieId,title,avgVote,releaseYear,genres
189,Sin City,8.000000,2005,Crime|Thriller
2300,The Fifth Element,7.700000,1997,Action|Adventure|Sci-Fi
11969,Tombstone,7.800000,1993,Action|Romance|Western
```
Note that the `genres` column contains multiple values separated by a pipe (`|`).

`role.csv`
```csv
personId,movieId,character
2295,189,Marv
56731,189,Nancy
16851,189,Dwight
```
Note that the `person.csv` has a unique ID for every person, and the `movie.csv` has a unique ID for every movie. The `role.csv` relates a person to a movie, and provides the characters

### De-normalized Data
If the source data is de-normalized, there will typically be a single CSV file. The single file will contain all the data, often duplicated where there are relationships between entities. For example,

`movies-n.csv`
```csv
movieId,title,avgVote,releaseYear,genres,personType,name,birthYear,character
2300,The Fifth Element,7.700000,1997,Action|Adventure|Sci-Fi,ACTOR,Bruce Willis,1955,Korben Dallas
2300,The Fifth Element,7.700000,1997,Action|Adventure|Sci-Fi,ACTOR,Gary Oldman,1958,Jean-Baptiste Emanuel Zorg
2300,The Fifth Element,7.700000,1997,Action|Adventure|Sci-Fi,ACTOR,Ian Holm,1931,Father Vito Cornelius
11969,Tombstone,7.800000,1993,Action|Romance|Western,ACTOR,Kurt Russell,1951,Wyatt Earp
11969,Tombstone,7.800000,1993,Action|Romance|Western,ACTOR,Val Kilmer,1959,Doc Holliday
11969,Tombstone,7.800000,1993,Action|Romance|Western,ACTOR,Sam Elliott,1944,Virgil Earp
```
De-normalized data typically represents data from multiple tables. The movie and person data is repeated in multiple rows in the file. A row represents a particular actor's role in a movie.

## Loading CSV Files
The `LOAD CSV` clause reads data from a CSV file and returns the rows in the file:
```sql
LOAD CSV [WITH HEADERS] FROM url [AS alias] [FIELDTERMINATOR char]
```
- `WITH HEADERS` specifies that the first row of the CSV file contains the column names. If this is not specified, the first row is treated as data.
- `FROM url` specifies the location of the CSV file. The URL can be a local file path or a web address. For example, `file:///path/to/file.csv` or `https://example.com/file.csv`. The URL must be accessible from the Neo4j server.
- `AS alias` specifies an alias for the rows returned from the CSV file. This is optional, and if not specified, the rows will be returned as a list of values.
- `FIELDTERMINATOR char` specifies the character used to separate the values in the CSV file. The default is a comma (`,`). This is optional, and if not specified, the default will be used.

For example, we will load the `people.csv` file:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/people.csv'
AS row
RETURN row
```
This will return a list of rows from the CSV file, with each row represented as a map of key-value pairs. For example,
```json
{
  "birthYear": "1942",
  "name": "Gerard Pires",
  "personId": "23945"
}
```

To ensure all rows are loaded, we can coutn the number of rows in the CSV file and compare it to the number of rows returned by the `LOAD CSV` clause. For example,
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/people.csv'
AS row
RETURN count(row)
```

## Creating Nodes, Properties, and Relationships
We will load THE `persons.csv` file:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv'
AS row
RETURN row
```
We can see that the CSV file contains
- `bio`
- `born`
- `bornIn`
- `died`
- `person_imdbId`
- `person_tmdbId`
- `Id`
- `name`
- `person_poster`
- `person_url`

### Creating `Person` Nodes
We will create `Person` nodes from the CSV file directly:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET
    p.imdbId = toInteger(row.person_imdb),
    p.bornIn = row.bornIn,
    p.name = row.name,
    p.bio = row.bio,
    p.poster = row.person_poster,
    p.url = row.person_url,
    p.born = row.born,
    p.died = row.died
```

We could confirm the data in the graph by returning the first 25 `Person` nodes:
```sql
MATCH (p:Person)
RETURN p LIMIT 25
```

### Unique IDs and Constraints
A Neo4j best practice is to use an ID as a unique property value for each node. Unique IDs help ensure duplicate data is not created.

If the IDs in our CSV file are not unique for the same entity (node), we could create duplicate data. We may have issues loading the data and creating relationships between nodes. This is where we need to add constraints to our database to stop creating nodes with duplicate IDs.

The syntax for creating a unique constraint on a property is:
```sql
CREATE CONSTRAINT [constriant_name] [IF NOT EXISTS]
FOR (n:LabelName)
REQUIRE n.propertyName IS UNIQUE
```
- `constraint_name` is the name of the constraint. This is optional, and if not specified, Neo4j will create a default name for the constraint.
- `IF NOT EXISTS` is optional, and if specified, the constraint will only be created if it does not already exist. If not specified, an error will be raised by Neo4j if the constraint already exists.
- `LabelName` is the name of the label for the nodes to which the constraint applies.
- `REQUIRE n.propertyName IS UNIQUE` specifies the property that must be unique for the nodes with the specified label. The property must be indexed for the constraint to be created.

Now we can create a unique constraint for our `Person` nodes. The `Person` nodes should all have a unique `tmdbId` property. We can create a constraint for the `tmdbId` property to ensure that all `Person` nodes have a unique `tmdbId` property value:
```sql
CREATE CONSTRAINT Person_tmdbId IF NOT EXISTS
FOR (p:Person)
REQUIRE p.tmdbId IS UNIQUE
```
Note that
- The constraint name is `Person_tmdbId`.
- The `IF NOT EXISTS` clause is optional, and if not specified, an error will be raised by Neo4j if the constraint already exists.
- It applies to all nodes with the `Person` label.
- It requires the `tmdbId` property to be unique

We can check the constraints has been created by running
```sql
SHOW CONSTRAINTS
```
We should see the contraint named `Person_tmdbId` in the results.

If we try to create a `Person` node with a duplicate `tmdbId` property value,
```sql
CREATE (p:Person {tmdbId: 3})
RETURN p
```
Neo4j will raise an error:

<img src="imgs/constraint_error.PNG" alt="Constraint Error" width="50%"/>

To drop a constraint,
```sql
DROP CONSTRAINT [constraint_name]
```

### Adding `Movie` Nodes
Next we will load the `movies.csv` file to create `Movie`:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
    m.tmdbId = row.movie_tmdbId,
    m.imdbId = row.movie_imdbId,
    m.released = row.released,
    m.title = row.title,
    m.year = toInteger(row.year),
    m.plot = row.plot,
    m.budget = toInteger(row.budget)
```

To return the first 25 `Movie` nodes,
```sql
MATCH (m:Movie)
RETURN m LIMIT 25
```

### `ACTED_IN` Relationships
We will create relationships between the `Person` and `Movie` nodes by loading the `acted_in.csv` file, which contains
- `movieId` - the `movieId` property of the `Movie` node
- `person_tmdbId` - the `tmdbId` property of the `Person` node
- `role` - the role of the person played in the movie

We will create `ACTED_IN` relationships between the `Person` and `Movie` nodes:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/acted_in.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.role = row.role
```
Note that
- The two `MATCH` clauses are used to find the `Person` and `Movie` nodes using the `tmdbId` and `movieId` properties, respectively.
- The `MERGE` clause is used to create the `ACTED_IN` relationship between the matched `Person` and `Movie` nodes.
- The `SET` clause is used to set the `role` property of the `ACTED_IN` relationship to the value in the CSV file.

To verify the relationships have been created,
```sql
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
RETURN p, r, m LIMIT 25
```

### `DIRECTED` Relationships
We will create `DIRECTED` relationships between the `Person` and `Movie` nodes by loading the `directed.csv` file, which contains
- `movieId`
- `person_tmdbId`

Unlike the `ACTED_IN` relationships, the `DIRECTED` relationships has no properties, so we will not set any properties on the relationship.
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/directed.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[:DIRECTED]->(m)
```
To verify the relationships have been created,
```sql
MATCH (p:Person)-[r:DIRECTED]->(m:Movie)
RETURN p, r, m LIMIT 25
```

Once we have created the `ACTED_IN` and `DIRECTED` relationships, we can find people who directed and acted in the same movie:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(p:Person)
RETURN p, m
```

## Data Types, Lists, and Labels
All data loaded using `LOAD CSV` will be returned as strings - we need to cast the data to appropriate data types before being written to properties. We have seen `toInteger()` to cast a string to an integer when we created the `Person` and `Movie` nodes.

Cypher supports the following data types:
| Function | Description |
|----------|-------------|
| `toBoolean()` | Cast to a boolean |
| `toFloat()` | Cast to a float |
| `toInteger()` | Cast to an integer |
| `toString()` | Cast to a string |
| `date()` | Cast to a date |
| `datetime()` | Cast to a date and time |

We can use the `apoc.meta.nodeTypeProperties()` function to show the data types used in the graph:
```sql
CALL apoc.meta.nodeTypeProperties()
YIELD nodeType, propertyName, propertyTypes
```

NOTE: Neo4j will return the data type `Long` for integers.

### Person node dates
The `Person` nodes have the properties `born` and `died`, which are dates instead of strings. They should be cast to `Date` data types:
```sql
LOAD CSV WITH HEADERS 
FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET
    p.imdbId = toInteger(row.person_imdb),
    p.bornIn = row.bornIn,
    p.name = row.name,
    p.bio = row.bio,
    p.poster = row.person_poster,
    p.url = row.person_url,
    p.born = date(row.born),
    p.died = date(row.died)
```
To verify the data types of the properties, we can run:
```sql
CALL apoc.meta.nodeTypeProperties()
YIELD nodeType, propertyName, propertyTypes
```

The `Date` data type allows us to extract the `year`, `month`, and `day` from the data. For example,
```sql
MATCH (p:Person)
RETURN p.born.year as YearOfBirth
```

### Movie node dates and budgets
The `year` and `budget` properties of the `Movie` nodes should not be strings, and we should cast them to `Integer` data types:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
    m.tmdbId = toInteger(row.movie_tmdbId),
    m.imdbId = toInteger(row.movie_imdbId),
    m.released = row.released,
    m.title = row.title,
    m.plot = row.plot,
    m.year = toInteger(row.year),
    m.budget = toInteger(row.budget)
```

The `movies.csv` file also contains:
- `imdbRating`
- `movie_poster`
- `runtime`
- `imdbVotes`
- `revenue`
- `movie_url`

We can add these properties to the `Movie` nodes:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
    m.imdbRating = toFloat(row.imdbRating),
    m.poster = row.movie_poster,
    m.runtime = toInteger(row.runtime),
    m.imdbVotes = toInteger(row.imdbVotes),
    m.revenue = toInteger(row.revenue),
    m.url = row.movie_url
```
Now we can check the data types of the properties:
```sql
CALL apoc.meta.nodeTypeProperties()
YIELD nodeType, propertyName, propertyTypes
```

### Lists
A multi-value property is a property that can hold one or more values. Neo4j represents this type of data as a list (or `StringArray`). All values in a list must have the same data type.

The `movies.csv` data file contains multi-value properties:
- `countries` - the countries which produced the movie
- `languages` - the languages spoken in the movie

They are separated by a pipe (`|`):
```csv
USA|France|Italy|Germany
English|Mandarin|Russian
```

We can use the `split()` function to transform a string value into a list with a delimiter:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
    m.tmdbId = toInteger(row.movie_tmdbId),
    m.imdbId = toInteger(row.movie_imdbId),
    m.released = date(row.released),
    m.title = row.title,
    m.year = toInteger(row.year),
    m.plot = row.plot,
    m.budget = toInteger(row.budget),
    m.imdbRating = toFloat(row.imdbRating),
    m.poster = row.movie_poster,
    m.runtime = toInteger(row.runtime),
    m.imdbVotes = toInteger(row.imdbVotes),
    m.revenue = toInteger(row.revenue),
    m.url = row.movie_url,
    m.countries = split(row.countries, '|')
```
The last line sets the `countries` property as a list by splitting the data from the CSV file by the `|` character.

We can query data in a list using the `IN` operator. For example,
```sql
MATCH (m:Movie)
WHERE "France" IN m.countries
RETURN m
```

Now we can add the `languages` property to the `Movie` nodes:
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
    m.languages = split(row.languages, '|')
```

### Labels
Adding labels to existing nodes can make our graph more useful and performant.

The `Person` nodes in the graph right now represent both actors and directors. To determine if a person is an actor or director, we need to query the `ACTED_IN` and `DIRECTED` relationships. Alternatively, we can add labels to the `Person` nodes to distinguish between actors and directors.

For example, We can add the `Actor` label to all `Person` nodes that have acted in a movie:
```sql
MATCH (p:Person)[:ACTED_IN]->()
SET p:Actor
```
This query finds all `Person` nodes with an `ACTED_IN` relationship and sets the `Actor` label on those nodes.

As there are people in the database who have acted in more than one movie, we can use `WITH DISTINCT` to ensure that each person is only labeled once. Although not necessary, this will improve performance:
```sql
MATCH (p:Person)-[:ACTED_IN]->()
WITH DISTINCT p SET p:Actor
```
We can confirm the labels have been added by running:
```sql
MATCH (a:Actor) RETURN a LIMIT 25
```
By adding the `Actor` label to the graph, queries that use the label rather than the relationship will be faster to return.

Now we can add the `Director` label to all `Person` nodes that have directed a movie:
```sql
MATCH (p:Person)-[:DIRECTED]->()
WITH DISTINCT p SET p:Director
```

## Importing Data Considerations
As a recap, we 
- create `Person` and `Movie` constraints
- import data from `persons.csv` to create `Person` nodes
- import data from `movies.csv` to create `Movie` nodes
- create `ACTED_IN` and `DIRECTED` relationships between `Person` and `Movie` nodes
- create additional `Actor` and `Director` labels on `Person` nodes

```sql
CREATE CONSTRAINT Person_tmdbId IF NOT EXISTS
FOR (x:Person)
REQUIRE x.tmdbId IS UNIQUE;

CREATE CONSTRAINT Movie_movieId IF NOT EXISTS
FOR (x:Movie)
REQUIRE x.movieId IS UNIQUE;

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET
p.imdbId = toInteger(row.person_imdbId),
p.bornIn = row.bornIn,
p.name = row.name,
p.bio = row.bio,
p.poster = row.poster,
p.url = row.url,
p.born = date(row.born),
p.died = date(row.died);

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
m.tmdbId = toInteger(row.movie_tmdbId),
m.imdbId = toInteger(row.movie_imdbId),
m.released = date(row.released),
m.title = row.title,
m.year = toInteger(row.year),
m.plot = row.plot,
m.budget = toInteger(row.budget),
m.imdbRating = toFloat(row.imdbRating),
m.poster = row.poster,
m.runtime = toInteger(row.runtime),
m.imdbVotes = toInteger(row.imdbVotes),
m.revenue = toInteger(row.revenue),
m.url = row.url,
m.countries = split(row.countries, '|'),
m.languages = split(row.languages, '|');

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/acted_in.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.role = row.role;

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/directed.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:DIRECTED]->(m);

MATCH (p:Person)-[:ACTED_IN]->()
WITH DISTINCT p SET p:Actor;

MATCH (p:Person)-[:DIRECTED]->()
WITH DISTINCT p SET p:Director;
```
All the queries are independent of each other and do not form a single process.

### Multiple queries
To run multiple queries together, we must put a semi-colon (`;`) at the end of each query. For example,
```sql
MATCH (p:Person) RETURN p;
MATCH (m:Movie) RETURN m;
```

### Resetting the data
Before re-running the import process, we must delete any existing data and drop any constraints.

To delete the `ACTED_IN` and `DIRECTED` relationships, we can run:
```sql
MATCH (Person)-[r:ACTED_IN]->(Movie)
DELETE r;
MATCH (Person)-[r:DIRECTED]->(Movie)
DELETE r;
```

Once the relationships are deleted, we can delete the `Person` and `Movie` nodes:
```sql
MATCH (p:Person) DELETE p;
MATCH (m:Movie) DELETE m;
```

Alternatively, we can use `DETACH DELETE` to delete the nodes and relationship at the same time:
```sql
MATCH (p:Person) DETACH DELETE p;
MATCH (m:Movie) DETACH DELETE m;
```

If there are any constraints, we can drop them using:
```sql
DROP CONSTRAINT Person_tmdbId IF EXISTS;
DROP CONSTRAINT Movie_movieId IF EXISTS;
```

These queries reset the database and allow use to re-run the import process.

### Importing the data
If we combine all previous queries into a single query, we can run the import process in one go:
```sql
MATCH (p:Person) DETACH DELETE p;
MATCH (m:Movie) DETACH DELETE m;

DROP CONSTRAINT Person_tmdbId IF EXISTS;
DROP CONSTRAINT Movie_movieId IF EXISTS;

CREATE CONSTRAINT Person_tmdbId IF NOT EXISTS
FOR (x:Person)
REQUIRE x.tmdbId IS UNIQUE;

CREATE CONSTRAINT Movie_movieId IF NOT EXISTS
FOR (x:Movie)
REQUIRE x.movieId IS UNIQUE;

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
SET
p.imdbId = toInteger(row.person_imdbId),
p.bornIn = row.bornIn,
p.name = row.name,
p.bio = row.bio,
p.poster = row.poster,
p.url = row.url,
p.born = date(row.born),
p.died = date(row.died);

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/movies.csv' AS row
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET
m.tmdbId = toInteger(row.movie_tmdbId),
m.imdbId = toInteger(row.movie_imdbId),
m.released = date(row.released),
m.title = row.title,
m.year = toInteger(row.year),
m.plot = row.plot,
m.budget = toInteger(row.budget),
m.imdbRating = toFloat(row.imdbRating),
m.poster = row.poster,
m.runtime = toInteger(row.runtime),
m.imdbVotes = toInteger(row.imdbVotes),
m.revenue = toInteger(row.revenue),
m.url = row.url,
m.countries = split(row.countries, '|'),
m.languages = split(row.languages, '|');

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/acted_in.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:ACTED_IN]->(m)
SET r.role = row.role;

LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/directed.csv' AS row
MATCH (p:Person {tmdbId: toInteger(row.person_tmdbId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (p)-[r:DIRECTED]->(m);

MATCH (p:Person)-[:ACTED_IN]->()
WITH DISTINCT p SET p:Actor;

MATCH (p:Person)-[:DIRECTED]->()
WITH DISTINCT p SET p:Director;
```

We can run this query at any point to refresh the database with the latest data. A single process to build our graph provides a consistent mechanism to test our import.

### Transactions
Importing significant volumes of data in a single transaction can result in large write operations - this can cause performance issues and potential failure.

We can split a query into multiple transactions using the `CALL` clause with `IN TRANSACTIONS`:
```sql
CALL {
  // our query here
} IN TRANSACTIONS [OF X ROWS]
```
For example, we can create the `Person` nodes in each individual transaction of 100 rows:
```sql
:auto
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/persons.csv' AS row
CALL (row) {
    MERGE (p:Person {tmdbId: toInteger(row.person_tmdbId)})
    SET
        p.imdbId = toInteger(row.person_imdbId),
        p.bornIn = row.bornIn,
        p.name = row.name,
        p.bio = row.bio,
        p.poster = row.person_poster,
        p.url = row.person_url,
        p.born = date(row.born),
        p.died = date(row.died)
} IN TRANSACTIONS OF 100 ROWS
```
This will create `Person` nodes in batches of 100 rows at each transaction.

The `:auto` browser command executes the query in **auto-committing transactions**. This means that each transaction is committed automatically after the query is executed. This is useful for large queries that may take a long time to run, as it allows the database to commit the changes in smaller batches rather than waiting for the entire query to finish. This can help reduce the risk of running out of memory or causing other performance issues.


### Multiple passes
If we have a csv file `books.csv` with the following data:
```csv
id,title,author,publication_year,genre,rating,still_in_print,last_purchased
19515,The Heights,Anne Conrad,2012,Comedy,5,true,2023/4/12 8:17:00
39913,Starship Ghost,Michael Tyler,1985,Science Fiction|Horror,4.2,false,2022/01/16 17:15:56
60980,The Death Proxy,Tim Brown,2002,Horror,2.1,true,2023/11/26 8:34:26
18793,Chocolate Timeline,Mary R. Robb,1924,Romance,3.5,false,2022/9/17 14:23:45
67162,Stories of Three,Eleanor Link,2022,Romance|Comedy,2,true,2023/03/12 16:01:23
25987,Route Down Below,Tim Brown,2006,Horror,4.1,true,2023/09/24 15:34:18
```
We could import the data using
```sql
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/books.csv' AS row
MERGE (b:Book {id: row.id})
SET b.title = row.title
MERGE (a:Author {name: row.author})
MERGE (a)-[:WROTE]->(b)
```
This will create `Book` and `Author` nodes, and create a `WROTE` relationship between them.

Queries with multiple operations chained together have the potential to write data and then read data that is out of sync- which can result in an **Eager** operator. The Eager operator will cause any operations to execute in their entirety before continuing, ensuring isolation between the different parts of the query. When importing data the Eager operator can cause high memory usage and performance issues.

A better approach to avoid the Eager operator is to break the import into smaller parts. By taking multiple passes over the data file, the query also becomes simpler to understand and change to fit the data model.

In the example above, the import could be broken into three parts:
- Create the `Book` nodes
- Create the `Author` nodes
- Create the `WROTE` relationships

So we could run the following queries:
```sql
// Create "Book" nodes
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/books.csv' AS row
MERGE (b:Book {id: row.id})
SET b.title = row.title;

// Create "Author" nodes
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/books.csv' AS row
MERGE (a:Author {name: row.author});

// Create "WROTE" relationships
LOAD CSV WITH HEADERS
FROM 'https://data.neo4j.com/importing-cypher/books.csv' AS row
MATCH (a:Author {name: row.author})
MATCH (b:Book {id: row.id})
MERGE (a)-[:WROTE]->(b);
```