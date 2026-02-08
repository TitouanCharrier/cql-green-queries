# Tutoriel CodeQL pour l'Éco-conception

## Intérêts du langage CodeQL

CodeQL est un langage d'analyse de code qui permet de détecter des patterns problématiques dans une codebase. Pour l'éco-conception, il devient un outil puissant pour :

- **Détecter les gaspillages énergétiques** : boucles inefficaces, requêtes N+1, polling inutile
- **Identifier les fuites de ressources** : connexions non fermées, caches non libérés
- **Repérer les anti-patterns** : chargements excessifs de données, transformations inutiles
- **Automatiser les audits** : scanner tout le code en quelques secondes au lieu de reviews manuelles

CodeQL transforme le code en base de données interrogeable sous la forme d'un arbre de syntaxe (AST). Il permet d'écrire des requêtes qui détectent des patterns problématiques (code smells).

## Syntaxe basique d'une requête

Une requête CodeQL suit toujours cette structure :
(ici exemple avec une requète java)
```ql
import java

from MethodCall call
where call.getMethod().hasName("toString")
select call, "Conversion inutile vers String"
```

**Composition :**

- `import java` : importe la bibliothèque pour analyser du code Java
- `from ... ` : définit les variables (comme un FROM en SQL)
- `where ...` : filtre les résultats (comme un WHERE en SQL)
- `select ...` : choisit ce qu'on affiche (comme un SELECT en SQL)

**Exemple :** Trouver les `Thread.sleep()` qui font du polling actif

```ql
import java

from MethodCall sleep
where 
  sleep.getMethod().hasName("sleep") and
  sleep.getMethod().getDeclaringType().hasName("Thread")
select sleep, "Polling actif détecté - consomme du CPU inutilement"
```

## Les outils principaux à disposition

### 1. Les classes de base

Chaque langage a ses classes principales.

Un fichier .md sera fourni dans chaque dossier pour rappeler les classes spécifiques à chaque language.

Exemple en Java :

- `MethodCall` : un appel de méthode
- `Method` : une déclaration de méthode
- `Class` : une classe
- `Field` : un attribut
- `Expr` : une expression

### 2. Les prédicats

Les prédicats sont des fonctions réutilisables qui retournent vrai/faux.

```ql
predicate estRequeteSQL(MethodCall m) {
  m.getMethod().hasName("executeQuery") or
  m.getMethod().hasName("executeUpdate")
}

from MethodCall sql
where estRequeteSQL(sql)
select sql, "Requête SQL détectée"
```

**Exemple :** Prédicat pour détecter les méthodes gourmandes

```ql
predicate estMethodeGourmande(Method m) {
  m.getName().matches("%All%") or
  m.getName().matches("%Everything%")
}

from MethodCall call
where estMethodeGourmande(call.getMethod())
select call, "Méthode qui charge tout - risque de surconsommation mémoire"
```

### 3. Les méthodes de navigation

CodeQL permet de naviguer dans l'AST représentant le code analysé :

- `.getMethod()` : récupère la méthode appelée
- `.getAnArgument()` : récupère un argument
- `.getEnclosingCallable()` : récupère la fonction contenante
- `.getAChild()` : récupère un enfant dans l'AST


### 4. Les quantificateurs

- `exists(...)` : il existe au moins un
- `forall(...)` : pour tous
- `not exists(...)` : il n'existe aucun

## Les concepts avancés

### 1. Data Flow (Flux de données)

Le data flow suit comment les données circulent dans le code.

**Cas simple :** Trouver où une variable arrive

```ql
import java
import semmle.code.java.dataflow.DataFlow

from MethodCall source, Expr sink
where DataFlow::localFlow(
  DataFlow::exprNode(source),
  DataFlow::exprNode(sink)
)
select sink, "Données provenant de " + source.toString()
```

**Exemple :** Détecter les gros objets passés par valeur

```ql
import java
import semmle.code.java.dataflow.DataFlow

class GrosObjet extends Class {
  GrosObjet() {
    this.getName().matches("%Image%") or
    this.getName().matches("%Video%") or
    this.getName().matches("%Document%")
  }
}

from Parameter param, GrosObjet type
where 
  param.getType() = type and
  not param.getType() instanceof RefType
select param, "Gros objet passé par valeur - préférer une référence"
```

### 2. Taint Flow (Flux de contamination)

Le taint flow suit la "contamination" des données (ex: données utilisateur → risque injection).

**Structure de base :**

```ql
import java
import semmle.code.java.dataflow.TaintTracking

class MaConfigTaint extends TaintTracking::Configuration {
  MaConfigTaint() { this = "MaConfigTaint" }
  
  override predicate isSource(DataFlow::Node source) {
    // Définir les sources
  }
  
  override predicate isSink(DataFlow::Node sink) {
    // Définir les destinations
  }
}
```

**Exemple :** Tracer les gros payloads jusqu'aux logs

```ql
import java
import semmle.code.java.dataflow.TaintTracking

class GrosPayloadVersLog extends TaintTracking::Configuration {
  GrosPayloadVersLog() { this = "GrosPayloadVersLog" }
  
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

from GrosPayloadVersLog config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "Gros payload logué - gaspillage I/O et stockage"
```

### 3. Requêtes avec agrégation

Compter, grouper, trouver les pires cas.

**Exemple :** Identifier les classes avec le plus d'allocations

```ql
import java

from Class c, int allocations
where allocations = count(ClassInstanceExpr alloc |
  alloc.getEnclosingCallable().getDeclaringType() = c
) and allocations > 10
select c, allocations + " allocations - optimiser la réutilisation d'objets"
order by allocations desc
```

### 4. Analyse de path (chemins d'exécution)

Détecter des patterns complexes avec `getAPredecessor()` et `getASuccessor()`.

**Exemple :** Détecter if-else qui font la même allocation

```ql
import java

from IfStmt ifStmt, ClassInstanceExpr alloc1, ClassInstanceExpr alloc2
where 
  alloc1.getEnclosingStmt().getParent*() = ifStmt.getThen() and
  alloc2.getEnclosingStmt().getParent*() = ifStmt.getElse() and
  alloc1.getConstructedType() = alloc2.getConstructedType()
select ifStmt, "Allocation identique dans if/else - mutualiser avant le if"
```

### Fin ! 
