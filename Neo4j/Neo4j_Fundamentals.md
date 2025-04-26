# Neo4j Fundamentals

## What is Neo4j?

Neo4j is a graph database that stores data in a graph. Data is stored as nodes and relationships instead of tables or documents. A graph shows *how objects are related to each other*. The objects are referred to as **nodes** (vertices) connected by **relationships** (edges).

Neo4j uses the graph structure to store data and is known as a **labeled property graph**. Data within Neo4j is stored and organized using
- **Nodes**
- **Relationships**
- **Labels**
- **Properties**

### Nodes

**Nodes** are represented as circles in a graph. Nodes typically represent *objects* or *entities*. Each entity would be stored as a separate node in the graph.

### Labels

Nodes are grouped by or categorized using **labels**. Labels describe what the nodes are, for example, `Person`, `Company`, `Location`. Nodes of the same type would have the same label. Labels allow us to distinguish between different types of nodes and filter the graph.

Nodes can have multiple labels, for example, a node can be labeled as both `Person` and `Employee`. 

Nodes typically represent things, and should be given a singular noun label. For example, `Product`, `Event`, `Account`, etc.

### Relationships

Relationships are the lines in the graph. Relationsihps describe how nodes within the graph are connected to each other.

A relationship in Neo4j connects two nodes, referred to as the **start** and **end** nodes.

All relationships have
- a **type** (e.g., `WORKS_AT`, `FOUNDED_IN`)
- a **directions** (e.g., Bin `WORKS_AT` Neo4j, but Neo4j does not work at Bin.)

Nodes can have multiple relationships to other nodes. Multiple relationships can be used to describe bi-directional relationships, so we need two `FRIENDS_WITH` relationships to describe a friendship between two people.

We can use a relationship to represent:
- a personal connection (e.g., `Person KNOWS Person`, `Person MARRIED_TO Person`)
- a fact (e.g., `Person LIVES_IN Location`, `Person OWNS Car`, `Person RATED Movie`)
- a hierarchy (e.g., `Parent PARENT_OF Child`, `Software DEPENDS_ON Library`)
- any type of connection between two entities (e.g., `Entity CONNECTED_TO Entity`)

### Properties

We can store data against nodes and relationships as properties. Properties are named key, value pairs; for example, *firstName*, *lastName*, and *position*. For example, a `Person` node can have properties such as `firstName`, `lastName`, and `age`. A `WORKS_AT` relationship can have properties such as `position`, `startDate` and `endDate`. 

Properties have a type (e.g, integer, boolean, string, list, etc) and can be unique identifiers (keys) for specific node labels.

## Thinking in Graphs

Relationships in a graph are treated with the same importance as nodes that connect them.

Storing data in rows and columns is what traditionally been done in relational databases. Tabular data works well for many use cases, however, as the amount of data grows or the application or use case becomes more complex, we may encounter challenges dealing with relationships. When querying across tables, the joins are computed at read-time, using an index to find the corresponding rows in the target table. The more data added to the database, the larger the index grows, the slower the response time. This is known as the "Big O" or O(n) problem.

### Graphs

When we create a relationship between two nodes, the database stores a pointer to the relationship with each node. When reading data, the database will follow pointers in memory rather than relying on an underlying index. This means that the query time remains constant to the size of the relationships expanded regardless of the overall size of the data.

A graph database yields faster results for queries across entities when we need to
- understand the relationships between entities (e.g., how two people are connected)
- self reference data of the same type (e.g., a hierarchy of employees within a company)
- explore relationships of varying or unkonwn depth (e.g., the use of parts within a factory)
- calculate a route between two points in a network (e.g., finding the most efficient route on public transport)

## Graphs are Everywhere

