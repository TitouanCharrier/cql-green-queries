/**
 * @name Boucles imbriquées détectées
 * @description Identifie les boucles (for, while, do) situées à l'intérieur d'une autre boucle.
 * @kind problem
 * @problem.severity recommendation
 * @id cpp/nested-loops
 */

import cpp

from Loop outer, Loop inner
where
  // L'instruction 'inner' est contenue dans le corps de 'outer'
  inner.getParent+() = outer
select inner, "Cette boucle est imbriquée dans une autre boucle."
