import UIKit




class FlickrPhotosViewController: UICollectionViewController {

  private let reuseIdentifier = "FlickrCell"
  private let sectionInsents = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
  private var searches: [FlickrSearchResults] = []  // serches 是一個數組，用來追蹤每一個搜尋
  private let flickr = Flickr() // 是對搜尋的對象一個引用
  private let itemsPerRow: CGFloat = 3

}

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
    // 1
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
    
    // 2
    let flickrPhoto = photo(for: indexPath)
    cell.backgroundColor = .black
//    // 3
    cell.imageView.image = flickrPhoto.thumbnail

    return cell
  }
}

// MARK: - Collection View Flow Layout Delegate
extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
  // 1
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // 2
    // 換言之，這裡的間距就是sectionInsents.left(就是20)
    let paddingSpace = sectionInsents.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  // 3
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsents //Cell的EdgeInsets
  }
  
  // 4
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsents.left
  }
}



// MARK: - Private
private extension FlickrPhotosViewController {
  func photo(for indexPath: IndexPath) -> FlickrPhoto {
    return searches[indexPath.section].searchResults[indexPath.row]
  }
}


// MARK: - Text Field Delegate
extension FlickrPhotosViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard
      let text = textField.text,
      !text.isEmpty
    else { return true }
    
    // 1 After adding an activity view, you use the Flickr wrapper class to search Flickr asynchronously for photos that match the given search term. When the search completes, you call the completion block with the result set of FlickrPhoto objects and any errors.
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()
    
    flickr.searchFlickr(for: text) { searchResults in
      DispatchQueue.main.async {
        activityIndicator.removeFromSuperview()
        
        switch searchResults {
        case .failure(let error) :
          // 2 You log any errors to the console. Obviously, in a production app, you would want to show the user these errors.
          print("Error Searching: \(error)")
        case .success(let results):
          // 3 Then, you log the results and add them at the beginning of the searches array.
          print("""
          Found \(results.searchResults.count) \
          matching \(results.searchTerm)
          """)
          self.searches.insert(results, at: 0)  // 若成功找到data，插入到陣列第一個位置(index:0)
          print(self.searches)
          // 4 Finally, you refresh the UI to show the new data. You use reloadData(), which works as it does in a table view.
          self.collectionView?.reloadData()     // 刷新 CollectionView
        }
      }
    }
    textField.text = nil
    textField.resignFirstResponder()
    return true
  }
}
