use cardano/transaction.{OutputReference, Transaction}

validator simple_typed {
  spend(_datum: Option<Void>, redeemer: Int, _utxo: OutputReference, _self: Transaction) -> Bool {
    (redeemer == 42)?
  }
}

pub type Answer {
  val: Int,
}

pub type Guess {
  val: Int,
}

validator guessing {
  spend(datum: Option<Answer>, redeemer: Guess, _utxo: OutputReference, _self: Transaction) -> Bool {
    expect Some(answer) = datum
    (redeemer.val == answer.val)?
  }
}
