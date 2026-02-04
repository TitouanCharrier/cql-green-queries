/**
 * @name Avoid automatic video preloading
 * @description Automatically playing or preloading videos increases energy consumption and bandwidth usage.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id js/avoid-video-autoplay
 * @tags efficiency
 * sustainability
 */

import javascript

from JsxElement video, JsxAttribute attr
where
  video.getName() = "video" and
  attr = video.getAnAttribute() and
  (
    attr.getName() = "autoPlay"
    or
    (
      attr.getName() = "preload" and
      attr.getValue().(StringLiteral).getValue().regexpMatch("(?i)auto|metadata")
    )
  )
select video, "Avoid 'autoPlay' or 'preload=\"auto/metadata\"' on video elements to reduce environmental footprint."