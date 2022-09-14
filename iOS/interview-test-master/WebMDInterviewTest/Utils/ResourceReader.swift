import Foundation

struct ResourceReader {
    
    enum ReaderError: Error {
        case resourceNotFound
    }
    
    public static func read<T:Codable>(resource: String, ofType type: String) throws -> T {
        guard let resourcePath = Bundle.main.path(forResource: resource, ofType: type) else {
            throw ReaderError.resourceNotFound
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: resourcePath), options: .mappedIfSafe)
        
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
    }
}
