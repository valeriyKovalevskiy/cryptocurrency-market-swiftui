import Foundation
import os.log

extension URLSession.DataTaskPublisher {
    
    /// Log combine request
    func logRequest() -> Self {
        #if DEBUG
        let log = OSLog(
            subsystem: Bundle.main.bundleIdentifier!,
            category: "[Network]"
        )
        os_log("%@\n",
            log: log,
            request.cURLString()
        )
        #endif
        return self
    }
}

extension URLRequest {
    
    /// Converts URLRequest instance to cURL that we can paste into Postman
    fileprivate func cURLString(pretty: Bool = true) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        return "curl " + method + url + header + data
    }
}
