// RUN: %target-swift-frontend -D CONFIG1 -dump-ast -parse-as-library %s | %FileCheck %s --check-prefix=CHECK-CONFIG1
// RUN: %target-swift-frontend -D CONFIG2 -dump-ast -parse-as-library %s | %FileCheck %s --check-prefix=CHECK-CONFIG2
// RUN: %target-swift-frontend -D CONFIG3 -dump-ast -parse-as-library %s | %FileCheck %s --check-prefix=CHECK-CONFIG3

// REQUIRES: concurrency

protocol AppConfiguration { }

struct Config1: AppConfiguration {}
struct Config2: AppConfiguration {}
struct Config3: AppConfiguration {}

@available(SwiftStdlib 5.5, *)
protocol App {
    associatedtype Configuration: AppConfiguration
}

@available(SwiftStdlib 5.5, *)
extension App where Configuration == Config1 {
// CHECK-CONFIG1: (func_decl implicit "$main()" interface type='(MainType.Type) -> () -> ()'
// CHECK-CONFIG1: where_clause_main_resolution.swift:[[# @LINE+1 ]]
    static func main() { }
}

@available(SwiftStdlib 5.5, *)
extension App where Configuration == Config2 {
    static func bar() async { }

// CHECK-CONFIG2: (func_decl implicit "$main()" interface type='(MainType.Type) -> () async -> ()'
// CHECK-CONFIG2: where_clause_main_resolution.swift:[[# @LINE+1 ]]
    static func main() async {
        await Self.bar()
    }
}

@available(SwiftStdlib 5.5, *)
extension App {
// CHECK-CONFIG3: (func_decl implicit "$main()" interface type='(MainType.Type) -> () async -> ()'
// CHECK-CONFIG3: where_clause_main_resolution.swift:[[# @LINE+1 ]]
    static func main() async { }
}

@main
@available(SwiftStdlib 5.5, *)
struct MainType : App {

#if CONFIG1
    typealias Configuration = Config1
#elseif CONFIG2
    typealias Configuration = Config2
#elseif CONFIG3
    typealias Configuration = Config3
#endif
}
