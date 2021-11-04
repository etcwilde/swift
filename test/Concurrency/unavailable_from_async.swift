// RUN: %target-swift-frontend -typecheck -verify %s

// REQUIRES: concurrency

@unavailableFromAsync
struct Bip {
}

@unavailableFromAsync
func asyncFunc() async { // expected-error{{Asynchronous functions must be available from an asynchronous context}}
  let _ = Bip() //expected-error{{Can't use this type from an async context}}
}
