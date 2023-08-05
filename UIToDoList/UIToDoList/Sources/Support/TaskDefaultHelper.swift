//
//  TaskDefaultHelper.swift
//  UIToDoList
//
//  Created by Luiz Araujo on 03/08/23.
//

import Foundation

class TaskDefaultHelper {
    let keyTask = "kTask"

    public func saveListTask(lista: [Task]) {
        do {
            let listAux = try JSONEncoder().encode(lista)
            UserDefaults.standard.setValue(listAux, forKey: self.keyTask)
        } catch {
            print(error)
        }
    }

    func getTaskList() -> [Task] {
        do {
            guard let list = UserDefaults.standard.object(forKey: self.keyTask)
            else { return []}

            let listAux = try JSONDecoder().decode([Task].self, from: list as! Data)
            return listAux

        } catch {
            print(error)
        }

        return []
    }

    func updateTask(_ task: Task) {
        var list = self.getTaskList()
        list.removeAll(where: { $0.id == task.id })
        list.append(task)
        saveListTask(lista: list)
    }

    func deleteTask(_ task: Task) {
        var list = self.getTaskList()
        list.removeAll(where: { $0.id == task.id })
        saveListTask(lista: list)
    }

    func getNextID() -> Int {
        let listAux = getTaskList()
        var greaterID = 0

        guard !listAux.isEmpty else {

            print("\(#function): \(greaterID)")
            return greaterID }

        for task in listAux where task.id > greaterID {
            greaterID = task.id
        }
        print("\(#function): \(greaterID + 1)")
        return greaterID + 1
    }
}
