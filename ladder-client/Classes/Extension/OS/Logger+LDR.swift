import Foundation
import os

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "org.kenzan8000.ladder-client", category: "main")

// MARK: - Logger + LDR
extension Logger {
  func prefix(_ instance: Any, _ function: String) -> String {
    """
    
    
    **************************************************
    \(String(describing: type(of: instance)))#\(function)
    --------------------------------------------------
    
    """
  }
}
