//
//  ViewController.swift
//  SquadDemo
//
//  Created by Sandip  on 01/01/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    lazy var squadView = SquadView()
    var viewModel = SquadViewModel(api: Apimanager())
    var bindings = Set<AnyCancellable>()
    var teamFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        cellConfiguration()
        setupBinding()
        title = "Teams"
    }
    
    override func loadView() {
        view = squadView
    }
    
    func uiSetup() {
        squadView.segmentBtn1.addTarget(self, action: #selector(onPressSegmentBtn1(_:)), for: .touchUpInside)
        squadView.segmentBtn2.addTarget(self, action: #selector(onPressSegmentBtn2(_:)), for: .touchUpInside)
    }
    
    func cellConfiguration() {
        squadView.tableView.dataSource = self
    }
    
    @objc func onPressSegmentBtn1(_ sender: UIButton) {
        teamFlag = false
        squadView.tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.squadView.leadingSpace?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func onPressSegmentBtn2(_ sender: UIButton) {
        teamFlag = true
        squadView.tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.squadView.leadingSpace?.constant = self.squadView.segmentBtn1.frame.width
            self.squadView.trailingSpace?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupBinding() {
        let pakistanValueHandler: ([Players]) -> Void = { [weak self] _ in
            self?.squadView.tableView.reloadData()
        }
        
        let southAfricaValueHandler: ([Players]) -> Void = { [weak self] teams in
            self?.squadView.tableView.reloadData()
        }
        
        let pakistan: (Teams?) -> Void = { [weak self] pak in
            self?.squadView.segmentBtn1.setTitle(pak?.Name_Full ?? "", for: .normal)
        }
        
        let southAfrica: (Teams?) -> Void = { [weak self] sa in
            self?.squadView.segmentBtn2.setTitle(sa?.Name_Full ?? "", for: .normal)
            
        }
        
        let stateValueHandler: (LoadingState) -> Void = { [weak self] state in
            switch state {
            case .loading:
                self?.squadView.startLoading()
            case .finish:
                self?.squadView.finishLoading()
            case .error(let error):
                self?.squadView.finishLoading()
                self?.showError(error.localizedDescription)
                
            }
        }
        
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
        
        viewModel.$pakPlayersArr.receive(on:  DispatchQueue.main)
            .sink(receiveValue: pakistanValueHandler).store(in: &bindings)
        
        viewModel.$saPlayersArr.receive(on: DispatchQueue.main)
            .sink(receiveValue: southAfricaValueHandler).store(in: &bindings)
        
        viewModel.$pakTeamsObject.receive(on: DispatchQueue.main)
            .sink(receiveValue: pakistan).store(in: &bindings)
        
        viewModel.$saTeamsObject.receive(on: DispatchQueue.main)
            .sink(receiveValue: southAfrica).store(in: &bindings)
    }
    
    private func showError(_ error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if teamFlag == false {
            return viewModel.pakPlayersArr.count
        }else {
            return viewModel.saPlayersArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlayersTableViewCell else{ return UITableViewCell() }
       
        if teamFlag == false {
            cell.viewModel = SquadViewModel(player: viewModel.pakPlayersArr[indexPath.row])
        }else {
            cell.viewModel = SquadViewModel(player: viewModel.saPlayersArr[indexPath.row])
        }
        return cell
    }
}

