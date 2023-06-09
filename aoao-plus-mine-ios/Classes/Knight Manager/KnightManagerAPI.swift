//
//  KnightManagerAPI.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

enum KnightManagerAPI {
	/// 获取骑手列表
	case getKnightList(workType: UserWorkState, page: Int)
	
	/// 离岗
	case dissmission(knightid: String, workState: UserWorkState)
	
	/// 获取店铺列表
	case getShopList(accountID: String)
	/// 检查骑手信息
	case checkKnightContent(name: String, phone: String, idCardNum: String)
	
	
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
		case .getKnightList(let type, let page):
			params["work_state"] = type.rawValue
			params["_meta"] = ["page":page, "limit": 30]
			
		case .dissmission(let id, let workstate):
			params["_id"] = id
			params["work_state"] = workstate.rawValue
			params["is_root"] = false
			params["is_mock_poi"] = false
			
		case .checkKnightContent(let name, let phone, let idCardNum):
			params["name"] = name
			params["mobile"] = phone
			params["id_card_num"] = idCardNum
		
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
		default:
			break
		}
		
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}
	
	public var headers: [String: String]? {
		switch self {
		case .getKnightList(_,_):
			return ["X-CMD":"aoao.courier.work.allow_courier_find"]
		case .dissmission(_,_):
			return ["X-CMD":"aoao.courier.work.switch_work_state"]
			
		case .getShopList(_):
			return ["X-CMD":"dms.courier.courier_work_store.find"]
		case .checkKnightContent(_, _, _):
			return ["X-CMD":"dms.courier.courier.check"]
		
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
