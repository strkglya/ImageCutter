//
//  SettingsTableViewModel.swift
//  ImageCutter
//
//  Created by Александра Среднева on 7.08.24.
//

import Foundation
import UIKit

protocol SettingsScreenViewModelProtocol {
    var performUpdate: (() -> Void)? { get set }
    func getNumberOfRows() -> Int
    func addRow()
}

final class SettingsScreenViewModel: SettingsScreenViewModelProtocol {
    
    // MARK: - Properties
        
    var performUpdate: (() -> Void)?
    
    private var numberOfRows = 1 {
        didSet {
            performUpdate?()
        }
    }
    
    // MARK: - Methods

    func getNumberOfRows() -> Int {
        return numberOfRows
    }
    
    func addRow() {
        numberOfRows += 1
    }
}
