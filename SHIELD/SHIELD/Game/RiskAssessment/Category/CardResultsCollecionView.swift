//
//  CardResultImageCell.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/27.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

let cardResultImageCellID = "card result image cell identifier"
class CardResultImageCell: UICollectionViewCell {
    fileprivate let imageView = UIImageView()
    fileprivate let typeImageView = UIImageView()
    fileprivate var factorType = FactorType.score
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        
        typeImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(typeImageView)
        contentView.addSubview(imageView)
        
        // shadow
        layer.shadowColor = UIColorFromRGB(178, green: 188, blue: 202).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.9
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        typeImageView.frame = bounds
        
        let borderWidth: CGFloat = min(bounds.width, bounds.height) / 35 // about 2 point
        let inset = (factorType == .score ? 0 : 6.3 * borderWidth)
        imageView.frame = bounds.insetBy(dx: inset, dy: inset)
        imageView.layer.borderWidth = borderWidth
        imageView.layer.cornerRadius = round ? imageView.bounds.height * 0.5 : borderWidth * 2
        layer.shadowRadius = borderWidth
    }
    
    func configureWithCard(_ card: CardInfoObjModel, mainColor: UIColor, factorType: FactorType) {
        self.factorType = factorType
        self.round = false
        
        switch factorType {
        case .bonus:
            imageView.layer.borderColor = UIColor.clear.cgColor
            typeImageView.image = #imageLiteral(resourceName: "bonus_border")
        case .complementary:
            imageView.layer.borderColor = UIColor.clear.cgColor
            typeImageView.image = #imageLiteral(resourceName: "complementary_border")
        default:
            imageView.layer.borderColor = mainColor.cgColor
            typeImageView.image = nil
        }
        
        card.addMatchedImageOnImageView(imageView)
        self.layoutSubviews()
    }

    
    fileprivate var round = false
    func configureWithRoundImage(_ imageUrl: URL?, mainColor: UIColor) {
        round = true
        imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, progress: nil) { (image, error, type, url) in
        }
        imageView.layer.borderColor = mainColor.cgColor
        typeImageView.image = nil
    }
}

// MARK: ------------- deck of cards --------------
class CardResultsCollecionView: UICollectionView {
    var cardIsSelected: ((Int)->Void)?
    var cards = [CardInfoObjModel]() {
        didSet{
            reloadData()
        }
    }
    
    var mainColor = tabTintGreen
    fileprivate var factorType: FactorType = .score
    class func createWithFrame(_ frame: CGRect, cards: [CardInfoObjModel], mainColor: UIColor) -> CardResultsCollecionView {
        // layout
        let coverFlowLayout = ScaleLayout()
        coverFlowLayout.minimumLineSpacing = -5
        coverFlowLayout.minRatio = 0.8
        coverFlowLayout.scrollDirection = .horizontal
        coverFlowLayout.itemSize = CGSize(width: frame.height, height: frame.height)
        
        // create
        let cardResult = CardResultsCollecionView(frame: frame, collectionViewLayout: coverFlowLayout)
        cardResult.backgroundColor = UIColor.clear
        cardResult.cards = cards
        cardResult.mainColor = mainColor
        cardResult.isScrollEnabled = false
        cardResult.showsHorizontalScrollIndicator = false

        // register and delegate
        cardResult.register(CardResultImageCell.self, forCellWithReuseIdentifier: cardResultImageCellID)
        cardResult.dataSource = cardResult
        cardResult.delegate = cardResult
        
        return cardResult
    }
    
    func reloadDataWithCards(_ cards: [CardInfoObjModel], factorType: FactorType) {
        self.cards = cards
        self.factorType = factorType
        
        reloadData()
    }
}

// dataSource
extension CardResultsCollecionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardResultImageCellID, for: indexPath) as! CardResultImageCell
        cell.configureWithCard(cards[indexPath.item], mainColor: mainColor, factorType: factorType)
        
        return cell
    }
}

// size delegate
extension CardResultsCollecionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = bounds.height * 0.94
        let middle = bounds.midX - length * 0.5
        let flow = collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = -length * 0.92
        flow.sectionInset = UIEdgeInsets(top: 0, left: middle, bottom: bounds.height - length, right: middle)
        return CGSize(width: length, height: length)
    }
}

extension CardResultsCollecionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardIsSelected?(indexPath.item)
    }
}
