//
//  SubscribeTableViewCell.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation
import UIKit
import RxSwift

class SubscribeTableViewCell: UITableViewCell {
    
    var viewModel: SubscribeTableViewViewModel?
    private var bag = DisposeBag()
    var selectedValue: Bool = false {
        didSet {
            updateImage()
            updateBorder()
        }
    }
    private lazy var selectedImage = UIImage(named: "circle_select")
    private lazy var unselectedImage = UIImage(named: "circle_unselect")
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var selectImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        parentView.layer.masksToBounds = true
        parentView.layer.cornerRadius = 5
        parentView.layer.shadowOffset = .zero
        parentView.layer.shadowColor = UIColor(rgb: 0xB8B8D2).cgColor
        parentView.layer.shadowOpacity = 1
        parentView.layer.shadowRadius = 5
    }
    
    func bind(to viewModel: SubscribeTableViewViewModel) {
        self.viewModel = viewModel
        
        viewModel.isSelected
            .distinctUntilChanged()
            .subscribeNext { [weak self] isSelect in
                guard let self = self else { return }
                self.selectedValue = isSelect
            }
            .disposed(by: bag)
        
        viewModel.subscribeItem
            .subscribeNext { [weak self] item in
                guard let self = self,
                let item = item else { return }
                self.titleLabel.attributedText = SubscribeTableViewCell.attributedTitle(title: item.title ?? "")
                self.descLabel.attributedText = SubscribeTableViewCell.attributedDesc(descHead: item.descHead ?? "", descBody: item.descBody ?? "")
            }
            .disposed(by: bag)
    }
    
    private func configureListener() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    private func updateImage() {
        let image = selectedValue ? selectedImage : unselectedImage
        self.selectImgView.image = image
    }
    
    private func updateBorder() {
        if selectedValue {
            parentView.layer.borderWidth = 1
            parentView.layer.borderColor = UIColor(rgb: 0x3D5CFF).cgColor
        } else {
            parentView.layer.borderWidth = 1
            parentView.layer.borderColor = UIColor(rgb: 0xB8B8D2).cgColor
        }
    }
}

extension SubscribeTableViewCell {
    public static func attributedTitle(title: String) -> NSAttributedString? {
        let att = NSMutableAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor(rgb: 0x1F1F39),
                        .font: UIFont.boldSystemFont(ofSize: 14)
                        ]
        )
        return att
    }
    
    public static func attributedDesc(descHead: String, descBody: String) -> NSAttributedString? {
        let attDesc = NSMutableAttributedString(
            string: descHead,
            attributes: [.foregroundColor: UIColor(rgb: 0x1F1F39),
                         .font: UIFont.boldSystemFont(ofSize: 12)
                         ]
        )
        let attDescBody = NSAttributedString(string: " - \(descBody)", attributes: [.foregroundColor: UIColor(rgb: 0x1F1F39),
                                                                                    .font: UIFont.systemFont(ofSize: 12)
                                                                                    ]
        )
        attDesc.append(attDescBody)
        return attDesc
    }
}
