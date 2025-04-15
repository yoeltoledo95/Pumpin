import Foundation

enum BuildConfig {
    enum Environment: String {
        case dev = "DEV"
        case test = "TEST"
        case prod = "PROD"
        
        static var current: Environment {
            #if DEV
                return .dev
            #elseif TEST
                return .test
            #elseif PROD
                return .prod
            #else
                return .dev // Default to dev environment
            #endif
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static var baseURL: String {
        guard let baseURLString = infoDictionary["BASE_URL"] as? String else {
            #if DEBUG
            print("⚠️ BASE_URL not set in environment")
            #endif
            return ""
        }
        return baseURLString
    }
    
    static var environment: String {
        guard let environment = infoDictionary["APP_ENVIRONMENT"] as? String else {
            #if DEBUG
            print("⚠️ APP_ENVIRONMENT not set in environment")
            #endif
            return ""
        }
        return environment
    }
    
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
} 