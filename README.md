# SwiftOAuth1a
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Swift OAuth1a library inspired by https://github.com/guicocoa/cocoa-oauth

# Carthage

`github "yageek/SwiftOAuth1a" "develop"`

# Example

```swift

import SwiftOAuth1a

let oauthSerializer = Serializer(consumerKey: "consumerKey", consumerSecret: "consumerSecret")

let request = URLRequest("GET", url: NSURL(string: "http://some.url")!, parameters: ["oauth_callback" :  "http://some.callback"])
```

## License

SwiftOAuth1a is available under the MIT license. See the LICENSE file for more info
