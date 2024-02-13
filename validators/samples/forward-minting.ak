use aiken/bytearray.{push}
use aiken/hash.{Blake2b_224, Hash, sha2_256}
use aiken/list.{any}
use aiken/transaction.{Output, OutputReference, ScriptContext}
use aiken/transaction/credential.{Script,
  VerificationKey, from_verification_key}
use aiken/transaction/value.{
  AssetName, MintedValue, PolicyId, from_minted_value, lovelace_of, quantity_of,
}
use utils.{find_own_input, forward_to_validator}

type TicketDatum {
  policy_id: PolicyId,
  redeemer_hash: ByteArray,
  ticket_price: Int,
}

// Spending Validator
validator(host_pkh: Hash<Blake2b_224, VerificationKey>) {
  fn ticket_spend(
    datum: TicketDatum,
    redeemer: ByteArray,
    ctx: ScriptContext,
  ) -> Bool {
    expect Some(input) = find_own_input(ctx)
    (sha2_256(redeemer) == datum.redeemer_hash)? && check_payment(
      host_pkh,
      datum.ticket_price,
      ctx.transaction.outputs,
    )? && check_mint(
      datum.policy_id,
      mk_ticket_name(input.output_reference),
      ctx.transaction.mint,
    )?
  }
}

fn check_payment(
  host_pkh: Hash<Blake2b_224, VerificationKey>,
  ticket_price: Int,
  outputs: List<Output>,
) -> Bool {
  any(
    outputs,
    fn(output) {
      (from_verification_key(host_pkh) == output.address)? && (lovelace_of(
        output.value,
      ) == ticket_price)?
    },
  )
}

fn check_mint(
  policy_id: PolicyId,
  token_name: AssetName,
  minted: MintedValue,
) -> Bool {
  let val = from_minted_value(minted)
  quantity_of(val, policy_id, token_name) == 1
}

fn mk_ticket_name(oref: OutputReference) -> AssetName {
  let OutputReference { transaction_id, output_index } = oref
  transaction_id.hash |> push(output_index) |> sha2_256
}

// Forwarding Minting Policy
validator(val_hash: Hash<Blake2b_224, Script>) {
  fn ticket_mint(_redeemer: Void, ctx: ScriptContext) -> Bool {
    forward_to_validator(val_hash, ctx)
  }
}
