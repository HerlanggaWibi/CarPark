//
//  ASlotsCell.swift
//  CobaTable

import UIKit
class ASlotsCell: UITableViewCell {
    
    var myLabel: UILabel = {
        var lbl = UILabel()
        return lbl
    }()
    
    var myLabel1: UILabel = {
        var lbl1 = UILabel()
        return lbl1
    }()
    
    var myLabel2: UILabel = {
        var lbl2 = UILabel()
        return lbl2
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(myLabel)
        self.addSubview(myLabel1)
        self.addSubview(myLabel2)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myLabel.frame = CGRect(x: 20, y: 0, width: 150, height: 30)
        myLabel1.frame = CGRect(x: 20, y: 15, width: 150, height: 30)
        myLabel2.frame = CGRect(x: 270, y: 15, width: 150, height: 30)
    }
    
}
