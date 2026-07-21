import Foundation

extension Date {
    var dateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YY HH:mm"  
        return formatter.string(from: self)
    }
}
