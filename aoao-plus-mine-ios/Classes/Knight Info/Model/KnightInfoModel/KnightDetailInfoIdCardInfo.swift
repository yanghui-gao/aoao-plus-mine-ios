//
//	KnightDetailInfoIdCardInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class KnightDetailInfoIdCardInfo : NSObject, NSCoding{
	/// 反面照片
	var backUrl : String!
	/// 过期时间
	var endDate : Int!
	/// 开始时间
	var fromDate : Int!
	/// 正面照片
	var frontUrl : String!
	/// 手持照片
	var handUrl : String!
	/// 状态【1:未完善，100:已完善，-100:已过期】
	var state : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		backUrl = json["back_url"].stringValue
		endDate = json["end_date"].intValue
		fromDate = json["from_date"].intValue
		frontUrl = json["front_url"].stringValue
		handUrl = json["hand_url"].stringValue
		state = json["state"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if backUrl != nil{
			dictionary["back_url"] = backUrl
		}
		if endDate != nil{
			dictionary["end_date"] = endDate
		}
		if fromDate != nil{
			dictionary["from_date"] = fromDate
		}
		if frontUrl != nil{
			dictionary["front_url"] = frontUrl
		}
		if handUrl != nil{
			dictionary["hand_url"] = handUrl
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
    @objc required init(coder aDecoder: NSCoder)
	{
         backUrl = aDecoder.decodeObject(forKey: "back_url") as? String
         endDate = aDecoder.decodeObject(forKey: "end_date") as? Int
         fromDate = aDecoder.decodeObject(forKey: "from_date") as? Int
         frontUrl = aDecoder.decodeObject(forKey: "front_url") as? String
         handUrl = aDecoder.decodeObject(forKey: "hand_url") as? String
         state = aDecoder.decodeObject(forKey: "state") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if backUrl != nil{
			aCoder.encode(backUrl, forKey: "back_url")
		}
		if endDate != nil{
			aCoder.encode(endDate, forKey: "end_date")
		}
		if fromDate != nil{
			aCoder.encode(fromDate, forKey: "from_date")
		}
		if frontUrl != nil{
			aCoder.encode(frontUrl, forKey: "front_url")
		}
		if handUrl != nil{
			aCoder.encode(handUrl, forKey: "hand_url")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}

	}

}