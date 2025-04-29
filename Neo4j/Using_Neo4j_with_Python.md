# Using Neo4j with Python

## The Driver
To install the Neo4j driver for Python, we can use `pip`:
```shell
pip install neo4j
```

After installing the driver, we can create an instance:
```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver(
    "bolt://localhost:7687",  # URI of the Neo4j database
    auth=("neo4j", "password")  # Authentication credentials (username, password)
)
```
The best practice is to create a single driver instance and reuse it throughout our entire application.

We can verify the connection is correct:
```python
driver.verify_connectivity()
```
This will raise an exception if the connection is not valid.

### Running the first query
The `execute_query()` method executes a Cypher query and returns the results:
```python
records, summary, keys = driver.execute_query(
    "RETURN COUNT {()} AS count", # This gets the count of all nodes in the database
)

# `records` contains a list of the rows returned
# Get the first record
first = records[0]

# Keys from the `RETURN` clause are accessed as dictionaries
print(first['count'])
```

### Full driver lifecycle
Once we have finished with the driver, we should call `close()` to release any resources:
```python
driver.close()
```

We can use `with` to create an all-in-one solution that will automatically close the driver when the block is exited:
```python
with GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USERNAME, NEO4J_PASSWORD)) as driver:
    records, summary, keys = driver.execute_query(
        "RETURN COUNT {()} AS count",
    )
```

### Executing Cypher statements
The `execute_query()` method is used to execute Cypher statements. 

We can write a Cypher statement as a string and pass it to the `execute_query()` method:
```python
cypher = """
MATCH (p:Person {name: $name})-[r:ACTED_IN]->(m:Movie)
RETURN m.title AS title, r.role as role
"""
name = "Tom Hanks"

records, summary, keys = driver.execute_query(
    cypher,
    name=name,  # Pass the parameter as a keyword argument
)
```
The method returns a tuple that can be unpacked into `records`, `summary`, and `keys`. In the `cypher` variable, we can use `$name` to refer to the parameter passed in. Any named parameters not suffixed with an underscore can be accessed in the query by prefixing the name with `$`.

It is good practice to use parameters in our queries to avoid malicious code being injected into our Cypher statements.


The `execute_query()` method returns
- `records`: a list of `Record` objects
- `summary`: a summary of the query execution
- `keys`: a list of keys specified in the `RETURN` clause

If we print out these,
```python
print(keys) # ['title', 'role']
print(summary) # a summary of the query execution
```

As we just mentioned, each row returned by the query is a `Record` object. The `Record` object is a dictionary-like object that provides access to the data returned by the query:
```python
# RETURN m.title AS title, r.role as role

for record in records:
    print(record['title']) # "Toy Story"
    print(record['role']) # "Woody"
```

The `execute_query()` method also accepts a `result_transformer_` argument that allows us to transform the result into an alternative format. For example, rather than returning the tuple, the query below will return the output of the `result_transformer_` function:
```python
result = driver.execute_query(
    cypher,
    name=name,
    # change the format
    result_transformer_= lambda result:[
        f"Tom Hanks played {record['role']} in {record['title']}"
        for record in result
    ]
)

print(result) # ["Tom Hanks played Woody in Toy Story", ...]
```

In the `neo4j` python package, the `Result` class can provide a `to_df()` method that transforms the result into a pandas `DataFrame`:
```python
from neo4j import Result

driver.execute_query(
    cypher,
    name=name,
    result_transformer_=Result.to_df,  # Transform the result into a pandas DataFrame
)
```

By default, `execute_query()` runs in **WRITE** mode. When we only read data, we can optimize performance by setting the `routing_` parameter to **READ** mode:
```python
from neo4j impot Result, RoutingControl

driver.execute_query(
    cypher,
    name=name,
    result_transformer_=Result.to_df,
    routing_=RoutingControl.READ, # or simply `r`
)
```
We can also pass `r` for read mode and `w` for write mode.

