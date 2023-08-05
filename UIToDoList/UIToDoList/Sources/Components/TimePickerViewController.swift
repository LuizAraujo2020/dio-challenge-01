//
//  TimePickerViewController.swift
//  UIToDoList
//
//  Created by Luiz Araujo on 02/08/23.
//

import UIKit

protocol TimePickerProtocol {
    func sendHour(hour: String)
}

class TimePickerViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOK: UIButton!

    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - Var / lets
    public var delegate: TimePickerProtocol?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

// MARK: - Action
    @IBAction func close(_ sender: UIButton) {
        if sender == self.buttonOK {
            self.dismiss(animated: true) { [weak self] in
                guard let delegate = self?.delegate else { return }
                let datePickerSelect: Date = self?.datePicker.date ?? .now
                let dateString = Date().dateToString(date: datePickerSelect, dateFormatter: "HH:mm")
                delegate.sendHour(hour: dateString)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
}
