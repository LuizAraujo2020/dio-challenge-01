//
//  ManageTaskTableViewController.swift
//  UIToDoList
//
//  Created by Luiz Araujo on 31/07/23.
//

import UIKit
import FSCalendar

class ManageTaskTableViewController: UITableViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var calendar: FSCalendar!

    @IBOutlet weak var buttonHour: UIButton!
    @IBOutlet weak var buttonRemove: UIButton!

    public var task: Task?

    var hour = ""
    var date = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        configView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TimePickerViewController {
            controller.delegate = self
        }
    }

    // MARK: - IBAction
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func openComponent(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueComponentFile", sender: nil)
    }

    @IBAction func deleteTask(_ sender: Any) {
        if let task {
            TaskDefaultHelper().deleteTask(task)
            self.task = nil
            self.dismiss(animated: true)
        }
        tableView.reloadData()
    }

    @IBAction func createTask(_ sender: Any) {
        createTask()
        tableView.reloadData()
    }

    // MARK: - Methods
    private func configView() {
        self.buttonRemove.isHidden = self.task == nil
        guard let taskAux = self.task else { return }
        buttonHour.setTitle(taskAux.hour, for: .normal)
        titleTextField.text = taskAux.title
        hour = taskAux.hour
        date = taskAux.date
        print(taskAux)
    }

    private func createTask() {
        if self.task != nil {
            self.task!.date = self.date
            self.task!.hour = self.hour
            self.task!.title = self.titleTextField.text ?? ""

            TaskDefaultHelper().updateTask(self.task!)
        } else {
            var list = TaskDefaultHelper().getTaskList()
            let task = Task(
                id: TaskDefaultHelper().getNextID(),
                title: self.titleTextField.text ?? "",
                hour: self.hour,
                date: self.date)
            list.append(task)
            TaskDefaultHelper().saveListTask(lista: list)
        }
        self.dismiss(animated: true)
    }
}


// MARK: - Table view data source
extension ManageTaskTableViewController: TimePickerProtocol, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func sendHour(hour: String) {
        self.buttonHour.setTitle(hour, for: .normal)
        self.hour = hour
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date.dateToString(date: date, dateFormatter: "dd/MM/yyyy"))
        self.date = date.dateToString(date: date, dateFormatter: "dd/MM/yyyy")
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateAux = Date().dateToString(date: date, dateFormatter: "dd/MM/yyyy")
        if self.date == dateAux {
            return .green
        }

        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateAux = Date().dateToString(date: date, dateFormatter: "dd/MM/yyyy")
        if self.task != nil {
            if self.date == dateAux {
                return .black
            }
        }
        return nil
    }
}
