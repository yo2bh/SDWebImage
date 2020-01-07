//
//  File.swift
//  
//
//  Created by Yogesh Bharate on 1/3/20.
//

import Foundation

public class NetworkManager {
  public static func sendRequest(urlPath: String, parameters: [String: Any]?, httpMethod: String? = "POST",  completionHandler: @escaping(_ response: Any?, _ error: Error?) -> Void) {
    
    let url = URL(string: urlPath)
    
    var request = URLRequest(url: url!)
    request.addValue(WalletConstants.applicationJSON, forHTTPHeaderField: WalletConstants.contentType)
    request.httpMethod = httpMethod
    do {
      if let parameter = parameters {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
      }
    } catch let error {
      completionHandler(nil, error)
    }
    
    URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
      do {
        if let data = data,
          let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
          print("JSON ---- > \(json)")
          completionHandler(json, nil)
        } else {
          completionHandler(nil, error)
        }
      } catch let error {
        completionHandler(nil, error)
      }
    }).resume()
  }
}
