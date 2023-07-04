//
//  UserInfoMationVc.swift
//  boss-mine-ios
//
//  Created by 高炀辉 on 2020/8/27.
//

import UIKit
import Kingfisher
import RxSwift
import aoao_plus_common_ios
import SwiftyJSON

class UserInfomationVc: AAViewController {
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 性别
    @IBOutlet weak var genderLabel: UILabel!
    /// 出生日期
    @IBOutlet weak var birthDateLabel: UILabel!
    /// 民族
    @IBOutlet weak var nationalLabel: UILabel!
    /// 身份证号
    @IBOutlet weak var idCardNumberLabel: UILabel!
	/// 更新身份信息
    @IBOutlet weak var updateTemporaryIDInfoButton: UIButton!
    /// 身份类型Label
	@IBOutlet weak var idCardTypeLabel: UILabel!
	/// 有效期
	@IBOutlet weak var PeriodValidityLabel: UILabel!
	/// 身份证照片上传状态
	@IBOutlet weak var idCardImageState: UILabel!
	
	@IBOutlet weak var idCardTipLabel: UILabel!
	
	var userInfoModel: KnightDetailInfoModel?
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
		bindViewModel()
    }
    
    func setUI(){
        self.title = "身份信息"
        self.updateTemporaryIDInfoButton.layer.cornerRadius = 4
		
        if let model = userInfoModel{
            // 当 可以更改身份信息 且 身份信息为 临时身份信息时
			nameLabel.text = model.name
            genderLabel.text  = model.gender
            birthDateLabel.text = model.birthDateStr
            nationalLabel.text = model.national
            idCardNumberLabel.text = model.idCardStr
			idCardTypeLabel.text = model.idCardInfo.idCardTypeStr
            PeriodValidityLabel.text = model.idCardInfo.idCardStartDateStr + "~" + model.idCardInfo.idCardEndDateStr
			
			
			
			PeriodValidityLabel.textColor = model.idCardInfo.idCardIsOverDate ? .red : UIColor(named: "boss_000000-90_FFFFFF-90", in: AAMineModule.share.bundle, compatibleWith: nil) ?? .black
			
			idCardImageState.textColor = model.idCardInfo.idCardIsOverDate ? .red : UIColor(named: "boss_000000-90_FFFFFF-90", in: AAMineModule.share.bundle, compatibleWith: nil) ?? .black
			
			idCardImageState.text = model.idCardInfo.idCardIsOverDate ? "已过期" : "已上传"
			
			if model.id == UserModelManager.manager.userInfoModel?.id {
				/// 如果查看的是本人的信息可以更新用户信息
				self.updateTemporaryIDInfoButton.isHidden = false
				self.idCardTipLabel.isHidden = model.idCardInfo.isHiddenTipLabel
				self.idCardTipLabel.text = model.idCardInfo.idCardTipLabelText
			} else {
				self.updateTemporaryIDInfoButton.isHidden = true
				self.idCardTipLabel.isHidden = true
			}
        }
    }
	
	func bindViewModel() {
		/// 跳转更新身份证
		updateTemporaryIDInfoButton.rx.tap.subscribe(onNext: { _ in
			"updateIdentityCard".openURL()
		}).disposed(by: disposeBag)
	}
}
