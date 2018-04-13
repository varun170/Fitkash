//
//  Shop.swift
//  CoreMotionPost
//
//  Created by Varun Bhutoria on 20/03/18.
//  Copyright © 2018 kamwysoc. All rights reserved.
//

import UIKit

class Shop: UIViewController {

    @IBOutlet weak var display_coins: UILabel!
    @IBAction func buy_membership(_ sender: UIButton) {
        if(wallet>0){
        wallet = wallet - 1
        print(wallet)
        self.display_coins.text = String(wallet) + " FitCoins"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(wallet)
        self.display_coins.text = String(wallet) + " FitCoins"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
