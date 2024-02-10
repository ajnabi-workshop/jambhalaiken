use aiken/transaction.{ScriptContext}
use utils.{trace_if_false}

validator {
  fn simple_typed(_datum: Void, redeemer: Int, _ctx: ScriptContext) -> Bool {
    (redeemer == 42)?
  }
}

type Answer {
  answer: Int,
}

type Guess {
  guess: Int,
}

validator {
  fn guessing(datum: Answer, redeemer: Guess, _ctx: ScriptContext) -> Bool {
    (redeemer.guess == datum.answer)?
  }
}
