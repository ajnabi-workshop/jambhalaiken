use aiken/crypto.{Hash, Blake2b_224, Script}
use aiken/collection/list.{any, filter}
use cardano/transaction.{Input, Output, OutputReference, Transaction, find_input}
use cardano/address.{from_script}

pub type POSIXTime =
  Int

pub type PubKeyHash =
  Hash<Blake2b_224, Script>

pub fn find_own_input(tx_info: Transaction, output_ref: OutputReference) -> Option<Input> {
  find_input(tx_info.inputs, output_ref)
}

pub fn get_continuing_outputs(tx_info: Transaction, output_ref: OutputReference) -> List<Output> {
  expect Some(own_input) = find_own_input(tx_info, output_ref)
  let script_address = own_input.output.address
  filter(tx_info.outputs, fn(out: Output) { out.address == script_address })
}

pub fn forward_to_validator(
  val_hash: Hash<Blake2b_224, Script>,
  transaction: Transaction,
) -> Bool {
  any(
    transaction.inputs,
    fn(input) { input.output.address == from_script(val_hash) },
  )
}
