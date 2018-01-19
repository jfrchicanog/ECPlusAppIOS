//
//  DAOFactory.swift
//  ECPlusApp
//
//  Created by José Francisco Chicano García on 16/1/18.
//  Copyright © 2018 José Francisco Chicano García. All rights reserved.
//

import Foundation

public class DAOFactory {
    static var _daoSindrome : DAOSindrome?;
    static var _daoPalabra : DAOPalabra?;
    
    static func getDAOSindrome() -> DAOSindrome {
        if _daoSindrome == nil {
            _daoSindrome = DAOSindromeDatabase();
        }
        return _daoSindrome!;
    }
    
    static func getDAOPalabra() -> DAOPalabra {
        if _daoPalabra == nil {
            _daoPalabra = DAOPalabraImpl();
        }
        return _daoPalabra!;
    }
}
