//
//  ViewController.swift
//  MyTestApp
//
//  Created by Bhatt,Rushi on 3/18/20.
//

import UIKit
import Firebase
import FirebaseUI

class ViewController: UIViewController, FUIAuthDelegate {

  @IBOutlet var email: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBOutlet var loginButton: UIButton!
  var authUI: FUIAuth?
  var ref: DatabaseReference?
  var storageRef = Storage.storage().reference()
  var storageMeta = StorageMetadata()
  
  @IBAction func onCreate(_ sender: Any) {
//    if let email = email.text, let password = password.text {
//      Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//        if error == nil {
//          //print(user?.user.displayName ?? "No display name")
//          print(user?.user.email ?? "No Email")
//          print(Auth.auth().currentUser?.uid ?? "No USER id")
//        }
//      }
//    }
    
//reusing the button to change the value of name
//    ref?.child("Games/1/name").setValue("Foosball \(Date())")
    
//reusing the button to upload image
    let fileKey = ref?.child("Games/2").key
    let filename = "\(fileKey!).png"
    self.storageMeta.contentType = "image/png"
    let fileRef = storageRef.child(filename)
    
    fileRef.putFile(from: Bundle.main.url(forResource: "image", withExtension: "png")!, metadata: storageMeta) { (meta, error) in
      if error == nil {
        self.ref?.child("Games/2/image").setValue(filename)
      }
    }
    
//    if let image = UIImage.init(named: "image.png") {
//      fileRef.putData(image.pngData()!, metadata: storageMeta) { (meta, error) in
//        if error == nil {
//          self.ref?.child("Games/1/image").setValue(filename)
//        }
//      }
//    }
    
    
  }
  
  @IBAction func onLogin(_ sender: Any) {
    if Auth.auth().currentUser == nil {
      // User not signed it
      //Using Google
      if let authVC = authUI?.authViewController() {
        present(authVC, animated: true, completion: nil)
      }
      
//      Using Email and password
//      if let email = email.text, let password = password.text {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//          if error == nil {
//            print("Sign-in successful")
//            print(user?.user.email ?? "No Email")
//            print(Auth.auth().currentUser?.uid ?? "No USER id")
//            self.loginButton.setTitle("Logout", for: .normal)
//          } else {
//            //Signin Error
//            print("Sign-in error for email: \(email) and password: \(password)")
//          }
//        }
//      }
    } else {
      //User signed in, call sign-out code
      do {
        try Auth.auth().signOut()
        print("Sign-out successful")
        self.loginButton.setTitle("Login", for: .normal)
      } catch {
      }
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    authUI = FUIAuth.defaultAuthUI()
    authUI?.delegate = self
    let providers : [FUIAuthProvider] = [FUIGoogleAuth(), FUIEmailAuth()]
    authUI?.providers = providers
    ref = Database.database().reference()
    // Do any additional setup after loading the view.
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    ref?.child("Games/1/name").removeAllObservers()
  }
  func createDataEntry() {
    ref?.child("Games").child("1").child("name").setValue("Foosball")
    ref?.child("Games/1/type").setValue("indoor")
    ref?.child("Games").child("2").setValue(["name": "Football", "type": "outdoor"])
    ref?.child("Games").childByAutoId().setValue(["name": "BasketaBall", "type": "outdoor"])
    
    ref?.child("Games/1/name").observeSingleEvent(of: .value, with: { (snapshot) in
      if let val = snapshot.value as? String {
        print(val)
      }
    })
    
    ref?.child("Games").observeSingleEvent(of: .value, with: { (snapshot) in
      if let val = snapshot.value as? [String:Any] {
        print(val)
      }
    })
    
    ref?.child("Games/1/name").observe(.value, with: { (snapshot) in
      if let val = snapshot.value as? String {
        print(val)
      }
    })
    
    let childUpdates = ["Games/1/name": "Multiplayer FoosBall", "Games/2/name": "Rugby"] as [String:Any]
    ref?.updateChildValues(childUpdates)
  }
  
  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
    if error == nil {
      print("Sign-in successful with Google")
      print("Email:\(authDataResult?.user.email ?? "No Email")")
      print(Auth.auth().currentUser?.uid ?? "No USER id")
      loginButton.setTitle("Logout", for: .normal)
//      if Auth.auth().currentUser != nil {
//         createDataEntry()
//      }
      
    }
  }

}

