//
//	KnightDetailInfoPactInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


public class KnightDetailInfoPactInfo : NSObject, NSCoding{

	/// 是否可以签约
	public var allowSign : Bool!
	/// 过期时间
	public var endDate : Int!
	/// 开始时间
	public var fromDate : Int!
	/// 合同地址
	public var pactUrl : String!
	/// 签约状态
	public var signState : Int!
	/// 合同状态 【1:待签约，10: public 待签约，50:待签约，100:生效中，-100:已失效，-110:已作废
	public var state : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	public init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		allowSign = json["allow_sign"].boolValue
		endDate = json["end_date"].intValue
		fromDate = json["from_date"].intValue
		pactUrl = json["pact_url"].stringValue
		signState = json["sign_state"].intValue
		state = json["state"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	public func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if allowSign != nil{
			dictionary["allow_sign"] = allowSign
		}
		if endDate != nil{
			dictionary["end_date"] = endDate
		}
		if fromDate != nil{
			dictionary["from_date"] = fromDate
		}
		if pactUrl != nil{
			dictionary["pact_url"] = pactUrl
		}
		if signState != nil{
			dictionary["sign_state"] = signState
		}
		if state != nil{
			dictionary["state"] = state
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc public required init(coder aDecoder: NSCoder)
	{
         allowSign = aDecoder.decodeObject(forKey: "allow_sign") as? Bool
         endDate = aDecoder.decodeObject(forKey: "end_date") as? Int
         fromDate = aDecoder.decodeObject(forKey: "from_date") as? Int
         pactUrl = aDecoder.decodeObject(forKey: "pact_url") as? String
         signState = aDecoder.decodeObject(forKey: "sign_state") as? Int
         state = aDecoder.decodeObject(forKey: "state") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
	public func encode(with aCoder: NSCoder)
	{
		if allowSign != nil{
			aCoder.encode(allowSign, forKey: "allow_sign")
		}
		if endDate != nil{
			aCoder.encode(endDate, forKey: "end_date")
		}
		if fromDate != nil{
			aCoder.encode(fromDate, forKey: "from_date")
		}
		if pactUrl != nil{
			aCoder.encode(pactUrl, forKey: "pact_url")
		}
		if signState != nil{
			aCoder.encode(signState, forKey: "sign_state")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}

	}

}
