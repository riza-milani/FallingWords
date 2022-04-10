import UIKit


protocol AnswerWidgetDelegate {
    func toggle(sender: AnswerWidget)
}

class AnswerWidget: UIView {

    let answerType: AnswerType
    let button: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var delegate: AnswerWidgetDelegate?
    var isWidgetSelected: Bool = false {
        didSet {
            if isWidgetSelected {
                layer.borderWidth = 4
                layer.borderColor = UIColor.green.cgColor
            } else {
                layer.borderWidth = 0
                layer.borderColor = UIColor.green.cgColor
            }
        }
    }

    required init?(coder: NSCoder) {
        answerType = .none
        super.init(coder: coder)
    }

    init(answerType: AnswerType) {
        self.answerType = answerType
        super.init(frame: CGRect())
        setupView()
    }

    override func layoutSubviews() {
        switch(answerType) {
        case .correct:
            button.backgroundColor = Constants.correctColor
            button.layer.cornerRadius = 8
            layer.cornerRadius = 8
        case .incorrect:
            button.backgroundColor = Constants.incorrectColor
            button.layer.cornerRadius = 8
            layer.cornerRadius = 8
        case .none:
            button.backgroundColor = .gray
            button.layer.cornerRadius = 8
            layer.cornerRadius = 8
        }
    }
    func setupView() {
        addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: widthAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        switch (answerType) {
        case .correct:
            button.setTitle(Constants.correct, for: .normal)
        case .incorrect:
            button.setTitle(Constants.incorrect, for: .normal)
        case .none:
            button.setTitle(Constants.none, for: .normal)
        }
        
    }
    
    enum Constants {
        static fileprivate let correct = "Correct"
        static fileprivate let incorrect = "Incorrect"
        static fileprivate let none = "None"
        static fileprivate let selectedColor = UIColor(red: 0.78, green: 0.94, blue: 0.94, alpha: 1.00)
        static fileprivate let correctColor = UIColor(red: 0.39, green: 0.55, blue: 0.55, alpha: 1.00)
        static fileprivate let incorrectColor = UIColor(red: 0.59, green: 0.55, blue: 0.55, alpha: 1.00)
    }

    @objc
    func buttonAction(_ button: UIButton) {
        delegate?.toggle(sender: self)
    }
}
