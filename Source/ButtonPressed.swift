//
//  ButtonPressed.swift
//  ToDo-List
//
//  Created by student on 2022/3/29.
//

import UIKit

class ToDoListButton: UIButton {
    var buttonPressedCallback: () -> ()  = { }
    
    @objc func didPressedButton() {
        buttonPressedCallback()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didPressedButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
