import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DumpFileTests.allTests),
        testCase(EmfPlusFileTests.allTests),
    ]
}
#endif
