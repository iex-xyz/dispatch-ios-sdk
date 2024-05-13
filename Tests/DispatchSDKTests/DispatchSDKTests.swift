import XCTest
@testable import DispatchSDK

final class DispatchSDKTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

class PhoneNumberValidatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Load phone number rules if needed
        // PhoneNumberValidator.loadPhoneNumberRules()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testFormatWithCompleteInternationalNumber() {
        let number = "+12223334444"
        let country = Country.unitedStates  // Assuming Country is defined with a code attribute.
        let formattedNumber = PhoneNumberValidator.format(for: number, country: country)
        XCTAssertEqual(formattedNumber, "+1 (222) 333 4444", "The formatted number should match the expected output.")
    }

    func testFormatWithNationalNumber() {
        let number = "12223334444"
        let country = Country.unitedStates
        let formattedNumber = PhoneNumberValidator.format(for: number, country: country)
        XCTAssertEqual(formattedNumber, "+1 (222) 333 4444", "The formatted number should match the expected output.")
    }

    func testFormatWithLocalNumber() {
        let number = "2223334444"
        let country = Country.unitedStates
        let formattedNumber = PhoneNumberValidator.format(for: number, country: country)
        XCTAssertEqual(formattedNumber, "+1 (222) 333 4444", "The formatted number should have the country code prefixed.")
    }

    func testPhoneNumberWithParenthesesAndSpaces() {
        let number = "+1 (222) 333-4444"
        let country = Country.unitedStates
        let formattedNumber = PhoneNumberValidator.format(for: number, country: country)
        XCTAssertEqual(formattedNumber, "+1 (222) 333 4444", "The formatted number should remain correctly formatted.")
    }

}
