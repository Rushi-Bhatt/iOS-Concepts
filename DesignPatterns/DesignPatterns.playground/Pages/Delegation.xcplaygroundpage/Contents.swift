import UIKit

// Here MenuViewController acts an object that needs a delegate, so it defines a delegate protocol, and holds a weak reference of the delegate object
// Some other class will act as a delegate by conforming to MenuViewControllerDelegate protocol and setting MenuViewController.delegate = self in its own viewDidLoad method

//  Here MenuViewController also acts as a delegate for TableView

// Notice how for the delegate protocol methods, its always a standard to have the object itself as the first parameter
public protocol MenuViewControllerDelegate: AnyObject {
  func menuViewController(_ menuViewController: MenuViewController, didSelectItemAtIndex index: Int)
}

public class MenuViewController: UIViewController {
  
  public weak var delegate: MenuViewControllerDelegate?
  
  @IBOutlet public var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
      tableView.delegate = self
    }
  }
  
  private var items = ["Item 1", "Item 2", "Item 3"]
}

extension MenuViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
}

extension MenuViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // Notice how for the delegate protocol methods, its always a standard to pass the object itself as the first parameter
    delegate?.menuViewController(self, didSelectItemAtIndex: indexPath.row)
  }
}
