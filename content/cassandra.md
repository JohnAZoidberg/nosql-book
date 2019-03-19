\chapter{Cassandra}
\chapterauthor{David Marchi, Daniel Schäfer, Erik Zeiske}

# Properties of Cassandra (David)
> Cassandra is a distributed storage system for managing very
> large  amounts  of  structured  data  spread  out  across  many
> commodity servers, while providing highly available service
> with no single point of failure. \autocite{lakshman2010cassandra}

https://www.youtube.com/watch?v=B_HTdrTgGNs
- writes to a single node.
- sequential I/O vs random I/O?

Cassandra - Writes in the cluster:
- fully distributed, no Single Point of Failure
- partitioning:
  - primary_key MD5 hash 
  - token ring
  - 128Bit nbr into 4 chunks
  - Hash of primary_key fits into one of the chunks
    - good distribution
  - each node has a replication factor
    - e.g. replication factor 3 -> data gets replicated on up to 3 nodes
  - change to virtual nodes, MD5 ranges are smaller
    - 

Cassandra - Reads
  - Request Hits first Node:
    - Doesn't have the data
    - coordinates data request and asks other nodes
    


- Wide Column Store
- Distributed Data Store

## Terminology
% https://docs.datastax.com/en/glossary/doc/glossary/glossaryTOC.html
- Keyspace <-> Database
- Table
- Column
- Columnfamily <-> Table
- Node
- Ring
- Seed-Node
- Tombstone
- Repair
- Partition
- Primary Key
- Partition Key
- Static Column: A special column that is shared by all rows of a partition.
- SSTable
- Compaction
- Zombie
- Bloom Filter
- Token

# Goals of Cassandra (David)

# Use cases of Cassandra (David)

# How to model data to take advantage of Cassandra (David & Daniel)
> Writes are cheap. Write everything the way you want to read it. % https://medium.com/@alexbmeng/cassandra-query-language-cql-vs-sql-7f6ed7706b4c

## Non-Goals (Things to avoid doing)
- Minimize the number of writes
- Minimize data duplication

## Goals
- Spread data evenly around the cluster
- Minimize the number of partitions read

## Examples

# How data is saved on disk (Erik)
% https://docs.datastax.com/en/cassandra/3.0/cassandra/dml/dmlHowDataWritten.html
## SSTable
## File structure (Column oriented)
## Compaction

# Distributedness (Erik & Daniel)
## How it works
Ring

## Scalability

## CAP (Consistency, Availability, Partition Tolerance)
Default is AP with eventual consistency.

Custom priority can be chosen.

## Replication Strategies
- SimpleStrategy (For evaluating Cassandra)
- NetworkTopologyStrategy (For production use or for use with mixed workloads)

# Differences (Daniel)
## Advantages and disadvantages summary
- Advantages
  - Elastic Scalability - easy add or remove nodes
  - Peer to peer instead of master slave => No single point of failure & Write to any node
  - Fault tolerance to failure of individual nodes
  - Great analytics capabilities (e.g. with Hadoop, Spark, ...) [because of column orientation?]
  - Flexible data model (no strict schemas)
  - Fast INSERT because of caching and commit logs
- Disadvantages
  - CQL is SQL but stripped down
  - Doesn't do data validation like NULL-constraint, uniqueness violations, ...
  - Needs repairs sometimes
  - Not ACID (No transactions)
  - Updates and deletes are slow (tombstones) TODO: Review updates

## Keep in mind
- Not relational!
- Denormalize data => Super fast reads (no joins) but more data duplication
- CAP: Cassandra is an available, partition-tolerant system that supports eventual consistency
- Seed nodes are just for joining the cluster, are NOT a single point of failure

## CQL
> Typically, a cluster has one keyspace per application. \autocite{datastax6cqldoc}

Keyspace == Database
Column Family == Table (Is called that in CQL 3)

### Comparison to SQL
- No
  - Transactions
  - Subqueries
  - `JOIN`
  - `GROUP BY`
  - `FOREIGN KEY`

