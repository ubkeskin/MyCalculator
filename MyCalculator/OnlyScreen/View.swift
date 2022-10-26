//
//  TextView.swift
//  MyCalculator
//
//  Created by OS on 25.10.2022.
//

import Foundation
import UIKit
import MathParser

class View: UIView {
  private var cUsed: Bool = false
  private var haveAnEquation = false
  private let buttonTitles: [String: [String]] = ["1st" : ["(",")","%","C/AC"],
                                                  "2nd" : ["7","8","9","/"],
                                                  "3rd" : ["4","5","6","x"],
                                                  "4th" : ["1","2","3","-"],
                                                  "5th" : ["0",".","=","+"]]
  
  lazy var textView: UITextView = {
    var textView = UITextView()
    textView.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 40)
    textView.textColor = .gray
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  
  lazy var buttons: [String: [UIButton]] = {
    var buttons: [String: [UIButton]] = [:]
    buttonTitles.forEach { (key: String, value: [String]) in
      buttons[key] = createButtonsCollection(collection: value)
    }
    return buttons
  }()
  
  lazy var HStacks: [UIStackView] = {
    var sortedButtons = buttons.sorted  {
      $0.key.first! < $1.key.first!
    }
    var hStacks = sortedButtons.map {
      createHStack(collection: $0.value)
    }
    return hStacks
  }()
  
  lazy var stackView: UIStackView = {
    createVStack(stacks: HStacks)
   }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layoutSubviews()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func addButton(title: String) -> UIButton {
    let newButton = UIButton(type: .system)
    newButton.setTitle(title, for: .normal)
    if newButton.titleLabel?.text?.first?.isNumber == true {
      newButton.setTitleColor(.black, for: .normal)
      newButton.titleLabel?.backgroundColor = .white
    } else if newButton.titleLabel?.text?.first == "=" {
      newButton.setTitleColor(.black, for: .normal)
      newButton.titleLabel?.backgroundColor = UIColor(red: 0, green: 153, blue: 0, alpha: 0.6)
    } else if newButton.titleLabel?.text?.first == "C" {
      newButton.setTitleColor(.black, for: .normal)
      newButton.titleLabel?.backgroundColor = UIColor(red: 64, green: 0, blue: 0, alpha: 0.6)
    } else {
      newButton.setTitleColor(.black, for: .normal)
      newButton.titleLabel?.backgroundColor = UIColor(red: 64, green: 64, blue: 64, alpha: 0.8)
    }
    newButton.translatesAutoresizingMaskIntoConstraints = false
    newButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    newButton.titleLabel?.textAlignment = .center
    NSLayoutConstraint.activate([
      newButton.titleLabel!.topAnchor.constraint(equalTo: newButton.topAnchor, constant: 3),
      newButton.titleLabel!.leftAnchor.constraint(equalTo: newButton.leftAnchor, constant: 3)
    ])
    newButton.addTarget(self, action: #selector(oneTouchButtonBehaviour), for: .touchDown)
    if newButton.titleLabel?.text == "C/AC" {
      newButton.addTarget(self, action: #selector(repeatedTouchButtonBehaviour), for: .touchDownRepeat)
    }
    return newButton
  }
  private func createButtonsCollection(collection: [String]) -> [UIButton] {
    let buttons = collection.map { string in
      addButton(title: string)
    }
    return buttons
  }
  
  private func createHStack(collection: [UIButton]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: collection)
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }
  private func createVStack(stacks: [UIStackView]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: stacks)
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }
}
extension View {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.addSubview(textView)
    self.addSubview(stackView)
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      textView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
      textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
      textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
      stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 300),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
      stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
    ])
  }
  @objc private func oneTouchButtonBehaviour(sender: UIButton) {
    guard let buttonTitle = sender.titleLabel?.text else {return }
    if buttonTitle != "=" && buttonTitle != "C/AC" && buttonTitle != "x" {
      if haveAnEquation == true {
        textView.text.removeAll()
        haveAnEquation = false
      }
      cUsed = false
      print(buttonTitle)
      textView.text.append(buttonTitle)
    } else if buttonTitle == "=" {
      let evaluation = try! textView.text.evaluate()
      textView.text.append("\n=\(evaluation)")
      haveAnEquation = true
    } else if buttonTitle == "x" {
      cUsed = false
      textView.text.append("*")
    } else if buttonTitle == "C/AC" {
      if textView.text.isEmpty == false {
        textView.text.removeLast()
      }
    }
  }
  @objc private func repeatedTouchButtonBehaviour(sender: UIButton) {
      textView.text.removeAll()
  }
}
