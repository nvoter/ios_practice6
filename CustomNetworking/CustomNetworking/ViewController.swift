//
//  ViewController.swift
//  CustomNetworking
//
//  Created by Анастасия on 01.12.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TodoWorker().fetchTodos { todo in
            
        }
    }


}

