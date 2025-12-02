//
//  FakeNFTMockData.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

class FakeNFTMockData {
    lazy var usersDto: [ProfileDto] = {
        let data = FakeNFTMockData()
        guard let jsonData = data.getUserProfilesJSON().data(using: .utf8),
              let users = try? JSONDecoder().decode([ProfileDto].self, from: jsonData) else {
            assertionFailure("Failed to load users mock data")
            return []
        }
        
        guard users.count >= FakeNFTService.DEFAULT_USER_INDEX else {
            assertionFailure("Default user index exceeds loaded users array length")
            return []
        }
        return users
    }()

    var nftsDtos: [NFTDto] {
        let data = FakeNFTMockData()
        guard let jsonData = data.getFakeNFTsJSON().data(using: .utf8)
                
        else {
            return []
        }
        do {
            let nfts = try NFTDto.decodeFromJSONArray(jsonData)
            return nfts
        } catch {
            print("Ошибка декодирования: \(error.localizedDescription)")
            return []
        }
    }
    
    // Данные профиля пользователя по умолчанию
    func defaultUserProfileJSON() -> String {
        return """
                    {
                      "name": "Joaqin Phoenix",
                      "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/350.jpg",
                      "description": "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100 NFT, и еще больше — на моём сайте.",
                      "website": "https://practicum.yandex.ru/visual-presentation/",
                      "nfts": [ "ca34d35a-4507-47d9-9312-5ea7053994c0",
                                "1e649115-1d4f-4026-ad56-9551a16763ee",
                                "28829968-8639-4e08-8853-2f30fcf09783",
                                "7773e33c-ec15-4230-a102-92426a3a6d5a",
                                "9e472edf-ed51-4901-8cfc-8eb3f617519f",
                                "eb959204-76cc-46ef-ba07-aefa036ca1a5",
                                "fc92edf5-1355-4246-b3b7-d64bc54d1abd",
                                "a4edeccd-ad7c-4c7f-b09e-6edec02a812b" ],
                      "likes": [
                                "1e649115-1d4f-4026-ad56-9551a16763ee",
                                "28829968-8639-4e08-8853-2f30fcf09783",
                                "7773e33c-ec15-4230-a102-92426a3a6d5a"],
                      "rating": "1",
                      "id": "226bbeab-14ef-42e7-9826-7749bfa05603"
                    }
    """
    }
    
