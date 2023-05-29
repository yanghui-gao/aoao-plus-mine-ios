//
//  ContractVC.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/5/29.
//

import UIKit
import aoao_plus_common_ios

class ContractVC: PreviewVc {

	var url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "电子签约"
		setContent()
    }
    
	func setContent() {
		guard let url = self.url else {
			return
		}
		self.fileUrl = url
	}
}
