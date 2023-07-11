//
//  FeedBackViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/29.
//

import UIKit
import aoao_plus_common_ios

class FeedBackViewController: AAViewController {

	@IBOutlet weak var contentTextView: UITextView!
	
	@IBOutlet weak var commitButton: UIButton!
	
	@IBOutlet weak var charCountLabel: UILabel!
	
	let placeholder = "请输入您的宝贵意见"
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
    }

	func setUI() {
		self.title = "意见反馈"
		self.commitButton.layer.cornerRadius = 4
		self.view.backgroundColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		self.contentTextView.textColor = .lightGray
	}
	
	@IBAction func commit(_ sender: UIButton) {
		guard let text = self.contentTextView.text, text != self.placeholder else {
			self.view.makeToast("请输入意见反馈内容")
			return
		}
		print(text)
//		Analytics.logEvent("feedBack", parameters: ["content": text])
		self.navigationController?.popViewController(animated: true)
	}
	
}
extension FeedBackViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = placeholder
			textView.textColor = UIColor.lightGray
		}
	}
	func textViewDidChange(_ textView: UITextView) {
		self.charCountLabel.text = "\(self.contentTextView.text.count)/100"
	}
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return textView.text.count + (text.count - range.length) <= 100
	}
}
