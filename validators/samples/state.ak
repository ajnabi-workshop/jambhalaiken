use cardano/transaction.{OutputReference, Transaction, InlineDatum, Input}
use cardano/assets.{AssetName, PolicyId, quantity_of}
use utils.{find_own_input, get_continuing_outputs}

validator count(policy: PolicyId, name: AssetName) {
  spend(datum: Option<Int>, _redeemer: Void, utxo: OutputReference, self: Transaction) -> Bool {
    expect Some(current_count) = datum
    spends_proof(policy, name, self, utxo)? && locks_proof(
      policy,
      name,
      current_count,
      self,
      utxo
    )?
  }
}

fn spends_proof(policy: PolicyId, name: AssetName, tx_info: Transaction, output_ref: OutputReference) -> Bool {
  expect Some(Input { output, .. }) = find_own_input(tx_info, output_ref)
  quantity_of(output.value, policy, name) == 1
}

fn locks_proof(
  policy: PolicyId,
  name: AssetName,
  current_count: Int,
  tx_info: Transaction,
  output_ref: OutputReference
) -> Bool {
  expect [output] = get_continuing_outputs(tx_info, output_ref)
  expect InlineDatum(datum) = output.datum
  expect new_count: Int = datum
  (quantity_of(output.value, policy, name) == 1)? && (new_count == current_count + 1)?
}
