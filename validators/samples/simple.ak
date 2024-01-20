validator {
  fn gift(_datum: Data, _redeemer: Data, _ctx: Data) -> Bool {
    True
  }
}

validator {
  fn burn(_datum: Data, _redeemer: Data, _ctx: Data) -> Bool {
    False
  }
}
