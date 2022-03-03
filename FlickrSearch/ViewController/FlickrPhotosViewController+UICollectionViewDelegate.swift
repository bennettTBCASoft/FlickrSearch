import UIKit

extension FlickrPhotosViewController{
  override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    
    // if the app is in sharing mode, you want the method to do nothing.
    guard !isSharing else {
      return true
    }
    
    if largePhotoIndexPath == indexPath {
      largePhotoIndexPath = nil
    } else {
      largePhotoIndexPath = indexPath
    }
    return false
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard isSharing else {
      return
    }
    
    let flickrPhoto = photo(for: indexPath)
    selectedPhotos.append(flickrPhoto)
    updateSharePhotoCountLabel()
  }
  
  override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard isSharing else {
      return
    }
    
    let flickrPhoto = photo(for: indexPath)
    // 返回 flickrPhoto 所在位置索引
    if let index = selectedPhotos.firstIndex(of: flickrPhoto) {
      selectedPhotos.remove(at: index)
      updateSharePhotoCountLabel()
    }
  }
}

