//
//  SquadViewModel.swift
//  SquadDemo
//
//  Created by Sandip  on 01/01/21.
//

import Foundation
import Combine

class SquadViewModel {
    
    var apiManager: ApimanagerProtocol?

    @Published var pakTeamsObject: Teams?
    @Published var saTeamsObject: Teams?
    @Published var saPlayersArr = [Players]()
    @Published var pakPlayersArr = [Players]()
    @Published var playersPosition: String?
    @Published var state: LoadingState = .loading
    
    var player: Players?
    private var cancellable: AnyCancellable?
    
    init(api: ApimanagerProtocol) {
        self.apiManager = api
        cricketData()
    }
    
    init(player: Players) {
        self.player = player
        setupBinding()
    }
    
    func setupBinding() {
        if self.player?.Iscaptain == true &&  self.player?.Iskeeper == true{
            playersPosition = "\(player?.Name_Full ?? "" ) (c) (wc)"
            
        }else if self.player?.Iscaptain == true {
            playersPosition = "\(player?.Name_Full ?? "") (c)"
        }else if self.player?.Iskeeper == true{
            playersPosition = "\(player?.Name_Full ?? "") (wc)"
        }else {
            playersPosition = "\(player?.Name_Full ?? "")"
        }
    }

    
    func cricketData() {
        let cricketUrl = URL(string:BASE_URL)!
        state = .loading
        apiManager?.getCricketData(requestUrl: cricketUrl, resultType: CricketContainer.self, completionHandler: {[weak self] (response) in
            self?.cancellable = response.sink(receiveCompletion: {completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.state = .error(error)
                case .finished:
                    self?.state = .finish
                    print("Success")
                } } ) { (teams) in
                
                let pakistan = teams.Teams?.teams?.first
                self?.pakTeamsObject = pakistan
                self?.pakPlayersArr = pakistan?.Players?.players ?? []
                let southAfrica = teams.Teams?.teams?.last
                self?.saTeamsObject = southAfrica
                self?.saPlayersArr = southAfrica?.Players?.players ?? []
            }
        })
    }
}

