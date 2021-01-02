//
//  SquadView.swift
//  SquadDemo
//
//  Created by Sandip  on 01/01/21.
//

import Foundation
import UIKit

class SquadView: UIView {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PlayersTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var segmentBtn1: UIButton = {
        let btn = UIButton()
        btn.setTitle("AUS", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var segmentBtn2: UIButton = {
        let btn = UIButton()
        btn.setTitle("PAK", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    var pagerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var activityIndicationView: UIActivityIndicatorView = {
        let activityIndicationView = UIActivityIndicatorView(style: .medium)
        activityIndicationView.color = .white
        activityIndicationView.backgroundColor = .darkGray
        activityIndicationView.layer.cornerRadius = 5.0
        activityIndicationView.hidesWhenStopped = true
        activityIndicationView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicationView
    }()
    
    var leadingSpace:NSLayoutConstraint?
    var trailingSpace:NSLayoutConstraint?
    
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        stackView.addArrangedSubview(segmentBtn1)
        stackView.addArrangedSubview(segmentBtn2)
        let subviews = [stackView, pagerView, tableView,activityIndicationView]
        
        subviews.forEach {
            addSubview($0)
        }
    }
    
    func constraints() {
        stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
        segmentBtn1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pagerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
        pagerView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        pagerView.widthAnchor.constraint(equalTo: segmentBtn1.widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        leadingSpace = pagerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        leadingSpace?.isActive = true
        trailingSpace = pagerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: segmentBtn2.frame.width)
        trailingSpace?.isActive = true
        trailingSpace?.priority = UILayoutPriority(rawValue: 250)
        
        tableView.topAnchor.constraint(equalTo: pagerView.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        activityIndicationView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicationView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicationView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func startLoading() {
        tableView.isUserInteractionEnabled = false
        activityIndicationView.isHidden = false
        activityIndicationView.startAnimating()
    }
    
    func finishLoading() {
        tableView.isUserInteractionEnabled = true
        activityIndicationView.stopAnimating()
    }
    
}
