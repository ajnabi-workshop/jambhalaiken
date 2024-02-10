use aiken/interval.{Finite}
use aiken/list
use aiken/transaction.{ScriptContext, Transaction, ValidityRange}
use utils.{POSIXTime, PubKeyHash, trace_if_false}

type VestingDatum {
  beneficiary: PubKeyHash,
  maturity: POSIXTime,
}

validator {
  fn vesting(datum: VestingDatum, _redeemer: Void, ctx: ScriptContext) -> Bool {
    must_be_signed_by(ctx.transaction, datum.beneficiary)? && must_start_after(
      ctx.transaction.validity_range,
      datum.maturity,
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

validator(beneficiary: PubKeyHash) {
  fn param_vesting(
    datum: POSIXTime,
    _redeemer: Void,
    ctx: ScriptContext,
  ) -> Bool {
    must_be_signed_by(ctx.transaction, datum.beneficiary)? && must_start_after(
      ctx.transaction.validity_range,
      datum.maturity,
    )?
  }
}
