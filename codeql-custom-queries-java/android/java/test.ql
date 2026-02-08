/**
 * @name Activation de JavaScript dans WebView
 * @description L'activation de JavaScript dans une WebView augmente la surface d'attaque aux injections.
 * @kind problem
 * @id java/android/web-view-js-enabled
 * @problem.severity warning
 * @tags security
 * android
 */

import java

from MethodAccess call
where
  call.getMethod().hasName("setJavaScriptEnabled") and
  call.getMethod().getDeclaringType().hasQualifiedName("android.webkit", "WebSettings") and
  call.getArgument(0).(BooleanLiteral).getBooleanValue() = true
select call, "L'activation de JavaScript dans une WebView est détectée."
