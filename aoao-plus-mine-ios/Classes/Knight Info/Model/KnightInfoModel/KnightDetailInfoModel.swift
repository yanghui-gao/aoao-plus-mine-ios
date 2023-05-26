//
//	KnightDetailInfoModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
import aoao_plus_common_ios
import aoao_plus_net_ios


class KnightDetailInfoModel : NSObject, NSCoding, AAModelProtocol{

	var id : String!
	/// 归属区域ID
	var areaId : String!
	/// 区域名称
	var areaName : String!
	/// 实名认证的时间
	var authenticationAt : String!
	/// 实名认证状态
	var authenticationState : Int!
	/// 实名认证状态
	var authenticateState : AuthenticationState {
		return AuthenticationState(rawValue: authenticationState) ?? .none
	}
	/// 实名认证的方式 10 身份证 20 人脸识别
	var authenticationType : Int!
	var userAuthenticationType:UserAuthenticationType{
		return UserAuthenticationType(rawValue: authenticationType) ?? .none
	}
	/// 出生日期
	var birthDate : Int!
	/// 城市编码
	var cityCode : String!
	/// 城市名称
	var cityName : String!
	/// 骑手编码
	var code : String!
	/// 创建时间
	var createdAt : String!
	/// 创建人
	var creatorName : String!
	/// 分组ID
	var groupsId : String!
	/// 分组名称
	var groupsName : String!
	/// 健康证信息
	var healthCardInfo : KnightDetailInfoHealthCardInfo!
	/// 健康证状态(1:未完善/100:已完善)
	var healthCardState : Int!
	var userHealthCardState:HealthCardState {
		return HealthCardState(rawValue: healthCardState) ?? .none
	}
	/// 身份信息
	var idCardInfo : KnightDetailInfoIdCardInfo!
	/// 身份证号码
	var idCardNum : String!
	/// 身份证状态【1：未完善/100：已完善】
	var idCardState : Int!
	var userIdCardState: IdCardState {
		return IdCardState(rawValue: idCardState) ?? .none
	}
	/// 入职日期yyyymmdd
	var joinDate : Int!
	/// 居住地址
	var liveAddress : String!
	/// 居住城市编码
	var liveCityCode : String!
	/// 居住城市
	var liveCityName : String!
	/// 姓名
	var name : String!
	/// 民族
	var national : String!
	/// 操作人
	var operatorName : String!
	/// 合同信息
	var pactInfo : KnightDetailInfoPactInfo!
	/// 手机号
	var phone : String!
	/// 角色
	var role : Int!
	var userRole: UserRole {
		return UserRole.init(rawValue: role) ?? .none
	}
	/// 性别
	var sex : Int!
	/// 签约状态
	var signState : Int!
	/// 签约状态
	var userSignState: UserSignState {
		return UserSignState(rawValue: signState) ?? .none
	}
	/// 在职状态
	var state : Int!
	var userJobState:UserJobState {
		return UserJobState.init(rawValue: state) ?? .none
	}
	/// 更新时间
	var updatedAt : String!
	/// 工作状态(100:在岗 -100:离岗)
	var workState : Int!
	var userWorkState: UserWorkState {
		return UserWorkState.init(rawValue: workState) ?? .none
	}
	/// 工作类型10全职，20：兼职
	var workType : Int!
	var userWorkType:UserWorkType {
		return UserWorkType(rawValue: workType) ?? .none
	}

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["_id"].stringValue
		areaId = json["area_id"].stringValue
		areaName = json["area_name"].stringValue
		authenticationAt = json["authentication_at"].stringValue
		authenticationState = json["authentication_state"].intValue
		authenticationType = json["authentication_type"].intValue
		birthDate = json["birth_date"].intValue
		cityCode = json["city_code"].stringValue
		cityName = json["city_name"].stringValue
		code = json["code"].stringValue
		createdAt = json["created_at"].stringValue
		creatorName = json["creator_name"].stringValue
		groupsId = json["groups_id"].stringValue
		groupsName = json["groups_name"].stringValue
		let healthCardInfoJson = json["health_card_info"]
		if !healthCardInfoJson.isEmpty{
			healthCardInfo = KnightDetailInfoHealthCardInfo(fromJson: healthCardInfoJson)
		}
		healthCardState = json["health_card_state"].intValue
		let idCardInfoJson = json["id_card_info"]
		if !idCardInfoJson.isEmpty{
			idCardInfo = KnightDetailInfoIdCardInfo(fromJson: idCardInfoJson)
		}
		idCardNum = json["id_card_num"].stringValue
		idCardState = json["id_card_state"].intValue
		joinDate = json["join_date"].intValue
		liveAddress = json["live_address"].stringValue
		liveCityCode = json["live_city_code"].stringValue
		liveCityName = json["live_city_name"].stringValue
		name = json["name"].stringValue
		national = json["national"].stringValue
		operatorName = json["operator_name"].stringValue
		let pactInfoJson = json["pact_info"]
		if !pactInfoJson.isEmpty{
			pactInfo = KnightDetailInfoPactInfo(fromJson: pactInfoJson)
		}
		phone = json["phone"].stringValue
		role = json["role"].intValue
		sex = json["sex"].intValue
		signState = json["sign_state"].intValue
		state = json["state"].intValue
		updatedAt = json["updated_at"].stringValue
		workState = json["work_state"].intValue
		workType = json["work_type"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if areaId != nil{
			dictionary["area_id"] = areaId
		}
		if areaName != nil{
			dictionary["area_name"] = areaName
		}
		if authenticationAt != nil{
			dictionary["authentication_at"] = authenticationAt
		}
		if authenticationState != nil{
			dictionary["authentication_state"] = authenticationState
		}
		if authenticationType != nil{
			dictionary["authentication_type"] = authenticationType
		}
		if birthDate != nil{
			dictionary["birth_date"] = birthDate
		}
		if cityCode != nil{
			dictionary["city_code"] = cityCode
		}
		if cityName != nil{
			dictionary["city_name"] = cityName
		}
		if code != nil{
			dictionary["code"] = code
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if creatorName != nil{
			dictionary["creator_name"] = creatorName
		}
		if groupsId != nil{
			dictionary["groups_id"] = groupsId
		}
		if groupsName != nil{
			dictionary["groups_name"] = groupsName
		}
		if healthCardInfo != nil{
			dictionary["health_card_info"] = healthCardInfo.toDictionary()
		}
		if healthCardState != nil{
			dictionary["health_card_state"] = healthCardState
		}
		if idCardInfo != nil{
			dictionary["id_card_info"] = idCardInfo.toDictionary()
		}
		if idCardNum != nil{
			dictionary["id_card_num"] = idCardNum
		}
		if idCardState != nil{
			dictionary["id_card_state"] = idCardState
		}
		if joinDate != nil{
			dictionary["join_date"] = joinDate
		}
		if liveAddress != nil{
			dictionary["live_address"] = liveAddress
		}
		if liveCityCode != nil{
			dictionary["live_city_code"] = liveCityCode
		}
		if liveCityName != nil{
			dictionary["live_city_name"] = liveCityName
		}
		if name != nil{
			dictionary["name"] = name
		}
		if national != nil{
			dictionary["national"] = national
		}
		if operatorName != nil{
			dictionary["operator_name"] = operatorName
		}
		if pactInfo != nil{
			dictionary["pact_info"] = pactInfo.toDictionary()
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if role != nil{
			dictionary["role"] = role
		}
		if sex != nil{
			dictionary["sex"] = sex
		}
		if signState != nil{
			dictionary["sign_state"] = signState
		}
		if state != nil{
			dictionary["state"] = state
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if workState != nil{
			dictionary["work_state"] = workState
		}
		if workType != nil{
			dictionary["work_type"] = workType
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         areaId = aDecoder.decodeObject(forKey: "area_id") as? String
         areaName = aDecoder.decodeObject(forKey: "area_name") as? String
         authenticationAt = aDecoder.decodeObject(forKey: "authentication_at") as? String
         authenticationState = aDecoder.decodeObject(forKey: "authentication_state") as? Int
         authenticationType = aDecoder.decodeObject(forKey: "authentication_type") as? Int
         birthDate = aDecoder.decodeObject(forKey: "birth_date") as? Int
         cityCode = aDecoder.decodeObject(forKey: "city_code") as? String
         cityName = aDecoder.decodeObject(forKey: "city_name") as? String
         code = aDecoder.decodeObject(forKey: "code") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         creatorName = aDecoder.decodeObject(forKey: "creator_name") as? String
         groupsId = aDecoder.decodeObject(forKey: "groups_id") as? String
         groupsName = aDecoder.decodeObject(forKey: "groups_name") as? String
         healthCardInfo = aDecoder.decodeObject(forKey: "health_card_info") as? KnightDetailInfoHealthCardInfo
         healthCardState = aDecoder.decodeObject(forKey: "health_card_state") as? Int
         idCardInfo = aDecoder.decodeObject(forKey: "id_card_info") as? KnightDetailInfoIdCardInfo
         idCardNum = aDecoder.decodeObject(forKey: "id_card_num") as? String
         idCardState = aDecoder.decodeObject(forKey: "id_card_state") as? Int
         joinDate = aDecoder.decodeObject(forKey: "join_date") as? Int
         liveAddress = aDecoder.decodeObject(forKey: "live_address") as? String
         liveCityCode = aDecoder.decodeObject(forKey: "live_city_code") as? String
         liveCityName = aDecoder.decodeObject(forKey: "live_city_name") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         national = aDecoder.decodeObject(forKey: "national") as? String
         operatorName = aDecoder.decodeObject(forKey: "operator_name") as? String
         pactInfo = aDecoder.decodeObject(forKey: "pact_info") as? KnightDetailInfoPactInfo
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         role = aDecoder.decodeObject(forKey: "role") as? Int
         sex = aDecoder.decodeObject(forKey: "sex") as? Int
         signState = aDecoder.decodeObject(forKey: "sign_state") as? Int
         state = aDecoder.decodeObject(forKey: "state") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         workState = aDecoder.decodeObject(forKey: "work_state") as? Int
         workType = aDecoder.decodeObject(forKey: "work_type") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if areaId != nil{
			aCoder.encode(areaId, forKey: "area_id")
		}
		if areaName != nil{
			aCoder.encode(areaName, forKey: "area_name")
		}
		if authenticationAt != nil{
			aCoder.encode(authenticationAt, forKey: "authentication_at")
		}
		if authenticationState != nil{
			aCoder.encode(authenticationState, forKey: "authentication_state")
		}
		if authenticationType != nil{
			aCoder.encode(authenticationType, forKey: "authentication_type")
		}
		if birthDate != nil{
			aCoder.encode(birthDate, forKey: "birth_date")
		}
		if cityCode != nil{
			aCoder.encode(cityCode, forKey: "city_code")
		}
		if cityName != nil{
			aCoder.encode(cityName, forKey: "city_name")
		}
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if creatorName != nil{
			aCoder.encode(creatorName, forKey: "creator_name")
		}
		if groupsId != nil{
			aCoder.encode(groupsId, forKey: "groups_id")
		}
		if groupsName != nil{
			aCoder.encode(groupsName, forKey: "groups_name")
		}
		if healthCardInfo != nil{
			aCoder.encode(healthCardInfo, forKey: "health_card_info")
		}
		if healthCardState != nil{
			aCoder.encode(healthCardState, forKey: "health_card_state")
		}
		if idCardInfo != nil{
			aCoder.encode(idCardInfo, forKey: "id_card_info")
		}
		if idCardNum != nil{
			aCoder.encode(idCardNum, forKey: "id_card_num")
		}
		if idCardState != nil{
			aCoder.encode(idCardState, forKey: "id_card_state")
		}
		if joinDate != nil{
			aCoder.encode(joinDate, forKey: "join_date")
		}
		if liveAddress != nil{
			aCoder.encode(liveAddress, forKey: "live_address")
		}
		if liveCityCode != nil{
			aCoder.encode(liveCityCode, forKey: "live_city_code")
		}
		if liveCityName != nil{
			aCoder.encode(liveCityName, forKey: "live_city_name")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if national != nil{
			aCoder.encode(national, forKey: "national")
		}
		if operatorName != nil{
			aCoder.encode(operatorName, forKey: "operator_name")
		}
		if pactInfo != nil{
			aCoder.encode(pactInfo, forKey: "pact_info")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if role != nil{
			aCoder.encode(role, forKey: "role")
		}
		if sex != nil{
			aCoder.encode(sex, forKey: "sex")
		}
		if signState != nil{
			aCoder.encode(signState, forKey: "sign_state")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if workState != nil{
			aCoder.encode(workState, forKey: "work_state")
		}
		if workType != nil{
			aCoder.encode(workType, forKey: "work_type")
		}

	}

}
