use aiken/dict as dict
use aiken/list.{any} as list
use aiken/transaction.{Input, OutputReference, ScriptContext, Transaction} as tx
use aiken/transaction/value.{AssetName, MintedValue, PolicyId}

validator {
  fn free_minting(_redeemer: Void, _ctx: ScriptContext) -> Bool {
    True
  }
}

type Mode {
  Minting
  Burning
}

validator(token_name: ByteArray, oref: OutputReference) {
  fn nft(redeemer: Mode, ctx: ScriptContext) -> Bool {
    expect tx.Mint(policy_id) = ctx.purpose

    let Transaction { inputs, mint, .. } = ctx.transaction

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

fn check_mint(cs: PolicyId, tn: AssetName, mint: MintedValue, mint_qty: Int) {
  expect [(asset_name, qty)] =
    mint
      |> value.from_minted_value
      |> value.tokens(cs)
      |> dict.to_list()
  (qty == mint_qty)? && (asset_name == tn)?
}
