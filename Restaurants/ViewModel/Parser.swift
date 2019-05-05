//
//  Parser.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/1/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import RxSwift

enum ParsingStatus {
    case NotStarted
    case Success
    case InvalidFile
    case FileNotFound
}
class Parser {
    var status = ParsingStatus.NotStarted
    
    func readJSONFromFile(fileName: String) -> Single<[Restaurant]> {
        return Single<[Restaurant]>.create { single in
//            sleep(5)
            let bundle = Bundle(for: Parser.self)
            if let path = bundle.path(forResource: fileName, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                    let restList = try JSONDecoder().decode(RestaurantList.self, from: data)
                    self.status = .Success
                    single(.success(restList.restaurants))
                }
                catch {
                    self.status = .InvalidFile
                    single(.error(ParsingError.invalidDataFile))
                }
            }
            else {
                self.status = .FileNotFound
                single(.error(ParsingError.fileNotFound))
            }
            return Disposables.create()
        }
    }

    
    
}
