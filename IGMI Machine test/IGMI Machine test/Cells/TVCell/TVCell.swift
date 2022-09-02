//
//  TVCell.swift
//  IGMI Machine test
//
//  Created by Galaxy Decoders on 02/09/22.
//

import UIKit

class TVCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var restTitle: UILabel!
    @IBOutlet weak var restRateTitle: UILabel!
    @IBOutlet weak var restDescTitle: UILabel!
    @IBOutlet weak var restLocationTitle: UILabel!
    
    @IBOutlet weak var postCLView: UICollectionView!
    
    var timeData: [TimeAvailability]? = []

    override func awakeFromNib() {
        super.awakeFromNib()
        self.postCLView.register(UINib(nibName: "CVCell", bundle: nil), forCellWithReuseIdentifier: "CVCell")
        self.postCLView.delegate = self
        self.postCLView.dataSource = self
        self.postCLView.isScrollEnabled = false
        self.postCLView.backgroundColor = UIColor(named: "F3F3F3")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTimeData(timeDataAll: [TimeAvailability]?) {
        self.timeData = timeDataAll
        self.postCLView.reloadData()
        
    }
    
}

extension TVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CVCell
        let restObj = self.timeData?[indexPath.item]
        cell.timeLabel.text = restObj?.time ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - CGFloat(8 + (5 * 8)))/CGFloat(5)
        let height = CGFloat(40)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    

}
