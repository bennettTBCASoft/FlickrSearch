import UIKit

/*
 Data about a photo retrieved from Flickr: its thumbnail, image and metadata information such as its ID.
 There are also some methods for building Flickr URLs and some size calculations.
 FlickrSearchResults contains an array of these objects.
 */

//MARK: - Data about a photo retrieved from Flickr
class FlickrPhoto: Equatable {
  var thumbnail: UIImage?   // 縮略圖
  var largeImage: UIImage?  // 圖像
  let photoID: String       // metadata information
  let farm: Int
  let server: String
  let secret: String

  init (photoID: String, farm: Int, server: String, secret: String) {
    self.photoID = photoID
    self.farm = farm
    self.server = server
    self.secret = secret
  }

//MARK: - Building Flickr URLs
  func flickrImageURL(_ size: String = "m") -> URL? {
    return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")
  }

  enum Error: Swift.Error {
    case invalidURL
    case noData
  }

  func loadLargeImage(_ completion: @escaping (Result<FlickrPhoto, Swift.Error>) -> Void) {
    guard let loadURL = flickrImageURL("b") else {
      DispatchQueue.main.async {
        completion(.failure(Error.invalidURL))
      }
      return
    }

    let loadRequest = URLRequest(url: loadURL)

    URLSession.shared.dataTask(with: loadRequest) { data, _, error in
      DispatchQueue.main.async {
        if let error = error {
          completion(.failure(error))
          return
        }

        guard let data = data else {
          completion(.failure(Error.noData))
          return
        }

        let returnedImage = UIImage(data: data)
        self.largeImage = returnedImage
        completion(.success(self))
      }
    }
    .resume()
  }

//MARK: - Some size calculations.
  func sizeToFillWidth(of size: CGSize) -> CGSize {
    guard let thumbnail = thumbnail else {
      return size
    }

    let imageSize = thumbnail.size
    var returnSize = size

    let aspectRatio = imageSize.width / imageSize.height

    returnSize.height = returnSize.width / aspectRatio

    if returnSize.height > size.height {
      returnSize.height = size.height
      returnSize.width = size.height * aspectRatio
    }

    return returnSize
  }

  static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
  }
}
