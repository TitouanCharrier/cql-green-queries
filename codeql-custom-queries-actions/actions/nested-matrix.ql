/**
 * @name Nested Matrix in GitHub Actions
 * @description Détecte les matrices imbriquées dans les workflows GitHub Actions.
 * @kind problem
 * @id github-actions/nested-matrix
 * @problem.severity warning
 * @tags correctness
 */

import actions
import codeql.actions.ast.internal.Yaml
import codeql.actions.ast.internal.Ast

from Job j, StrategyImpl s, YamlMapping matrixNode, YamlMapping innerMatrix
where
  s.getParentNode() = j and
  matrixNode = s.getNode().lookup("matrix") and
  innerMatrix = matrixNode.getAChildNode+() and
  exists(innerMatrix.lookup("matrix"))
select j, "Le job '" + j.getId() + "' contient une matrice imbriquée."