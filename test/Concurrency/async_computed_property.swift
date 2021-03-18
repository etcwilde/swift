// RUN: %target-typecheck-verify-swift -enable-experimental-concurrency
// REQUIRES: concurrency

func asyncFunc(_ value: String) async {}

class ComputedPropertyClass {
  var meep: String {
    //expected-error@+1:19{{'async' call in a function that does not support concurrenct}}
    await asyncFunc("Meep")
    return "15"
  }
}
