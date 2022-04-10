import UIKit

class WordWidget: UIView {

    private let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        return label
    }()

    var title: String = "test" {
        didSet {
            wordLabel.text = title
        }
    }

    var size: CGSize {
        get {
            frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var origin: CGPoint {
        get {
            frame.origin
        }
        
        set {
            frame.origin = newValue
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupWidget()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }

    func setupWidget() {
        addSubview(wordLabel)
        NSLayoutConstraint.activate([
            wordLabel.widthAnchor.constraint(equalTo: widthAnchor),
            wordLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    enum Constants {
        static fileprivate let widthMultiplier = 0.3
        static fileprivate let heightMultiplier = widthMultiplier * 0.1
    }
}