## Handling results
The majority of the types returned by a Cypher query are mapped directly to Python types:
| Python Type | Neo4j Cypher Type |
|-------------|-------------------|
| `None` | `null` |
| `bool` | `Boolean` |
| `int` | `Integer` |
| `float` | `Float` |
| `str` | `String` |
| `bytearray` | `Bytes [1]` |
| `list` | `List` |
| `dict` | `Map` |

However, some more complex types need special handling:
- Graph types - Nodes, Relationships, and Paths
- Temporal types - Dates and Times
- Spatial types - Points and distances

### Graph types
We will find all movies with the specified title and return `person`, `acted_in` and `movie`:
```python
# Return nodes and relationships
movie = "Toy Story"
records, summary, keys = driver.execute_query(
    """
    MATCH path = (person:Person)-[actedIn:ACTED_IN]->(movie:Movie {title: $title})
    RETURN path, person, actedIn, movie
    """,
    title=movie
)
```

#### Nodes
Nodes are returned as a `Node` object.
```python
for record in records:
    node = record['movie']

print(node)
print(node.element_id) # The internal ID of the node
print(node.labels) # a fronzenset of labels attributed to the Node
print(node.items()) # a list of tuples (key, value) for the properties of the node

print(node['name'])
print(node.get('name', 'N/A')) # Get the value of the property 'name' or 'N/A' if it does not exist
```

#### Relationships
Relationships are returned as a `Relationship` object.
```python
acted_in = record['actedIn']

print(acted_in)
print(acted_in.id) # The internal ID of the relationship
print(acted_in.type) # The type of the relationship, e.g., "ACTED_IN"
print(acted_in.items()) # a list of tuples (key, value) for the properties of the relationship

print(acted_in['role'])
print(acted_in.get('role', '(Unknown)')) # Get the value of the property 'role' or '(Unknown)' if it does not exist

print(acted_in.start_node) # The start node of the relationship
print(acted_in.end_node) # The end node of the relationship
```

#### Paths
A path is a sequence of nodes and relationships and is returned as a `Path` object.
```python
path = record['path']

print(path)
print(path.start_node) # The start node of the path
print(path.end_node) # The end node of the path
print(len(path)) # number of relationships in the path
print(path.relationships) # a tuple of `Relationship` objects in the path
```

**Paths are iterable**. We can use `iter(path)` to iterate over the relationships in a path.

### Dates and times
The `neo4j.time` module provides classes for working with dates and times in Python.

| Type | Description | Date? | Time? | Timezone? |
|--------|-------------|-------|--------|-----------|
| `Date` | A tuple of Year, Month and Day | Y | | |
| `Time` | The time of the day with a UTC offset | Y | Y | |
| `LocalTime` | A time without a timezone | | Y | |
| `DateTime` | A combination of Date and Time | Y | Y | Y |
| `LocalDateTime` | A combination of Date and Time without a timezone | Y | Y | |

#### Writing temporal types
```python
from neo4j.time import DateTime
from datetime import timezone, timedelta

cypher = """
CREATE (e:Event {
    startsAt: $datetime,
    createdAt: datetime($dtstring),
    updatedAt: datetime()
})
"""
parameters = {
    "datetime": DateTime(
        2025, 4, 29, 11, 30, 0,
        tzinfo=timezone(timedelta(hours=2))
    ),
    "dtstring": "2025-04-29T11:30:00+02:00
}

driver.execute_query(cypher, **parameters)
```
In the `cypher` variable, we use a `DateTime` object as a parameter, we cast an ISO 8601 format string within the Cypher query, and we get the current date and time using the `datetime()` function in Cypher. The `datetime()` function is not from `datetime` module in Python, but from the Neo4j database.

#### Reading temporal types
When reading temporal types from the database, we will receive an instance of the corresponding Python type unless we cast the value within our query:
```python
# Query returning temporal types
records, summary, keys = driver.execute_query(
    """
    RETURN date() as date, time() as time, datetime() as datetime, toString(datetime()) as asString
    """
)

# Access the first record
for record in records:
    # Automatic conversion to Python driver types
    date = record['date'] # neo4j.time.Date
    time = record['time'] # neo4j.time.Time
    datetime = record['datetime'] # neo4j.time.DateTime
    as_string = record['asString'] # str
```

