import Foundation

/**
 Create a model that will represent the feed item from the data.json file.
 */

class FeedItem: NSObject {
    /**
     title
     */
    var title: String?
    /**
     description
     */
    var descriptionString: String?
    /**
     image_url
     */
    var imageUrl: String?
    /**
     detail
     */
    var detail: String?
}
