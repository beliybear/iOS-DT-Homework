//
//  SignUpViewController.swift
//  Navigation
//
//  Created by Beliy.Bear on 21.05.2023.
//

import UIKit
import FirebaseAuth
import SnapKit

class SignupViewController: UIViewController {

    var signUpDelegate: LoginDelegateProtocol?

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.spacing = 3
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        return stackView
    }()

    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Confirm password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(patternImage: UIImage (named: "blue_pixel")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        view.addSubview(createAccountButton)
        setupButton()
        setupConstraints()
        addTargets()
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }

        loginTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
    }

    private func setupButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pushCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func addTargets() {
        createAccountButton.addTarget(self, action: #selector(pushCreateAccountButton), for: .touchUpInside)
    }

    @objc
    private func pushCancelButton() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc
    private func pushCreateAccountButton() {
        singUp()
    }

    private func singUp() {
        let email = loginTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text

        signUpDelegate?.signUp(email: email, password: password, passwordConfirmation: confirmPassword, completion: { data, error in
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
                    return
                case .signUp:
                    self.navigationController?.popToRootViewController(animated: true)
                default:
                    return
                }
            }
        })
    }
}