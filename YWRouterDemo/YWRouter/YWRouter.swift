//
//  YWRouter.swift
//  YWRouterDemo
//
//  Created by 賴弋威 on 2019/1/15.
//  Copyright © 2019 賴弋威. All rights reserved.
//

import Foundation
import UIKit

public struct YWAction<T> {
    public let base: T
    public init(_ base: T) {
        self.base = base
    }
    
}

public protocol YWActionProtocol {
    associatedtype CompatibleType
    var ywAction: YWAction<CompatibleType> { get }
}

extension YWActionProtocol {
    public var ywAction: YWAction<Self> {
        get {
            return YWAction(self)
        }
    }
}

extension NSObject: YWActionProtocol{}

protocol YWRouterPathable {
    var viewcontroller: UIViewController.Type { get } // 定義有哪些VC要使用Router
}
protocol BaseViewControllerDataProvider {
    var parameter: [String: Any?]? { set get }
    init(parameter: [String : Any?]?)
}
protocol YWRoutable {
    //通過RouterPathable中的params來init並塞值
    
    static func initWithParameter(dataProvider: BaseViewControllerDataProvider?) -> UIViewController
}

enum YWViewRouterAction: YWRouterPathable {
    //透過enum定義所有跟Web有關的行為以及需要的參數
    case firstPage(title: String)
    case secondPage(title: String)
    case thirdPage(title: String)
    var viewcontroller: UIViewController.Type {
        // 將各個case與ViewController做連結 在open時需要使用
        switch self {
        case .firstPage:
            return FirstController.self
        case .secondPage:
            return SecondController.self
        case .thirdPage:
            return ThirdController.self
        }
    }
}

struct DataProvider: BaseViewControllerDataProvider {
    var parameter: [String : Any?]?
    init(parameter: [String : Any?]?) {
        self.parameter = parameter
    }
}

class YWRouter {
    open class func open(current: UIViewController?, path: YWViewRouterAction, present: Bool = false, animated: Bool = true, presentComplete: (() -> Void)? = nil) {
        guard let action = path.viewcontroller as? YWRoutable.Type else {
            return
        }
        var vc: UIViewController? = nil
        switch path {
        case .firstPage(let title):
            vc = action.initWithParameter(dataProvider: DataProvider.init(parameter: ["Title": title]))
        case .secondPage(let title):
            vc = action.initWithParameter(dataProvider: DataProvider.init(parameter: ["Title": title]))
        case .thirdPage(let title):
            vc = action.initWithParameter(dataProvider: DataProvider.init(parameter: ["Title": title]))
        }
        guard let currentVC = vc else {
            return
        }
        if present {
            current?.present(currentVC, animated: animated, completion: presentComplete)
        } else {
            if let nav = current?.navigationController {
                nav.pushViewController(currentVC, animated: animated)
            }
        }
    }
}