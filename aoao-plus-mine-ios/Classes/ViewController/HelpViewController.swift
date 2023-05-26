//
//  HelpViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/11.
//

import UIKit
import aoao_common_ios

class HelpViewController: AAViewController {
//    ["name": "模拟接单学习", "type": "learn"]
	let dateSource = [["name": "服务协议", "type": "agreement"],
					  ["name": "隐私政策", "type": "policy"],
					  ["name": "意见反馈", "type": "feadback"]]

    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
    }
	
	func setUI() {
		self.title = "帮助"
		
		self.view.backgroundColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		
	}

}
extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		cell.textLabel?.text = dateSource[indexPath.row]["name"]
		if let type = dateSource[indexPath.row]["type"], type == "feadback" {
			cell.accessoryType = .none
		}
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let type = dateSource[indexPath.row]["type"]{
			switch type {
			case "learn":
				print("跳转模拟接单学习")
			case "agreement":
				getAgreementPathOrprivacyPathUrl(type: .agreement).openURL()
			case "policy":
				getAgreementPathOrprivacyPathUrl(type: .privacy).openURL()
			case "feadback":
				"feedback".openURL()
			default:
				print("其他")
			}
		}
	}
}
