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

class EmailValidatorTests: XCTestCase {
    
    func testValidEmails() {
        let validEmails = [
            "email@example.com",
            "firstname.lastname@example.co.uk",
            "email@subdomain.example.com",
            "firstname+lastname@example.com",
            "1234567890@example.com",
            "email@example-one.com",
            "_______@example.com",
            "email@example.name",
            "email@example.museum",
            "email@example.co.jp",
            "firstname-lastname@example.com"
        ]
        
        for email in validEmails {
            XCTAssertTrue(try EmailValidator.validateEmail(email), "Valid email should pass: \(email)")
        }
    }
    
    func testInvalidEmails() {
        let invalidEmails = [
            "plainaddress",
            "@missingusername.com",
            "email.example.com",
            "email@example@example.com",
            ".email@domain.com",
            "email@-domain.com",
            "email@111.222.333.44444",
            "email@domain..com",
            "Abc..123@example.com",
            "“(),:;<>[\\]@example.com",
            "just”not”right@example.com",
            "this\\ is\"really\"not\\allowed@example.com",
            "email@domain.com@"
        ]
        
        for email in invalidEmails {
            XCTAssertFalse(try EmailValidator.validateEmail(email), "Invalid email should fail: \(email)")
        }
    }
}

class PhoneNumberValidatorTests: XCTestCase {
    
    // Test valid phone numbers
    func testValidPhoneNumbers() {
        let validNumbers = [
            "(123) 456-7890",
            "123-456-7890",
            "123 456 7890",
            "1234567890"
        ]
        
        for number in validNumbers {
            XCTAssertTrue(PhoneNumberValidator.validatePhoneNumber(number), "The phone number \(number) should be valid.")
        }
    }
    
    // Test invalid phone numbers
    func testInvalidPhoneNumbers() {
        let invalidNumbers = [
            "(123) 456-789",  // Not enough digits
            "123-45-67890",  // Incorrectly placed hyphens
            "12 345 67890",  // Improper spaces
            "abc-def-ghij",  // Non-numeric characters
            "(123) 456 78901", // Too many digits
            "123-456-78901",  // Too many digits
            "(123)456-7890",  // Missing space
            "123) 456-7890",  // Incorrect formatting
            "(123 456-7890",  // Missing closing parenthesis
            "123.456.7890"   // Incorrect delimiter
        ]
        
        for number in invalidNumbers {
            XCTAssertFalse(PhoneNumberValidator.validatePhoneNumber(number), "The phone number \(number) should be invalid.")
        }
    }
    
    // Test malformed inputs
    func testMalformedPhoneNumbers() {
        let malformedNumbers = [
            "",  // Empty string
            "   ",  // Only spaces
            "()--"  // Only punctuation
        ]
        
        for number in malformedNumbers {
            XCTAssertFalse(PhoneNumberValidator.validatePhoneNumber(number), "The malformed phone number \(number) should be invalid.")
        }
    }
}


class CreditCardValidatorTests: XCTestCase {
    // Valid Visa card number
    func testValidateCardNumber() {
        
        XCTAssertTrue(CreditCardValidator.validateCardNumber("4111111111111111"), "Visa card number should be valid.")
        
        // Invalid Visa card number
        XCTAssertFalse(CreditCardValidator.validateCardNumber("4111111111111112"), "Visa card number should be invalid.")
        
        // Valid American Express card number
        XCTAssertTrue(CreditCardValidator.validateCardNumber("378282246310005"), "American Express card number should be valid.")
        
        // Invalid American Express card number
        XCTAssertFalse(CreditCardValidator.validateCardNumber("378282246310006"), "American Express card number should be invalid.")
    }
    
    func testDetectCardType() {
        XCTAssertEqual(CreditCardValidator.detectCardType(from: "4111111111111111"), .visa, "Should detect Visa.")
        XCTAssertEqual(CreditCardValidator.detectCardType(from: "5500000000000004"), .masterCard, "Should detect MasterCard.")
        XCTAssertEqual(CreditCardValidator.detectCardType(from: "378282246310005"), .americanExpress, "Should detect American Express.")
        XCTAssertEqual(CreditCardValidator.detectCardType(from: "6011111111111117"), .discover, "Should detect Discover.")
        XCTAssertNil(CreditCardValidator.detectCardType(from: "9111111111111111"), "Should not detect any known card type.")
    }

    func testValidateSecurityCode() {
        XCTAssertTrue(CreditCardValidator.validateSecurityCode("123", cardType: .visa), "Visa CVV should be valid with 3 digits.")
        XCTAssertFalse(CreditCardValidator.validateSecurityCode("1234", cardType: .visa), "Visa CVV should be invalid with 4 digits.")
        XCTAssertTrue(CreditCardValidator.validateSecurityCode("1234", cardType: .americanExpress), "American Express CVV should be valid with 4 digits.")
        XCTAssertFalse(CreditCardValidator.validateSecurityCode("123", cardType: .americanExpress), "American Express CVV should be invalid with 3 digits.")
    }

    func testIsDateValid() {
        let calendar = Calendar.current
        let nextYear = calendar.date(byAdding: .year, value: 1, to: Date())!
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: Date())!

        XCTAssertTrue(CreditCardValidator.isDateValid(nextYear), "The date one year in the future should be valid.")
        XCTAssertFalse(CreditCardValidator.isDateValid(lastMonth), "The date one month in the past should be invalid.")
    }

}
