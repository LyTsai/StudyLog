import UIKit

class FeedViewController: UIViewController {
    
    /**
     1. Load the feed items using the FeedProvider.
     2. Display the feed items using a table view (following best practices for design). Each feed item should be contain the followings:
        a. An image loaded from the FeedItem imageUrl param (you can use the Foundation framework or any open source technology to load the image).
        b. If the imageUrl param is nil, you should only show the FeedItem's title and description.
        c. The FeedItem's title param below the image. This text should be a bit larger and bold.
        d. The FeedItem's description param below the title. This text should be a standard, but readable text size.
     3. Each feed item, when tapped, should push a new controller (you must create this new controller) that displays the corresponding FeedItem's parameters:
        a. The FeedItem's title param should be used as navigation bar title.
        b. At the top of the page, an image loaded from the FeedItem imageUrl param. (You can use the Foundation framework or any open source technology to load the image.)
        c. If the imageUrl param is nil, you should only show the FeedItem's title, description and details.
        d. The FeedItem's description parameter below the image. This text should be a standard, but readable text size.
        e. The FeedItem's detail parameter below the description. This text should be a standard, but readable text size.
            
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let responseData = FeedProvider.getFeedResponse()
        print("hello")
        
    }
}

