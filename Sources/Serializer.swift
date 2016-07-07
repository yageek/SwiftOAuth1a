//
//  OAuth1RequestSerializer.swift
//  SwiftOAuth1a
//
//  Created by Yannick Heinrich on 17/06/15.
//  Copyright (c) 2015 yageek. All rights reserved.
//

import Foundation
import HMAC
import Base32

public class Serializer {

    enum SignatureMethod: String {
       case HMAC = "HMAC-SHA1"
       case RSA = "RSA-SHA1"
    }
        /// The consumerKey provided by the API
        let consumerKey: String
        /// The consumerSecrte provided by the API
        let consumerSecret: String
        /// The accessToken provided by the API
       public var accessToken: String?
        /// The tokenSecretProvided by the API
       public var tokenSecret: String?

        let version = "1.0"
        let signatureMethod = SignatureMethod.HMAC

        public var userAgent = "SwiftOAuth1a"
        public var timeout = 10.0


    var hmacSignKey: String {
        get {
            return String(format: "%@&%@", arguments: [self.consumerSecret, self.tokenSecret ?? ""])
        }
    }

    internal func OAuthParameters(nonce: String? = nil, timeStamp: String? = nil) -> [String:String] {
        var baseArray: [String:String] =  [
            "oauth_version" : self.version,
            "oauth_nonce" : nonce ?? Serializer.nonce(),
            "oauth_signature_method" : self.signatureMethod.rawValue,
            "oauth_timestamp" : timeStamp ?? Serializer.timeStamp(),
            "oauth_consumer_key" : self.consumerKey
        ]

        if let token = accessToken {
            baseArray["oauth_token"] = token
        }

        return baseArray

    }

    internal class func nonce() -> String {
        return NSUUID().UUIDString
    }

    internal class func timeStamp() -> String {
        var t: time_t = time_t()
        time(&t)
        mktime(gmtime(&t))

        return String(format: "%i", arguments: [Int(t)])

    }

    /**
    Initialize a new OAuth1A Serializer

    - parameter consumerKey:    The consumer key
    - parameter consumerSecret: The consumer secret
    - parameter accessToken:    The access token if available
    - parameter tokenSecret:    The token secret if available

    - returns: A new OAuth1A serializer
   */

    public init(consumerKey key: String, consumerSecret secret: String, accessToken token: String? = nil, tokenSecret: String? = nil) {
            self.consumerKey = key
            self.consumerSecret = secret
            self.accessToken = token
            self.tokenSecret = tokenSecret
        }
    /**
   Serailize a request

    - parameter method:     The HTTP Method
    - parameter url:        The URL
    - parameter parameters: The parameters of the request

    - returns: A NSMutableURLRequest instance

    */
    public func URLRequest(method: String, url: NSURL, parameters: [String: String]) -> NSMutableURLRequest? {


        let oauthParams = self.OAuthParameters()
        let params = ParameterList()

        params.addParameters(oauthParams)
        params.addParameter("oauth_signature", value: self.Signature(method, url: url, requestParams: parameters, oauthParams:oauthParams))

        let authorizationHeader = "OAuth " + params.normalizedParameters(",", escapeValues: true)

        //Build request
        let finalURL: NSURL
        let requestParameters = ParameterList()
        requestParameters.addParameters(parameters)


        if method == "GET" {
            let urlString = String(format: "%@?%@", arguments: [url.absoluteString, requestParameters.normalizedParameters()])
            finalURL = NSURL(string: urlString)!
        } else {
            finalURL = url
        }

        let request = NSMutableURLRequest(URL: finalURL, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: self.timeout)

        if method != "GET" {
            let query = requestParameters.normalizedParameters("=")
            let data = query.dataUsingEncoding(NSUTF8StringEncoding)!
            let length = String(data.length)

            request.HTTPBody = data
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(length, forHTTPHeaderField: "Content-Length")
        }

        request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        request.HTTPMethod = method

        return request
    }


    internal func Signature(method: String, url: NSURL, requestParams: [String:String], oauthParams oparams: [String:String]) -> String {

        var oauthParams = oparams
        if let token =  self.accessToken {
            oauthParams["oauth_access_token"] = token
        }
        let baseSignature = Serializer.SignatureBaseString(method, url: url, requestParams: requestParams, oauthParams:oauthParams)

        let base = baseSignature.dataUsingEncoding(NSUTF8StringEncoding)!
        let secret = self.hmacSignKey.dataUsingEncoding(NSUTF8StringEncoding)!

        let hmacRawSignature = HMAC(algorithm: .SHA1, key: secret).update(base).final()
        let data = NSData(bytes: hmacRawSignature, length: hmacRawSignature.count)
        let oauthSignature = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

        return oauthSignature

    }

    internal class func SignatureBaseString(method: String, url: NSURL, requestParams: [String:String], oauthParams: [String:String]) -> String {

        let params = ParameterList()
        params.addParameters(requestParams)
        params.addParameters(oauthParams)

        //Signature
        var signature = method
        signature += "&"
        signature +=  url.baseStringURI().pcen()
        signature += "&"
        signature += params.normalizedParameters().pcen()

        return signature
    }

}
