//
//  FactsCell.swift
//  FactsData
//
//  Created by Varsha Shankar on 30/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import UIKit

class FactsCell: UITableViewCell {
    
    var title = UILabel()
    var descriptionText = UILabel()
    var imgView = UIImageView()
    var containerView = UIView()
    private var urlString: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(imgView)
        containerView.addSubview(title)
        containerView.addSubview(descriptionText)
        self.contentView.addSubview(containerView)
        
        configureImageView()
        configureContainerView()
        configureTitleLabel()
        configureDesciptionLabel()
        
        setImageConstraints()
        setContainerViewConstraints()
        setTitleLabelConstraints()
        setDescriptionLabelConstraints()
        
        self.layoutIfNeeded()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = nil
        self.descriptionText.text = nil
        self.imgView.image = nil
    }
    
    // MARK: - Configure Cell
    func set(fact: Rows) {
        title.text = fact.title
        descriptionText.text = fact.description
        
        guard let imageHref = fact.imageHref else {return}
        urlString = imageHref
        
        guard let imageURL = URL(string: urlString) else {
            self.imageView?.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // clear old image before downloading new
        self.imgView.image = nil
        getImageDataFrom(url: imageURL)
    }
    
    // MARK: - Get Image Data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.imgView.image = image
                }
            }
        }.resume()
    }
    // MARK: - Configure Image View
    private func configureImageView() {
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
    }
    
    // MARK: - Configure Container View
    private func configureContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
    }
    
    // MARK: - Configure Title Label
    private func configureTitleLabel() {
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        title.adjustsFontForContentSizeCategory = true
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.textColor = UIColor.black
    }
    
    // MARK: - Configure Description Label
    private func configureDesciptionLabel() {
        descriptionText.numberOfLines = 0
        descriptionText.minimumScaleFactor = 10.0
        descriptionText.adjustsFontSizeToFitWidth = true
        descriptionText.adjustsFontForContentSizeCategory = true
        descriptionText.font = UIFont.systemFont(ofSize: 14)
        descriptionText.textColor = UIColor.darkGray
    }
    
    // MARK: - Set Image Constraints
    private func setImageConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor, multiplier: 16/9).isActive = true
        
    }

    // MARK: - Set Container View Constraints
    private func setContainerViewConstraints() {
        containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    // MARK: - Set Title Label Constraints
    private func setTitleLabelConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        title.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1).isActive = true
        contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: descriptionText.lastBaselineAnchor, multiplier: 1).isActive = true
    }
    
    // MARK: - Set Description Label Constraints
    private func setDescriptionLabelConstraints() {
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.topAnchor.constraint(equalTo: self.title.bottomAnchor).isActive = true
        descriptionText.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        descriptionText.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
    }
}