Graphs allow us to uncover patterns in our data, whether that be:
- **Customer**: using customer data for recommendations, churn prevention, tailored offers, and targeted ads, enhancing customer retention and revenue growth.
- **Network & Security*: analyzing IT asset data to support comprehensive security monitoring and proactive threat response.
- **Employee**: storing employee data to support talent development, career management, and resource allocation, helping align workforce capabilities with business needs.
- **Transactions**: capturing transactional data to detect illegal activities, supporting anti-money laundering, fraud detection, credit risk assessment, and credit fraud detection by revealing hidden patterns, anomalies, and connections.
- **Product**: centralizing product data to support personalized recommendations, optimize new product launches, enhance customization, manage inventory, and refine pricing strategies.
- **Suppliers**: storing data on supplier performance, inventory, costs, logistics, and compliance to optimize supply chain management, supporting programs like route planning, real-time visibility, inventory planning, and risk analysis.
- **Process**: creating a graph of process-related data can identify bottlenecks, improve efficiency, automate tasks, and monitor performance by analyzing operational, resource, quality, and cost data.

### Knowledge Graphs & GenAI

GenAI applications need access to the meaning in data, and *knowledge graphs* can provide this context. **Knoledge graphs** provide a structured way to represent entities, their attibutes, and their relationships, allowing for a comprehensive and interconnected understanding of the information. For example, search engines typically use knowledge graphs to provide information about people, places, and things. Knowledge graphs can break down sources of information and integrate them, allowing us to see the relationships between the data.

### Routing

Graphs are easy to visualize in route planning. By finding the shortest or most efficient paths throught the network, we can engage in problem-solving similar to graph traversal, optimizing routes efficiently.

A higher level graph may contain weighted relationships between nodes, while a lower level graph may contain unweighted relationships.


## Reading Graphs

Graph databases have their own query language, GQL, an ISO standard for graph databases.

Cypher is Neo4j's implementation of GQL. Cypher is a declarative language, meaning that the database is responsible for finding the most optimal way of executing that query.

