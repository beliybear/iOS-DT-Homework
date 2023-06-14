import UIKit

class FeedViewController: UIViewController {
    let coordinator: FeedCoordinator
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private weak var delegate: FeedViewDelegate?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var buttonFirst = CustomButton(title: "View Info",
                                           cornerRadius: 5,
                                           titleColor: .white,
                                                color: .systemBlue)

    private lazy var buttonSecond = CustomButton(title: "View Post",
                                           cornerRadius: 5,
                                           titleColor: .white,
                                                 color: .systemBlue)

    private lazy var textField: UITextField = {
           let textField = UITextField()
           textField.backgroundColor = .white
           textField.textAlignment = .center
           textField.layer.borderWidth = 1
           textField.layer.borderColor = UIColor.black.cgColor
           textField.layer.cornerRadius = 12
           textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
           textField.textColor = .black
           textField.clearButtonMode = .whileEditing
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
       }()

       private lazy var label: UILabel = {
           let label = UILabel()
           label.layer.cornerRadius = 25
           label.backgroundColor = .systemGray
           label.clipsToBounds = true
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()

       private lazy var checkGuessButton = CustomButton(title: "Guess word",
                                                        cornerRadius: 10,
                                                        titleColor: .white,
                                                        color: .systemBlue)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Feed", comment: "")
        view.backgroundColor = .white
        setupConstraints()
        addTargets()
        checkWord()
    }

    private func addTargets(){
        buttonFirst.addTarget(self, action: #selector(pushToInfo), for: .touchUpInside)
        buttonSecond.addTarget(self, action: #selector(pushToPost), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(stackView)
        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(label)
        stackView.addArrangedSubview(buttonFirst)
        stackView.addArrangedSubview(buttonSecond)

        textField.translatesAutoresizingMaskIntoConstraints = false
        checkGuessButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 20),
                textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                textField.heightAnchor.constraint(equalToConstant: 50),

            checkGuessButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
                checkGuessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                checkGuessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                checkGuessButton.heightAnchor.constraint(equalToConstant: 50),

            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                label.widthAnchor.constraint(equalToConstant: 50),
                label.heightAnchor.constraint(equalToConstant: 50),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }

    private func checkWord() {
            checkGuessButton.target = { [self] in
                if textField.hasText {
                    let model = FeedModel().check(textField.text ?? "")
                    if model {
                        label.backgroundColor = .systemGreen
                        view.endEditing(true)
                    } else {
                        label.backgroundColor = .systemRed
                    }
                } else {
                    label.backgroundColor = .systemGray
                    print(NSLocalizedString("TextField is empty", comment: ""))
                }
            }
        }
    
    @objc private func pushToInfo(){
        navigationController?.pushViewController(InfoViewController(), animated: true)
    }
    
    @objc private func pushToPost(){
        navigationController?.pushViewController(PostViewController(), animated: true)
    }
}



