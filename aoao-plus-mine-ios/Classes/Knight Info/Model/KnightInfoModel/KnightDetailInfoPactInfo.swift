//
//	KnightDetailInfoPactInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class KnightDetailInfoPactInfo : NSObject, NSCoding{

	var allowSign : Bool!
	var endDate : Int!
	var fromDate : Int!
	var pactUrl : String!
	var signState : Int!
	var state : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
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
	func toDictionary() -> [String:Any]
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
    @objc required init(coder aDecoder: NSCoder)
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
    func encode(with aCoder: NSCoder)
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