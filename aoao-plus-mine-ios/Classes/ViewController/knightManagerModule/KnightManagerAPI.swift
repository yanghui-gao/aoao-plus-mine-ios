//
//  KnightManagerAPI.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import Foundation
import Moya
import aoao_net_ios
import RxSwift
import aoao_common_ios

enum KnightManagerAPI {
	/// 获取店铺列表
	case getShopList(accountID: String)
	/// 检查骑手信息
	case checkKnightContent(name: String, phone: String, idCardNum: String)
	/// 获取当前店铺骑手列表
	case getCurrentStoreKnightList(storeID: String)
	/// 离岗
	case dissmission(accountID: String, storeID: String, workState: WorKState)
	/// 创建骑手
	case createKnight(name:String, mobile:String, idCardNum: String, courier_store_maps:
					  [(storeID: String, merchantID: String, role: KnightRoleType, workType: KnightWorkType)])
	/// 离岗
	case editKnightShopList(courier_store_maps:
								[(storeID: String, merchantID: String, role: KnightRoleType, workType: KnightWorkType, courierid: String, opt: String)])
}
extension KnightManagerAPI: TargetType, AuthenticationProtocol {
	
	
	var method: Moya.Method {
		return .post
	}
	
	var baseURL: URL {
		guard let url = URL(string: basicURL) else {
			fatalError("非法的URL字符串: \(basicURL)")
		}
		return url
	}
	public var task: Task {
		var params: [String: Any] = [:]
		switch self {
		case .getShopList(let accountID):
			params["courier_id"] = accountID
			params["state"] = 100
		case .checkKnightContent(let name, let phone, let idCardNum):
			params["name"] = name
			params["mobile"] = phone
			params["id_card_num"] = idCardNum
		case .getCurrentStoreKnightList(let storeID):
			params["store_id"] =  storeID
		case .dissmission(let accountID, let storeID, let workstate):
			params["courier_id"] = accountID
			params["store_id"] = storeID
			params["work_state"] = workstate.rawValue
		case .createKnight(let name, let mobile, let idCardNum,let courier_store_maps):
			params["name"] = name
			params["mobile"] = mobile
			params["id_card_num"] = idCardNum
			let dic = courier_store_maps.map{ model in
				return ["store_id": model.storeID,
						"biz_mode": 10,
						"work_type": model.workType.rawValue,
						"role": model.role.rawValue,
						"merchant_id": model.merchantID
				]
			}
			params["courier_store_maps"] = dic
		case .editKnightShopList(let courier_store_maps):
			let dic = courier_store_maps.map{ model in
				return ["store_id": model.storeID,
						"biz_mode": 10,
						"work_type": model.workType.rawValue,
						"role": model.role.rawValue,
						"merchant_id": model.merchantID,
						"courier_id": model.courierid,
						"opt": "create"
				]
			}
			params["courier_store_maps"] = dic
		}
		
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}
	
	public var headers: [String: String]? {
		switch self {
		case .getShopList(_):
			return ["X-CMD":"dms.courier.courier_work_store.find"]
		case .checkKnightContent(_, _, _):
			return ["X-CMD":"dms.courier.courier.check"]
		case .getCurrentStoreKnightList(_):
			return ["X-CMD":"dms.merchant.store.find_courier_realtime_monitor"]
		case .dissmission(_,_,_):
			return ["X-CMD":"dms.courier.courier.switch_work_state_v2"]
		case .createKnight(_,_,_,_):
			return ["X-CMD":"dms.courier.courier.create"]
		case .editKnightShopList(_):
			return ["X-CMD":"dms.courier.courier_work_store.batch_update"]
		}
	}
	
	public var authenticationType: AuthenticationType? {
		return .xToken
	}
}
