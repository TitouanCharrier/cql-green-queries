# Tutoriel CodeQL

CodeQL transforme votre code en base de données interrogeable. Voici comment écrire des requêtes pour détecter des patterns / code smells.

## Les fondamentaux

Une requête CodeQL analyse la structure du code (analyse statique). Elle cherche des patterns dans l'arbre syntaxique abstrait (AST).

**Structure de base :**
```ql
import java

from MethodAccess call
where call.getMethod().hasName("execute")
select call, "Appel à la méthode execute"
```

Cette requête se lit comme du SQL : `from` définit ce qu'on cherche, `where` filtre, `select` affiche les résultats.

## Les trois piliers d'une requête

### 1. Import et classes
Commencez par importer le langage cible :
```ql
import javascript
import python
import cpp
```

Les classes représentent les éléments du code. Exemples : `Function`, `IfStmt`, `Variable`, `StringLiteral`.

### 2. Le pattern FROM-WHERE-SELECT

**FROM** : déclarez vos variables
```ql
from FunctionCall fc, string name
```

**WHERE** : exprimez vos conditions
```ql
where fc.getTarget().getName() = "eval" and
      name = fc.getArgument(0).toString()
```

**SELECT** : choisissez ce qui s'affiche
```ql
select fc, "Appel dangereux à eval avec : " + name
```

### 3. La navigation dans le code

CodeQL utilise des prédicats (méthodes) pour naviguer :

```ql
// Remonter : de l'appel vers la fonction
call.getTarget().getName()

// Descendre : de la fonction vers ses paramètres
func.getParameter(0)

// Traverser : trouver le bloc englobant
stmt.getEnclosingStmt()
```

## Exemple concret : détecter une injection SQL

```ql
import java

from Variable conn, VariableAccess access
where 
  // Variable de type Connection
  conn.getType().hasName("Connection") and
  access.getVariable() = conn and
  
  // La connexion est créée mais jamais fermée
  exists(MethodAccess create | 
    create.getMethod().hasName("getConnection") and
    create.getParent*() = conn.getInitializer()
  ) and
  
  // Aucun appel à close() dans un finally ou try-with-resources
  not exists(MethodAccess close | 
    close.getMethod().hasName("close") and
    close.getQualifier() = access
  ) and
  
  not conn.getAnAccess().getParent() instanceof TryStmt
  
select conn, "Fuite de ressource : connexion jamais fermée. " +
       "Utiliser try-with-resources pour économiser les ressources serveur."
```

## Concepts avancés essentiels

### Data flow (flux de données)
Suit les données à travers le code :
```ql
DataFlow::localFlow(source, sink)  // Dans une fonction
DataFlow::globalFlow(source, sink) // Entre fonctions
```

### Taint tracking (propagation de contamination)
Détecte quand des données dangereuses atteignent un point sensible :
```ql
class SqlInjectionConfig extends TaintTracking::Configuration {
  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof UserInput
  }
  
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma | 
      ma.getMethod().hasName("executeQuery") and
      sink.asExpr() = ma.getArgument(0)
    )
  }
}
```

### Quantificateurs logiques
**exists** : "il existe au moins un" 
```ql
exists(IfStmt if | if.getCondition() = expr)
```

**forall** : "pour tous"
```ql
forall(Parameter p | p = func.getParameter(_) | p.getType().hasName("String"))
```

## Astuces pratiques

**1. Testez progressivement** : commencez simple, ajoutez des contraintes une par une.

**2. Utilisez les prédicats réutilisables** :
```ql
predicate isDangerousCall(MethodAccess ma) {
  ma.getMethod().hasName("eval") or
  ma.getMethod().hasName("exec")
}
```

**3. Explorez les bibliothèques standard** : CodeQL fournit des prédicats prêts à l'emploi pour les patterns courants (XSS, injection, etc.).

**4. Limitez les faux positifs** : ajoutez des conditions pour exclure les cas légitimes :
```ql
where isDangerous(call) and
      not call.getEnclosingCallable().hasName("sanitize")
```

## Workflow recommandé

1. Identifiez le pattern à détecter (ex: "appels à eval avec entrée utilisateur")
2. Trouvez les classes CodeQL correspondantes (`MethodAccess`, `UserInput`)
3. Écrivez la requête de base (sans filtres)
4. Ajoutez les contraintes pour réduire les faux positifs
5. Testez sur du code réel et affinez

## Ressources

Le site de CodeQL offre une documentation exhaustive et des exemples : explorez les requêtes standard dans le dépôt GitHub `github/codeql` pour apprendre des patterns éprouvés.

Avec ces bases, vous pouvez déjà créer des requêtes puissantes pour auditer votre code automatiquement !
