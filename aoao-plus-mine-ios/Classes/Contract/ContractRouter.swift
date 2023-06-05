//
//  ContractRouter.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/5/29.
//

import UIKit
import aoao_plus_common_ios
import SwiftyJSON

struct ContractRouter {
	
	static func initialize() {
		
		/// 签约
		navigator.register("sign".routerUrl) { url, values, context in
			return AAMineModule.share.contractStoryboard.instantiateViewController(withIdentifier: "SignVc")
		}
		
		// 查看合同
		navigator.register("contract".routerUrl) { url, values, context in
			let vc = ContractVC()
			guard let para = context as? [String: Any?] else {
				return vc
			}
			if let url = para["url"] as? String {
				vc.fileUrl = url
			}
			return vc
		}
	}
}
