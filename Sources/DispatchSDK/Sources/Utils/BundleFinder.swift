import Foundation

// RESOURCE: https://forums.developer.apple.com/forums/thread/652736
fileprivate class BundleFinder {}

#if !SPM
extension Bundle {
  static var module: Bundle { Bundle(for: BundleFinder.self) }
}
#endif
