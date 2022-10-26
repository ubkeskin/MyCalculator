//
//  ViewController.swift
//  MyCalculator
//
//  Created by OS on 25.10.2022.
//

import UIKit

class ViewController: UIViewController {
  let content = View(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(content)
    content.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      content.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      content.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
      content.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
    ])
  }
}

