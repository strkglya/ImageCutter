//
//  CustomAlertController.swift
//  ImageCutter
//
//  Created by Александра Среднева on 12.08.24.
//

import UIKit

class CustomAlertController: UIAlertController {

    convenience init(title: String, message: String, actionTitle: String, handler: ((UIAlertAction) -> ())? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: handler)
        self.addAction(alertAction)
    }
}
