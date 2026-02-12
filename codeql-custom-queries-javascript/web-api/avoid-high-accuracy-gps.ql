/**
 * @name Use of high accuracy GPS detected
 * @description Enabling 'enableHighAccuracy' triggers hardware GPS chips, significantly increasing power consumption on mobile devices.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id js/web-api/avoid-high-accuracy-gps
 * @tags efficiency
 * sustainability
 * green-it
 */

import javascript

from MethodCallExpr call, ObjectExpr options, Property prop
where
  // 1. Identify Geolocation API calls
  (
    call.getMethodName() = "getCurrentPosition" or 
    call.getMethodName() = "watchPosition"
  ) and
  // 2. Ensure it's called on the geolocation object
  call.getReceiver().(PropAccess).getPropertyName() = "geolocation" and
  // 3. Locate the 'options' argument (typically the 3rd argument)
  options = call.getArgument(2).getUnderlyingValue() and
  // 4. Find the 'enableHighAccuracy' property within that object
  prop = options.getPropertyByName("enableHighAccuracy") and
  // 5. Check if it is explicitly set to 'true'
  prop.getInit().(BooleanLiteral).getValue() = "true"
select prop, "Green IT: Avoid 'enableHighAccuracy: true' to reduce battery drain unless meter-level precision is strictly required for the core user experience."