    // Массив профилей пользователей
    func getUserProfilesJSON() -> String {
        return """
                [
                    {
                    "name": "Joaquin Phoenix",
                    "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/350.jpg",
                    "description": "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100 NFT, и еще больше — на моём сайте.",
                    "website": "Joaquin Phoenix.com",
                    "nfts": [ "ca34d35a-4507-47d9-9312-5ea7053994c0",
                              "1e649115-1d4f-4026-ad56-9551a16763ee",
                              "28829968-8639-4e08-8853-2f30fcf09783",
                              "7773e33c-ec15-4230-a102-92426a3a6d5a",
                              "9e472edf-ed51-4901-8cfc-8eb3f617519f",
                              "eb959204-76cc-46ef-ba07-aefa036ca1a5",
                              "fc92edf5-1355-4246-b3b7-d64bc54d1abd",
                              "a4edeccd-ad7c-4c7f-b09e-6edec02a812b" ],
                  "likes": [
                            "1e649115-1d4f-4026-ad56-9551a16763ee",
                            "28829968-8639-4e08-8853-2f30fcf09783",
                            "7773e33c-ec15-4230-a102-92426a3a6d5a"],
                    "rating": "1",
                    "id": "226bbeab-14ef-42e7-9826-7749bfa05603"
                  },
                  {
                    "name": "Blair Hull",
                    "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/553.jpg",
                    "description": null,
                    "website": "https://practicum.yandex.ru/promo/courses/application-security",
                    "nfts": [
                                "7773e33c-ec15-4230-a102-92426a3a6d5a",
                                "ca34d35a-4507-47d9-9312-5ea7053994c0",
                                "28829968-8639-4e08-8853-2f30fcf09783",
                                "9e472edf-ed51-4901-8cfc-8eb3f617519f",
                                "fc92edf5-1355-4246-b3b7-d64bc54d1abd",
                                "a4edeccd-ad7c-4c7f-b09e-6edec02a812b",
                                "eb959204-76cc-46ef-ba07-aefa036ca1a5",
                                "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
                                "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
                                "3434c774-0e0f-476e-a314-24f4f0dfed86",
                                "594aaf01-5962-4ab7-a6b5-470ea37beb93",
                                "83c23ccc-1368-4da8-b54d-76c9b235835b",
                                "cc74e9ab-2189-465f-a1a6-8405e07e9fe4",
                                "0ddb6c9b-20c1-4891-9b1c-f5f4bb2be2fb",
                                "7dc60644-d3cd-4cf9-9854-f5293ebe93f7",
                                "75a45377-a978-4969-965f-17e0d216a01a"
                              ],
                    "rating": "2",
                    "id": "aa87dab8-01e5-4aa8-957e-951e3edcb363"
                  },
                  {
                    "name": "Jacob Rodriquez",
                    "avatar": "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/597.jpg",
                    "description": null,
                    "website": "https://practicum.yandex.ru/algorithms/",
                    "nfts": [],
                    "rating": "2",
                    "id": "c4fbbf06-749c-4902-8dce-94ea95fb5ece"
                  },
                  {
                    "name": "Landon Armstrong",
                    "avatar": "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0",
                    "description": "learn it all",
                    "website": "https://cloud.yandex.ru/training/production",
                    "nfts": [
                        "7dc60644-d3cd-4cf9-9854-f5293ebe93f7",
                        "75a45377-a978-4969-965f-17e0d216a01a",
                        "0bc94496-379c-4c3d-a437-8aea459dd008",
                        "2c9d09f6-25ac-4d6f-8d6a-175c4de2b42f",
                        "a7efecb7-caf8-412c-838e-01e4d432907b",
                        "89e16821-0a25-44b8-b199-fa8183c19dd9",
                        "db196ee3-07ef-44e7-8ff5-16548fc6f434",
                        "f380f245-0264-4b42-8e7e-c4486e237504",
                        "458dbc0d-3cc0-4894-90ac-319888ca3c60",
                        "d02ecb5a-2e45-4b82-9f6b-9200e0eec88a",
                        "d6a02bd1-1255-46cd-815b-656174c1d9c0",
                        "b6d0e246-d317-4f3e-b0c9-b4a2ce4d4c2a",
                        "9810d484-c3fc-49e8-bc73-f5e602c36b40",
                        "82570704-14ac-4679-9436-050f4a32a8a0",
                        "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3",
                        "35957714-585d-443f-ad9d-6cb994b64377",
                        "497a53d1-b5c1-4777-bdcc-48050d032df5",
                        "6ff48b36-68ff-4192-87e3-f11669123a97",
                        "18231384-1291-42ae-8776-e699fb839687",
                        "5a30697e-23aa-40c1-b28d-c7f6385d93ad",
                        "8c18e88f-50e7-407e-9232-054e8eef9bb9",
                        "ce04d6a5-e3dc-4c67-ac71-037b001da91d",
                        "3dbad332-2c3b-43b1-94cf-4c4aaad21a18",
                        "9046bec6-fd58-409d-8d54-6188ae8873f8",
                        "2aa0ba3a-9273-49a5-8812-78fcc0ca1234",
                        "de7c0518-6379-443b-a4be-81f5a7655f48",
                        "e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb",
                        "35670864-8997-492c-be36-2a1c7c7a2bd4",
                        "45e7c144-77d1-471f-8aa3-bc490c629aba",
                        "933ed94d-2b94-4163-944a-3813aa4503f8",
                        "34c50a1f-e66b-4617-b7a9-8307bb0769af",
                        "5e5c7b47-3086-483b-8b90-70a7cabcdeb4",
                        "a640ea4f-fe73-4994-835a-a715542cdaeb",
                        "7f93b6b6-9f42-4a8c-b238-8edab95098a7",
                        "256e28df-aa17-46e4-9586-cb78aab7143c",
                        "5cd791a3-96cd-4ac3-92cd-744f7422fb31",
                        "90758b01-1ba2-4b2c-a7af-09bdc17d2679",
                        "04b79f11-313e-47b4-bd26-f513b77ed264",
                        "507004f5-1cef-4f56-9739-0e506989d633",
                        "e33e18d5-4fc2-466d-b651-028f78d771b8"
                    ],
                    "rating": "1",
                    "id": "54109550-3338-457f-81d5-2e54d69e7125"
                  }
                ]
    """
    }
    