In the GraphAcademy course, Neo4j has a [Neo4j database instance](https://sandbox.neo4j.com/?_gl=1*xd2m9y*_gcl_au*MTgzNTEzNTU4NS4xNzQ0Mzc2ODU1*_ga*MTMzNzk4NDIxMy4xNzQ0Mzc2ODU1*_ga_DL38Q8KGQC*MTc0NTUwNjY2MC42LjEuMTc0NTUwODc3Ni4wLjAuMA..*_ga_DZP8Z65KK4*MTc0NTUwNjY2MC42LjEuMTc0NTUwODc3Ni4wLjAuMA..) for us to explore. In this default example database, the graph contains `Person` and `Movie` nodes. Each of `Person` node may have one or more outgoing `ACTED_IN` and `DIRECTED` relationships to a `Movie` node.

Movies are categorized into one or more genres, for example, Adventure, Animation, and Comedy. The `Movie` nodes are connected to `Genre` nodes by an `IN_GENRE` relationship.

The graph also contains `User` nodes and over 100,000 movie ratings. `User` nodes are connected to `Movie` nodes by a `RATED` relationship.

### People

To find a `Person` node with the `name` attribute `'Tom Hanks'`, we can run
```sql
MATCH (n:Person)
WHERE n.name = 'Tom Hanks
REUTRN n
```
Each `Person` node has an unique `name` property and other properties such as `bio` and `born`. We can view the node properties by selecting the node. We can also expand the node's relationship by double-clicking the node. Then we can see there are `ACTED_IN` and `DIRECTED` relationships to `Movie` nodes.

### Movies

Each `Movie` node has a unique `title` property and other properties including `plot`, `released`, and `url`. To find the movie `'Toy Story'`, we can run
```sql
MATCH (m:Movie)<-[r:ACTED_IN]-(p:Person)
WHERE m.title = 'Toy Story'
RETURN m, r, p
```
This query uses the `[ACTED_IN]` relationship to find the `Person` nodes who have a connection to the `Movie` node.

To find related `Genre` nodes, we can run
```sql
MATCH (m:Movie)-[r:IN_GENRE]->(g:Genre)
WHERE m.title = 'Toy Story'
RETURN m, r, g
```

We can return tabular data by including the properties of the nodes.
```sql
MATCH (m:Movie)-[r:IN_GENRE]->(g:Genre)
WHERE m.title = 'Toy Story'
RETURN m.title, g.name
```

### User Ratings

To find all the movies rated by a specific `User` (`"Mr. Jason Love"`), we can run
```sql
MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE u.name = 'Mr. Jason Love'
RETURN u, r, m
```

The `rating` the user has given for the movie is stored as a property on the `RATED` relationship. We can run the following query to return a table of movie ratings:
```sql
MATCH (u:User)-[r:RATED]->(m:Movie)
WHERE u.name = 'Mr. Jason Love'
RETURN u.name, r.rating, m.title
```

## Pattern Matching

Cypher is a **declarative** query language that allows us to identify **patterns** in our data using an **ASCII-art style syntax** consisting of **brackets**, **dashes**, and **arrows**.

For example,
```sql
(p:Person)-[r:ACTED_IN]->(m:Movie)
```
finds all nodes with a label of `Person`, that have an *outgoing* `ACTED_IN` relationship to a node with a label of `Movie`.

### Nodes

Nodes in the pattern are expressed with parentheses - `( )`. Inside the paretheses, we can define information about the node, for example, the label(s) or properties the node should contain.

Labels are prefixed a colon - `(:Label)`. The pattern contains two nodes `(:Person)` and `(:Movie)`. 

### Relationships

Relationships are drawn with two dashes (`--`) and an arrow to specify the direction (`<` or `>`).

Relationship information is contained within sqaure brackets - `[ ]`. The relationship type is prefixed with a colon - `[:TYPE]`. The pattern contains one relationship - `-[:ACTED_IN]->` between `(:Person)` and `(:Movie)` nodes.

### Variables
The nodes and relationships in the pattern are assigned to variables. These variables are positioned before the information about the node or relationship.
- `p` - the `:Person` node
- `r` - the `:ACTED_IN` relationship
- `m` - the `:Movie` node

### `MATCH`-ing

The `MATCH` clause is used to find patterns in the data.

```sql
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Tom Hanks'
RETURN p,r,m
```
In this query, we should identify
- the pattern being used
- a `WHERE` clause which filters the results
- the variables used in the `RETURN` clause

Patterns can be as simple as a single node, or contain multiple relationships. The following example find all people who have acted in movies with `"Tom Hanks"`, and uses the `RETURN` clause to define the properties:
```sql
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[r:ACTED_IN]-(p2:Person)
WHERE p.name = 'Tom Hanks'
RETURN p2.name AS actor, m.title AS movie, r.role AS ROLE
```
This pattern uses the `ACTED_IN` relationship to find the movies that `Tom Hanks` is in, and then a second time to find the actos in the movies with `"Tom Hanks"`.

The keyword `AS` is used to define an alias, for example, the property `p2.name` will be returned as `actor`.


## Creating Graphs

The `MERGE` clause is used to create nodes and relationships in the database. We can use the `MERGE` clause to create a pattern if the pattern does not already exist.

### Create a Movie node
```sql
MERGE (m:Movie {title: "Arthur the King"})
SET m.year = 2024
RETURN m
```
In this query, we should identify
- the `MERGE` clause is used
- The pattern creates a node with a label `Movie` - `(m:Movie)`
- The `title` is included as part of the pattern - `{title: "Arthur the King"}`
- A single property `year` is set - `SET m.year = 2024`

This will create and return a new node.

### Create a RATED relationship
```sql
MERGE (m:Movie {title: "Arthur the King"})
MERGE (u:User {name: "Adam"})
MERGE (u)-[r:RATED {rating: 5}]->(m)
RETURN u, r, m
```
This query creates
- a `Movie` node
- a `User` node
- a `RATED` relationship between them, that has a `rating` property of 5

Note that the previous `year` property is not set in this query. The `MERGE` clause will not create a new node if the node already exists, so the `year` property will not be set again but will be retained.

`MERGE` uses the properties in the pattern to identify an existing node or relationship before creating it. Running this query multiple times would only result in the nodes and relationship being created once.