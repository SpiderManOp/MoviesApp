import UIKit
class MovieDetailView : UIView {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var thumbnailimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.text = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        ratingLabel.text = nil
        thumbnailimg.image=nil
    }
}
