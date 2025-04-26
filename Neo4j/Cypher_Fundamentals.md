# Cypher Fundamentals

We will use the Movies example dataset and will create and execute Cypher code to find actors and movies in our graph. The data model contains nodes with labels `Person` and `Movie`. `Person` nodes have several types of relationships to `Movie` nodes. A `Person` node can have a `FOLLOWS` relationship to another `Person` node.

## What is Cypher?

Cypher is a query language designed for graphs. The pattern in Cypher:
- Nodes are represented by parentheses `( )`.
- We use a colon to signify the label(s), for example `(:Person)`.
- Relationships between nodes are written with two dashes, for example `(:Person)--(:Movie)`.
- The direction of a relationship is indicated using a greater than or less than symbol, for example `(:Person)->(:Movie)`.
- The type of the relationship is written using the square brackets between the two dashes, for example `[:ACTED_IN]`
- Properties drawn in a *speech bubble* are specified in a JSON like syntax.
  - Properties in Neo4j are key/value pairs, for example `{name: 'Tom Hanks'}`.

For example, a Cypher pattern in the graph could be:
```cypher
// example Cypher pattern
(m:Movie {title: 'Cloud Atlas'})<-[:ACTED_IN]-(p:Person)
```

## How Cypher works
Cypher works by matching patterns in the data. We retrieve data from the graph using the `MATCH` keyword. The `MATCH` keyword is similar to the `FROM` clause in the SQL language.

For example, if we want to find a `Person` in the graph,
```sql
MATCH (:Person)
// incomplete MATCH clause because we need to return something
```

Suppose we want to retrieve all `Person` nodes from the graph. We can assign a variable by placing a value before the colon.
```sql
MATCH (p:Person)
RETURN p
```
This query returns all nodes in the graph with the `Person` label.

Suppose we want to find the node which represents the `Person` whose name is Tom Hanks. Our `Person` nodes all have a `name` property. We can use `{..}` to specify the key-value pair of name and Tom Hanks as the filter.
```sql
MATCH (p:Person {name: 'Tom Hanks'})
RETURN p
```
This query returns a single node that represents Tom Hanks.

In our Cypher statement, we can access properties using a dot notation. For example, to return the `born` property value from the `Person` node,
```sql
MATCH (p:Person {name: 'Tom Hanks'})
RETURN  p.born
```
This query returns the value of the `born` property of the Tom Hanks node.

NOTE: In Cypher, labels, property keys, and variables are case-sensitive. Cypher keywords are not case-sensitive. 

Neo4j best practices include:
- Name labels using **CamelCase**.
- Name property keys and variables using **camelCase**.
- Use **UPPERCASE** for Cypher keywords.

Another way that you can filter queries is by using the `WHERE` clause, rather than specifying the property value inline with braces.
```sql
MATCH (p:Person)
WHERE p.name = 'Tom Hanks'
RETURN p.born
```
This query returns the same data as the previous query.

Using the `WHERE` clause to filter our queries is more flexible because we can add more logic to our `WHERE` clause. For example, we can filter by two values for `name`:
```sql
MATCH (p:Person)
WHERE p.name = 'Tom Hanks' OR p.name = 'Rita Wilson'
RETURN p.name, p.born
```
This query returns two names and their associated birth years.

## Finding Relationships

We have used the `MATCH` clause to find the node in our database that represented Tom Hanks.

We can now extend the pattern in the `MATCH` clause to *traverse* through all relationships with a type of `ACTED_IN` to any node. Note that the `ACTED_IN` relationship in our domain model is an outgoing relationship from the `Person` node to the `Movie` node. We can use the `->` operator to indicate the direction of the relationship and we use the variable `m` to represent the `Movie` node without specifying the `:Movie` label.
```sql
MATCH (p:Person {name: 'Tom Hanks'})-[:ACTED_IN]->(m)
RETURN m.title
```
This query returns the titles of all movies that Tom Hanks acted in as a list.

