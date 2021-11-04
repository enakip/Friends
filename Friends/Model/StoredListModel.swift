//
//  StoredListModel.swift
//  Friends
//
//  Created by Emiray Nakip on 5.11.2021.
//

import Foundation
import RealmSwift

@objcMembers class StoredListModel: Object, Decodable {
    let results = RealmSwift.List<StoredResult>()
    dynamic var info: Info?
    
    enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let resultList = try container.decode([StoredResult].self, forKey: .results)
        results.append(objectsIn: resultList)
        
        super.init()
    }
    
    required override init()
    {
        super.init()
    }
    
}

@objcMembers class StoredResult: Object, Decodable {
    dynamic var gender: Gender?
    dynamic var name: NameClass?
    dynamic var location: Location?
    dynamic var email: String?
    dynamic var login: Login?
    dynamic var dob, registered: Dob?
    dynamic var phone, cell: String?
    dynamic var id: ID?
    dynamic var picture: Picture?
    dynamic var nat: String?

    enum CodingKeys: String, CodingKey {
        case gender
        case name
        case location
        case email
        case login
        case dob
        case registered
        case phone
        case cell
        case id
        case picture
        case nat
    }
    
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        gender = try container.decode(Gender.self, forKey: .gender)
        name = try container.decode(NameClass.self, forKey: .name)
        location = try container.decode(Location.self, forKey: .location)
        email = try container.decode(String.self, forKey: .email)
        login = try container.decode(Login.self, forKey: .login)
        dob = try container.decode(Dob.self, forKey: .dob)
        registered = try container.decode(Dob.self, forKey: .registered)
        phone = try container.decode(String.self, forKey: .phone)
        cell = try container.decode(String.self, forKey: .cell)
        id = try container.decode(ID.self, forKey: .id)
        picture = try container.decode(Picture.self, forKey: .picture)
        nat = try container.decode(String.self, forKey: .nat)
        
        super.init()
    }
    
    
    required override init()
    {
        super.init()
    }
    
}
