# Column Oriented Stores
\chapterauthor{David Marchi, Daniel Schäfer, Erik Zeiske}

- Types
  - Column oriented relational database
  - Wide Columnar Store
- Comparison to ...
  - Row Oriented Relational Database
  - Columnar Relational Database
  - Key-Value store
- Are they NoSQL?
- Layout on Disk
- Advantages/Disadvantages Summary
- Use cases
- Examples
  - Cassandra
  - C-Base
  - Vertica
  - SAP HANA
  - SAP/Sybase IQ


> A wide columnar store takes the idea of a key value store to the next level. Data is still distributed by a key, but the value is a structured set of rows and columns. This tabular payload allows for storage of more complex, structured data. Depending on the implementation, there may or may not be a strict schema applied to this payload.
> 
> Wide columnar stores offer many of the semantics of relational databases but support the ability to distribute and scale the system.
\autocite{hatcher2018nosqltype}
