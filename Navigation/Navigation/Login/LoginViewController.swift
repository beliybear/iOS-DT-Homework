//
//  LoginViewController.swift
//  Navigation
//
//  Created by Beliy.Bear on 30.12.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage (named: "logo")
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 10
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.spacing = 0.5
        stackView.backgroundColor = .lightGray
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var login: UITextField = {
        let login = UITextField()
        login.tag = 0
        login.textColor = .black
        login.backgroundColor = .systemGray6
        login.textAlignment = .left
        login.placeholder = "  Email or phone"
        login.tintColor =  UIColor (named: "MyColor")
        login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        login.autocapitalizationType = .none
        login.clearButtonMode = .whileEditing
        login.delegate = self
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    lazy var password: UITextField = {
        let password = UITextField()
        password.tag = 1
        password.textColor = .black
        password.backgroundColor = .systemGray6
        password.textAlignment = .left
        password.placeholder = "  Password"
        password.tintColor = UIColor (named: "MyColor")
        password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.clearButtonMode = .whileEditing
        password.delegate = self
        password.rightViewMode = UITextField.ViewMode.always
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    private lazy var button: UIButton = {
        let loginButton = UIButton()
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor(patternImage: UIImage (named: "blue_pixel")!)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
        return loginButton
    }()
    
    private lazy var pickUpButton = CustomButton(title: "Подобрать пароль", cornerRadius: 10, titleColor: .white, color: .black)

     private lazy var activityIndicator: UIActivityIndicatorView = {
         let indicator = UIActivityIndicatorView()
         indicator.translatesAutoresizingMaskIntoConstraints = false
         return indicator
     }()
    
    private let alert = UIAlertController(title: "Неверный логин или пароль", message: "",  preferredStyle: .alert)
    var loginDelegate: LoginViewControllerDelegate?
    private var userService: UserService?
    var passwordForLogin: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        setupGestures()
        addSubview()
        setupConstraints()
        setupAlert()
#if DEBUG
        userService = TestUserService(user: User(login: "0001", name: "User Name", avatar: UIImage(named: "a") ?? .add, status: "testing account"))
#else
        userService = CurrentUserService(user: User(login: "0000", name: "BeliyBear", avatar: UIImage(named: "avatarImage") ?? .add, status: "waiting for something"))
#endif
        pickUpButton.addTarget(self, action: #selector(touchPickUpButton), for: .touchUpInside)
    }
    
    @objc private func touchPickUpButton() {
        
        let queue = DispatchQueue.global(qos: .userInteractive)
                    let group = DispatchGroup()

                    group.enter()
                    self.activityIndicator.startAnimating()
                    queue.async {
                        self.bruteForce(passwordToUnlock: self.randomPassword(length: 4))
                        group.leave()
                    }
                    group.notify(queue: .main){ [self] in
                        self.password.isSecureTextEntry = false
                        self.password.text = self.passwordForLogin
                        self.activityIndicator.stopAnimating()

                    }
        
    }
        
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func addSubview() {
        stackView.addArrangedSubview(login)
        stackView.addArrangedSubview(password)
        stackView.addArrangedSubview(activityIndicator)
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(stackView)
        scrollView.addSubview(button)
        scrollView.addSubview(pickUpButton)
    }
    
    func setupConstraints() {
        pickUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.heightAnchor.constraint(equalToConstant: 100),
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pickUpButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 3),
            pickUpButton.heightAnchor.constraint(equalToConstant: 50),
            pickUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pickUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupAlert() {
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            print("OK")
        }))
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottomPointY =  button.frame.origin.y + button.frame.height
            let keyboardOriginY = view.frame.height - keyboardHeight
            
            let yOffset = keyboardOriginY < loginButtonBottomPointY
            ? loginButtonBottomPointY - keyboardOriginY + 16
            : 0
            scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        view.endEditing(true)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func touchLoginButton() {
        guard let login = self.login.text, let password = self.password.text else { return }
        if let delegate = self.loginDelegate, delegate.check(login, password) {
            if let user = userService?.authorization(login) {
                print("User found: \(user.name)") // Debug print
                self.coordinator.startView(user: user)
            } else {
                showAlert()
            }
        } else {
            showAlert()
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: "Unknown login or password", message: "Please, enter correct user login and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

extension String {
var digits:      String { return "0123456789" }
var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
var letters:     String { return lowercase + uppercase }
var printable:   String { return digits + letters }



mutating func replace(at index: Int, with character: Character) {
    var stringArray = Array(self)
    stringArray[index] = character
    self = String(stringArray)
}
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        forcedHidingKeyboard()
        return true
    }
    
    func bruteForce(passwordToUnlock: String) {
            
            let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

            

            // Will strangely ends at 0000 instead of ~~~
            while passwordForLogin != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
                passwordForLogin = generateBruteForce(passwordForLogin, fromArray: ALLOWED_CHARACTERS)
            }
            print(passwordForLogin)
        }

        func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
        }

        func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
        }

        func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
        }
        
        func randomPassword(length: Int) -> String {
            let letters = String().printable
            return String((0..<length).map{ _ in letters.randomElement()! })
        }

    
}
