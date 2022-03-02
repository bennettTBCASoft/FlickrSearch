import Foundation

/*
 A struct which wraps up a search term and the results found for that search.
 
 */


struct FlickrSearchResults {
  let searchTerm: String  //搜索詞
  let searchResults: [FlickrPhoto]  // 搜索找到的結果
}
