import Foundation

// Resources:
// https://www.timekl.com/blog/2017/08/31/swift-tricks-emoji-flags/

extension Country {
    private func isLowercaseASCIIScalar(_ scalar: Unicode.Scalar) -> Bool {
        return scalar.value >= 0x61 && scalar.value <= 0x7A
    }

    private func regionalIndicatorSymbol(for scalar: Unicode.Scalar) -> Unicode.Scalar? {
        guard isLowercaseASCIIScalar(scalar) else {
            return nil
        }
        
        // 0x1F1E6 marks the start of the Regional Indicator Symbol range and corresponds to 'A'
        // 0x61 marks the start of the lowercase ASCII alphabet: 'a'
        return Unicode.Scalar(scalar.value + (0x1F1E6 - 0x61))
    }
    
    func emojiFlag() -> String? {
        let lowercasedCode = code.lowercased()
        guard lowercasedCode.count == 2 else {
            return nil
        }
        guard lowercasedCode.unicodeScalars.allSatisfy(isLowercaseASCIIScalar) else {
            return nil
        }
        
        let indicatorSymbols = lowercasedCode.unicodeScalars.compactMap(regionalIndicatorSymbol)
        guard indicatorSymbols.count == 2 else {
            return nil
        }
        
        return String(indicatorSymbols.map(Character.init))
    }
}
