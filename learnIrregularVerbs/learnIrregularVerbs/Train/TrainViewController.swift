//
//  trainViewController.swift
//  learnIrregularVerbs
//
//  Created by User on 20.11.2023.
//

import UIKit
import SnapKit

final class TrainViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var pastSimpleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Simple"
        
        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Participle"
        
        return label
    }()
    
    private lazy var pastSimpleTextField: UITextField = {
        let field = UITextField()
        
        field.borderStyle = .roundedRect
        field.delegate = self
        
        return field
    }()
    
    private lazy var participleTextField: UITextField = {
        let field = UITextField()
        
        field.borderStyle = .roundedRect
        field.delegate = self
        
        return field
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray5
        button.setTitle("Check".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self,
                         action: #selector(checkAction),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var countCorrectAnswerLabel: UILabel = {
        let label = UILabel()
        label.text = "Count: 0".localized
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var countCurrentVerbLabel: UILabel = {
        let label = UILabel()
        label.text = "\(countCurrentVerb)/\(dataSource.count)"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray5
        button.setTitle("Skip".localized, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self,
                         action: #selector(skipAnswer),
                         for: .touchUpInside)
        
        
        return button
    }()
    
    // MARK: - Properties
    private let edgeInsets = 30
    private let dataSource = IrregularVerbs.shared.selectedVerbs
    private var currentVerb: Verb? {
        guard dataSource.count > count else { return nil }
        return dataSource[count]
    }
    private var countCorrectAnswer = 0 {
        didSet {
            countCorrectAnswerLabel.text = "Count: ".localized + String(countCorrectAnswer)
        }
    }
    private var countCurrentVerb = 1 {
        didSet {
            countCurrentVerbLabel.text = "\(countCurrentVerb)/\(dataSource.count)"
        }
    }
    private var count = 0 {
        didSet {
            infinitiveLabel.text = currentVerb?.infinitive
            pastSimpleTextField.text = ""
            participleTextField.text = ""
            checkButton.backgroundColor = .systemGray5
            countCurrentVerb += 1
            checkButton.setTitle("Check".localized, for: .normal)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Train Verbs".localized
        setupUI()
        hideKeyboardWhenTappedAround()
        
        infinitiveLabel.text = dataSource.first?.infinitive
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Private methods
    @objc private func skipAnswer() {
        pastSimpleTextField.text = currentVerb?.pastSimple
        participleTextField.text = currentVerb?.participle
        checkButton.isEnabled = false
        if currentVerb?.infinitive == dataSource.last?.infinitive {
            makeAlert()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.count += 1
                self?.checkButton.isEnabled = true
                self?.checkButton.setTitle("Check".localized, for: .normal)
                
            }
        }
    }
    
    @objc private func checkAction() {
        if checkAnswers() {
            let isSecondAttempt = checkButton.backgroundColor == .red
            if currentVerb?.infinitive == dataSource.last?.infinitive {
                countCorrectAnswer += isSecondAttempt ? 0 : 1
                makeAlert()
            } else {
                checkButton.backgroundColor = .green
                checkButton.setTitle("Ok".localized, for: .normal)
                countCorrectAnswer += isSecondAttempt ? 0 : 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.count += 1
                }
            }
        } else {
            checkButton.backgroundColor = .red
            checkButton.setTitle("Try again".localized, for: .normal)
        }
    }
    
    private func checkAnswers() -> Bool {
        pastSimpleTextField.text?.lowercased() == currentVerb?.pastSimple.lowercased() &&
        participleTextField.text?.lowercased() == currentVerb?.participle.lowercased()
        
    }
    
    private func makeAlert() {
        let stringForAlert = "Message_for_allert:".localized + "%d"
        let message = String(format: stringForAlert, countCorrectAnswer)
        let alert = UIAlertController(title: "The end".localized,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true) }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            infinitiveLabel,
            pastSimpleLabel,
            pastSimpleTextField,
            participleLabel,
            participleTextField,
            checkButton,
            countCorrectAnswerLabel,
            countCurrentVerbLabel,
            skipButton
        ])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() //Edges - привязываем ВСЕ границы
        }
        
        contentView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(60)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleTextField.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleTextField.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleTextField.snp.makeConstraints { make in
            make.top.equalTo(participleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(participleTextField.snp.bottom).offset(100)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        countCorrectAnswerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(edgeInsets)
        }
        
        countCurrentVerbLabel.snp.makeConstraints { make in
            make.top.equalTo(countCorrectAnswerLabel).offset(30)
            make.right.equalToSuperview().inset(edgeInsets)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(checkButton).offset(70)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TrainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pastSimpleTextField.isFirstResponder {
            participleTextField.becomeFirstResponder()
        } else {
            scrollView.endEditing(true)
        }
        
        return true
    }
}

// MARK: - Keyboard events_
private extension TrainViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = frame.height + 50
    }
    
    @objc func keyboardWillHide () {
        scrollView.contentInset.bottom = .zero - 50
    }
    
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
