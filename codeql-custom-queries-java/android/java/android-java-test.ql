/**
 * @name Instructions test android-java
 * @kind problem
 * @problem.severity recommendation
 * @tags android 
 * java
 * android-java
 */

import java

from IfStmt outer, IfStmt inner
where outer.getThen() = inner
select outer, "Instruction if imbrique detecte."
