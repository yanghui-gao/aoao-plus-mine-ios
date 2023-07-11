//
//  ContractAPI.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/5/29.
//

import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

enum ContractAPI {
	/// 获取合同信息
	case getContract(knightID: String)
	/// 创建协议
	case createContract
	/// 签约
	case signContract(id: String, signImg: String)
}
extension ContractAPI: TargetType, AuthenticationProtocol {
	
	
	var method: Moya.Method {
		return .post
	}
	
	var baseURL: URL {
		guard let url = URL(string: basicURL) else {
			fatalError("非法的URL字符串: \(basicURL)")
		}
		return url
	}
	var task: Task {
		var params: [String: Any] = [:]
		switch self {
		case .signContract(let id, let signImg):
			params["pact_id"] = id
			params["sign_img"] = signImg
		case .getContract(let id):
			params["courier_id"] = id
		default:
			break
		}
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}
	
	var headers: [String: String]? {
		switch self {
		case .getContract(_):
			return ["X-CMD": "aoao.courier.pact.find_one"]
		case .signContract(_, _):
			return ["X-CMD": "aoao.courier.pact.sign"]
		case .createContract:
			return ["X-CMD": "aoao.courier.pact.create"]
		}
	}
	var authenticationType: AuthenticationType? {
		return .xToken
	}
}
