//
//  AddressesTableViewController.swift
//  Maps
//
//  Created by Luiz Araujo on 29/07/23.
//

import UIKit

class AddressesTableViewController: UITableViewController {
    var addresses = [Address]()
    var selectedAddress: ((Address) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: "AddressCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell")!
        let address = addresses[indexPath.row]
//        let address = addresses[indexPath.row]
        print(address)
        cell.addressLabel.text = address.name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedAddress else { return }
        let address = addresses[indexPath.row]
        selectedAddress(address)
        self.navigationController?.popViewController(animated: true)
    }
}
