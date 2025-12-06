//
//  ProfilePresenterProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 29.11.2025.
//

protocol ProfilePresenterProtocol: AnyObject {
    var servicesAssembly: ServicesAssembly {get}
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func updateProfile(profile: ProfileDto)
}
