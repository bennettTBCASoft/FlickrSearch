import UIKit

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

