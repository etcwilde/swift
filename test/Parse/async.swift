// RUN: %target-typecheck-verify-swift -enable-experimental-concurrency

// REQUIRES: concurrency

// Parsing function declarations with 'async'
func asyncGlobal1() async { }
func asyncGlobal2() async throws { }

func asyncGlobal3() throws async { } // expected-error{{'async' must precede 'throws'}}{{28-34=}}{{21-21=async }}

func asyncGlobal3(fn: () throws -> Int) rethrows async { } // expected-error{{'async' must precede 'rethrows'}}{{50-56=}}{{41-41=async }}

func asyncGlobal4() -> Int async { } // expected-error{{'async' may only occur before '->'}}{{28-34=}}{{21-21=async }}

func asyncGlobal5() -> Int async throws { }
// expected-error@-1{{'async' may only occur before '->'}}{{28-34=}}{{21-21=async }}
// expected-error@-2{{'throws' may only occur before '->'}}{{34-41=}}{{21-21=throws }}

func asyncGlobal6() -> Int throws async { }
// expected-error@-1{{'throws' may only occur before '->'}}{{28-35=}}{{21-21=throws }}
// expected-error@-2{{'async' may only occur before '->'}}{{35-41=}}{{21-21=async }}

func asyncGlobal7() throws -> Int async { } // expected-error{{'async' may only occur before '->'}}{{35-41=}}{{21-21=async }}

func asyncGlobal8() async throws async -> async Int async {}
// expected-error@-1{{'async' has already been specified}} {{34-40=}}
// expected-error@-2{{'async' has already been specified}} {{43-49=}}
// expected-error@-3{{'async' has already been specified}} {{53-59=}}

class X {
  init() async { } // expected-error{{initializer cannot be marked 'async'}}

  deinit async { } // expected-error{{deinitializers cannot have a name}}

  func f() async { }

  subscript(x: Int) async -> Int { // expected-error{{expected '->' for subscript element type}}
    // expected-error@-1{{single argument function types require parentheses}}
    // expected-error@-2{{cannot find type 'async' in scope}}
    // expected-note@-3{{cannot use module 'async' as a type}}
    get {
      return 0
    }

    set async { // expected-error{{expected '{' to start setter definition}}
    }
  }
}

// Parsing function types with 'async'.
typealias AsyncFunc1 = () async -> ()
typealias AsyncFunc2 = () async throws -> ()
typealias AsyncFunc3 = () throws async -> () // expected-error{{'async' must precede 'throws'}}{{34-40=}}{{27-27=async }}

// Parsing type expressions with 'async'.
func testTypeExprs() {
  let _ = [() async -> ()]()
  let _ = [() async throws -> ()]()
  let _ = [() throws async -> ()]()  // expected-error{{'async' must precede 'throws'}}{{22-28=}}{{15-15=async }}

  let _ = [() -> async ()]() // expected-error{{'async' may only occur before '->'}}{{18-24=}}{{15-15=async }}
}

// Parsing await syntax.
struct MyFuture {
  func await() -> Int { 0 }
}

func testAwaitExpr() async {
  let _ = await asyncGlobal1()
  let myFuture = MyFuture()
  let _ = myFuture.await()
}

func getIntSomeday() async -> Int { 5 }

func testAsyncLet() async {
  async let x = await getIntSomeday()
  _ = await x
}

async func asyncIncorrectly() { } // expected-error{{'async' must be written after the parameter list of a function}}{{1-7=}}{{30-30= async}}

// completion handler async mapping parsing errors

// expected-error@+1{{expected '(' in 'completionHandlerAsync' attribute}}
@completionHandlerAsync
func compHandlerFunc1() {}

// expected-error@+1:28{{expected a colon ':' after 'for'}}
@completionHandlerAsync(for)
func compHandlerFunc2() {}

// expected-error@+1:25{{missing label 'for:' in '@completionHandlerAsync' attribute}}
@completionHandlerAsync(foo: "asynFunc(task: String)", completionHandlerIndex: 1)
func compHandleFunc3(task: String, completionHandler: @escaping (Int) -> Void) {}

// expected-error@+1:30{{expected string literal in 'completionHandlerAsync' attribute}}
@completionHandlerAsync(for: 32, completionHandlerIndex: 1)
func compHandleFunc4(task: String, completionHandler: @escaping (Int) -> Void) {}

// expected-error@+1:55{{expected ',' separator}}
@completionHandlerAsync(for: "asyncFunc(task: String)")
func compHandleFunc5(task: String, completionHandler: @escaping (Int) -> Void) {}

// expected-error@+3:25{{missing label 'for:' in '@completionHandlerAsync' attribute}}
// expected-error@+2:30{{expected string literal in 'completionHandlerAsync' attribute}}
// expected-error@+1:32{{expected ',' separator}}
@completionHandlerAsync(foo: 32)
func compHandleFunc6() {}

// expected-error@+1:57{{missing label 'completionHandlerIndex:' in '@completionHandlerAsync' attribute}}
@completionHandlerAsync(for: "asyncFunc(task: String)", comHandleIdx: 13)
func compHandlerFunc7() {}

// expected-error@+1:81{{expected string literal in 'completionHandlerAsync' attribute}}
@completionHandlerAsync(for: "asyncFunc(task: String)", completionHandlerIndex: "99")
func compHandlerFunc8() {}

// expected-error@+4:25{{missing label 'for:' in '@completionHandlerAsync' attribute}}
// expected-error@+3:30{{expected string literal in 'completionHandlerAsync' attribute}}
// expected-error@+2:34{{missing label 'completionHandlerIndex:' in '@completionHandlerAsync' attribute}}
// expected-error@+1:42{{expected string literal in 'completionHandlerAsync' attribute}}
@completionHandlerAsync(foo: 19, foobar: "19")
func compHandlerFunc9() {}

// expected-error@+3:20{{'@completionHandlerAsync' parameter 'completionHandlerIndex' must have a function type}}
// expected-error@+2:35{{'@completionHandlerAsync' attribute attached to async function}}
@completionHandlerAsync(for: "asyncFunc", completionHandlerIndex: 0)
func myAsyncFunc(_ value: String) async {}

// expected-error@+1:67{{'@completionHandlerAsync' parameter 'completionHandlerIndex' out of range}}
@completionHandlerAsync(for: "asyncFunc", completionHandlerIndex: 1)
func myAsyncFunc1(_ value: String) {}

// Without the closing paren, it's hard to know exactly what the intent is or
// where to jump, so we don't jump over the tokens.
// expected-error@+6:54{{expected ')' in 'completionHandlerAsync' attribute}}
// expected-error@+5:25{{expected declaration}}
// expected-error@+4:28{{expected pattern}}
// expected-error@+3:30{{expected type}}
// expected-error@+2:30{{expected 'in' after for-each pattern}}
// expected-error@+1{{expected '{' to start the body of for-each loop}}
@completionHandlerAsync(for: "asynFunc(task: String)"
func compHandlerFunc10(task: String, completionHandler: @escaping (Int) -> Void) {}
