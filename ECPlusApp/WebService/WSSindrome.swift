//
//  WSSindrome.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 13/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

protocol WSSindrome {
    func getSyndromes(language: String, completion: @escaping ([Sindrome]) -> Void);
    func getHashForListOfSyndromes(language: String, completion: @escaping (String?) -> Void);
}
