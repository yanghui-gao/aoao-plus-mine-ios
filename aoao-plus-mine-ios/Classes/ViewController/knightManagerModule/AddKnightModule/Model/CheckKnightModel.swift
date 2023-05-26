//
//	CheckKnightModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
import aoao_net_ios

class CheckKnightModel : NSObject, NSCoding, AAModelProtocol{

	var id : String!
	var isExistsMobile : Bool!
	var isJump : Bool!
	var message : String!
	var ok : Bool!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["_id"].stringValue
		isExistsMobile = json["is_exists_mobile"].boolValue
		isJump = json["is_jump"].boolValue
		message = json["message"].stringValue
		ok = json["ok"].boolValue
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
		if isExistsMobile != nil{
			dictionary["is_exists_mobile"] = isExistsMobile
		}
		if isJump != nil{
			dictionary["is_jump"] = isJump
		}
		if message != nil{
			dictionary["message"] = message
		}
		if ok != nil{
			dictionary["ok"] = ok
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
         isExistsMobile = aDecoder.decodeObject(forKey: "is_exists_mobile") as? Bool
         isJump = aDecoder.decodeObject(forKey: "is_jump") as? Bool
         message = aDecoder.decodeObject(forKey: "message") as? String
         ok = aDecoder.decodeObject(forKey: "ok") as? Bool

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
		if isExistsMobile != nil{
			aCoder.encode(isExistsMobile, forKey: "is_exists_mobile")
		}
		if isJump != nil{
			aCoder.encode(isJump, forKey: "is_jump")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if ok != nil{
			aCoder.encode(ok, forKey: "ok")
		}

	}

}
