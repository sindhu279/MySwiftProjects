//
//  ViewController.swift
//  Environments
//
//  Created by SindhuS on 16/11/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentConfigLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let config = Bundle.main.infoDictionary?["Configuration"] as? String
        self.currentConfigLabel.text = config
    }
}

