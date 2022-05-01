//
//  Person.swift
//  NamestoFaces
//
//  Created by CEVAT UYGUR on 1.05.2022.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
