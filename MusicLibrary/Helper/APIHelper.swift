//
//  APIHelper.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 29/06/20.
//

import Foundation
class APIHelper {
    
    public static let shared = APIHelper()
    private init() {}
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://itunes.apple.com/search")
    private let jsonDecoder: JSONDecoder = JSONDecoder()
        
    public enum APIServiceError: Error, CustomStringConvertible {
        public var description: String{
            switch self {
            case .apiError          : return "api error"
            case .invalidEndpoint   : return "invalidEndpoint"
            case .invalidResponse   : return "invalidResponse"
            case .noData            : return "noData"
            case .decodeError       : return "decodeError"
            }
        }
        
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    public enum RequestType : String{
        case get    = "GET"
        case post   = "POST"
    }
    
    
    
    private func fetchResources<T: Decodable>(url: URL, method:RequestType,
                                              completion: @escaping (Result<T, APIServiceError>) -> Void)
    {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        urlSession.dataTask(with: request) { (result) in
            switch result {
                case .success(let (response, data)):
                    print("response \(response)")
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    do {
                        let values = try self.jsonDecoder.decode(T.self, from: data)
                        completion(.success(values))
                    } catch let error{
                        print("error \(error)")
                        completion(.failure(.decodeError))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.apiError))
                }
         }.resume()
    }
    
    func fetchMusic(from searchString:String, result: @escaping (Result<MusicLibraryObject,APIServiceError>)-> Void){
        if let url = baseURL{
            let queryItem = URLQueryItem(name: "term", value: "\(searchString)")
            var urlComps = URLComponents(string: url.absoluteString)!
            urlComps.queryItems = [queryItem]
            if let finalUrl = urlComps.url{
                fetchResources(url: finalUrl, method: .get, completion: result)
            }else{
                result(.failure(.invalidEndpoint))
            }
        }else{
            result(.failure(.invalidEndpoint))
            print("URL not found")
        }
    }

}
