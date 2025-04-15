import XCTest
@testable import PumpIn

final class BuildConfigTests: XCTestCase {
    
    func testEnvironmentValues() {
        // Test base URL format
        XCTAssertFalse(BuildConfig.baseURL.isEmpty, "Base URL should not be empty")
        XCTAssertTrue(BuildConfig.baseURL.hasPrefix("https://"), "Base URL should start with https://")
        
        // Test environment
        XCTAssertFalse(BuildConfig.environment.isEmpty, "Environment should not be empty")
        
        // Test current environment
        let current = BuildConfig.Environment.current
        
        switch current {
        case .dev:
            XCTAssertEqual(BuildConfig.baseURL, "https://dev.api.pumpin.com")
            XCTAssertEqual(BuildConfig.environment, "DEV")
        case .test:
            XCTAssertEqual(BuildConfig.baseURL, "https://test.api.pumpin.com")
            XCTAssertEqual(BuildConfig.environment, "TEST")
        case .prod:
            XCTAssertEqual(BuildConfig.baseURL, "https://api.pumpin.com")
            XCTAssertEqual(BuildConfig.environment, "PROD")
        }
        
        // Print current configuration for debugging
        print("🔧 Current Configuration:")
        print("Environment: \(BuildConfig.environment)")
        print("Base URL: \(BuildConfig.baseURL)")
        print("Is Debug: \(BuildConfig.isDebug)")
    }
} 