//
//  UserTableViewCell.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 28.11.2025.
//

import UIKit

final class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    // MARK: - UI components
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var body: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, body])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        contentView.addSubview(avatar)
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            
            vStack.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36)
        ])
    }

}
