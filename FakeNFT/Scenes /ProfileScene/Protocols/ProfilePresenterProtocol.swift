//
//  ProfilePresenterProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 29.11.2025.
//

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
}
