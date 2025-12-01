//
//  UserDefaultsKeeperService.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 27.11.2025.
//

import Foundation

public class FakeNFTUserDefaultsKeeperService: FakeNFTUserDefaultsKeeperProtocol {
    func resetUserDefaults() -> ProfileModel {
        return ProfileModel()
    }
    
    func loadUserDefaults() -> ProfileModel{
    do {
            if !checkFileExists(atPath: userDefaultsFullPathURL.absoluteString)
            {
                return resetUserDefaults()
            }
            else {
                let fileContent = try String(contentsOf: userDefaultsFullPathURL, encoding: .utf8)
                guard let loadedUserProfile = try? JSONDecoder().decode(ProfileModel.self, from: fileContent.data(using: .utf8)!) else {
                    let errorMessage = "Ошибка при чтении данных профиля из файла '\(userDefaultsFullPathURL.absoluteString)'"
                    assertionFailure(errorMessage)
                    throw RuntimeError(errorMessage)
                }
                return loadedUserProfile
            }
        } catch {
            print("Ошибка при загрузке профиля: \(error.localizedDescription)")
        }
        return ProfileModel() //TODO: may be later
    }
    
    func saveUserDefaults(_ profile: ProfileModel) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(profile)
            
            // Преобразуем Data в строку
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                assertionFailure("Ошибка преобразования данных в строку")
                return
            }
            
            saveUserDefaults(jsonString)
        } catch {
            assertionFailure("Ошибка сохранения профиля: \(error.localizedDescription)")
        }
        return
    }
    
    private func saveUserDefaults(_ json: String) {
        let directory = userDefaultsFullPathURL.deletingLastPathComponent()
        
        // Создаем папку, если она не существует
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        
        // Записываем данные в файл
        do {
            try json.write(to: userDefaultsFullPathURL, atomically: true, encoding: .utf8)
        } catch {
            print("Ошибка сохранения данных: \(error.localizedDescription)")
        }
    }
    
    
    // Папка для хранения настроек пользователя
    lazy var userDefaultsFolderURL: URL = {
        let folderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return folderUrl.appendingPathComponent("UserDefaults")
    }()
    
    // Полный путь к файлу настроек пользователя
    lazy var userDefaultsFullPathURL: URL = {
        return userDefaultsFolderURL.appendingPathComponent("UserDefaults.json")
    }()
    
    lazy var userDefaultsFullPath: String = {
        var fullPathURL =  userDefaultsFolderURL.appendingPathComponent("UserDefaults.json")
        var fullpath = fullPathURL.absoluteString
        fullpath = fullpath.replacingOccurrences(of: "%20", with: "").replacingOccurrences(of: "file://", with: "")
        return fullpath
    }()
 
    // Функция проверки наличия файла по полному пути
    func checkFileExists(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        let path2 = path.replacingOccurrences(of: "%20", with: " ")
        let path21 = path2.replacingOccurrences(of: "file://", with: "")
        let exists = fileManager.fileExists(atPath: path21)
        return exists
    }

}
