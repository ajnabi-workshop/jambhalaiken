use aiken/collection/dict as dict
use aiken/collection/list.{any} as list
use cardano/transaction.{Input, OutputReference, Transaction} as tx
use cardano/assets.{AssetName, Value, PolicyId}

validator free_minting{
  mint(_redeemer: Void, _policy_id: PolicyId, _self: Transaction) -> Bool {
    True
  }
}

pub type Mode {
  Minting
  Burning
}

validator nft(token_name: ByteArray, oref: OutputReference) {
  mint(redeemer: Mode, policy_id: PolicyId, self: Transaction) -> Bool {

    let Transaction { inputs, mint, .. } = self

    when redeemer is {
      Minting ->
        has_utxo(oref, inputs)? && check_mint(policy_id, token_name, mint, 1)?
      Burning -> check_mint(policy_id, token_name, mint, -1)?
    }
  }
}

fn has_utxo(oref: OutputReference, inputs: List<Input>) {
  any(inputs, fn(input) { input.output_reference == oref })
}

fn check_mint(cs: PolicyId, tn: AssetName, mint: Value, mint_qty: Int) {
  expect [Pair(asset_name, qty)] =
    mint
      |> assets.tokens(cs)
      |> dict.to_pairs()
  (qty == mint_qty)? && (asset_name == tn)?
}
