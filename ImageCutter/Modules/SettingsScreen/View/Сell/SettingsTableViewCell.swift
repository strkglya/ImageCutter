//
//  SettingsTableViewCell.swift
//  ImageCutter
//
//  Created by Александра Среднева on 7.08.24.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    // MARK: - Constants
    
    private enum Constants {
        static let aboutLabelLeadingOffset = 16
    }
    
    // MARK: - Properties
    
    private lazy var aboutCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.Settings.cellTitleText
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        addSubview(aboutCompanyLabel)
    }
    
    private func setUpConstraints() {
        aboutCompanyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(Constants.aboutLabelLeadingOffset)
        }
    }
}
