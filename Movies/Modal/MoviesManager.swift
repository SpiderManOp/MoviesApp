import Foundation
import UIKit
class MoviesManager: NSObject {
    var dataURLString : String = ""
    var apiStrings = APIStrings()
    let searchStruct1=SearchHere()
    var totalElements : [MovieResultElement] = Array() {
        didSet {
        }}
    func numberOfListSections() -> Int {
        var sections = 0
        if totalElements.count > 0 {
            sections = 1
        }
        return sections
    }
    func amountOfElementsInList() -> Int {
        print("TotalElements.count \(totalElements.count)")
        return totalElements.count
    }
    func getElementForList(atIndex index : Int) -> MovieResultElement {
        return totalElements[index]
    }
    func downloadImage(at url: URL, from elementIndex: Int, withCompletion closure: @escaping (UIImage?, Int) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                //print("Error downloading image.")
                closure(nil, elementIndex)
            } else {
                if let imgData = data {
                    closure(UIImage(data: imgData), elementIndex)
                }
            }
        }
        task.resume()
    }
    func getJSONData(forListType type: TMDBListCategorization, callingClosure closure: @escaping () -> Void) {
    
        switch type {
        case .NowPlayingList:
            dataURLString = apiStrings.nowPlayingURL
        case .PopularityList:
            dataURLString = apiStrings.popularURL
        case .TopRatedList:
            dataURLString = apiStrings.topRatedURL
        case .Searching:
            print("Searching= \(String(describing: dataURLString))")
            dataURLString = apiStrings.getsearchUrl()
        }
        getRemoteJSONData(thenCall: closure)
    }
    private func getRemoteJSONData(thenCall closure : @escaping () -> Void) {
        if let url = URL(string: dataURLString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                   // print("Error obtaining JSON data.")
                } else {
                    if let jsonData = data {
                        //print("json data: \(jsonData)")
                        self.parseJSON(data: jsonData)
                        closure()
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(data: Data) {
        do {
            let decoder = JSONDecoder()
            let decodedList : MovieList = try decoder.decode(MovieList.self, from: data)
            self.totalElements = decodedList.results
        } catch let error {
            print("\(error)")
        }
    }
}
