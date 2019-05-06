//
//  RestaurantCell.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/3/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import SnapKit

class RestaurantCell: UITableViewCell {
    

    //Upper Section
    let upperView = UIView()
    let makeFavourite = UIButton()
    
    //lower section
    let lowerView = UIView()
    let lowerLeft = UIView()
    let lowerRight = UIView()
    
    let openStateLabel = UILabel()
    let openStateValue = UILabel()
    let selectedSortLabel = UILabel()
    let selectedSortValue = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        adjustLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        
        self.selectionStyle = .none
        
        self.textLabel?.font = UIFont(name: "Optima-Bold", size: 20)
        self.textLabel?.backgroundColor = .green
        self.textLabel?.removeFromSuperview()
        self.contentView.addSubview(textLabel!)

        
        
        
        makeFavourite.setBackgroundImage(UIImage(named: "empty-heart"), for: .normal)
        makeFavourite.setBackgroundImage(UIImage(named: "full-heart"), for: .selected)
        openStateLabel.text = "Status:"

        selectedSortLabel.text = "Popularity:"
        self.contentView.addSubview(upperView)
        upperView.addSubview(makeFavourite)
        
        self.contentView.addSubview(lowerView)
        lowerView.addSubview(lowerLeft)
        lowerView.addSubview(lowerRight)
        
        lowerLeft.addSubview(openStateLabel)
        lowerLeft.addSubview(openStateValue)
        openStateLabel.textAlignment = .right
        
        lowerRight.addSubview(selectedSortLabel)
        lowerRight.addSubview(selectedSortValue)
        selectedSortLabel.textAlignment = .left
        selectedSortValue.textAlignment = .left
        
        

    }
    func adjustLayout() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        //Upper View
        self.upperView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(self.contentView).multipliedBy(0.5)
        }
        
        textLabel!.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(upperView)
            make.width.equalTo(upperView).multipliedBy(0.7)
        })
        
        self.makeFavourite.snp.makeConstraints { (make) in
            make.top.equalTo(upperView).offset(10)
            make.right.equalTo(upperView).offset(-10)
            make.bottom.equalTo(upperView).offset(10)
            make.width.equalTo(makeFavourite.snp.height)
        }
        
        //Lower View
        //Lower Left
        self.lowerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.upperView.snp.bottom).offset(10)
        }
        
        self.lowerLeft.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self.lowerView)
            make.width.equalTo(self.lowerView).multipliedBy(0.5)
        }
        
        self.openStateLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(lowerLeft)
            make.width.equalTo(lowerLeft).multipliedBy(0.4)
        }
        
        self.openStateValue.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(lowerLeft)
            make.left.equalTo(openStateLabel.snp.right)
        }
        
        //Lower Right:
        self.lowerRight.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(self.lowerView)
            make.left.equalTo(self.lowerLeft.snp.right)
        }
        
        self.selectedSortLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(lowerRight)
            make.width.equalTo(lowerRight).multipliedBy(0.5)
        }
        
        self.selectedSortValue.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(lowerRight)
            make.left.equalTo(selectedSortLabel.snp.right)
        }
        
    }

}
