import Foundation

struct AppEnvironment {
    var environmentName: String {
        guard let dictionary = Bundle.main.infoDictionary,
              let name = dictionary["CFBundleDisplayName"] as? String else {
            fatalError("Required value for Bundle Display Name is not defined.")
        }
        return name

    }
    var apiURL: String {
        guard let dictionary = Bundle.main.infoDictionary,
              let hostname = dictionary["AppAPIHostname"] as? String else {
            fatalError("Required value for API URL is not defined.")
        }
        return "https://\(hostname)"
    }

    init() {
        print("API URL: \(apiURL)")
    }
}
