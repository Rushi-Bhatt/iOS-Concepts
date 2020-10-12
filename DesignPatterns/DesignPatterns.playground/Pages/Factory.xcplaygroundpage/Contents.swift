import Foundation

public struct JobApplication {
  public enum Status {
     case new, interview, hired, rejected
  }
  
  public let name: String
  public let email: String
  public var status: Status
}

//MARK:- Product
// Notice how the product creation logic( based on the status of the job application, change the email subject and body) is moved out of the product itself.
// Email product doesnt take JobApplication as the parameter, rather factory takes it as parameter and returns appropriate Email Object.
public struct Email {
  public let subject: String
  public let messageBody: String
  public let recipientEmail: String
  public let senderEmail: String
}

//MARK:- Factory
public struct EmailFactory {
  public let senderEmail: String
  public func createEmail(to recipient: JobApplication) -> Email {
    let subject: String
    let messageBody: String
    switch recipient.status {
    case .new:
      subject = "We Received your application"
      messageBody =
      """
      Thank you for applying.
      """
    case .interview:
      subject = "We want to schedule an Interview"
      messageBody =
      """
      Please let us know the time that works best for you.
      """
    case .hired:
      subject = "Congratulations"
      messageBody =
      """
      You are hired. Welcome to the team.
      """
    case .rejected:
      subject = "Thank you for your interest"
      messageBody =
      """
      Sorry but the position has been filled.
      """
    }
    
    return Email(subject: subject, messageBody: messageBody, recipientEmail: recipient.email, senderEmail: self.senderEmail)
  }
}


//MARK:- Example
var jacksonJobApplication = JobApplication(name: "Jackson Smith", email: "jackson.smith@example.com", status: .new)

let emailFactory = EmailFactory(senderEmail: "jobs@paypal.com")
print(emailFactory.createEmail(to: jacksonJobApplication), "\n")

jacksonJobApplication.status = .interview
print(emailFactory.createEmail(to: jacksonJobApplication), "\n")

jacksonJobApplication.status = .hired
print(emailFactory.createEmail(to: jacksonJobApplication), "\n")


