//
//  Address.swift
//  Maps
//
//  Created by Luiz Araujo on 29/07/23.
//

import Foundation
import Contacts
import CoreLocation

struct Address {
    var name: String
    var placemark: CLPlacemark
    var postalAddress: CNPostalAddress
}
