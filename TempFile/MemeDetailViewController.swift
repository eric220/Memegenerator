//
//  MemeDetailController.swift
//  TempFile
//
//  Created by Macbook on 11/9/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var detailView: UIImageView!
    
    var newMeme: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailView.image = newMeme
    }
}
