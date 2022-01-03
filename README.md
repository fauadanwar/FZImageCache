# FZImageCache

FZImageCache returns the cached image if available, otherwise asynchronously loads and caches it.

## Method for image fetching

```swift
func load(url: NSURL, itemIdentifier: AnyHashable, completion: @escaping (AnyHashable, UIImage?) -> Swift.Void)
```


## Sample Example

```swift
let modelObject = // AnyHashable model Object
let imageUrl = URL(string: "path for URL")
modelObject.url = imageUrl
let imageView =  UIImageView(image: "Place Holder Image")
modelObject.imageView = imageView

ImageCache.publicCache.load(url: modelObject.url, itemIdentifier: modelObject) { (modelObject, image) in
    if let img = image
    {
        modelObject.imageView.image = img
    }
}
```