In this database, we only have the `Movie` label associated with the `ACTED_IN` relationship. However, if our graph had different labels, for examle, `:Movie` and `:Television`, then this query would have returned all `Movie` and `Television` nodes at the end of the `ACTED_IN` relationship in our graph. To make sure that we only return `Movie` nodes, we can specify the label in the pattern.
```sql
MATCH (p:Person {name: 'Tom Hanks})-[:ACTED_IN]->(m:Movie)
RETURN m.title
```

## Filtering Queries

We can apply *equality* to filter what we want to retrieve. For example, we can retrieve the `Person` nodes and `Movie` nodes where the person acted in a movie that was released in 2008 or 2009:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.released = 2008 OR m.released = 2009
RETURN p, m
```

We can also return the names of all people who acted in the movie *The Maxtrix*:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE m.title = 'The Matrix'
RETURN p.name
```
An alternative way to this query is the following where we test the node labels in the `WHERE` clause:
```sql
MATCH (p)-[:ACTED_IN]->(m)
WHERE p:Person AND m:Movie AND m.title = 'The Matrix'
RETURN p.name
```
This query returns the same result as the previous query.

### Filtering using ranges
We can specify a range for filtering a query. For example, we can retrieve `Person` nodes of people who acted in movies released between 2000 and 2003:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE 2000 <= m.released <= 2003
RETURN p.name, m.title, m.released
```

### Filtering by existence of a property
We can return `Movie` nodes where *Jack Nicholson* acted in the movie and the movie has the `tagline` property:
```sql
MATCH (p:Person-[:ACTED_IN])->(m:Movie)
WHERE p.name = 'Jack Nicholson' AND m.tagline IS NOT NULL
RETURN m.title, m.tagline
```
The `IS NOT NULL` operator checks for the existence of the `tagline` property. We can also use the `IS NULL` operator to check for the absence of a property.

### Filtering by partial strings
Cypher has a set of string-related keywords that we can use in our `WHERE` clause, such as `STARTS WITH`, `ENDS WITH`, and `CONTAINS`. 

For example, to find all actors in a graph whose first name is *Michael*, we could write
```sql
MATCH (p:Person)-[:ACTED_IN]->()
WHERE p.name STARTS WITH 'Michael'
RETURN p.name
```

String tests are case-sensitive, so we may need to use the `toLower()` or `toUpper()` functions to ensure the test yields the correct results.
```sql
MATCH (p:Person)-[:ACTED_IN]->()
WHERE toLower(p.name) STARTS WITH 'michael'
RETURN p.name
```

### Filtering by patterns in the graph
Suppose we want to find all people who wrote a movie but did not direct that same movie:
```sql
MATCH (p:Person)-[:WROTE]->(m:Movie)
WHERE NOT exists( (p)-[:DIRECTED]->(m) )
RETURN p.name, m.title
```
This query uses the `exists()` function to check for the existence of a relationship between two nodes. The `NOT` operator negates the result of the `exists()` function.

### Filtering using lists
If we have a set of values we want to test with, we can place them in a list or we want test with an existing list in the graph. A Cypher list is a *comma-separated* set of values within square brackets.

We can place either numeric or string values in the list, but typically, elements of the list are of the same type of data. For example, we can retrieve `Person` nodes of people born in 1965, 1970, or 1975:
```sql
MATCH (p:Person)
WHERE p.born IN [1965, 1970, 1975]
RETURN p.name, p.born
```

We can also compare a value to an existing list in the graph.

The `:ACTED_IN` relationship has a property called `roles` that contains the list of roles an actor had in a particular movie they acted in. We can return the name of the actor who played *Neo* in the movie *The Matrix*:
```sql
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE 'Neo' IN r.roles AND m.title = 'The Matrix'
RETURN p.name, r.roles
```

### What properties does a a node or relationship have?
We can use the `keys()` function to returns a list of all property keys for a node.
```sql
MATCH (p:Person)
RETURN p.name, keys(p)
```

### What properties exist in the graph?
We can run the following code to return all the property keys defined in the graph:
```sql
CALL db.propertyKeys()
```