#### Working with Durations
```python
from neo4j.time import Duration, DateTime

starts_at = DateTime.now()
event_length = Duration(hours=1, minutes=30)
ends_at = starts_at + event_length

driver.execute_query(
    """
    CREATE (e:Event {
        startsAt: $startsAt, 
        endsAt: $endsAt,
        duration: $eventLength,
        interval: duration('P30M')
    })""",
    startsAt=starts_at,
    endsAt=ends_at,
    eventLength=event_length,
)
```
Durations represent a period of time and can be used for date arithmetic in both Python and Cypher. We can also use the `duration.between` method to calculate the duration between two date or time objects.

### Spatial Types
Neo4j has built-in support for 2D and 3D spatial data types. These are referred to as **points**. A point may represent geographic coordinates (longitude and latitude) or Cartesian coordinates (x, y, z). Depending on the values used to create the point, it can either be a `CartesianPoint` or a`WGS84Point`.

In Python, these values are represented by the `neo4j.spatial.CartesianPoint` and `neo4j.spatial.WGS84Point` classes, which are subclasses of the `neo4j.spatial.Point` class.

| Cypher Type | Python Type | SRID | 3D SRID |
| ------------|-------------| -------|---------|
| Point (Cartesian) | `neo4j.spatial.CartesianPoint` | 7203 | 9157 |
| Point (WGS84) | `neo4j.spatial.WGS84Point` | 4326 | 4979 |

#### CartesianPoint
```python
from neo4j.spatial import CartesianPoint

two_d = CartesianPoint((x, y))
three_d = CartesianPoint((x, y, z))
```
For example, the driver will convert `point` data types created with x,y,z value to an instance of the `CartesianPoint` class:
```python
records, summary, keys = driver.execute_query(
    """
    RETURN point({x: 1.23, y: 4.56, z: 7.89}) AS threeD
    """
)

point = records[0]['threeD']

print(point.x, point.y, point.z) # 1.23 4.56 7.89
print(point.srid) # 9157

# Desctructuring
x, y, z = point
```


#### WGS84Point
A WGS (*World Geodetic System*) point consists of a `longitude` and `latitude` value. An additional `height` value can be provided to define a 3D point.
```python
from neo4j.spatial import WGS84Point

ldn = WGS84Point((-0.118092, 51.509865)) # longitude, latitude
print(ldn.latitude, ldn.longitude) # 51.509865 -0.118092
print(ldn.srid) # 4326

shard = WGS84Point((-0.086500, 51.504501, 310)) # longitude, latitude, height
print(shard.latitude, shard.longitude, shard.height) # 51.504501 -0.086500 310
print(shard.srid) # 4979

# Desctructuring
longitude, latitude, height = shard
```
The driver will return `WGS84Point` objects when `point` data types are created with `longitude` and `latitude` values in Cypher.
```python
records, summary, keys = driver.execute_query(
    """
    RETURN point({
        longitude: -0.118,
        latitude: 51.5,
        height: 100
    }) AS point
    """
)

point = records[0]['point']
longitude, latitude, height = point
```

#### Distance
The `point.distance` function can be used to calculate the distance bewteen two points with the same SRID. The result is a `float` representing the distance in a straight line between the two points.
```python
# Create two points
point1 = CartesianPoint((1, 1))
point2 = CartesianPoint((4, 5))

# Query the distance using Cypher
records, summary, keys = driver.execute_query(
    """
    RETURN point.distance($p1, $p1) AS distance
    """,
    p1=point1,
    p2=point2,
)

distance = records[0]['distance']
print(distance)
```
NOTE: **If the SRID values are different, the function will return `None`**.

## Best practices
In a production application, we may need finer control of database transactions or to run multiple related queries as part of aa single transaction. Transaction functions allow us to run multiple queries in a single transaction while accessing results immediately.

### Sessions
To execute transactions, we need to open a **session**. The `session` object manages the underlying database connections and provides methods for executing transactions:
```python
with driver.session() as session:
    # Call transaction functions here
```
Consuming a session within a `with` will automatically close the session and release any underlying connections when the block is exited.

