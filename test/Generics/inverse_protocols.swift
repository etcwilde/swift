// RUN: %target-typecheck-verify-swift -enable-experimental-feature NoncopyableGenerics

// REQUIRES: asserts

protocol Eq: ~Copyable {
  func same(as: borrowing Self) -> Bool
  func different(from: borrowing Self) -> Bool
}

extension Eq {
  func different(from other: borrowing Self) -> Bool { !same(as: other) }
}

struct File: ~Copyable, Eq {
  let fd: Int = 0
  deinit {}

  func same(as other: borrowing Self) -> Bool {
    return fd == other.fd
  }
}

func check<T: ~Copyable>(_ a: T, _ b: borrowing T) -> Bool where T: Eq {
// expected-error@-1 {{noncopyable parameter must specify its ownership}}
// expected-note@-2 {{add 'borrowing' for an immutable reference}}
// expected-note@-3 {{add 'inout' for a mutable reference}}
// expected-note@-4 {{add 'consuming' to take the value from the caller}}

    return a.same(as: b)
}
