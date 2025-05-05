# Intermediate Cypher Queries

We will use the movie dataset for all the queries in this example in GraphAcademy. The graph data model is as follows:

<img src="imgs/movie-data-model.png" alt="Movie Data Model" width="50%"/>

## Filtering Queries
In a graph database, we can view the data model by exucuting
```sql
CALL db.schema.visualization()
```
The node labels for the graph invlude:
- `Person`
- `Actor`
- `Director`
- `Movie`
- `Genre`
- `User`

The relationship types include:
- `ACTED_IN` (with an optional role property)
- `DIRECTED` (with an optional role property)
- `RATED` (with rating and timestamp properties)
- `IN_GENRE`

We know that the nodes have a number of properties, along with the type of data that will be used for each property. We can view the property types for nodes in the graph by executing
```sql
CALL db.schema.nodeTypeProperties()
```
We can view the property types for relationships in the graph by executing
```sql
CALL db.schema.relTypeProperties()
```

Each node with a given label has a property that uniquely identifies the node. These nodes are indexed in the graph.
- `Movie` nodes use `movieId`
- `Person` nodes use `tmdbId`
- `User` nodes use `userId`
- `Genre` nodes use `name`

We can view the uniqueness constraint indexes in the graph by executing
```sql
SHOW CONSTRAINTS
```

### Basic Cypher Queries

#### Testing equality
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = "Tom Hanks"
AND m.year = 2013
RETURN m.title
```
This query
- finds all `Person` nodes with the name "Tom Hanks"
- traverses the `ACTED_IN` relationship to find all `Movie` nodes, and filter for movies released in 2013
- returns the title of the movie

We are specyfing the pattern to *traverse through the graph*, and then filtering on what data is retrieved within that pattern.

#### Testing inequality
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name <> "Tom Hanks"
AND m.title = "Captain Phillips"
RETURN p.name
```
This query returns the names of all actors that acted in the movie "Captain Phillips" where "Tom Hanks" is excluded. The `<>` operator is used to test for inequality.

#### Testing less than or greater than
```sql
MATCH (m:Movie) WHERE m.title = "Toy Story"
RETURN
    m.year < 1995 AS lessThan, // Less than (false)
    m.year <= 1995 AS lessThanOrEqual, // Less than or equal (true)
    m.year > 1995 AS greaterThan, // Greater than (false)
    m.year >= 1995 AS greaterThanOrEqual // Greater than or equal (true)
```

#### Testing ranges
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = "Tom Hanks"
AND 2005 <= m.year <= 2010
RETURN m.title, m.released
```
This query returns the title and release date of movies that Tom Hanks acted in between 2005 and 2010. 

We can also use `OR` to expand the filtering to return more data as follows:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = "Tom Hanks"
OR m.title = "Captain Phillips"
RETURN p.name, m.title
```

#### Testing `null` property values
A property for a node or relationship is null if it does not exist. We can test the existence of a property for a node using the `IS NOT NULL` predicate.
```sql
MATCH (p:Person)
WHERE p.died IS NOT NULL
AND p.born.year >= 1985
RETURN p.name, p.born, p.died
```
This query returns the names, born, and died properties for all people who have a value for their `died` property and were born after 1985.  We can also test `IS NULL` predicate:
```sql
MATCH (p:Person)
WHERE p.died IS NULL
AND p.born.year <= 1922
RETURN p.name, p.born, p.died
```

#### Testing labels or patterns
We can test for a label's existence on a node using the `{alias}:{label}` syntax.
```sql
MATCH (p:Person)
WHERE p.born.year > 1960
AND p:Actor
AND p:Director
RETURN p.name, p.born, labels(p)
```
This query will retrieve all `Person` nodes with the labels `Actor` and `Director` that were born after 1960. The `labels()` function returns the list of labels for a node.

