//
//  ChangePhoneRouter.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/6/5.
//

import UIKit
import aoao_plus_common_ios
import SwiftyJSON

struct ChangePhoneRouter {
	
	static func initialize() {
		
		/// 修改手机号
		navigator.register("changePhone".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "ChangePhoneExplainVc") as! ChangePhoneExplainVc
			vc.changePhoneType = .changePhone
			return vc
		}
		
		/// 修改手机号 -> 输入新手机号页面
		navigator.register("setupNewPhoneNumber".routerUrl) { url, values, context in
			let vc = AAMineModule.share.mineStoryboard.instantiateViewController(withIdentifier: "SetupNewPhoneNumberVC") as! SetupNewPhoneNumberVC
			return vc
		}
	
	}
}
