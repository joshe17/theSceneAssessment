//
//  UpgradeTiers.swift
//  theSceneAssessment
//
//  Created by Joshua Ho on 1/14/24.
//

import Foundation

enum UpgradeTiers: String, CaseIterable {
    case free = "Free"
    case basic = "Basic"
    case pro = "Pro"
    
    func paymentCost() -> String {
        switch self {
        case .free:
            return  "$0.00"
        case .basic:
            return "$4.99"
        case .pro:
            return "$9.99"
        }
     }
}
