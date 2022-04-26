//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by CEVAT UYGUR on 26.04.2022.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
