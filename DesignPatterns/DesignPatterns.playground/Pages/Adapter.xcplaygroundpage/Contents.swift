import Foundation
import UIKit

//MARK:- Legacy Object
public class GoogleAuthenticator {
  public func login(email: String, password: String, completion: @escaping (GoogleUser?, Error?) -> Void) {
    //Make network calls, which returns token value
    let token = "Special token value after auth"
    let user = GoogleUser(email: email, password: password, token: token)
    completion(user, nil)
  }
}

public struct GoogleUser {
  public var email: String
  public var password: String
  public var token: String
}

//MARK:- New protocol
// To make the authenticator service more generalized, and in future, replace it with Gitgub or Apple authentication instead of Google authentication, if required
public protocol AuthenticatorService {
  func login(email: String,
                    password: String,
                    success: @escaping (User, Token) -> Void,
                    failure: @escaping (Error?) -> Void)
}

public struct User {
  public var email: String
  public var password: String
}

public struct Token {
  public let value: String
}

// Here, the Google Authenticator directly can not be used as authenticator service
// In order to use it as the authentication service, it needs to conform to AuthenticatorService protocol
// This can be done using 2 approaches:
// 1) Protocol conforance using extension
// extension GoogleAuthenticator: AuthenticatorService { // Provide the definition of login here }
// OR
// 2) Using Adapter class: Lets use Adapter class approach here:

//MARK:- Adapter class
// See how this acts as an adapter between new protocol and old legacy object, by calling the old object's respective API from the new protocol functions

public class GoogleAuthenticatorAdapter: AuthenticatorService {
  
  public var authenticator = GoogleAuthenticator()
  
  public func login(email: String, password: String, success: @escaping (User, Token) -> Void, failure: @escaping (Error?) -> Void) {
    authenticator.login(email: email, password: password) { (googleUser, error) in
      guard let googleUser = googleUser else {
        failure(error)
        return
      }
      let user = User(email: email, password: password)
      let token = Token(value: googleUser.token)
      success(user, token)
    }
  }
}


//MARK:- Example

// Here the class that might use authService is dependent on new protocol (AuthenticatorService), and our Adapter class conforms to that protocol and call the respective functions of the legacy object
let authService: AuthenticatorService = GoogleAuthenticatorAdapter()   // this can be changed to any other Adapter and the code will work seamlessly.
authService.login(
  email: "user@example.com",
  password: "password",
  success: { (user, token) in
    print("Auth successful: \(user.email), \(token.value)")
  }, failure: { error in
  if let error = error {
    print("Auth failed with error: \(error)")
  } else {
    print("Auth failed with no error provided")
  }
})
