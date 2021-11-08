// RUN: %target-swift-frontend -typecheck -verify %s

// REQUIRES: concurrency

func okay() {}

@unavailableFromAsync
struct Bip {
}

struct Bop {
  @unavailableFromAsync
  init() {}

  init(a: Int) {}
}

extension Bop {
  @unavailableFromAsync
  func foo() {}
}

@unavailableFromAsync
func foo() {}

func makeAsyncClosuresSynchronously() -> (() async -> ()) {
  return { () async -> () in
    let _ = Bip() // expected-error@:13{{Can't use this type from an async context}}
    let _ = Bop() // expected-error@:13{{Can't use this decl from an async context}}

    let _ = Bip() //expected-error@:13{{Can't use this type from an async context}}
    let _ = Bop() // expected-error@:13{{Can't use this decl from an async context}}
    let bop = Bop(a: 32)
    bop.foo() // expected-error@:9{{Can't use this decl from an async context}}
    foo() // expected-error{{Can't use this decl from an async context}}
  }
}

@unavailableFromAsync
func asyncFunc(bip: Bip) async { // expected-error{{Asynchronous functions must be available from an asynchronous context}}
  okay()
  let _ = Bip() //expected-error@:11{{Can't use this type from an async context}}
  let _ = Bop() // expected-error@:11{{Can't use this decl from an async context}}
  let bop = Bop(a: 32)
  bop.foo() // expected-error@:7{{Can't use this decl from an async context}}
  foo() // expected-error{{Can't use this decl from an async context}}

  let _ = { () -> () in
    let _ = Bip()
    let _ = Bop()
    foo()
    bop.foo()

    let _ = { () async -> () in
      foo()           // expected-error@:7{{Can't use this decl from an async context}}
      bop.foo()       // expected-error@:11{{Can't use this decl from an async context}}
      let _ = Bip()   // expected-error@:15{{Can't use this type from an async context}}
      let _ = Bop()   // expected-error@:15{{Can't use this decl from an async context}}
    }
  }

  let _ = { () async -> () in
    let _ = Bip() // expected-error@:13{{Can't use this type from an async context}}
    let _ = Bop() // expected-error@:13{{Can't use this decl from an async context}}
    foo()         // expected-error@:5{{Can't use this decl from an async context}}
    bop.foo()     // expected-error@:9{{Can't use this decl from an async context}}

    let _ = {
      foo()
      bop.foo()
      let _ = Bip()
      let _ = Bop()
    }
  }

}
