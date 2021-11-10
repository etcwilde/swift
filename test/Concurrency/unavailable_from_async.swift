// RUN: %target-swift-frontend -typecheck -verify -disable-availability-checking %s

// REQUIRES: concurrency

func okay() {}

// expected-error@+1{{'@unavailableFromAsync' attribute cannot be applied to this declaration}}
@unavailableFromAsync
struct Foo { }

// expected-error@+1{{'@unavailableFromAsync' attribute cannot be applied to this declaration}}
@unavailableFromAsync
extension Foo { }

// expected-error@+1{{'@unavailableFromAsync' attribute cannot be applied to this declaration}}
@unavailableFromAsync
class Bar {
  // expected-error@+1{{'@unavailableFromAsync' attribute cannot be applied to this declaration}}
  @unavailableFromAsync
  deinit { }
}

// expected-error@+1{{'@unavailableFromAsync' attribute cannot be applied to this declaration}}
@unavailableFromAsync
actor Baz { }

struct Bop {
  @unavailableFromAsync
  init() {}

  init(a: Int) { }
}

extension Bop {
  @unavailableFromAsync
  func foo() {}


  @unavailableFromAsync
  mutating func muppet() { }

}

@unavailableFromAsync
func foo() {}

func makeAsyncClosuresSynchronously(bop: inout Bop) -> (() async -> Void) {
  return { () async -> Void in
    // Unavailable methods
    _ = Bop()     // expected-error@:9{{Can't use this decl from an async context}}
    _ = Bop(a: 32)
    bop.foo()     // expected-error@:9{{Can't use this decl from an async context}}
    bop.muppet()    // expected-error@:9{{Can't use this decl from an async context}}
    // Can use them from synchronous closures
    _ = { Bop() }()
    _ = { bop.foo() }()
    _ = { bop.muppet() }()

    // Unavailable global function
    foo()         // expected-error{{Can't use this decl from an async context}}

    // Okay function
    okay()
  }
}

@unavailableFromAsync
func asyncFunc() async { // expected-error{{Asynchronous functions must be available from an asynchronous context}}

  var bop = Bop(a: 32)
  _ = Bop()     // expected-error@:7{{Can't use this decl from an async context}}
  bop.foo()     // expected-error@:7{{Can't use this decl from an async context}}
  bop.muppet()    // expected-error@:7{{Can't use this decl from an async context}}

  // Unavailable global function
  foo()         // expected-error{{Can't use this decl from an async context}}

  // Available function
  okay()

  _ = { () -> Void in
    // Check unavailable things inside of a nested synchronous closure
    _ = Bop()
    foo()
    bop.foo()
    bop.muppet()

    _ = { () async -> Void in
      // Check Unavailable things inside of a nested async closure
      foo()           // expected-error@:7{{Can't use this decl from an async context}}
      bop.foo()       // expected-error@:11{{Can't use this decl from an async context}}
      bop.muppet()    // expected-error@:11{{Can't use this decl from an async context}}
      _ = Bop()       // expected-error@:11{{Can't use this decl from an async context}}
    }
  }

  _ = { () async -> Void in
    _ = Bop()     // expected-error@:9{{Can't use this decl from an async context}}
    foo()         // expected-error@:5{{Can't use this decl from an async context}}
    bop.foo()     // expected-error@:9{{Can't use this decl from an async context}}
    bop.muppet()  // expected-error@:9{{Can't use this decl from an async context}}

    _ = {
      foo()
      bop.foo()
      _ = Bop()
    }
  }

}
