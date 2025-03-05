//
//  CustomTableViewCell.swift
//  Test!!
//
//  Created by Bharat Shilavat on 03/03/25.
//

import UIKit

protocol CustomTableViewCellDelegate : NSObject {
    func likeButtonTapped(atIndex: Int)
    func viewMoreButtonTapped(atIndex: Int)
}

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var ingredientCollectionView: UICollectionView!
    @IBOutlet weak var likeButtin: UIButton!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    weak var delegate: CustomTableViewCellDelegate?
    
    private var viewModel : DemoViewModel = DemoViewModel()
    var thumbnilImgUrl: String?
    var ingredients: [(ingredient: String, measure: String)] = [] {
        didSet {
            ingredientCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.layer.shadowPath = UIBezierPath(roundedRect: backView.bounds, cornerRadius: backView.layer.cornerRadius).cgPath
    }

    
    func setupUI(){
        backView.layer.cornerRadius = 12
        backView.backgroundColor = .white
        backView.clipsToBounds = false
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        contentView.clipsToBounds = false
        contentView.addShadow(
            shadowColor: UIColor.black.withAlphaComponent(0.2).cgColor,
            shadowOffset: CGSize(width: 0, height: 5),
            shadowRadius: 10,
            shadowOpacity: 0.3
        )
        backView.addShadow(
            shadowColor: UIColor.black.withAlphaComponent(0.2).cgColor,
            shadowOffset: CGSize(width: 0, height: 5),
            shadowRadius: 10,
            shadowOpacity: 0.3
        )
        
        productImageView.layer.cornerRadius = 12
        productImageView.layer.masksToBounds = true
        
        ingredientCollectionView.dataSource = self
        ingredientCollectionView.delegate = self
        
        if let layout = ingredientCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        productDescriptionLabel.numberOfLines = 2
        productDescriptionLabel.lineBreakMode = .byTruncatingTail
        productDescriptionLabel.isUserInteractionEnabled = true
        
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.likeButtonTapped(atIndex: sender.tag)
    }
    
    
    @IBAction func viewMoreButoonAction(_ sender: UIButton) {
        delegate?.viewMoreButtonTapped(atIndex: sender.tag)
    }
}

extension CustomTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DemoViewControllerContent.Content.ingredientCellID, for: indexPath) as! IngredientCollectionViewCell
        let ingredientData = ingredients[indexPath.row]
        cell.ingrdientImageView.layer.cornerRadius = 10
        cell.ingredientNameLabel.text = "\(ingredientData.ingredient) - \(ingredientData.measure)"
        viewModel.downloadImage(usingUrl: thumbnilImgUrl ?? DemoViewControllerContent.Content.plahlderImgStr) { image in
            DispatchQueue.main.async {
                if let image = image {
                    cell.ingrdientImageView.image = image
                }
            }
        }
        
        return cell
    }
}

extension CustomTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
}
