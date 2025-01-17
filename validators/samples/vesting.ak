use aiken/interval.{Finite}
use aiken/collection/list
use cardano/transaction.{OutputReference, Transaction, ValidityRange}
use utils.{POSIXTime, PubKeyHash}

pub type VestingDatum {
  beneficiary: PubKeyHash,
  maturity: POSIXTime,
}

validator vesting {
  spend(datum: Option<VestingDatum>, _redeemer: Void, _utxo: OutputReference, self: Transaction) -> Bool {
    expect Some(vesting_datum) = datum
    must_be_signed_by(self, vesting_datum.beneficiary)? && must_start_after(
      self.validity_range,
      vesting_datum.maturity,
    )?
  }
}

fn must_be_signed_by(transaction: Transaction, pkh: PubKeyHash) {
  list.has(transaction.extra_signatories, pkh)
}

fn must_start_after(range: ValidityRange, maturity: POSIXTime) {
  when range.lower_bound.bound_type is {
    Finite(tx_earliest_time) -> (tx_earliest_time >= maturity)?
    _ -> {
      trace @"Non-finite interval"
      False
    }
  }
}

validator param_vesting(beneficiary: PubKeyHash) {
  spend(
    datum: Option<POSIXTime>,
    _redeemer: Void,
    _utxo: OutputReference,
    self: Transaction,
  ) -> Bool {
    expect Some(maturity) = datum
    must_be_signed_by(self, beneficiary)? && must_start_after(
      self.validity_range,
      maturity,
    )?
  }
}
