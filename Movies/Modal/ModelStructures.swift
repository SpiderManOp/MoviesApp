import Foundation
enum TMDBListCategorization {
    case NowPlayingList
    case PopularityList
    case TopRatedList
    case Searching
}
struct SearchHere{
    public var queryString: String!
    public var myfinalstring: String!
    mutating func searchMoviesWith(query:String)
    {
        let cleanQuery = self.cleanQueryString(query)
        setQueryString(cleanQuery)
    }
    func cleanQueryString(_ queryString: String) -> String {
        let clean = queryString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let _clean = clean {
            return _clean
        } else {
            let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
            return queryString.filter {okayChars.contains($0) }

        }
    }
    mutating func setQueryString(_ qs:String){
        let myqueryString = qs
        self.myfinalstring=myqueryString
    }
}
struct APIStrings {
    let searchStruct2=SearchHere()
    
    let nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=12745d743049d4328bbee5774aa809c0"
    let popularURL = "https://api.themoviedb.org/3/movie/popular?api_key=12745d743049d4328bbee5774aa809c0"
    let topRatedURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=12745d743049d4328bbee5774aa809c0"
    
    //Problem Here
    mutating func getfinalquery() -> String {
        let simplequery=searchStruct2.myfinalstring
        print("myfinalstring= \(String(describing: simplequery))")
        //Here I am getting myfinalstring as nil and search result is printed for default m
        guard let finalquery = simplequery else {return "m"}
        return finalquery
        }
    //
    mutating func getsearchUrl() -> String {
        let LastFinalQuery=getfinalquery()
        let finalSearchURL="https://api.themoviedb.org/3/search/movie?api_key=12745d743049d4328bbee5774aa809c0&query=\(LastFinalQuery)"
        return finalSearchURL
        }
}
struct MovieResultElement : Decodable {
    static private let basePosterURLString = "https://image.tmdb.org/t/p/w500"
    var voteCount : Int
    var identification : Int
    var video : Bool
    var voteAverage : Float
    var title : String
    var popularity : Float
    var posterPath : String
    var originalLanguage : String
    var originalTitle : String
    var genreIds : [Int]
    var backdropPath : String
    var adult : Bool
    var overview : String
    var releaseDate : String
    private enum CodingKeys: String, CodingKey {
        case video, title, popularity, adult, overview
        case voteCount = "vote_count"
        case identification = "id"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
    func getPosterImageURL() -> URL? {
        let posterURLString = MovieResultElement.basePosterURLString + posterPath
        return URL(string: posterURLString)
    }
    func getThumbnailImageURL() -> URL? {
        let ThumbnailURLString = MovieResultElement.basePosterURLString + backdropPath
        return URL(string: ThumbnailURLString)
    }
}
struct MovieList : Decodable {
    var totalResult : Int
    var totalPages : Int
    var results : [MovieResultElement]
    var page : Int
    private enum CodingKeys: String, CodingKey {
        case totalResult = "total_results"
        case totalPages = "total_pages"
        case results
        case page
    }
}
