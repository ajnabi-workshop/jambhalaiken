use aiken/primitive/bytearray.{push}
use aiken/crypto.{Script, Blake2b_224, Hash, VerificationKey, sha2_256}
use aiken/collection/list.{any}
use cardano/assets.{PolicyId, AssetName, Value, lovelace_of, quantity_of}
use cardano/transaction.{Output, OutputReference, Transaction}
use cardano/address.{from_verification_key}
use utils.{forward_to_validator}

pub type TicketDatum {
  policy_id: PolicyId,
  redeemer_hash: ByteArray,
  ticket_price: Int,
}

// Spending Validator
validator ticket_spend(host_pkh: Hash<Blake2b_224, VerificationKey>) {
  spend(
    datum: Option<TicketDatum>,
    redeemer: ByteArray,
    utxo: OutputReference,
    self: Transaction
  ) -> Bool {
    expect Some(ticket_datum) = datum
    (sha2_256(redeemer) == ticket_datum.redeemer_hash)? && check_payment(
      host_pkh,
      ticket_datum.ticket_price,
      self.outputs,
    )? && check_mint(
      ticket_datum.policy_id,
      mk_ticket_name(utxo),
      self.mint,
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
  minted: Value,
) -> Bool {
  quantity_of(minted, policy_id, token_name) == 1
}

fn mk_ticket_name(oref: OutputReference) -> AssetName {
  let OutputReference { transaction_id, output_index } = oref
  transaction_id |> push(output_index) |> sha2_256
}

// Forwarding Minting Policy
validator ticket_mint(val_hash: Hash<Blake2b_224, Script>) {
  mint(_redeemer: Void, _policy_id: PolicyId, self: Transaction) -> Bool {
    forward_to_validator(val_hash, self)
  }
}
