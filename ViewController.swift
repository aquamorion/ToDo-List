//
//  ViewController.swift
//  ToDo-List
//
//  Created by student on 2022/3/29.
//

import UIKit

class ViewController: UIViewController {
    
    var finishedTime: Date?
    var finishedTimes = [Date]()
    var toDoList = [List]()
    var finishedList = [List]()
    var textFieldMovedUp: Bool = false
    var keyboardHeight: CGFloat!
    var tabBarHeight: CGFloat!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[0]
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: "toDoCell")
        tableView.register(FinishedListCell.self, forCellReuseIdentifier: "finishedCell")
        textField.delegate = self
        API.shared.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            tabBarHeight = tabBar.frame.height
            textFieldMoveUpAnimation(keyboardHeight: keyboardHeight)
        }
    }

    @objc func textFieldEditingChanged(sender: UITextField){
        textField.layer.borderWidth = 0
        textField.layer.borderColor = .none
        textField.attributedPlaceholder = NSAttributedString(string: "請輸入待辦事項", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        submitBtn.isEnabled = true
    }
    
    func changeTextFieldArrtibute(placeholderText: String) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        if textField.text == "" {
            changeTextFieldArrtibute(placeholderText: "不得為空值")
            submitBtn.isEnabled = false
        } else {
            if tabBar.selectedItem == tabBar.items?[1] {
                tabBar.selectedItem = tabBar.items?[0]
            }
            submitBtn.isEnabled = false
            textField.isEnabled = false
            API.shared.callAPI()
            if textFieldMovedUp {
                textFieldMoveDownAnimation(keyboardHeight: keyboardHeight)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabBar.selectedItem?.tag == 0 {
            return toDoList.count
        } else {
            return finishedList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabBar.selectedItem?.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as! ToDoListCell
            cell.toDoLabel.text = toDoList[indexPath.row].name
            cell.removeBtn.buttonPressedCallback = {
                self.removeAlert(itemOfToDoList: self.toDoList[indexPath.row])
            }
            cell.finishBtn.buttonPressedCallback = {
                self.finishAlert(itemOfToDoList: self.toDoList[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "finishedCell", for: indexPath) as! FinishedListCell
            cell.finishedLabel.text = finishedList[indexPath.row].name
            cell.timeLabel.text = finishedList[indexPath.row].finishedTimeInterval
            return cell
        }
    }
    
    func setNewIndexPath(itemOfToDoList: List) -> IndexPath? {
        let index = self.toDoList.firstIndex { item in
            return item.id == itemOfToDoList.id
        }
        guard let i = index else { return nil }
        let indexPath = IndexPath(row: i, section: 0)
        return indexPath
    }
    
    func deleteToDoList(itemOfToDoList: List) {
        if let indexPath = setNewIndexPath(itemOfToDoList: itemOfToDoList) {
            toDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func finishAction(itemOfToDoList: List) {
        if let indexPath = setNewIndexPath(itemOfToDoList: itemOfToDoList) {
            let itemOfFinishedList = self.toDoList[indexPath.row]
            finishedList.append(itemOfFinishedList)
            deleteToDoList(itemOfToDoList: itemOfToDoList)
            finishedTime = Date()
            setFinishedTime(finishedTime: self.finishedTime, added: true)
        }
    }
    
    func removeAlert(itemOfToDoList: List) {
        let alert = UIAlertController(title: "提示", message: "是否移除", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let confirm = UIAlertAction(title: "確認", style: .default) { action in
            self.deleteToDoList(itemOfToDoList: itemOfToDoList)
            self.tableView.reloadData()
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func finishAlert(itemOfToDoList: List) {
        let alert = UIAlertController(title: "提示", message: "是否完成", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        let confirm = UIAlertAction(title: "確認", style: .default) { action in
            self.finishAction(itemOfToDoList: itemOfToDoList)
            self.tableView.reloadData()
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

extension ViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            tableView.reloadData()
        default:
            setFinishedTime(finishedTime: finishedTime, added: false)
            tableView.reloadData()
        }
    }
    
    func setFinishedTime(finishedTime: Date?, added: Bool) {
        guard let finishedTime = finishedTime else { return }
        if added {
            finishedTimes.append(finishedTime)
        }
        for index in 0...finishedTimes.count - 1 {
            let finishedTimeInterval = -(finishedTimes[index].timeIntervalSinceNow)
            let seconds = Int(finishedTimeInterval) % 60
            let minutes = Int(finishedTimeInterval / 60) % 60
            let hours = Int(finishedTimeInterval) / 3600
            if seconds < 60 && minutes == 0 {
                finishedList[index].finishedTimeInterval = "\(seconds) 秒前"
            } else if minutes < 60 && hours == 0 {
                finishedList[index].finishedTimeInterval = "\(minutes) 分鐘前"
            } else if hours < 24 {
                finishedList[index].finishedTimeInterval = "\(hours) 小時前"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.string(from: finishedTime)
                finishedList[index].finishedTimeInterval = date
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldMoveUpAnimation(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.textField.translatesAutoresizingMaskIntoConstraints = true
            self.textField.frame.origin.y -= keyboardHeight - self.tabBarHeight
        }
        textFieldMovedUp = true
    }
    
    func textFieldMoveDownAnimation(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.textField.translatesAutoresizingMaskIntoConstraints = true
            self.textField.frame.origin.y += keyboardHeight - self.tabBarHeight
        }
        textFieldMovedUp = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textFieldMoveDownAnimation(keyboardHeight: keyboardHeight)
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if textFieldMovedUp {
            textFieldMoveDownAnimation(keyboardHeight: keyboardHeight)
        }
    }
}

extension ViewController: APIDelegate {
    
    func addToDoList() {
        guard let name = textField.text else { return }
        let itemOfToDoList = List()
        itemOfToDoList.name = name
        toDoList.append(itemOfToDoList)
        textField.text = ""
    }
    
    func itemOfToDoListSubmited() {
        print("Submit success")
        addToDoList()
        tableView.reloadData()
        self.view.endEditing(true)
        
        submitBtn.isEnabled = true
        textField.isEnabled = true
        
        submitBtn.layer.sublayers?.remove(at: 1)
        submitBtn.tintColor = .tintColor
        submitBtn.titleLabel?.alpha = 1
    }
    
    func circularLoadingAnimation() {
        var progressCircle = CAShapeLayer()
        
        let circlePath = UIBezierPath(ovalIn: CGRect(x: submitBtn.frame.width / 2 - 10, y: submitBtn.frame.height / 2 - 10, width: submitBtn.frame.width / 2.5, height: submitBtn.frame.width / 2.5))
        progressCircle = CAShapeLayer()
        progressCircle.path = circlePath.cgPath
        progressCircle.strokeColor = UIColor.white.cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = 2.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.3
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        progressCircle.add(animation, forKey: "animation")
        submitBtn.layer.addSublayer(progressCircle)
        submitBtn.tintColor = .lightGray
        submitBtn.titleLabel?.alpha = 0
    }
}
