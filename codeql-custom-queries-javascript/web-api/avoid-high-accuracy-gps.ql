/**
 * @name Use of high accuracy GPS detected
 * @description Enabling 'enableHighAccuracy' triggers hardware GPS chips, significantly increasing power consumption on mobile devices.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id js/web-api/avoid-high-accuracy-gps
 * @tags web-api
 */

import javascript

from MethodCallExpr call, ObjectExpr options, Property prop
where
  (
    call.getMethodName() = "getCurrentPosition" or 
    call.getMethodName() = "watchPosition"
  ) and
  call.getReceiver().(PropAccess).getPropertyName() = "geolocation" and
  options = call.getArgument(2).getUnderlyingValue() and
  prop = options.getPropertyByName("enableHighAccuracy") and
  prop.getInit().(BooleanLiteral).getValue() = "true"
select prop, "Green IT: Avoid 'enableHighAccuracy: true' to reduce battery drain unless meter-level precision is strictly required for the core user experience."