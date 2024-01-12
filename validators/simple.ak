validator {
  fn gift(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    True
  }
}

validator {
  fn burn(_datum: Data, _redeemer: Data, _context: Data) -> Bool {
    False
  }
}
