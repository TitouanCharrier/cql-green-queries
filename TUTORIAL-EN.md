# CodeQL Tutorial for Eco-Design

## Benefits of the CodeQL language

CodeQL is a code analysis language that makes it possible to detect problematic patterns in a codebase. For eco-design, it becomes a powerful tool to:

* **Detect energy waste**: inefficient loops, N+1 queries, unnecessary polling
* **Identify resource leaks**: unclosed connections, unreleased caches
* **Spot anti-patterns**: excessive data loading, unnecessary transformations
* **Automate audits**: scan the entire codebase in a few seconds instead of manual reviews

CodeQL transforms code into a queryable database in the form of an abstract syntax tree (AST). It allows writing queries that detect problematic patterns (code smells).

## Basic query syntax

A CodeQL query always follows this structure:
(here an example with a Java query)

```ql
import java

from MethodCall call
where call.getMethod().hasName("toString")
select call, "Unnecessary conversion to String"
```

**Composition:**

* `import java` : imports the library to analyze Java code
* `from ...` : defines the variables (like a FROM in SQL)
* `where ...` : filters the results (like a WHERE in SQL)
* `select ...` : chooses what to display (like a SELECT in SQL)

**Example:** Find `Thread.sleep()` calls that perform active polling

```ql
import java

from MethodCall sleep
where 
  sleep.getMethod().hasName("sleep") and
  sleep.getMethod().getDeclaringType().hasName("Thread")
select sleep, "Active polling detected – unnecessarily consumes CPU"
```

## Main tools available

### 1. Base classes

Each language has its main classes.

An `.md` file will be provided in each folder to remind you of the classes specific to each language.

Example in Java:

* `MethodCall` : a method call
* `Method` : a method declaration
* `Class` : a class
* `Field` : a field
* `Expr` : an expression

### 2. Predicates

Predicates are reusable functions that return true/false.

```ql
predicate isSQLQuery(MethodCall m) {
  m.getMethod().hasName("executeQuery") or
  m.getMethod().hasName("executeUpdate")
}

from MethodCall sql
where isSQLQuery(sql)
select sql, "SQL query detected"
```

**Example:** Predicate to detect resource-hungry methods

```ql
predicate isGreedyMethod(Method m) {
  m.getName().matches("%All%") or
  m.getName().matches("%Everything%")
}

from MethodCall call
where isGreedyMethod(call.getMethod())
select call, "Method loads everything – risk of memory overconsumption"
```

### 3. Navigation methods

CodeQL allows navigation through the AST representing the analyzed code:

* `.getMethod()` : retrieves the called method
* `.getAnArgument()` : retrieves an argument
* `.getEnclosingCallable()` : retrieves the enclosing function
* `.getAChild()` : retrieves a child in the AST

### 4. Quantifiers

* `exists(...)` : there exists at least one
* `forall(...)` : for all
* `not exists(...)` : there exists none

## Advanced concepts

### 1. Data Flow

Data flow tracks how data moves through the code.

**Simple case:** Find where a variable ends up

```ql
import java
import semmle.code.java.dataflow.DataFlow

from MethodCall source, Expr sink
where DataFlow::localFlow(
  DataFlow::exprNode(source),
  DataFlow::exprNode(sink)
)
select sink, "Data originating from " + source.toString()
```

**Example:** Detect large objects passed by value

```ql
import java
import semmle.code.java.dataflow.DataFlow

class LargeObject extends Class {
  LargeObject() {
    this.getName().matches("%Image%") or
    this.getName().matches("%Video%") or
    this.getName().matches("%Document%")
  }
}

from Parameter param, LargeObject type
where 
  param.getType() = type and
  not param.getType() instanceof RefType
select param, "Large object passed by value – prefer a reference"
```

### 2. Taint Flow

Taint flow tracks data “contamination” (e.g. user input → injection risk).

**Basic structure:**

```ql
import java
import semmle.code.java.dataflow.TaintTracking

class MyTaintConfig extends TaintTracking::Configuration {
  MyTaintConfig() { this = "MyTaintConfig" }
  
  override predicate isSource(DataFlow::Node source) {
    // Define sources
  }
  
  override predicate isSink(DataFlow::Node sink) {
    // Define sinks
  }
}
```

**Example:** Track large payloads to logs

```ql
import java
import semmle.code.java.dataflow.TaintTracking

class LargePayloadToLog extends TaintTracking::Configuration {
  LargePayloadToLog() { this = "LargePayloadToLog" }
  
  override predicate isSource(DataFlow::Node source) {
    exists(MethodCall call |
      call.getMethod().getName().matches("%All%") and
      source.asExpr() = call
    )
  }
  
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall log |
      log.getMethod().getDeclaringType().getName().matches("%Log%") and
      sink.asExpr() = log.getAnArgument()
    )
  }
}

from LargePayloadToLog config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "Large payload logged – I/O and storage waste"
```

### 3. Queries with aggregation

Count, group, find worst cases.

**Example:** Identify classes with the most allocations

```ql
import java

from Class c, int allocations
where allocations = count(ClassInstanceExpr alloc |
  alloc.getEnclosingCallable().getDeclaringType() = c
) and allocations > 10
select c, allocations + " allocations – optimize object reuse"
order by allocations desc
```

### 4. Path analysis (execution paths)

Detect complex patterns using `getAPredecessor()` and `getASuccessor()`.

**Example:** Detect if-else blocks that perform the same allocation

```ql
import java

from IfStmt ifStmt, ClassInstanceExpr alloc1, ClassInstanceExpr alloc2
where 
  alloc1.getEnclosingStmt().getParent*() = ifStmt.getThen() and
  alloc2.getEnclosingStmt().getParent*() = ifStmt.getElse() and
  alloc1.getConstructedType() = alloc2.getConstructedType()
select ifStmt, "Identical allocation in if/else – factor it out before the if"
```

### The End!

