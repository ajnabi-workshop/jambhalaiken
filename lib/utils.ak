use aiken/hash.{Blake2b_224, Hash}
use aiken/list.{filter}
use aiken/transaction.{Input, Output, ScriptContext, Spend, find_input}
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

pub fn get_continuing_outputs(ctx: ScriptContext) -> List<Output> {
  expect Some(input) = find_own_input(ctx)
  let script_address = input.output.address
  filter(ctx.transaction.outputs, fn(o: Output) { o.address == script_address })
}
