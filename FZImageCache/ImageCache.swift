/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The Image cache.
*/
import UIKit
import Foundation

@objc final public class ImageCache: NSObject {
    
    @objc public static let publicCache = ImageCache()
    private override init() {
        super.init()
    }
    @objc public var placeholderImage = UIImage(systemName: "photo.fill.on.rectangle.fill")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(AnyHashable, UIImage?) -> Swift.Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    /// - Tag: cache
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    @objc public final func load(url: NSURL, itemIdentifier: AnyHashable, completion: @escaping (AnyHashable, UIImage?) -> Swift.Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(itemIdentifier, cachedImage)
            }
            return
        }
        // In case there are more than one requestor for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        // Go fetch the image.
        ImageURLProtocol.urlSession().dataTask(with: url as URL) { (data, response, error) in
            // Check for the error, then data and try to create the image.
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(itemIdentifier, nil)
                }
                return
            }
            // Cache the image.
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            // Iterate over each requestor for the image and pass it back.
            for block in blocks {
                DispatchQueue.main.async {
                    block(itemIdentifier, image)
                }
                return
            }
        }.resume()
    }
        
}