- Primary key is mandatory!
- Creating Keyspace(Database) requires replication strategy
- Logical operators only `AND` no `OR` or `NOT`
- `WHERE` only works on primary key and other indexed columns
- `UPDATE` needs `WHERE` with primary key
- `UPDATE` inserts if row is not yet there
- `INSERT` replaces if row is already there
- `INSERT INTO xxx JSON`
- `SELECT JSON`
- `USING TTL` - set expiry date of row

### Column types
- Collections
  - List
  - Map
  - Set
- Common DB Types
- Tuple
  - Blob
  - Boolean
  - Numbers
  - Strings
  - Time/Date values
- Counter
- IP-Address
- Java Types
- UUID

How to use collections

### Materialized Views
> Materialized views are suited for high cardinality data. The data in a
> materialized view is arranged serially based on the view's primary key.
> Materialized views cause hotspots when low cardinality data is inserted.

Properties:
- Read only!
- Always materialized! (Data partitioned and duplicated)
- > automated server-side denormalization % https://www.datastax.com/dev/blog/new-in-cassandra-3-0-materialized-views

Restrictions:
- Include all of the source table's primary keys in the materialized view's primary key.
- Only one new column can be added to the materialized view's primary key. Static columns are not allowed.
- Exclude rows with null values in the materialized view primary key column.

# Index
% https://docs.datastax.com/en/archived/cql/3.0/cql/ddl/ddl_when_use_index_c.html
> Secondary indexes are suited for low cardinality data. Queries of high
> cardinality columns on secondary indexes require Cassandra to access all
> nodes in a cluster, causing high read latency. \autocite{cassandra3cqldoc}

Don't use when:
- Table with counter column
- On high-cardinality column
- On extremely low cardinality column
- On a frequently updated or deleted column (because tombstones)

# Setting it up (Daniel)
## Machine/topological requirements and recommendations
> Cassandra can be made to run on small servers for testing or development
> environments (including Raspberry Pis), a minimal production server requires
> at least 2 cores, and at least 8GB of RAM. Typical production servers have 8
> or more cores and at least 32GB of RAM. \autocite{cassandracode}

## Configuration
All config files are located in `/etc/cassandra`.
Data is stored under `/var/lib/cassandra{cdc_raw,commitlog,data,saved_caches}`
Memory Consumption: 

- `cassandra.yml`: Config for Cassandra itself
  - `cluster_name`
  - `listen_address`: The IP address or hostname that Cassandra binds to for connecting this node to other nodes.
  - `seed_provider`: A joining node contacts one of the nodes in the seed list to learn the topology of the ring.
  - `disk_optimization_strategy`: `ssd` or `spinning`
  - `num_tokens`: Set this property for virtual node token architecture. Determines the number of token ranges to assign to this (vnode).
- `cassandra-env.sh`
  - `MAX_HEAP_SIZE`: total amount of memory dedicated to the Java heap
  - `HEAP_NEWSIZE`

| Port | Description    |
| ---- | -------------- |
| 22   | SSH            |
| ---- | -------------- |
| 7000 | Inter-Node     |
| 7001 | SSL Inter-Node |
| 7199 | JMX Monitoring |
| ---- | -------------- |
| 9042 | (SSL) Client   |
| 9160 | Thrift Client  |
| 9142 | SSL Client     |

### Virtual Nodes
> Generally when all nodes have equal hardware capability, they should have the
> same number of virtual nodes (vnodes). If the hardware capabilities vary
> among the nodes in your cluster, assign a proportional number of vnodes to
> the larger machines. For example, you could designate your older machines to
> use 128 vnodes and your new machines (that are twice as powerful) with 256
> vnodes. % https://docs.datastax.com/en/cassandra/3.0/cassandra/configuration/configVnodesEnable.html

### Security
- Use Roles
- Use a firewall to not expose it to the public internet
- Authentication with password 
- Authorisation
- Internode communication with SSL
- Client to Node communicaiton with SSL
- Disable default user
- JMX management only on localhost
