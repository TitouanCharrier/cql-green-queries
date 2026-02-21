/**
 * @name Nested Matrix in GitHub Actions
 * @description Détecte les matrices imbriquées dans les workflows GitHub Actions.
 * @kind problem
 * @id github-actions/nested-matrix
 * @problem.severity warning
 * @tags correctness
 */

import actions

from Job j, Strategy s, MatrixExpression outerMatrix, MatrixExpression innerMatrix
where
  s = j.getStrategy() and
  outerMatrix = s.getAChildNode() and
  innerMatrix = outerMatrix.getAChildNode+() and
  innerMatrix != outerMatrix
select j, "Job '" + j.getId() + "' contain a nested matrix."