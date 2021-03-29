import UIKit
class MovieListViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating{
    var dataManager = MoviesManager()
    var ApistringsStruct = APIStrings()
    var SearchStruct = SearchHere()
    let searchController=UISearchController()
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var detailView: MovieDetailView!
    @IBOutlet weak var listTypeSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies App"
        detailView.frame = view.frame
        listTableView.delegate = self
        listTableView.dataSource = self
        initSearchController()
    }
    @IBAction func detailButtonPressed(_ sender: Any) {
        detailView.isHidden=false
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        detailView.isHidden=true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segementSelected(listTypeSegmentedControl)
    }
    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater=self
        searchController.obscuresBackgroundDuringPresentation=false
        searchController.searchBar.enablesReturnKeyAutomatically=false
        searchController.searchBar.returnKeyType=UIReturnKeyType.done
        definesPresentationContext=true
        navigationItem.searchController=searchController
        navigationItem.hidesSearchBarWhenScrolling=false
        searchController.searchBar.delegate=self
    }
    func updateSearchResults(for searchController: UISearchController) {
        detailView.isHidden=true
        if let search = searchController.searchBar.text {
            print("User Typed in search = \(search)")
            self.SearchStruct.searchMoviesWith(query: search)
            let dataUpdateClosure1 = { DispatchQueue.main.async {
            self.listTableView.reloadData()
            }
            }
            print("Searching Movies with Typed Query = \(search)")
            dataManager.getJSONData(forListType: .Searching, callingClosure: dataUpdateClosure1)
            }
    }
    @IBAction func segementSelected(_ sender: UISegmentedControl) {
        let dataUpdateClosure = { DispatchQueue.main.async {
            self.listTableView.reloadData()
            }
        }
        switch sender.selectedSegmentIndex {
        case 0:
            dataManager.getJSONData(forListType: .NowPlayingList, callingClosure: dataUpdateClosure)
        case 1:
            dataManager.getJSONData(forListType: .PopularityList, callingClosure: dataUpdateClosure)
        case 2:
            dataManager.getJSONData(forListType: .TopRatedList, callingClosure: dataUpdateClosure)
        default:
            print("Lets try again in segement control")
        }
    }
}
extension MovieListViewController: UITableViewDelegate {
}
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.totalElements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:MovieListCell.reuseIdentifier) as? MovieListCell else {
            fatalError("The dequeued cell is not an instance of MovieListCell.")
        }
        var movieElement = dataManager.getElementForList(atIndex: indexPath.row)
        if(searchController.isActive){
        }else{
            movieElement = dataManager.getElementForList(atIndex: indexPath.row)
        }
        if let imageURLc = movieElement.getPosterImageURL() {
            dataManager.downloadImage(at: imageURLc, from: indexPath.row) { (downloadedImage : UIImage?, relatedIndex : Int) in
                if relatedIndex == indexPath.row {
                    DispatchQueue.main.async {
                        cell.poster.image=downloadedImage
                    }
                }
            }
        }
        cell.movieTitleLabel.text = movieElement.title
        cell.informationButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}
extension MovieListViewController: MovieCellButtonDelegate {
    func informationButtonDidGetSelected(at row: Int) {
           let selectedMovieElement = dataManager.getElementForList(atIndex: row)
           detailView.titleLabel.text = selectedMovieElement.title
           detailView.descriptionTextView.text = selectedMovieElement.overview
           detailView.releaseDateLabel.text=selectedMovieElement.releaseDate
           detailView.ratingLabel.text=String(format: "%.1f", selectedMovieElement.voteAverage)
        if let imageURLa = selectedMovieElement.getThumbnailImageURL() {
            dataManager.downloadImage(at: imageURLa, from: row) { (downloadedImage : UIImage?, relatedIndex : Int) in
                if relatedIndex == row {
                    DispatchQueue.main.async {
                        self.detailView.thumbnailimg.image = downloadedImage
                    }
                }
            }
        }
    }
}

