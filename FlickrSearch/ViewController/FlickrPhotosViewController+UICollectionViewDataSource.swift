import UIKit

// MARK: UICollectionViewDataSource
extension FlickrPhotosViewController {
  // 1
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return searches.count
  }
  
  // 2
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searches[section].searchResults.count
  }
  
  // 3
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrConstants.reuseIdentifier, for: indexPath) as? FlickrPhotoCell
    else {
      preconditionFailure("Invalid cell type")
    }
    
    let flickrPhoto = photo(for: indexPath)
    
    cell.activityIndicator.stopAnimating()
    
//    cell.backgroundColor = UIColor.white
    
    guard indexPath == largePhotoIndexPath else {
      cell.imageView.image = flickrPhoto.thumbnail
      return cell
    }
    
    cell.isSelected = true
    guard flickrPhoto.largeImage == nil else {
      cell.imageView.image = flickrPhoto.largeImage
      return cell
    }
    
    cell.imageView.image = flickrPhoto.thumbnail
    
    performLargeImageFetch(for: indexPath, flickrphoto: flickrPhoto, cell: cell)

    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    
    // If you weren’t using the flow layout, you wouldn’t get this behavior for free.
    case UICollectionView.elementKindSectionHeader:
      
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(FlickrPhotoHeaderView.self)", for: indexPath)
      
      guard let typedHeaderView = headerView as? FlickrPhotoHeaderView else { return headerView }
      let searchTerm = searches[indexPath.section].searchTerm
      typedHeaderView.titleLabel.text = searchTerm
      
      return typedHeaderView
      
    default:
      assert(false, "Invalid element")
    }
  }
  
}

