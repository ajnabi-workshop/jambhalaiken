use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction}

pub fn true() -> Bool {
  True
}

pub fn is_even(x: Int) -> Bool {
  x % 2 == 0
}

validator free_mint {
  mint(_redeemer: Void, _policy_id: PolicyId, _self: Transaction) -> Bool {
    True
  }
}

validator gift {
  spend(_datum: Option<Void>, _redeemer: Void, _utxo: OutputReference, _self: Transaction) -> Bool {
    True
  }
}
