# SwiftOAuth1a

Swift OAuth1a library inspired by https://github.com/guicocoa/cocoa-oauth

# Example

```swift

import SwiftOAuth1a

let oauthSerializer = Serializer(consumerKey: "consumerKey", consumerSecret: "consumerSecret")

let request = URLRequest("GET", url: NSURL(string: "http://some.url")!, parameters: ["oauth_callback" :  "http://some.callback"])

```
