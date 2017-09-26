//
//  MoyaDummyService.swift
//  RCMVVMSampleLib
//
//  Created by Alberto Salas on 24/8/17.
//  Copyright © 2017 Alberto Salas. All rights reserved.
//

import Foundation
import Moya

enum MoyaDummyService {
	case getItems(searchString: String?)
}

// MARK: - TargetType Protocol Implementation
extension MoyaDummyService: TargetType {
	var baseURL: URL { return URL(string: "https://api.myservice.com")! }
	var path: String { return "/items" }
	var method: Moya.Method { return .get }
	var parameters: [String: Any]? {
		switch self {
		case .getItems(let searchString):
			if let searchString = searchString {
				return ["searchString": searchString]
			} else {
				return nil
			}
		}
	}
	var parameterEncoding: ParameterEncoding { return URLEncoding.default }
	var sampleData: Data { return MoyaDummyServiceUtil.items }
	var task: Task { return Task.requestPlain }
	var headers: [String: String]? { return ["Content-type": "application/json"] }
}

class MoyaDummyServiceUtil {
	
	static var items: Data = {
		guard let url = Bundle(for: MoyaDummyServiceUtil.self).url(forResource: "itemsResponse", withExtension: "json"),
			let data = try? Data(contentsOf: url) else {
				return Data()
		}
		return data
	}()
	
}
