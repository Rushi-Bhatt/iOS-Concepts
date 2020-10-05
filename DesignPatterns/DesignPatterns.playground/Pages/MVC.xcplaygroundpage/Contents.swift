import Foundation
import UIKit

// MARK: - Model
public struct Address {
  public var street: String
  public var city: String
  public var state: String
  public var zipCode: String
}

// MARK:- View
public final class AddressView: UIView {
  @IBOutlet public var streetTextField: UITextField!
  @IBOutlet public var cityTextField: UITextField!
  @IBOutlet public var stateTextField: UITextField!
  @IBOutlet public var zipCodeTextField: UITextField!
}

//MARK:- Controller
public final class AddressViewController: UIViewController {
  
  //MARK:- Properties
  public var address: Address? {
    didSet {
      updateViewFromAddress()     // Property Observer: This is how the Model communicates with the ViewController
    }
  }
  public var addressView: AddressView! {
    guard isViewLoaded else { return nil }
    return (view as! AddressView?)
  }
  
  //MARK: View Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    updateViewFromAddress()
  }
  
  private func updateViewFromAddress() {
    guard let addressView = addressView, let address = address else {
      return
    }
    addressView.streetTextField.text = address.street
    addressView.cityTextField.text = address.city
    addressView.stateTextField.text = address.state
    addressView.zipCodeTextField.text = address.zipCode
  }
  
  // IBAction: This is how the view communicates with the ViewController
  
  //MARK:- Actions
  @IBAction public func updateAddressFromView(_ sender: AnyObject) {
    guard let street = addressView.streetTextField.text, street.count > 0,
      let city = addressView.cityTextField.text, city.count > 0,
      let state = addressView.streetTextField.text, state.count > 0,
      let zipCode = addressView.zipCodeTextField.text, zipCode.count > 0 else {
        // Show errors on the view, handle the error
        return
    }
    address = Address(street: street, city: city, state: state, zipCode: zipCode)
  }
  
}
