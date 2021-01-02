//
//  Constants.swift
//  SquadDemo
//
//  Created by Sandip  on 02/01/21.
//

import Foundation

let BASE_URL = "https://cricket.yahoo.net/sifeeds/cricket/live/json/sapk01222019186652.json"

enum LoadingState {
    case loading
    case finish
    case error(Error)
}
