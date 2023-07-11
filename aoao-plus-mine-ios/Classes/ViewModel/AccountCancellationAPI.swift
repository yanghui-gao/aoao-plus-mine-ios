//
//  AccountCancellationAPI.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2023/3/29.
//

import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

public enum AccountCancellationAPI {
	/// 发起注销
	case accountCancellation

}
extension AccountCancellationAPI: TargetType, AuthenticationProtocol {
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
		let params: [String: Any] = [:]
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}

	public var headers: [String: String]? {
		switch self{
		case .accountCancellation:
			return ["X-CMD":"aoao.courier.courier.deactivate"]
		}
	}
	public var authenticationType: AuthenticationType? {
		switch self {
		default:
			return .xToken
		}
	}
}

