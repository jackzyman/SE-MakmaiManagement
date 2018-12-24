//
//  EX-NSError.swift
//  YellowIsDad
//
//  Created by Jarukit Rungruang on 13/12/17.
//  Copyright © 2017 Jarukit Rungruang. All rights reserved.
//

import Foundation
import UIKit

extension NSError {
    public convenience init(domain: String, code: Int) {
        self.init(domain: domain, code: code, userInfo: nil)
    }
    public convenience init(domain: String, code: Int, reason: String, description: String) {
        self.init(domain: domain, code: code, userInfo: [
            NSLocalizedDescriptionKey: NSLocalizedString(description, comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, comment: "")
            ])
    }
}
