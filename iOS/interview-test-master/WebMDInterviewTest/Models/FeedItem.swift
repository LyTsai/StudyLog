import Foundation

/**
 Create a model that will represent the feed item from the data.json file.
 */

class FeedItem: Codable {
    /**
     title
     */
    var title: String?
    /**
     description
     */
    var description: String?
    /**
     image_url
     */
    var imageUrl: String?
    /**
     detail
     */
    var detail: String?
}

extension FeedItem {
    enum CodingKeys: String, CodingKey {
        case title, description, detail
        case imageUrl = "image_url"
    }
}
