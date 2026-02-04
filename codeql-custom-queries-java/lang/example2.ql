/**
 * @name Instructions if imbriquées
 * @description Identifie les instructions 'if' situées à l'intérieur d'un bloc 'then' d'un autre 'if'.
 * @kind problem
 * @problem.severity recommendation
 * @id java/nested-if-statements
 */

import java

from IfStmt outer, IfStmt inner
where

  // L'instruction 'inner' est contenue dans la branche 'then' de 'outer'

  inner.getParent+() = outer.getThen()
select inner, "Cette instruction 'if' est imbriquée dans un autre bloc 'if'."
