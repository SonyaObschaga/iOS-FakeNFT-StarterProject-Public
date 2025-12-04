//
//  Untitled.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//
import Foundation

typealias ProfileOperationCompletion = (Result<ProfileDto, Error>) -> Void

// Events
typealias ProfileLoadingStarted = () -> Void
typealias ProfileLoadingCompleted = (Result<ProfileDto, Error>) -> Void





