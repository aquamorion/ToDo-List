//
//  FinishedListCell.swift
//  ToDo-List
//
//  Created by student on 2022/3/29.
//

import UIKit

class FinishedListCell: UITableViewCell {

    let finishedLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(finishedLabel)
        self.addSubview(timeLabel)
        
        finishedLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
                // toDoLabel
                finishedLabel.topAnchor.constraint(equalTo: self.topAnchor),
                finishedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                finishedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                finishedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
                finishedLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor),
                // timeLabel
                timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
                timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
        ])
    }

}
