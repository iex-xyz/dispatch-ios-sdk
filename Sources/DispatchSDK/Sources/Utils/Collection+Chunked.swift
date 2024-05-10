import Foundation

extension Collection {
    func chunked(into chunkSize: Int) -> [[Element]] {
        var result = [[Element]]()
        var currentIndex = startIndex
        
        while currentIndex < endIndex {
            let endIndex = self.index(currentIndex, offsetBy: chunkSize, limitedBy: endIndex) ?? self.endIndex
            let chunk = Array(self[currentIndex..<endIndex])
            result.append(chunk)
            currentIndex = endIndex
        }
        
        return result
    }
}



