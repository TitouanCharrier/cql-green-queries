/**
 * @name PyTorch inference without torch.no_grad()
 * @description Using a PyTorch model in evaluation mode without wrapping inference in `torch.no_grad()` leads to unnecessary gradient tracking, increasing memory usage and energy consumption.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id ai/wrap-inference-no-grad
 * @link https://green-code-initiative.org/rules#id:GCI100
 * @tags efficiency
 */

import python

predicate isEvalCall(Call call) {
  exists(Attribute attr |
    call.getFunc() = attr and
    attr.getName() = "eval"
  )
}

predicate isModelInferenceCall(Call call) {
  call.getFunc() instanceof Name and
  not exists(Attribute attr | call.getFunc() = attr)
}

predicate isInsideNoGrad(Call call) {
  exists(With with_, Call noGradCall, Attribute attr |
    noGradCall.getFunc() = attr and
    attr.getName() = "no_grad" and
    attr.getObject().(Name).getId() = "torch" and
    with_.getContextExpr() = noGradCall and
    with_.getBody().contains(call)
  )
}

predicate evalModeUsedInScope(Call inferenceCall) {
  exists(Call evalCall |
    isEvalCall(evalCall) and
    evalCall.getScope() = inferenceCall.getScope()
  )
}

from Call inferenceCall
where
  isModelInferenceCall(inferenceCall) and
  evalModeUsedInScope(inferenceCall) and
  not isInsideNoGrad(inferenceCall)
select inferenceCall,
  "Green IT: Wrap PyTorch inference in `torch.no_grad()` to disable gradient tracking and reduce memory usage and energy consumption."