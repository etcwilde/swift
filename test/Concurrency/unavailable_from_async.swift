// RUN: %target-swift-frontend -typecheck -verify %s

// REQUIRES: concurrency

@unavailableFromAsync
struct Bip {
}

func asyncFunc() async {
  let _ = Bip() //expected-error{{Can't use this type from an async context}}
}
