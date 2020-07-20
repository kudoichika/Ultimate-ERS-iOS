//
//  TestViewController.swift
//  Ultimate-ERS
//
//  Created by Kudo on 6/28/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65).isActive = true

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    
        
        for _ in 0...25 {
            let stackCell = UIStackView()
            stackCell.axis = .horizontal
            //stackCell.spacing = 100
            stackCell.alignment = .fill
            stackCell.distribution = .equalCentering
            
            let label = UILabel()
            label.text = "Hello"
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont(name : "Helvetica Neue", size : 26)
            label.textAlignment = .center
            //let sw = UISwitch()
            
            stackCell.addArrangedSubview(label)
            //stackCell.addArrangedSubview(sw)
            
            stackView.addArrangedSubview(stackCell)
            /*stackCell.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10).isActive = true
            stackCell.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10).isActive = true
            
            label.leadingAnchor.constraint(equalTo: stackCell.leadingAnchor, constant: 10).isActive = true
            label.trailingAnchor.constraint(equalTo: stackCell.trailingAnchor, constant: -10).isActive = true*/
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