Rather than using the `Actor` and `Director` labels, we can also use the relationship types `ACTED_IN` and `DIRECTED` to imply that the node at the other end of the relationship has the correct label:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]>-(p)
WHERE p.born.year > 1960
RETURN p.name, p.born, labels(p), m.title
```

#### Discovering relationships
```sql
MATCH (p:Person)-[r]->(m:Movie)
WHERE p.name = "Tom Hanks"
RETURN m.title AS movie, type(r) AS relationshipType
```
This query retrieves all `Movie` nodes that are related to Tom Hanks. Each row returned is a movie title and the type of relationship that Tom Hanks has to that movie. The `type()` function returns the type of relationship.

#### Testing list includsion
```sql
MATCH (m:Movie)
WHERE "China" IN m.countries
RETURN m.title, m.languages, m.countries
```

### Testing Strings
When the property is a string type, we can filter with different string functions.
```sql
MATCH (m:Movie)
WHERE m.title STARTS WITH "Toy Story"
RETURN m.title, m.released
```
This query returns movie titles and release dates for movies that start with "Toy Story". We can also use `CONTAINS` and `ENDS WITH` functions:
```sql
MATCH (m:Movie)
WHERE m.title ENDS WITH "Story"
RETURN m.title, m.released
```
Or
```sql
MATCH (m:Movie)
WHERE m.title CONTAINS "Story"
RETURN m.title, m.released
```

String matching in Cypher is case-sensitive. We can use the `toLower()` function to convert the string to lower case before matching:
```sql
MATCH(p:Person)
WHERE toLower(p.name) ENDS WITH "demille"
RETURN p.name
```
Conversely, we can use the `toUpper()` function to convert the string to upper case before matching:
```sql
MATCH(p:Person)
WHERE toUpper(p.name) STARTS WITH "DEMILLE"
RETURN p.name
```
We can combine with `CONTAINS`:
```sql
MATCH(p:Person)
WHERE toUpper(p.name) CONTAINS "DE"
RETURN p.name
```

If we transform a string property during a query, such as `toLower()` or `toUpper()`, the query engine turns off the use of the index. With any query, we can always check if an index will be used by prefixing the query with `EXPLAIN`:
```sql
EXPLAIN MATCH (m:Movie)
WHERE m.title STARTS WITH "Toy Story"
RETURN m.title, m.released
```
This query produces the execution plan where the first step is `NodeIndexSeekByRange`. In this case an index will be used because it is defined in the graph.

<img src="imgs/string-explain.PNG" alt="String Explain" width="50%"/>

A best practice for handling property values that need to be evaluated as upper, lower, or mixed case is to use fulltext schema indexes.

### Query Patterns and Performance
A pattern is a combination of nodes and relationships that is used to traverse the graph at runtime. We can write queries that test whether a pattern exists in the graph:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = "Tom Hanks"
AND exists {(p)-[:DIRECTED]->(m)}
RETURN p.name, labels(p), m.title
```
This query
- Retrieves the anchor of the query, the Tom Hanks `Person` node
- Follows the `ACTED_IN` relationship to the `Movie` node
- Tests whether these nodes are related by the `DIRECTED` relationship for the `Movie` node and `Person` node
- Returns the rows if they are

The `exists {}` test is done for every `Movie` node related to Tom Hanks as an actor. This query returns the single movie that Tom Hanks directed and acted in.

We can use the `PROFILE` keyword to show the total number of rows retrieved from the graph in the query:
```sql
PROFILE MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = "Tom Hanks"
AND exists {(p)-[:DIRECTED]->(m)}
RETURN m.title
```
In the profile, we can see that the initial row is retrieved, but then 38 rows are retrieved for each `Movie` node that Tom Hanks acted in. Then the test is done for the `DIRECTED` relationship in the following returned image:

<img src="imgs/profile-plan.png" alt="Profile Plan" width="50%"/>

The following query is a better way to do the same query before:
```sql
PROFILE MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(p)
WHERE p.name = "Tom Hanks"
RETURN m.title
```
The query:
- Retrieves the anchor (the Tom Hanks `Person` node)
- Finds a `Movie` node where Tom Hanks is related to with the `ACTED_IN` relationship
- Traverses all `DIRECTED` relationships that point to the same Tom Hanks `Person` node

<img src="imgs/profile-plan2.png" alt="Profile Plan 2" width="50%"/>

This traversal is very efficient because the graph engine can take the internal relationship cardinalities into account. If we execute this query, it returns the same result as the previous query. However, this query is much more efficient.

The difference between using `EXPLAIN` and `PROFILE` is that `EXPLAIN` provides estimates of the query steps where `PROFILE` provides the exact steps and number of rows retrieved for the query.

We have already seen how we use `exists { }` to test for the existence of a pattern. We can also use `NOT exists { }` to exclude patterns in the graph. For example, we want to find all the movies that Tom Hanks acted in, but did not direct:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name = "Tom Hanks"
AND NOT exists {(p)-[:DIRECTED]->(m)}
RETURN m.title
```
Here we want to exclude the `DIRECTED` relationship to moveis for Tom Hanks.

### Multiple MATCH Clauses