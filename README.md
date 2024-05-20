
# DispatchSDK

![GitHub tag (latest SemVer)](https://github.com/iex-xyz/dispatch-ios-sdk/actions/workflows/ci.yml/badge.svg?branch=main)

## Demo

To run the demo project, clone this repo, and open Example.xcworkspace from the Example directory.


## Requirements
iOS 15.0+

## Installation
### Swift Package Manager

Add this to your project using Swift Package Manager. In Xcode:

Go to File > Swift Packages > Add Package Dependency...
Enter the package URL: https://github.com/iex-xyz/dispatch-ios-sdk.git
Click Next and select the version you want to use.
Click Next and select the target where you want to use the SDK.
Click Finish.

### Cocoapods
Add the following line to your Podfile:
pod 'DispatchSDK'
Then run pod install.

## Setup

1. Import the DispatchSDK module in your AppDelegate:

`import DispatchSDK`

2. Configure the SDK in your AppDelegate's application(_:didFinishLaunchingWithOptions:) method:

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let config = DispatchConfig(
        applicationId: "YOUR_APPLICATION_ID", 
        environment: .demo, // Use .production for release
        merchantId: "YOUR_MERCHANT_ID"
    )
    DispatchSDK.shared.setup(using: config)
    return true
}
```
3. Replace "YOUR_APPLICATION_ID" and "YOUR_MERCHANT_ID" with your actual values.

4. Present the SDK from anywhere in your app:

DispatchSDK.shared.present(with: .checkout(id: "DISTRIBUTION_ID")) 
Replace "DISTRIBUTION_ID" with the actual distribution ID you want to present.

5. (Optional) Register for analytics events:
```
DispatchSDK.shared.registerForEvents { event in
    print("Received event: \(event)")
}
```
## Configuration
### DispatchConfig
DispatchConfig is the configuration object used to set up the SDK. It has the following properties:

- applicationId: String - Your application ID
- environment: AppEnvironment - The environment to use (.demo or .production)
- merchantId: String - Your merchant ID
- orderCompletionCTA: String - The call to action text for the order completion screen (default is "Keep Shopping")
- hideOrderCompletionCTA: Bool - Whether to hide the order completion call to action (default is false)
- hideRootCloseButton: Bool - Whether to hide the close button in the root view controller (default is false)


## Author

Dispatch Solutions


## License

DispatchSDK is available under the MIT license. See [the LICENSE file](LICENSE) for more information.
