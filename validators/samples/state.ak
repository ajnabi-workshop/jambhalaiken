use aiken/transaction.{InlineDatum, Input, ScriptContext}
use aiken/transaction/value.{AssetName, PolicyId, quantity_of}
use utils.{find_own_input, get_continuing_outputs}

validator(policy: PolicyId, name: AssetName) {
  fn count(current_count: Int, _redeemer: Void, ctx: ScriptContext) -> Bool {
    spends_proof(policy, name, ctx)? && locks_proof(
      policy,
      name,
      current_count,
      ctx,
    )?
  }
}

fn spends_proof(policy: PolicyId, name: AssetName, ctx: ScriptContext) -> Bool {
  expect Some(Input { output, .. }) = find_own_input(ctx)
  quantity_of(output.value, policy, name) == 1
}

fn locks_proof(
  policy: PolicyId,
  name: AssetName,
  current_count: Int,
  ctx: ScriptContext,
) -> Bool {
  expect [output] = get_continuing_outputs(ctx)
  expect InlineDatum(datum) = output.datum
  expect new_count: Int = datum
  (quantity_of(output.value, policy, name) == 1)? && (new_count == current_count + 1)?
}
