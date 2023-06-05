//
//  UpLoadVaccineContentAPI.swift
//  flashman
//
//  Created by 高炀辉 on 2021/1/25.
//  Copyright © 2021 white. All rights reserved.
//

import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

public enum UpLoadVaccineContentAPI {
	// MARK: 3.0
	/// 获取旧手机号验证码
	case getCode(phone:String, event:InputCodeType)
	
	/// 退出登录
	case loginOut
	// MARK: 2.0
	
	
	/// 保存附件信息
	case upLoadVaccineContent(courierId: String,
							  vaccinationDate: String?,
							  testingDate: String?,
							  testingExpireDate: String?,
							  testingAssetKey: String?,
							  vaccinationAssetKey: String?)
	/// 更新
	case upDateVaccineContent(vaccinationId: String,
							  vaccinationDate: String?,
							  testingDate: String?,
							  testingExpireDate: String?,
							  testingAssetKey: String?,
							  vaccinationAssetKey: String?)
	/// 获取附件信息
	case getVaccineContent(vaccinationId: String)
    
    /// 获取骑手信息
    case getKnightContent(accountID: String)
	
	/// 更新骑手在职状态 - 关闭接单状态
	case switchWorkState(id: String, workState: Int)
	
	
	
	/// 获取骑手统计信息(折线图)
    case getStatisticsList(courierid: String, storeID: String, fromDate: String, toDate: String)
	/// 获取骑手统计信息
    case getStatistics(courierid: String, storeID: String, date: String)
	
	
	
	/// 校验手机号是否合法
	case checkNewPhone(phone: String, idCardNum: String)
	
	/// 获取店铺列表
	case getShopList(accountID: String)
	
	/// 设置新密码
	case setNewPassWord(oldPassword:String?, password: String)
}
extension UpLoadVaccineContentAPI: TargetType, AuthenticationProtocol {
	public var baseURL: URL {
		guard let url = URL(string: basicURL) else {
			fatalError("非法的URL字符串: \(basicURL)")
		}
		return url
	}
	public var method: Moya.Method {
		return .post
    }
	public var task: Task {
		var params: [String: Any] = [:]
		switch self {
		case .upLoadVaccineContent(let courierId,
								   let vaccinationDate,
								   let testingDate,
								   let testingExpireDate,
								   let testingAssetKey,
								   let vaccinationAssetKey):
			params["courier_id"] = courierId
            if let vaccinationDate = vaccinationDate, !vaccinationDate.isEmpty {
                params["vaccination_date"] = vaccinationDate
            }
            if let testingExpireDate = testingExpireDate, !testingExpireDate.isEmpty {
                params["testing_expire_date"] = testingExpireDate
            }
            if let testingDate = testingDate, !testingDate.isEmpty {
                params["testing_date"] = testingDate
            }
			params["testing_asset_key"] = testingAssetKey
			params["vaccination_asset_key"] = vaccinationAssetKey
		case .getVaccineContent(let id):
			params["_id"] = id
        case .getKnightContent(let id):
            params["_id"] = id
		case .switchWorkState(let accountID, let workState):
			params["_id"] = accountID
			params["work_state"] = workState
		case .upDateVaccineContent(let id,
								   let vaccinationDate,
								   let testingDate,
								   let testingExpireDate,
								   let testingAssetKey,
								   let vaccinationAssetKey):
            if let vaccinationDate = vaccinationDate, !vaccinationDate.isEmpty {
                params["vaccination_date"] = vaccinationDate
            }
            if let testingExpireDate = testingExpireDate, !testingExpireDate.isEmpty {
                params["testing_expire_date"] = testingExpireDate
            }
            if let testingDate = testingDate, !testingDate.isEmpty {
                params["testing_date"] = testingDate
            }
			params["testing_asset_key"] = testingAssetKey
			params["_id"] = id
			params["vaccination_asset_key"] = vaccinationAssetKey
		case .getStatisticsList(let courierid, let storeID, let from_date, let end_date):
			params["courier_id"] = courierid
			params["store_id"] = storeID
			params["from_date"] = from_date
			params["end_date"] = end_date
			
		case .getStatistics(let id, let storeID, let date):
			params["courier_id"] = id
			params["work_month"] = date
			params["store_id"] = storeID
			
		case .getShopList(let accountID):
			params["courier_id"] = accountID
            params["state"] = 100
		case .checkNewPhone(let phone, let idCardNum):
			params["mobile"] = phone
			params["id_card_num"] = idCardNum
		case .getCode(let phone, let event):
			params["phone"] = phone
			params["event"] = event.eventString()
		case .setNewPassWord(let oldPassword, let password):
			params["password"] = password
			params["raw_password"] = oldPassword
		default:
			break
		}
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}

	public var headers: [String: String]? {
		switch self {
			// MARK: 3.0
		case .loginOut:
			return ["X-CMD":"aoao.auth.token.logout"]
		case .getCode(_, _):
			return ["X-CMD":"aoao.auth.auth.send_verify_code"]
			// MARK: 2.0
		case .getVaccineContent(_):
			return ["X-CMD":"dms.certificate.vaccination.get"]
		case .setNewPassWord(_,_):
			return ["X-CMD":"aoao.auth.token.reset_password"]
		case .getShopList(_):
			return ["X-CMD":"dms.courier.courier_work_store.find"]
		case .upLoadVaccineContent(_, _, _, _, _, _):
			return ["X-CMD":"dms.certificate.vaccination.submit"]
		case .upDateVaccineContent(_, _, _, _, _, _):
			return ["X-CMD":"dms.certificate.vaccination.update"]
		case .getKnightContent(_):
			return ["X-CMD":"dms.courier.courier.get"]
		case .switchWorkState(_, _):
			return ["X-CMD":"dms.courier.courier.switch_work_state"]
			
		case .getStatisticsList(_, _, _, _):
			return ["X-CMD":"dms.statistic.order.find_range_daily_courier_order"]
		case .getStatistics(_, _, _):
			return ["X-CMD":"dms.statistic.order.get_daily_courier_order"]
		case .checkNewPhone(_, _):
			return ["X-CMD":"dms.courier.courier.check"]
		}
	}
	public var authenticationType: AuthenticationType? {
		switch self {
		case .getCode(_,_):
			return .xAuth
		default:
			return .xToken
		}
	}
}
