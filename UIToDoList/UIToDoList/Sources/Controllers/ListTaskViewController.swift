//
//  ListTaskViewController.swift
//  UIToDoList
//
//  Created by Luiz Araujo on 31/07/23.
//

import UIKit

class ListTaskViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonAdd: UIButton!

    private var list = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.registerNib()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ManageTaskTableViewController {
            guard let task = sender as? Task else { return }
            controller.task = task
        }
    }

    // MARK: - Methods
    private func registerNib() {
        self.tableView.register(
            UINib(nibName: "EmptyTableViewCell",
                  bundle: nil),
            forCellReuseIdentifier: "EmptyTableViewCell")
    }

    private func loadItems() {
        self.list = TaskDefaultHelper().getTaskList()
        tableView.reloadData()
    }

    private func callCreateTask(task: Task?) {
        self.performSegue(withIdentifier: "CreateTaskSegue", sender: task)
    }

    // MARK: - Action
    @IBAction func createTask(_ sender: Any) {
        callCreateTask(task: nil)
    }
}

extension ListTaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count > 0 ? self.list.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.list.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell

            let task = self.list[indexPath.row]
            cell.set(labelTitle: task.title)
            cell.set(labelHour: task.hour)
            cell.set(labelDate: task.date)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.list.count > 0 {
            callCreateTask(task: list[indexPath.row])
        } else {
            callCreateTask(task: nil)
        }
    }
}
