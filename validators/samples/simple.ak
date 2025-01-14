use aiken/transaction.{ScriptContext}

fn true() -> Bool {
  True
}

fn is_even(x: Int) -> Bool {
  x % 2 == 0
}

validator {
  fn free_mint(_redeemer: Void, _script_context: ScriptContext) -> Bool {
    True
  }
}

validator {
  fn gift(_datum: Void, _redeemer: Void, _script_context: ScriptContext) -> Bool {
    True
  }
}
