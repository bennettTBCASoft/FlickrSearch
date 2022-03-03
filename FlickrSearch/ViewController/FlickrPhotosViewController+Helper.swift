import UIKit

// MARK: - Private
extension FlickrPhotosViewController {
  func photo(for indexPath: IndexPath) -> FlickrPhoto {
    return searches[indexPath.section].searchResults[indexPath.row]
  }
  
  func removePhoto(at indexPath: IndexPath){
    searches[indexPath.section].searchResults.remove(at: indexPath.row)
  }
  
  func insertPhoto(_ flickrPhoto: FlickrPhoto, at indexPath: IndexPath) {
    searches[indexPath.section].searchResults.insert(flickrPhoto, at: indexPath.row)
  }
  
  func performLargeImageFetch (for indexPath: IndexPath, flickrphoto: FlickrPhoto, cell: FlickrPhotoCell) {
    cell.activityIndicator.startAnimating()
    
    flickrphoto.loadLargeImage { [weak self] result in
      cell.activityIndicator.stopAnimating()
      
      //Because you’re in a closure that captures self weakly, ensure the view controller still exists.
      guard let self = self else { return }
      
      switch result {
      case .success(let photo):
        if indexPath == self.largePhotoIndexPath {
          cell.imageView.image = photo.largeImage
        }
      case .failure :
        return
      }
      
    }
  }
  
  func updateSharePhotoCountLabel() {
    shareTextLabel.text = isSharing ? "\(selectedPhotos.count) photos selected" : ""
    
    shareTextLabel.textColor = themeColor
    UIView.animate(withDuration: 0.3) {
      self.shareTextLabel.sizeToFit()
    }
  }
  
}



