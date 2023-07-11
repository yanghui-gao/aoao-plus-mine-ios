//
//  AboutVc.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/30.
//

import UIKit
import aoao_plus_common_ios

class AboutVc: AAViewController {
	/// 版本号Label
	@IBOutlet weak var versionLabel: UILabel!
	/// 图标
	@IBOutlet weak var applicationImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let infoDictionary = Bundle.main.infoDictionary, let version = infoDictionary["CFBundleShortVersionString"] {
			self.versionLabel.text = "版本号: \(version)"
		}
		
    }

}
