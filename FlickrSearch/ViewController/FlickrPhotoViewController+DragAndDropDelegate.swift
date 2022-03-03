import UIKit

extension FlickrPhotosViewController: UICollectionViewDragDelegate {
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    
    // First, you fetch the thumbnail of the selected photo from the photo object.

    let flickrPhoto = photo(for: indexPath)
    guard let thumbnail = flickrPhoto.thumbnail else {
      return []
    }
      
    // Create an NSItemProvider object referencing the thumbnail. This is used by the drag system to indicate what item is being dragged.
    let item = NSItemProvider(object: thumbnail)
    
    // Then, create a UIDragItem that represents the selected item to be dragged.
    let dragItem = UIDragItem(itemProvider: item)
    
    
    return [dragItem]
  }
}

extension FlickrPhotosViewController: UICollectionViewDropDelegate {
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return true
  }
  
  // Making the Drop
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else {
      return
    }
    
    coordinator.items.forEach { dropItem in
      guard let sourceIndexPath = dropItem.sourceIndexPath else {
        return
      }
      
      collectionView.performBatchUpdates {
        
        let image = photo(for: sourceIndexPath)
        removePhoto(at: sourceIndexPath)
        insertPhoto(image, at: destinationIndexPath)
        collectionView.deleteItems(at: [sourceIndexPath])
        collectionView.insertItems(at: [destinationIndexPath])
      
      } completion: { _ in
      
        coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
      
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
  }
  
  
}
