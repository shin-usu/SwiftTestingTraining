import Testing
@testable import SwiftTestingTraining


@Suite("Sample tests")
final class SampleTests {
    var a: Int

    // initに書いた処理は各テストの最初に実行される。
    // XCTestのsetUp関数の代わりとなる。
    init() {
        a = 0
    }
    
    // deinitに書いた処理は各テストの最初に実行される。
    // XCTestのtearDown関数の代わりとなる。
    deinit {
        a = 10
    }

    // 基本的なやつ
    @Test func standardTest() {
        self.a += 1
        let b = 1
        #expect(a == b)
    }

    // わざとFailさせる
    @Test func failCheck() {
        let b = 3
        let sum = a + b
        let expect = 4
        #expect(sum == expect)
    }
    
    // #expectの場合は失敗しても後続処理を続ける
    // 最初はFail、その次Success、最後またFailという風に結果が出る
    @Test func expectMacroBehavorCheck() {
        var array = [String]()
        #expect(!array.isEmpty)
        array.append("Hello")
        #expect(!array.isEmpty)
        #expect(array.isEmpty)
    }
    
    // #requireの場合は失敗すると後続処理を実行しない
    @Test func requireMacroBehavor() throws {
        var array = [String]()
        try #require(!array.isEmpty)
        array.append("Hello")
        #expect(!array.isEmpty)
        #expect(array.isEmpty)
    }
    
    func getOptionalString(wantNil: Bool = false) -> String? {
        wantNil ? nil : "Optional"
    }

    // requireマクロを使用してUnwrapもできる
    @Test func requireUnwrap() throws {
        let string = try #require(getOptionalString())
        #expect(string != nil)
        
        // ここでnilが帰ってきた場合はテスト終了
        let string2 = try #require(getOptionalString(wantNil: true))
        #expect(string2 != nil)
    }
    
    enum SampleTestError: Error {
        case hogehoge
    }
    enum SampleTestError2: Error {
        case fugafuga(code: Int)
    }

    func sample() throws {
        throw SampleTestError.hogehoge
    }
    
    func sample2() throws {
        throw SampleTestError2.fugafuga(code: 400)
    }
    
    // エラーがthrowされるかどうかをチェックする
    @Test func throwErrorTest() throws {
        #expect(throws: (any Error).self) {
            try sample()
        }
        
        #expect(throws: SampleTestError.self) {
            try sample()
        }
        
        #expect(throws: SampleTestError.hogehoge) {
            try sample()
        }
        
        #expect {
            try sample2()
        } throws: { error in
            guard let error = error as? SampleTestError2,
                  case let .fugafuga(code) = error
            else {
                return false
            }
            return code == 400
        }
    }
}
