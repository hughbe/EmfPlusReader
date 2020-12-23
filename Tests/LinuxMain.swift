import XCTest

import WindowsDataTypesTests

var tests = [XCTestCaseEntry]()
tests += DumpFileTests.allTests()
tests += EmfPlusFileTests.allTests()
XCTMain(tests)
