\chapter{Cassandra}
\chapterauthor{David Marchi, Daniel Schäfer, Erik Zeiske}

# Properties of Cassandra (David)

## Terminology
- Keyspace
- Table
- Column
- Columnfamily
- Node
- Seed-Node
- Tombstone
- Repair
- Partition
- Primary Key
- Partition Key

# Goals of Cassandra (David)

# Use cases of Cassandra (David)

# How to model data to take advantage of Cassandra (David & Daniel)
## Non-Goals (Things to avoid doing)
- Minimize the number of writes
- Minimize data duplication

## Goals
- Spread data evenly around the cluster
- Minimize the number of partitions read

## Examples

# How data is saved on disk (Erik)
## File structure (Column oriented)

# Distributedness (Erik & Daniel)
## How it works
## Scalability
## CAP

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
  - No transactions
  - Updates and deletes are slow (tombstones)

## Keep in mind
- Denormalize data => Super fast reads (no joins) but more data duplication
- CAP: Cassandra is an available, partition-tolerant system that supports eventual consistency
- Seed nodes are just for joining the cluster, are NOT a single point of failure

## CQL
### Comparison to SQL

# Setting it up (Daniel)
## Machine/topological requirements and recommendations
> Cassandra can be made to run on small servers for testing or development
> environments (including Raspberry Pis), a minimal production server requires
> at least 2 cores, and at least 8GB of RAM. Typical production servers have 8
> or more cores and at least 32GB of RAM. \autocite{cassandracode}

## Configuration

#  Citation
> Cassandra is a distributed storage system for managing very
> large  amounts  of  structured  data  spread  out  across  many
> commodity servers, while providing highly available service
> with no single point of failure. \autocite{lakshman2010cassandra}
