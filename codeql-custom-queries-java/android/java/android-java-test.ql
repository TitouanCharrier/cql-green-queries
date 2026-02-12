/**
 * @name Instructions test android-java
 * @kind problem
 * @problem.severity recommendation
 * @id java/android-java-test
 * @tags android 
 * @tags java
 */

import java

from IfStmt outer, IfStmt inner
where outer.getThen() = inner
select outer, "Instruction if imbrique detecte."
