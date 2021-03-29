import UIKit
protocol MovieCellButtonDelegate {
    func informationButtonDidGetSelected(at row : Int)
}
class MovieListCell: UITableViewCell {
    var delegate : MovieCellButtonDelegate? = nil
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var poster: UIImageView!
    static let reuseIdentifier = "movieListCell"
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func informationButtonAction(_ sender: UIButton) {
        self.delegate?.informationButtonDidGetSelected(at: sender.tag)
    }
}
