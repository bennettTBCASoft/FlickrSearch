import UIKit

enum FlickrConstants {
  static let reuseIdentifier = "FlickrCell"
  static let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  static let itemsPerRow: CGFloat = 3
}


class FlickrPhotosViewController: UICollectionViewController {
  var selectedPhotos: [FlickrPhoto] = []   // keeps track of all currently selected photos while in sharing mode.
  let shareTextLabel = UILabel()          // gives the user feedback about how many photos are currently selected.
  var isSharing = false {                   // used to track whether the view controller is in sharing mode.
    didSet {
      collectionView.allowsMultipleSelection = isSharing
      
      collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
      selectedPhotos.removeAll()
    
      guard let shareButton = navigationItem.rightBarButtonItems?.first else {
        return
      }
    
      guard isSharing else {
        navigationItem.setRightBarButton(shareButton, animated: true)
        updateSharePhotoCountLabel()
        return
      }
      
      if largePhotoIndexPath != nil {
        largePhotoIndexPath = nil
      }
      
      updateSharePhotoCountLabel()
      
      let sharingItem = UIBarButtonItem(customView: shareTextLabel)
      let items: [UIBarButtonItem] = [
        shareButton,
        sharingItem
      ]
      
      navigationItem.setRightBarButtonItems(items, animated: true)
    }
    
    
    
  }
  var searches: [FlickrSearchResults] = []  // serches 是一個數組，用來追蹤每一個搜尋
  let flickr = Flickr() // 是對搜尋的對象一個引用
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dragDelegate = self
    collectionView.dragInteractionEnabled = true
    collectionView.dropDelegate = self
  }
  
  @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
    guard !searches.isEmpty else {
      return
    }
    
    guard !selectedPhotos.isEmpty else {
      isSharing.toggle()
      return
    }
    guard isSharing else {
      return
    }
    
    let images: [UIImage] = selectedPhotos.compactMap { photo in
      guard let thumbnail = photo.thumbnail else {
        return nil
      }
      return thumbnail
    }
    
    guard !images.isEmpty else {
      return
    }
    
    let shareController = UIActivityViewController(activityItems: images, applicationActivities: nil)
    
    shareController.completionWithItemsHandler = { _, _, _, _ in
      self.isSharing = false
      self.selectedPhotos.removeAll()
      self.updateSharePhotoCountLabel()
    }
    
    shareController.popoverPresentationController?.barButtonItem = sender
    shareController.popoverPresentationController?.permittedArrowDirections = .any
    present(shareController, animated: true, completion: nil)
  }
  
  
  var largePhotoIndexPath: IndexPath? {
    didSet {
      var indexPaths:[IndexPath] = []
      
      if let largePhotoIndexPath = largePhotoIndexPath {
        indexPaths.append(largePhotoIndexPath)
      }
      
      if let oldValue = oldValue {
        indexPaths.append(oldValue)
      }
      
      collectionView.performBatchUpdates {
        self.collectionView.reloadItems(at: indexPaths)
      } completion: { _ in
        if let largePhotoIndexPath = self.largePhotoIndexPath {
          self.collectionView.scrollToItem(at: largePhotoIndexPath, at: .centeredVertically, animated: true)
        }
      }

    }
  }
}


