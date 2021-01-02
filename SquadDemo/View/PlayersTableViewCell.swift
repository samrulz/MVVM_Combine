//
//  PlayersTableViewCell.swift
//  SquadDemo
//
//  Created by Sandip  on 02/01/21.
//

import UIKit
import Combine

class PlayersTableViewCell: UITableViewCell {
    
    var playersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bindings = Set<AnyCancellable>()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(playersLabel)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: SquadViewModel? {
        didSet {
            setupBinding()
        }
    }
    
    func setupBinding() {
        let position: (String?) -> Void = { [weak self] sa in
            self?.playersLabel.text = sa ?? ""
        }
        
        viewModel?.$playersPosition.receive(on:  DispatchQueue.main)
            .sink(receiveValue: position).store(in: &bindings)
    }
    
    func constraints() {
        playersLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playersLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 15).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -15).isActive = true
        playersLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

}
