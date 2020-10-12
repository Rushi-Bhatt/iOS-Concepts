import Foundation
import UIKit
import PlaygroundSupport

//MARK:- Model
public class Pet {
  public enum Rarity {
    case common, uncommon, rare, veryRare
  }
  
  public let name: String
  public let birthDay: Date
  public let rarity: Rarity
  
  public init(name: String, birthDay: Date, rarity: Rarity) {
    self.name = name
    self.birthDay = birthDay
    self.rarity = rarity
  }
}

//MARK:- ViewModel
public class PetViewModel {
  private let pet: Pet
  private let calendar: Calendar
  
  public init(pet: Pet, calendar: Calendar = Calendar(identifier: .gregorian)) {
    self.pet = pet
    self.calendar = calendar
  }
  
  public var name: String {
    return pet.name
  }
  
  // Notice how view model here is taking responsibiltiy to transform birthday from the model to age field of the view
  // In case of MVC, this responsibility falls onto View Controller hence MVC problems
  public var ageText: String {
    let birthDay =  calendar.startOfDay(for: pet.birthDay)
    let today = calendar.startOfDay(for: Date())
    let components = calendar.dateComponents([.year], from: birthDay, to: today)
    let age = components.year!
    return "\(age) years old"
  }
  
  // Notice how view model here is taking responsibiltiy to transform rarity of the pet from the model to adoption fees field of the view
  // In case of MVC, this responsibility falls onto View Controller hence MVC problems
  public var adoptionFees: String {
    switch pet.rarity {
    case .common:
      return "$50.00"
    case .uncommon:
      return "$70.00"
    case .rare:
      return "$150.00"
    case .veryRare:
      return "$500.00"
    }
  }
}

extension PetViewModel {
  public func configure(_ view: PetView) {
    view.nameLabel.text = name
    view.ageLabel.text = ageText
    view.adoptionFeesLabel.text = adoptionFees
  }
}

//MARK:- View
public class PetView: UIView {
  public let nameLabel: UILabel
  public let ageLabel: UILabel
  public let adoptionFeesLabel: UILabel
  
  public override init(frame: CGRect) {
    var childframe = CGRect(x: 0.0, y: 16.0, width : frame.width, height: frame.height/2)
    
    childframe.origin.y += childframe.height + 16
    childframe.size.height = 30.0
    nameLabel = UILabel(frame: childframe)
    nameLabel.textAlignment = .center
    
    childframe.origin.y += childframe.height
    ageLabel = UILabel(frame: childframe)
    ageLabel.textAlignment = .center
    
    childframe.origin.y += childframe.height
    adoptionFeesLabel = UILabel(frame: childframe)
    adoptionFeesLabel.textAlignment = .center
    
    super.init(frame: frame)
    backgroundColor = .white
//    self.view.addSubView(nameLabel)
//    self.view.addSubView(ageLabel)
//    self.view.addSubView(adoptionFeesLabel)
  }
  
  @available(*, unavailable)
  public required init(coder: NSCoder) {
    fatalError("Use init(frame:) instead")
  }
}

//MARK:- Example
let birthDay = Date(timeIntervalSinceNow: -2*86400*366)
let stuart = Pet(name: "Stuart", birthDay: birthDay, rarity: .veryRare)
let viewModel = PetViewModel(pet: stuart)

let frame = CGRect(x:0.0, y: 0.0, width: 300.0, height: 420.0)
let view = PetView(frame: frame)

//view.nameLabel.text = viewModel.name
//view.ageLabel.text = viewModel.ageText
//view.adoptionFeesLabel.text = viewModel.adoptionFees

viewModel.configure(view)

PlaygroundPage.current.liveView = view

