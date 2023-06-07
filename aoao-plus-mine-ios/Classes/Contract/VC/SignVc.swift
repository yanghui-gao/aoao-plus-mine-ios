//
//  SignVc.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/5/29.
//

import UIKit
import aoao_plus_common_ios
import RxSwift

class SignVc: AAViewController {
    
    /// 协议View
    var signView: DrawPathView?
    
    @IBOutlet weak var imageContentView: UIView!

    /// 协议内容高度
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    /// 签约按钮
    @IBOutlet weak var signButton: UIButton!
    /// viewmodel
    var viewModel: SignViewModel?
	/// 协议id
	var pactId:String?

    let disposebag = DisposeBag()
    
    private let contractCreatObservable = PublishSubject<Void>()
	
	private let signObservable = PublishSubject<(_id: String, signBase64: String)>()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.bindViewModel()
		self.contractCreatObservable.onNext(())
    }
    
    func setUI(){
        self.signView = AACommonMoudle.share.DrawPathView
        
        self.signView?.tipLabelText = "申请人签字"
        
        self.signButton.layer.cornerRadius = 4
        
        self.title = "承揽协议"
        
        self.signView?.confirmclosure = { image in
            // 签字后的图片
            self.signView?.isUserInteractionEnabled = false
			guard let id = self.pactId, let base64 = image.imageTobase64Str() else {
				self.signView?.remove()
				self.view.aoaoMakeToast("获取协议失败,请重试")
				return
			}
			// 签名
			self.signObservable.onNext((_id: id, signBase64: base64))
        }

    }
    @IBAction func signleClicked(_ sender: Any) {
        self.signView?.show()
    }
    func bindViewModel(){
		let input = SignViewModel.Input.init(
			contractCreatObservable: contractCreatObservable,
			signObservable: signObservable)
        
        self.viewModel = SignViewModel.init(input: input)
        
		contractCreatObservable.subscribe(onNext: { _ in
            self.view.showLoadingMessage()
            }).disposed(by: disposebag)
		
		signObservable.subscribe(onNext: { _ in
			self.signView?.showLoadingMessage()
			}).disposed(by: disposebag)
		
        // 回调结果
        self.viewModel?.signInfoObservable.subscribe(onNext: { json in
			
            let base64Arr = json["pact_image"].arrayValue.map{$0.stringValue}
            if (json["_id"].stringValue != ""){
                self.pactId = json["_id"].stringValue
            }
            
            let imageArr = base64Arr.map{$0.base64StringToImage()}
            let width = UIScreen.main.bounds.width
            let height = Int(UIScreen.main.bounds.height - 128)
            if (imageArr.count > 0){
                for i in 0...imageArr.count - 1{
                    if let image = imageArr[i] {
                        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0 + (i * height), width: Int(width), height: height))
                        imageView.image = image
                        self.imageContentView.addSubview(imageView)
                    }
                }
                self.contentHeight.constant = CGFloat((imageArr.count * height))
            }
            self.view.dissmissLoadingView()
        }).disposed(by: disposebag)
        
        // 错误处理
        self.viewModel?.errorObservable.subscribe(onNext: { model in
            self.view.dissmissLoadingView()
            self.view.makeToast(model.zhMessage)
            self.signButton.alpha = 0.4
			self.signButton.isEnabled = false
            }).disposed(by: disposebag)
        
        self.viewModel?.singErrorObservable.subscribe(onNext: { model in
			self.signView?.makeToast(model.zhMessage)
			self.signView?.dissmissLoadingView()
			self.signView?.isUserInteractionEnabled = true
			// 签约按钮不可点击
            self.signButton.alpha = 0.4
            self.signButton.isEnabled = false
			
			
            }).disposed(by: disposebag)
        
        // 签名回调
        self.viewModel?.signObservable.subscribe(onNext: { json in
            self.signView?.isUserInteractionEnabled = true
			self.signView?.dissmissLoadingView()
			self.signView?.remove()
			
			self.view.showSuccessMessage(message: "签约成功", handle: {
				guard let viewControllers = self.navigationController?.viewControllers else {
					self.navigationController?.popViewController(animated: true)
					return
				}
				for vc in viewControllers {
					if (vc.theClassName.contains("KnightViewController")) {
						self.navigationController?.popToViewController(vc, animated: true)
						return
					}
				}
				self.navigationController?.popViewController(animated: true)
			})
        }).disposed(by: disposebag)
    }

}
