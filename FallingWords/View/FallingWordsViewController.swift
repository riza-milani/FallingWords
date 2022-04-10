import UIKit

class FallingWordsViewController: UIViewController {

    private var propertyAnimator: UIViewPropertyAnimator?

    private let wordWidgetOne: WordWidget = {
        let widget = WordWidget()
        let screenSize = UIScreen.main.bounds.width
        let widgetWidth = 100.0
        widget.origin = CGPoint(x: (screenSize / 2.0) - (widgetWidth / 2.0), y: 100)
        widget.size = CGSize(width: widgetWidth, height: 100)
        widget.backgroundColor = UIColor(named: "bottomWord")
        return widget
    }()

    private let wordWidgetTwo: WordWidget = {
        let widget = WordWidget()
        widget.translatesAutoresizingMaskIntoConstraints = false
        widget.origin = CGPoint(x: 100, y: 100)
        widget.size = CGSize(width: 100, height: 100)
        widget.backgroundColor = UIColor(named: "bottomWord")
        return widget
    }()
    
    private let answerButtonCorrect: AnswerWidget = {
        let widget = AnswerWidget(answerType: .correct)
        widget.translatesAutoresizingMaskIntoConstraints = false
        return widget
    }()
    
    private let answerButtonIncorrect: AnswerWidget = {
        let widget = AnswerWidget(answerType: .incorrect)
        widget.translatesAutoresizingMaskIntoConstraints = false
        return widget
    }()

    
    private let scoreLabels: UILabel = {
       let label = UILabel()
        label.textColor = .blue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.backgroundColor = UIColor(named: "playButton")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var viewModel: FallingWordsViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let viewModel = viewModel {
            viewModel.loadWords()
        }
        setupView()
        showPlayWidgets()
        hideGameWidgets()
    }

    func setupView() {
        view.addSubview(answerButtonCorrect)
        NSLayoutConstraint.activate([
            answerButtonCorrect.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            answerButtonCorrect.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            answerButtonCorrect.heightAnchor.constraint(equalToConstant: 50),
            answerButtonCorrect.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16 - 8)
        ])
        answerButtonCorrect.delegate = self
        
        view.addSubview(answerButtonIncorrect)
        NSLayoutConstraint.activate([
            answerButtonIncorrect.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            answerButtonIncorrect.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            answerButtonIncorrect.heightAnchor.constraint(equalToConstant: 50),
            answerButtonIncorrect.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 16 - 8)
        ])
        answerButtonIncorrect.delegate = self

        view.addSubview(wordWidgetTwo)
        NSLayoutConstraint.activate([
            wordWidgetTwo.bottomAnchor.constraint(equalTo: answerButtonCorrect.topAnchor, constant: -32),
            wordWidgetTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordWidgetTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            wordWidgetTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            wordWidgetTwo.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4)
        ])

        view.addSubview(wordWidgetOne)

        view.addSubview(scoreLabels)
        NSLayoutConstraint.activate([
            scoreLabels.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            scoreLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])

        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    func showPlayWidgets() {
        playButton.isHidden = false
    }

    func hidePlayWidgets() {
        playButton.isHidden = true
    }

    func showGameWidgets() {
        wordWidgetOne.isHidden = false
        wordWidgetTwo.isHidden = false
        answerButtonCorrect.isHidden = false
        answerButtonIncorrect.isHidden = false
    }

    func hideGameWidgets() {
        wordWidgetOne.isHidden = true
        wordWidgetTwo.isHidden = true
        answerButtonCorrect.isHidden = true
        answerButtonIncorrect.isHidden = true
    }

    @objc
    func playButtonAction(button: UIButton) {
        viewModel?.resetScores()
        showGameWidgets()
        hidePlayWidgets()
        fall()
    }
}

extension FallingWordsViewController {
    func showReplay() {
        hideGameWidgets()
        showPlayWidgets()
        resetPlayerSelection()
    }

    func resetPlayerSelection() {
        answerButtonCorrect.isWidgetSelected = false
        answerButtonIncorrect.isWidgetSelected = false
        viewModel?.playerAnswer = .none
    }
    func fall() {

        viewModel?.generateRandomWords { [weak self] words in
            self?.wordWidgetOne.title = words.0
            self?.wordWidgetTwo.title = words.1
        }
        viewModel?.showScores()
        propertyAnimator = UIViewPropertyAnimator(duration: 4, curve: .linear)
        propertyAnimator?.addAnimations({ [weak self] in
            guard let self = self else {
                return
            }

            let screenSize = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let widgetWidth = 100.0
            self.wordWidgetOne.origin = CGPoint(x: (screenSize / 2.0) - (widgetWidth / 2.0), y: screenHeight - 100 - 16 - 100)
        }, delayFactor: 2)
        propertyAnimator?.addCompletion {[weak self] _ in
            guard let self = self else {
                return
            }
            self.viewModel?.checkAnswer()
            self.resetPlayerSelection()
            let screenSize = UIScreen.main.bounds.width
            let widgetWidth = 100.0
            self.wordWidgetOne.origin = CGPoint(x: (screenSize / 2.0) - (widgetWidth / 2.0), y: 100)
            if self.viewModel?.shouldGenerate ?? false {
                self.fall()
                return
            }
            self.showReplay()
        }
        propertyAnimator?.startAnimation()
    }
}

extension FallingWordsViewController: AnswerWidgetDelegate {
    func toggle(sender: AnswerWidget) {
        answerButtonCorrect.isWidgetSelected = false
        answerButtonIncorrect.isWidgetSelected = false
        sender.isWidgetSelected = true
        viewModel?.playerAnswer = sender.answerType
    }
}

extension FallingWordsViewController: ViewInput {
    func showScore(score: Score) {
        scoreLabels.text = "SCORE BOARD\n\n🤩: \(score.correct) ✅\n😥: \(score.incorrect) ❌\n🤔: \(score.none) 💭"
    }
}