    // Массив NFT
    func getFakeNFTsJSON() -> String {
        return """
                [
                  {
                    "CreatedAt": "2023-05-22T13:05:07.672Z[GMT]",
                    "Name": "Mattie McDaniel",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/3.png"
                    ],
                    "Rating": 1,
                    "Description": "noluisse euismod iudicabit saperet mattis",
                    "Price": 28.82,
                    "Author": "https://objective_yalow.fakenfts.org/",
                    "Id": "1e649115-1d4f-4026-ad56-9551a16763ee"
                  },
                  {
                    "CreatedAt": "2023-10-08T07:43:22.944Z[GMT]",
                    "Name": "Rosario Dejesus",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Finn/3.png"
                    ],
                    "Rating": 3,
                    "Description": "explicari lobortis rutrum evertitur fugit convenire ligula",
                    "Price": 28.27,
                    "Author": "https://unruffled_cohen.fakenfts.org/",
                    "Id": "7773e33c-ec15-4230-a102-92426a3a6d5a"
                  },
                  {
                    "CreatedAt": "2023-07-01T23:14:47.494Z[GMT]",
                    "Name": "Jody Rivers",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/3.png"
                    ],
                    "Rating": 4,
                    "Description": "posse honestatis lobortis tritani scelerisque inimicus",
                    "Price": 49.64,
                    "Author": "https://dazzling_meninsky.fakenfts.org/",
                    "Id": "ca34d35a-4507-47d9-9312-5ea7053994c0"
                  },
                  {
                    "CreatedAt": "2023-10-04T16:29:26.011Z[GMT]",
                    "Name": "Olive Avila",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png"
                    ],
                    "Rating": 2,
                    "Description": "saepe patrioque recteque doming fabellas harum libero",
                    "Price": 21.0,
                    "Author": "https://amazing_cerf.fakenfts.org/",
                    "Id": "28829968-8639-4e08-8853-2f30fcf09783"
                  },
                  {
                    "CreatedAt": "2023-10-25T05:36:25.64Z[GMT]",
                    "Name": "Erwin Barron",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/3.png"
                    ],
                    "Rating": 2,
                    "Description": "definiebas detraxit luctus reque nam adolescens sententiae suavitate",
                    "Price": 13.61,
                    "Author": "https://wizardly_borg.fakenfts.org/",
                    "Id": "9e472edf-ed51-4901-8cfc-8eb3f617519f"
                  },
                  {
                    "CreatedAt": "2023-07-16T12:47:06.33Z[GMT]",
                    "Name": "Anthony Roberson",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Winnie/3.png"
                    ],
                    "Rating": 1,
                    "Description": "consequat definitionem doming his senectus",
                    "Price": 32.31,
                    "Author": "https://exciting_almeida.fakenfts.org/",
                    "Id": "fc92edf5-1355-4246-b3b7-d64bc54d1abd"
                  },
                  {
                    "CreatedAt": "2023-06-08T05:52:06.646Z[GMT]",
                    "Name": "Daryl Lucas",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/3.png"
                    ],
                    "Rating": 2,
                    "Description": "animal solet pharetra perpetua usu alienum",
                    "Price": 43.53,
                    "Author": "https://strange_gates.fakenfts.org/",
                    "Id": "a4edeccd-ad7c-4c7f-b09e-6edec02a812b"
                  },
                  {
                    "CreatedAt": "2023-06-13T09:59:28.425Z[GMT]",
                    "Name": "Lonnie Mercado",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Penny/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Penny/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Penny/3.png"
                    ],
                    "Rating": 2,
                    "Description": "agam dicant referrentur facilisi interpretaris",
                    "Price": 23.02,
                    "Author": "https://objective_kilby.fakenfts.org/",
                    "Id": "eb959204-76cc-46ef-ba07-aefa036ca1a5"
                  },
                  {
                    "CreatedAt": "2023-06-01T06:26:53.123Z[GMT]",
                    "Name": "Carmine Wooten",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/3.png"
                    ],
                    "Rating": 4,
                    "Description": "mus inceptos sociosqu te orci ut hendrerit vix",
                    "Price": 32.89,
                    "Author": "https://goofy_bhabha.fakenfts.org/",
                    "Id": "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae"
                  },
                  {
                    "CreatedAt": "2023-09-27T23:48:21.462Z[GMT]",
                    "Name": "Myrna Cervantes",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/3.png"
                    ],
                    "Rating": 5,
                    "Description": "eloquentiam deterruisset tractatos repudiandae nunc a electram",
                    "Price": 39.37,
                    "Author": "https://priceless_leavitt.fakenfts.org/",
                    "Id": "c14cf3bc-7470-4eec-8a42-5eaa65f4053c"
                  },
                  {
                    "CreatedAt": "2023-08-20T05:02:45.672Z[GMT]",
                    "Name": "Rudolph Short",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Butter/3.png"
                    ],
                    "Rating": 2,
                    "Description": "praesent numquam commodo singulis labores dolor intellegat an orci",
                    "Price": 25.42,
                    "Author": "https://tender_solomon.fakenfts.org/",
                    "Id": "3434c774-0e0f-476e-a314-24f4f0dfed86"
                  },
                  {
                    "CreatedAt": "2023-07-11T00:08:48.728Z[GMT]",
                    "Name": "Minnie Sanders",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/3.png"
                    ],
                    "Rating": 2,
                    "Description": "mediocritatem interdum eleifend penatibus adipiscing mattis",
                    "Price": 40.59,
                    "Author": "https://wonderful_dubinsky.fakenfts.org/",
                    "Id": "594aaf01-5962-4ab7-a6b5-470ea37beb93"
                  },
                  {
                    "CreatedAt": "2023-08-12T05:55:23.445Z[GMT]",
                    "Name": "Raul Juarez",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Bitsy/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Bitsy/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Bitsy/3.png"
                    ],
                    "Rating": 1,
                    "Description": "persius dictumst sit dui sagittis solum primis perpetua",
                    "Price": 40.48,
                    "Author": "https://crazy_hoover.fakenfts.org/",
                    "Id": "83c23ccc-1368-4da8-b54d-76c9b235835b"
                  },
                  {
                    "CreatedAt": "2023-07-11T05:27:40.359Z[GMT]",
                    "Name": "James Burt",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Clover/3.png"
                    ],
                    "Rating": 2,
                    "Description": "eos habeo percipit duis malesuada",
                    "Price": 11.14,
                    "Author": "https://exciting_pare.fakenfts.org/",
                    "Id": "cc74e9ab-2189-465f-a1a6-8405e07e9fe4"
                  },
                  {
                    "CreatedAt": "2023-10-20T12:07:28.555Z[GMT]",
                    "Name": "Galen Copeland",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Moose/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Moose/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Moose/3.png"
                    ],
                    "Rating": 1,
                    "Description": "blandit quis rhoncus vulputate quaestio",
                    "Price": 4.78,
                    "Author": "https://clever_hermann.fakenfts.org/",
                    "Id": "0ddb6c9b-20c1-4891-9b1c-f5f4bb2be2fb"
                  },
                  {
                    "CreatedAt": "2023-10-07T15:55:58.549Z[GMT]",
                    "Name": "Duane Dillard",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Loki/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Loki/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Loki/3.png"
                    ],
                    "Rating": 1,
                    "Description": "tacimates prompta suspendisse scelerisque qui iisque",
                    "Price": 28.51,
                    "Author": "https://heuristic_cray.fakenfts.org/",
                    "Id": "7dc60644-d3cd-4cf9-9854-f5293ebe93f7"
                  },
                  {
                    "CreatedAt": "2023-09-05T00:53:45.546Z[GMT]",
                    "Name": "Liza Jefferson",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Elliot/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Elliot/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Elliot/3.png"
                    ],
                    "Rating": 1,
                    "Description": "fabulas ex animal rutrum populo vitae laoreet lobortis pellentesque",
                    "Price": 49.24,
                    "Author": "https://magical_dirac.fakenfts.org/",
                    "Id": "75a45377-a978-4969-965f-17e0d216a01a"
                  },
                  {
                    "CreatedAt": "2023-10-13T18:06:29.924Z[GMT]",
                    "Name": "Ralph Santiago",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Buster/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Buster/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Buster/3.png"
                    ],
                    "Rating": 1,
                    "Description": "ferri sociosqu melius legere delectus laudem risus indoctum dicit",
                    "Price": 35.29,
                    "Author": "https://cool_dubinsky.fakenfts.org/",
                    "Id": "0bc94496-379c-4c3d-a437-8aea459dd008"
                  },
                  {
                    "CreatedAt": "2023-07-30T16:18:00.095Z[GMT]",
                    "Name": "Luann Bauer",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Oscar/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Oscar/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Oscar/3.png"
                    ],
                    "Rating": 1,
                    "Description": "his esse labores euripidis dicit animal liber sententiae suspendisse",
                    "Price": 18.4,
                    "Author": "https://awesome_wescoff.fakenfts.org/",
                    "Id": "2c9d09f6-25ac-4d6f-8d6a-175c4de2b42f"
                  },
                  {
                    "CreatedAt": "2023-08-18T11:51:13.582Z[GMT]",
                    "Name": "Reynaldo Rocha",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Pumpkin/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Pumpkin/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Pumpkin/3.png"
                    ],
                    "Rating": 1,
                    "Description": "dicta graeco vituperata purus regione natum explicari contentiones",
                    "Price": 44.86,
                    "Author": "https://determined_hermann.fakenfts.org/",
                    "Id": "a7efecb7-caf8-412c-838e-01e4d432907b"
                  },
                  {
                    "CreatedAt": "2023-10-25T01:33:58.566Z[GMT]",
                    "Name": "Jamel Young",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Milo/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Milo/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Milo/3.png"
                    ],
                    "Rating": 1,
                    "Description": "odio mandamus sonet sociosqu omittantur posse moderatius ultrices assueverit",
                    "Price": 1.82,
                    "Author": "https://goofy_hopper.fakenfts.org/",
                    "Id": "89e16821-0a25-44b8-b199-fa8183c19dd9"
                  },
                  {
                    "CreatedAt": "2023-07-11T10:18:42.7Z[GMT]",
                    "Name": "Bob Carpenter",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Daisy/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Daisy/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Daisy/3.png"
                    ],
                    "Rating": 4,
                    "Description": "doctus libris no egestas adolescens massa vituperata fabellas pri",
                    "Price": 19.99,
                    "Author": "https://pedantic_dijkstra.fakenfts.org/",
                    "Id": "db196ee3-07ef-44e7-8ff5-16548fc6f434"
                  },
                  {
                    "CreatedAt": "2023-09-23T20:10:18.384Z[GMT]",
                    "Name": "Harry Hogan",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Rocky/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Rocky/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Rocky/3.png"
                    ],
                    "Rating": 5,
                    "Description": "deseruisse ubique mattis civibus hendrerit ultricies",
                    "Price": 35.86,
                    "Author": "https://goofy_vaughan.fakenfts.org/",
                    "Id": "f380f245-0264-4b42-8e7e-c4486e237504"
                  },
                  {
                    "CreatedAt": "2023-06-29T07:16:22.207Z[GMT]",
                    "Name": "Ethan Medina",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Toast/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Toast/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Toast/3.png"
                    ],
                    "Rating": 1,
                    "Description": "harum nostra aliquet vix turpis",
                    "Price": 22.64,
                    "Author": "https://xenodochial_buck.fakenfts.org/",
                    "Id": "458dbc0d-3cc0-4894-90ac-319888ca3c60"
                  },
                  {
                    "CreatedAt": "2023-05-30T07:45:57.099Z[GMT]",
                    "Name": "Salvatore Franco",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Larson/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Larson/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Larson/3.png"
                    ],
                    "Rating": 1,
                    "Description": "detraxit ornare magna putent voluptaria error iuvaret saepe",
                    "Price": 14.33,
                    "Author": "https://quizzical_snyder.fakenfts.org/",
                    "Id": "d02ecb5a-2e45-4b82-9f6b-9200e0eec88a"
                  },
                  {
                    "CreatedAt": "2023-07-07T05:50:45.848Z[GMT]",
                    "Name": "Stephanie Baxter",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Willow/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Willow/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Willow/3.png"
                    ],
                    "Rating": 5,
                    "Description": "accumsan appareat dolor volutpat volutpat class maecenas in affert",
                    "Price": 3.35,
                    "Author": "https://hungry_darwin.fakenfts.org/",
                    "Id": "d6a02bd1-1255-46cd-815b-656174c1d9c0"
                  },
                  {
                    "CreatedAt": "2023-10-14T07:43:13.948Z[GMT]",
                    "Name": "Ebony Decker",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Whisper/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Whisper/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Whisper/3.png"
                    ],
                    "Rating": 1,
                    "Description": "epicuri appetere vituperatoribus maximus porttitor",
                    "Price": 42.31,
                    "Author": "https://recursing_kilby.fakenfts.org/",
                    "Id": "b6d0e246-d317-4f3e-b0c9-b4a2ce4d4c2a"
                  },
                  {
                    "CreatedAt": "2023-06-07T18:53:46.914Z[GMT]",
                    "Name": "Mamie Norton",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Luna/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Luna/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Luna/3.png"
                    ],
                    "Rating": 3,
                    "Description": "voluptaria equidem oporteat volutpat nisi interdum quas",
                    "Price": 31.64,
                    "Author": "https://affectionate_bassi.fakenfts.org/",
                    "Id": "9810d484-c3fc-49e8-bc73-f5e602c36b40"
                  },
                  {
                    "CreatedAt": "2023-09-18T00:04:07.524Z[GMT]",
                    "Name": "Melvin Yang",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Dominique/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Dominique/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Dominique/3.png"
                    ],
                    "Rating": 3,
                    "Description": "leo liber nobis nisi animal posidonium facilisi mauris",
                    "Price": 8.04,
                    "Author": "https://sharp_matsumoto.fakenfts.org/",
                    "Id": "82570704-14ac-4679-9436-050f4a32a8a0"
                  },
                  {
                    "CreatedAt": "2023-08-19T16:58:19.859Z[GMT]",
                    "Name": "Sybil Sears",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Josie/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Josie/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Josie/3.png"
                    ],
                    "Rating": 3,
                    "Description": "turpis maximus vis senectus utinam persius equidem",
                    "Price": 13.44,
                    "Author": "https://dazzling_margulis.fakenfts.org/",
                    "Id": "ca9130a1-8ec6-4a3a-9769-d6d7958b90e3"
                  },
                  {
                    "CreatedAt": "2023-08-08T12:10:55.348Z[GMT]",
                    "Name": "Maryann Simon",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Rufus/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Rufus/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Rufus/3.png"
                    ],
                    "Rating": 1,
                    "Description": "lobortis invidunt morbi ad mea equidem",
                    "Price": 10.67,
                    "Author": "https://friendly_swanson.fakenfts.org/",
                    "Id": "35957714-585d-443f-ad9d-6cb994b64377"
                  },
                  {
                    "CreatedAt": "2023-08-24T12:02:49.691Z[GMT]",
                    "Name": "Faye Carey",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Ruby/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Ruby/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Ruby/3.png"
                    ],
                    "Rating": 1,
                    "Description": "alia hendrerit antiopam hinc singulis vel nonumes repudiare electram",
                    "Price": 31.26,
                    "Author": "https://kind_wescoff.fakenfts.org/",
                    "Id": "497a53d1-b5c1-4777-bdcc-48050d032df5"
                  },
                  {
                    "CreatedAt": "2023-06-28T12:16:02.017Z[GMT]",
                    "Name": "Harriet Rocha",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Stella/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Stella/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Stella/3.png"
                    ],
                    "Rating": 1,
                    "Description": "labores non legimus facilisis habitasse patrioque",
                    "Price": 37.49,
                    "Author": "https://crazy_lewin.fakenfts.org/",
                    "Id": "6ff48b36-68ff-4192-87e3-f11669123a97"
                  },
                  {
                    "CreatedAt": "2023-05-26T11:51:08.152Z[GMT]",
                    "Name": "Osvaldo Salas",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lucy/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lucy/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lucy/3.png"
                    ],
                    "Rating": 1,
                    "Description": "nascetur varius consectetuer eos ignota adipiscing fugit habemus",
                    "Price": 28.45,
                    "Author": "https://strange_rosalind.fakenfts.org/",
                    "Id": "18231384-1291-42ae-8776-e699fb839687"
                  },
                  {
                    "CreatedAt": "2023-07-14T09:56:02.518Z[GMT]",
                    "Name": "Royce McCoy",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Dingo/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Dingo/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Dingo/3.png"
                    ],
                    "Rating": 1,
                    "Description": "nulla faucibus dolorum melius curae",
                    "Price": 38.02,
                    "Author": "https://ecstatic_allen.fakenfts.org/",
                    "Id": "5a30697e-23aa-40c1-b28d-c7f6385d93ad"
                  },
                  {
                    "CreatedAt": "2023-08-10T15:15:03.689Z[GMT]",
                    "Name": "Joel Alford",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Lina/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Lina/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Lina/3.png"
                    ],
                    "Rating": 1,
                    "Description": "assueverit praesent referrentur venenatis ocurreret latine qui alia",
                    "Price": 8.4,
                    "Author": "https://laughing_hoover.fakenfts.org/",
                    "Id": "8c18e88f-50e7-407e-9232-054e8eef9bb9"
                  },
                  {
                    "CreatedAt": "2023-09-06T00:53:53.9Z[GMT]",
                    "Name": "Darius Benjamin",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Chip/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Chip/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Chip/3.png"
                    ],
                    "Rating": 1,
                    "Description": "bibendum molestiae ultrices montes veri senectus",
                    "Price": 21.71,
                    "Author": "https://angry_chebyshev.fakenfts.org/",
                    "Id": "ce04d6a5-e3dc-4c67-ac71-037b001da91d"
                  },
                  {
                    "CreatedAt": "2023-07-29T03:54:50.756Z[GMT]",
                    "Name": "Shawn Freeman",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Salena/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Salena/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Salena/3.png"
                    ],
                    "Rating": 1,
                    "Description": "petentium persequeris movet cubilia aliquam arcu",
                    "Price": 18.25,
                    "Author": "https://quirky_antonelli.fakenfts.org/",
                    "Id": "3dbad332-2c3b-43b1-94cf-4c4aaad21a18"
                  },
                  {
                    "CreatedAt": "2023-10-13T05:24:03.712Z[GMT]",
                    "Name": "Rusty Bishop",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Tater/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Tater/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Tater/3.png"
                    ],
                    "Rating": 1,
                    "Description": "dolorem legere lorem sumo impetus erroribus putent falli",
                    "Price": 39.23,
                    "Author": "https://brave_banzai.fakenfts.org/",
                    "Id": "9046bec6-fd58-409d-8d54-6188ae8873f8"
                  },
                  {
                    "CreatedAt": "2023-11-08T16:55:48.221Z[GMT]",
                    "Name": "Dolly Lancaster",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Biscuit/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Biscuit/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Biscuit/3.png"
                    ],
                    "Rating": 1,
                    "Description": "sadipscing ridiculus sonet repudiare verterem ex consetetur",
                    "Price": 40.13,
                    "Author": "https://xenodochial_babbage.fakenfts.org/",
                    "Id": "2aa0ba3a-9273-49a5-8812-78fcc0ca1234"
                  },
                  {
                    "CreatedAt": "2023-08-01T04:34:46.378Z[GMT]",
                    "Name": "Jan Wall",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Gwen/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Gwen/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Gwen/3.png"
                    ],
                    "Rating": 5,
                    "Description": "tacimates nonumes nascetur eloquentiam dui mucius",
                    "Price": 48.93,
                    "Author": "https://heuristic_babbage.fakenfts.org/",
                    "Id": "de7c0518-6379-443b-a4be-81f5a7655f48"
                  },
                  {
                    "CreatedAt": "2023-10-15T12:48:12.554Z[GMT]",
                    "Name": "Viola McClain",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Olaf/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Olaf/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Olaf/3.png"
                    ],
                    "Rating": 4,
                    "Description": "graecis his curabitur lacus meliore tamquam accusata nec aliquip",
                    "Price": 33.23,
                    "Author": "https://elastic_mclean.fakenfts.org/",
                    "Id": "e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb"
                  },
                  {
                    "CreatedAt": "2023-05-21T12:49:21.959Z[GMT]",
                    "Name": "Amanda Acevedo",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Diana/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Diana/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Diana/3.png"
                    ],
                    "Rating": 1,
                    "Description": "maecenas malorum vocent partiendo postea nibh",
                    "Price": 0.95,
                    "Author": "https://reverent_chebyshev.fakenfts.org/",
                    "Id": "35670864-8997-492c-be36-2a1c7c7a2bd4"
                  },
                  {
                    "CreatedAt": "2023-08-04T07:31:20.287Z[GMT]",
                    "Name": "Erich Andrews",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Iggy/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Iggy/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Iggy/3.png"
                    ],
                    "Rating": 1,
                    "Description": "persecuti elementum euismod salutatus interpretaris cursus omittam homero",
                    "Price": 37.28,
                    "Author": "https://jolly_swartz.fakenfts.org/",
                    "Id": "45e7c144-77d1-471f-8aa3-bc490c629aba"
                  },
                  {
                    "CreatedAt": "2023-10-17T20:49:22.649Z[GMT]",
                    "Name": "Nolan Savage",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Corbin/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Corbin/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Corbin/3.png"
                    ],
                    "Rating": 1,
                    "Description": "offendit interpretaris parturient an porta quot",
                    "Price": 9.75,
                    "Author": "https://festive_jennings.fakenfts.org/",
                    "Id": "933ed94d-2b94-4163-944a-3813aa4503f8"
                  },
                  {
                    "CreatedAt": "2023-11-04T15:32:18.586Z[GMT]",
                    "Name": "Jayne Baker",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Flower/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Flower/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Flower/3.png"
                    ],
                    "Rating": 1,
                    "Description": "similique volumus eloquentiam efficitur tempus potenti reformidans magnis",
                    "Price": 31.75,
                    "Author": "https://charming_cori.fakenfts.org/",
                    "Id": "34c50a1f-e66b-4617-b7a9-8307bb0769af"
                  },
                  {
                    "CreatedAt": "2023-07-03T05:37:25.031Z[GMT]",
                    "Name": "Gavin Perez",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Arlena/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Arlena/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Arlena/3.png"
                    ],
                    "Rating": 1,
                    "Description": "singulis venenatis dicam saperet auctor propriae enim varius mauris",
                    "Price": 26.79,
                    "Author": "https://jovial_mendel.fakenfts.org/",
                    "Id": "5e5c7b47-3086-483b-8b90-70a7cabcdeb4"
                  },
                  {
                    "CreatedAt": "2023-10-30T03:16:40.675Z[GMT]",
                    "Name": "Forest Hays",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Charlie/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Charlie/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Charlie/3.png"
                    ],
                    "Rating": 1,
                    "Description": "urbanitas hendrerit a interdum decore a appareat dictumst aptent",
                    "Price": 49.23,
                    "Author": "https://confident_shannon.fakenfts.org/",
                    "Id": "a640ea4f-fe73-4994-835a-a715542cdaeb"
                  },
                  {
                    "CreatedAt": "2023-07-04T20:53:17.492Z[GMT]",
                    "Name": "Valarie Key",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Devin/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Devin/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Devin/3.png"
                    ],
                    "Rating": 1,
                    "Description": "tantas proin tristique offendit sanctus hendrerit tempus vehicula",
                    "Price": 30.53,
                    "Author": "https://hopeful_bartik.fakenfts.org/",
                    "Id": "7f93b6b6-9f42-4a8c-b238-8edab95098a7"
                  },
                  {
                    "CreatedAt": "2023-07-25T13:37:43.885Z[GMT]",
                    "Name": "Tamera Alvarado",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Lanka/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Lanka/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Lanka/3.png"
                    ],
                    "Rating": 1,
                    "Description": "feugiat natoque conceptam mollis neglegentur vero legimus litora",
                    "Price": 10.13,
                    "Author": "https://goofy_villani.fakenfts.org/",
                    "Id": "256e28df-aa17-46e4-9586-cb78aab7143c"
                  },
                  {
                    "CreatedAt": "2023-06-28T09:29:26.857Z[GMT]",
                    "Name": "Rachael Owens",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Salena/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Salena/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Salena/3.png"
                    ],
                    "Rating": 1,
                    "Description": "voluptaria erat consetetur id delenit interpretaris condimentum scelerisque adolescens",
                    "Price": 30.63,
                    "Author": "https://musing_solomon.fakenfts.org/",
                    "Id": "5cd791a3-96cd-4ac3-92cd-744f7422fb31"
                  },
                  {
                    "CreatedAt": "2023-09-14T21:34:29.004Z[GMT]",
                    "Name": "Arnulfo Dawson",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Jerry/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Jerry/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Jerry/3.png"
                    ],
                    "Rating": 1,
                    "Description": "tation facilis platonem doming postea mentitum molestiae pro",
                    "Price": 25.37,
                    "Author": "https://vigilant_chatelet.fakenfts.org/",
                    "Id": "90758b01-1ba2-4b2c-a7af-09bdc17d2679"
                  },
                  {
                    "CreatedAt": "2023-07-12T11:23:32.841Z[GMT]",
                    "Name": "Woodrow Long",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Breena/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Breena/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Breena/3.png"
                    ],
                    "Rating": 1,
                    "Description": "eius reque aliquam prodesset vivamus",
                    "Price": 40.35,
                    "Author": "https://quizzical_lumiere.fakenfts.org/",
                    "Id": "04b79f11-313e-47b4-bd26-f513b77ed264"
                  },
                  {
                    "CreatedAt": "2023-07-05T20:41:18.758Z[GMT]",
                    "Name": "Sandy Eaton",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Melissa/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Melissa/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Green/Melissa/3.png"
                    ],
                    "Rating": 1,
                    "Description": "fabellas vituperata sumo nisi perpetua principes noluisse posuere",
                    "Price": 9.95,
                    "Author": "https://unruffled_khayyam.fakenfts.org/",
                    "Id": "507004f5-1cef-4f56-9739-0e506989d633"
                  },
                  {
                    "CreatedAt": "2023-06-10T11:42:16.363Z[GMT]",
                    "Name": "Sharon Paul",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lucky/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lucky/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lucky/3.png"
                    ],
                    "Rating": 3,
                    "Description": "definitionem interesset nostrum quod theophrastus",
                    "Price": 27.32,
                    "Author": "https://youthful_bartik.fakenfts.org/",
                    "Id": "e33e18d5-4fc2-466d-b651-028f78d771b8"
                  },
                  {
                    "CreatedAt": "2023-07-19T20:01:52.851Z[GMT]",
                    "Name": "Sebastian Good",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Tucker/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Tucker/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Tucker/3.png"
                    ],
                    "Rating": 1,
                    "Description": "natum consetetur pericula nibh persequeris indoctum felis",
                    "Price": 48.45,
                    "Author": "https://mystifying_agnesi.fakenfts.org/",
                    "Id": "8763e529-ab5f-410f-95c8-d08cb6f49453"
                  },
                  {
                    "CreatedAt": "2023-07-04T07:18:35.585Z[GMT]",
                    "Name": "Stephen Wiley",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Nala/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Nala/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Nala/3.png"
                    ],
                    "Rating": 1,
                    "Description": "iudicabit no dolorum verear veritus dapibus natum",
                    "Price": 40.52,
                    "Author": "https://stupefied_joliot.fakenfts.org/",
                    "Id": "5bec62f7-c0f2-4ef9-8cea-08885511cbcb"
                  },
                  {
                    "CreatedAt": "2023-11-13T22:09:56.357Z[GMT]",
                    "Name": "Ebony Clemons",
                    "Images": [
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Grace/1.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Grace/2.png",
                      "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Grace/3.png"
                    ],
                    "Rating": 1,
                    "Description": "constituam comprehensam vim pulvinar laoreet tantas ei putent",
                    "Price": 0.84,
                    "Author": "https://sleepy_lamarr.fakenfts.org/",
                    "Id": "4165fc16-cc82-47df-8160-3ee60449fe46"
                  }
                ]
    """
    }
}
