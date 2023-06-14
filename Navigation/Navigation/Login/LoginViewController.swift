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
        login.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        login.backgroundColor = .systemGray6
        login.textAlignment = .left
        login.placeholder = NSLocalizedString("  Email or Phone", comment: "")
        login.text = "beliybear@mail.ru"
        login.tintColor = UIColor(named: "MyColor")
        login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        login.autocapitalizationType = .none
        login.clearButtonMode = .whileEditing
        login.keyboardType = .emailAddress
        login.delegate = self
        login.translatesAutoresizingMaskIntoConstraints = false
        return login
    }()
    
    lazy var password: UITextField = {
        let password = UITextField()
        password.tag = 1
        password.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        password.backgroundColor = .systemGray6
        password.textAlignment = .left
        password.placeholder = NSLocalizedString("  Password", comment: "")
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
        button.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.createColor(lightMode: .white, darkMode: .black), for: .normal)
        button.backgroundColor = UIColor(patternImage: UIImage (named: "blue_pixel")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(touchSignUpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let loginButton = UIButton()
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle(NSLocalizedString("Log In", comment: ""), for: .normal)
        loginButton.setTitleColor(UIColor.createColor(lightMode: .white, darkMode: .black), for: .normal)
        loginButton.backgroundColor = UIColor(patternImage: UIImage (named: "blue_pixel")!)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(touchLoginButton), for: .touchUpInside)
        return loginButton
    }()
    
    private let alert = UIAlertController(title: NSLocalizedString("Wrong login or password", comment: ""), message: "",  preferredStyle: .alert)
    var passwordForLogin: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        setupGestures()
        addSubview()
        setupConstraints()
        setupAlert()
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
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(stackView)
        scrollView.addSubview(logInButton)
        scrollView.addSubview(signUpButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            logoImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 120),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logInButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 8),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
        let alert = UIAlertController(title: NSLocalizedString("Unknown login or password", comment: ""), message: NSLocalizedString("Please, enter correct user login and password", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        forcedHidingKeyboard()
        return true
    }
    
    func goLogin() {
        let email = login.text
        let password = password.text
        logInDelegate?.logIn(logIn: email, password: password, completion: { data, error  in
            if error != nil {
                switch error {
                case .emptyPasswordOrEmail:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.emptyPasswordOrEmail.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .invalidPassword:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.invalidPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .weakPassword:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.weakPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .mismatchPassword:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.mismatchPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .notFound:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.notFound.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .emailAlreadyInUse:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.emailAlreadyInUse.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .invalidEmail:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.invalidEmail.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .unexpected:
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: Authorization.unexpected.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
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
