//
//  LoginViewController.swift
//  Navigation
//
//  Created by Beliy.Bear on 30.12.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    let coordinator: ProfileCoordinator
    var logInDelegate: LoginDelegateProtocol?
    
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
        login.text = "beliybear@mail.ru"
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
        password.text = "123456"
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
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(patternImage: UIImage (named: "blue_pixel")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(touchSignUpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var logInButton: UIButton = {
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
    var passwordForLogin: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        setupGestures()
        addSubview()
        setupConstraints()
        setupAlert()
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
        scrollView.addSubview(logInButton)
        scrollView.addSubview(signUpButton)
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
            
            logInButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 3),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            pickUpButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
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
            
            let loginButtonBottomPointY = logInButton.frame.origin.y + logInButton.frame.height
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
        goLogin()
    }
    
    @objc func touchSignUpButton() {
        let VC = SignupViewController()
        VC.signUpDelegate = MyLoginFactory().makeCheckerService()
        navigationController?.pushViewController(VC, animated: true)
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
    
    func goLogin() {
        let email = login.text
        let password = password.text
        logInDelegate?.logIn(logIn: email, password: password, completion: { data, error  in
            if error != nil {
                switch error {
                case .emptyPasswordOrEmail:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.emptyPasswordOrEmail.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .invalidPassword:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.invalidPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .weakPassword:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.weakPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .mismatchPassword:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.mismatchPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .notFound:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.notFound.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .emailAlreadyInUse:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.emailAlreadyInUse.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .invalidEmail:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.invalidEmail.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .unexpected:
                    let alert = UIAlertController(title: "Ошибка", message: Authorization.unexpected.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                default:
                    return
                }
            } else {
                switch data {
                case .logIn:
                    self.coordinator.startView(user: User(login: "beliybear@mail.ru", name: "BeliyBear", avatar: UIImage(named: "avatarImage")!, status: "Something..."))
                case .signUp:
                    self.navigationController?.popToRootViewController(animated: true)
                default:
                    return
                }
            }
        })
    }
    
    
}
