//
//  ToDoListCell.swift
//  ToDo-List
//
//  Created by student on 2022/3/29.
//

import UIKit

class ToDoListCell: UITableViewCell {
    
    let toDoLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let removeBtn: ToDoListButton = {
        let button = ToDoListButton()
        button.setTitle("移除", for: .normal)
        button.titleLabel?.backgroundColor = .gray
        return button
    }()
    
    let finishBtn: ToDoListButton = {
        let button = ToDoListButton()
        button.setTitle("完成", for: .normal)
        button.titleLabel?.backgroundColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.isUserInteractionEnabled = true
        self.addSubview(toDoLabel)
        self.addSubview(removeBtn)
        self.addSubview(finishBtn)
        
        toDoLabel.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        finishBtn.translatesAutoresizingMaskIntoConstraints = false
        
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
                toDoLabel.topAnchor.constraint(equalTo: self.topAnchor),
                toDoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                toDoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                toDoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
                toDoLabel.rightAnchor.constraint(equalTo: removeBtn.leftAnchor),
                // removeBtn
                removeBtn.topAnchor.constraint(equalTo: self.topAnchor),
                removeBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                removeBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                removeBtn.rightAnchor.constraint(equalTo: finishBtn.leftAnchor, constant: -15),
                // finishBtn
                finishBtn.topAnchor.constraint(equalTo: self.topAnchor),
                finishBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                finishBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                finishBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
        ])
    }
}
