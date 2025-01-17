use cardano/transaction.{OutputReference, Transaction}
use aiken/crypto.{sha2_256}

validator password {
  spend(datum: Option<ByteArray>, redeemer: ByteArray, _utxo: OutputReference, _self: Transaction) -> Bool {
    expect Some(hashed) = datum
    sha2_256(redeemer) == hashed
  }
}
 
