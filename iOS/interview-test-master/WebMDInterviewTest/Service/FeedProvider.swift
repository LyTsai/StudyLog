import Foundation

struct FeedProvider {
    
    /**
     1. Create a function that will use the ResourceReader to read the data.json file and map the data to the corresponding models.
     2. Any feed items with the same title are considered duplicates and should be removed.
     3. Sort the FeedItem objects in alphabetical order by title.
     4. Make sure not to block the main thread when this task is performed.
     Note that this function should be used by FeedViewController to get the array of filtered and sorted FeedItem objects.
     */
    
    public static func getFeedResponse(_ completion: ((FeedResponse?, String?) -> Void)?) {
        DispatchQueue.global().async {
            do {
                let feedResponse: FeedResponse = try ResourceReader.read(resource: "data", ofType: "json")
                // filter and sort
                var items = [String: FeedItem]()
                for item in feedResponse.items {
                    items[item.title ?? ""] = item
                }
                feedResponse.items = items.values.sorted(by: {$0.title ?? "" < $1.title ?? ""})
                // sort
//                feedResponse.items.sort(by: {$0.title ?? "" < $1.title ?? ""})
                
                // finish
                DispatchQueue.main.async {
                    completion?(feedResponse, "Success")
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(nil, "Failed to Parse: \(error.localizedDescription)")
                }
            }
        }
    }
}
