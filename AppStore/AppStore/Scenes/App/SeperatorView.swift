//
//  SeperatorView.swift
//  AppStore
//
//  Created by Junsu Jang on 2022/05/10.
//

import SnapKit
import UIKit

final class SeperatorView: UIView {
    private lazy var seperator: UIView = {
        let seperator = UIView()
        seperator.backgroundColor = .separator
        
        return seperator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(seperator)
        seperator.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
