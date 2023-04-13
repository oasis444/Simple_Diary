//
//  WriteDiaryVC.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

/*
 info: registerBtn 버튼을 눌렀을 때 textField가 isEmpty 인지 확인하는 방법으로 만들 수도 있지만
 여기서는 registerBtn의 동적인 isEnabled을 보기 위해 textFiled의 내용이 변할 때마다 isEmpty를 확인하고,
 isEnabled의 값을 바꾸는 방법을 사용했습니다.
 */

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryVC: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateField: UITextField!
    
    private var registerBtn: UIBarButtonItem!
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate? // weak를 붙이지 않는다면 강한 참조에 의해 메모리 누수 발생
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureContextsTextView()
        configureDatePicker()
        configureInputField()
    }

    private func configure() {
        registerBtn = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(register))
        registerBtn.isEnabled = false
        navigationItem.title = "일기 작성"
        navigationItem.rightBarButtonItem = registerBtn
    }
    
    private func configureContextsTextView() {
        contentsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        contentsTextView.layer.borderWidth = 0.5
        contentsTextView.layer.cornerRadius = 5
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        dateField.inputView = datePicker
    }
    
    private func configureInputField() {
        contentsTextView.delegate = self
        titleField.addTarget(self, action: #selector(textFiledDidChage(_:)), for: .editingChanged)
        dateField.addTarget(self, action: #selector(textFiledDidChage(_:)), for: .editingChanged)
    }
    
    private func validateInputField() {
        registerBtn.isEnabled = !(titleField.text?.isEmpty ?? true) && !(dateField.text?.isEmpty ?? true) && !contentsTextView.text.isEmpty
    }
    
    @objc private func register() {
        guard let title = titleField.text else { return }
        guard let contents = contentsTextView.text else { return }
        guard let date = diaryDate else { return }
        let diary = Diary(title: title, contents: contents, date: date, bookMark: false)
        delegate?.didSelectRegister(diary: diary)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        dateField.text = CalcDate().dateToString(date: datePicker.date, type: "yyyy년 MM월 dd일(EEEEE)")
        diaryDate = datePicker.date
        dateField.sendActions(for: .editingChanged)
    }
    
    @objc private func textFiledDidChage(_ textFiled: UITextField) {
        validateInputField()
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension WriteDiaryVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateInputField()
    }
}
