use aiken/hash.{Blake2b_224, Hash}
use aiken/list.{filter}
use aiken/transaction.{Input, Output, ScriptContext, Spend, find_input} as tx
use aiken/transaction/credential.{VerificationKey}

pub type POSIXTime =
  Int

pub type PubKeyHash =
  Hash<Blake2b_224, VerificationKey>

pub fn trace_if_false(trace_msg: String, predicate: Bool) -> Bool {
  if !predicate {
    trace trace_msg
    predicate
  } else {
    predicate
  }
}

pub fn find_own_input(ctx: ScriptContext) -> Option<Input> {
  when ctx.purpose is {
    Spend(oref) -> find_input(ctx.transaction.inputs, oref)
    _other -> None
  }
}

// getContinuingOutputs :: ScriptContext -> [TxOut]
// getContinuingOutputs ctx | Just TxInInfo{txInInfoResolved=TxOut{txOutAddress}} <- findOwnInput ctx = filter (f txOutAddress) (txInfoOutputs $ scriptContextTxInfo ctx)
//     where
//         f addr TxOut{txOutAddress=otherAddress} = addr == otherAddress
// getContinuingOutputs _ = traceError "Lf" -- "Can't get any continuing outputs"

pub fn get_continuing_outputs(ctx: ScriptContext) -> List<Output> {
  expect Some(input) = find_own_input(ctx)
  let script_address = input.output.address
  filter(ctx.transaction.outputs, fn(o) { o.address == script_address })
}