In a multi-database instance, we can specify the database to use when creating a session using the `database` parameter.

#### Transaction functions
The session object provides:
- `Session.execute_read()`
- `Session.execute_write()`

If the entire function runs successfully, the transaction is commited automatically. If any errors occur, the entire transaction is rolled back.

#### Unit of work patterns
A unit of work is a pattern that groups related operations into a single transaction.
```python
def create_person(tx, name, age):
    result = tx.run(
        """
        CREATE (p:Person {name: $name, age: $age})
        RETURN p
        """,
        name=name,
        age=age,
    )
```
The first argument `tx` to the transaction function is always a `ManagedTransaction` object. Any additional arguments are passed from the call to `Session.execute_read` or `Session.execute_write`. The `run()` method on the `ManagedTransaction` object is called to execute a Cypher statement.

#### Multiple queries in one transaction
We can execute multiple queries within the same transaction function to ensure that all operations are completed or fail as a single unit.
```python
def transfer_funds(tx, from_account, to_account, amount):
    # Deduct from `from_account`
    tx.run(
        "MATCH (a:Account {id: #$from_}) SET a.balance = a.balance - $amount",
        from_=from_account,
        amount=amount,
    )

    # Add to `to_account`
    tx.run(
        "MATCH (a:Account {id: $to_}) SET a.balance = a.balance + $amount",
        to_=to_account,
        amount=amount,
    )
```

#### Handling outputs
The `ManagedTransaction.run()` method returns a `Result` object. The records contained within the result will be iterated over as soon as they are available. The result must be consumed within the transaction function.

The `consume()` method discards any remaining records and returns a `Summary` object that can be used to access metadata about the Cypher statement.

The `Session.execute_read()` and `Session.execute_write()` functions will return the result of the transaction function upon successful execution.
```python
with driver.session() as session:
    def get_answer(tx, answer):
        result = tx.run(
            "RETURN $answer AS answer",
            answer=answer,
        )

        return result.consume()

    # Call the transaction function
    summary = session.execute_read(get_answer, answer=14)

    # Output the summary
    print(
        "Results available after", summary.result_available_after,
        "ms and consumed after", summary.result_consumed_after, "ms"
    )
```

### Handling database errors
When working with Neo4j, we may encounter various database errors. The driver exports a `Neo4jError` class that is inherited by all exceptions thrown by the database.

Common exceptions:
- `CypherSyntaxError`: Raised when the Cypher syntax is invalid.
- `ConstraintError`: Raised when a constraint unique or other is violated.
- `AuthError`: Raised when authentication fails.
- `TransientError`: Raised when the database is not accessible.

Any errors raised by the DBMS (`Neo4jError`) will have `code` and `message` properties that describe the error:
```python
from neo4j.exceptions import Neo4jError

try:
    # Run a Cypher query
except Neo4jError as e:
    print(e.code)
    print(e.message)
    print(e.gql_status)
```
The `gql_status` property contains an error code that corresponds to an error in the ISO GQL standard.

One common scenario deals with constraint violations when inserting data. A unique constraint ensures that a property value is unique across all nodes with a specific label. For example, we can create a unique constraint named `unique_email` to ensure that the `email` property is unique for the `User` label:
```sql
CREATE CONSTRAINT unique_email IF NOT EXISTS
FOR (u:User) REQUIRE u.email IS UNIQUE
```
If a Cypher statement violates this constraint, Neo4j will raise a `ConstraintError`. For example, we can handle a unique constraint violation when creating a new user:
```python
from neo4j.exceptions import ConstraintError

def create_user(tx, name, email):
    try:
        result = tx.run(
            """
            CREATE (u:User {name: $name, email: $email})
            RETURN u
            """,
            name=name,
            email=email,
        )
    except ConstraintError as e:
        print(e.code) # "Neo.ClientError.Schema.ConstraintValidationFailed"
        print(e.message) # The value [email] for property [email] violates the constraint [unique_email]
        print(e.gql_status) # 22N41
```