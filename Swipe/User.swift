//
//  User.swift
//  Swipe
//
//  Created by Brett Wallace on 8/15/15.
//  Copyright (c) 2015 Brett Wallace. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        }
    }
}

private func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}

func fetchUnviewedUsers(callback: ([User]) -> ()) {
    PFUser.query()!
    .whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
    .findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        if let pfUsers = objects as? [PFUser] {
            let users = map(pfUsers, {pfUserToUser($0)})
            callback(users)
        }
    }
}

func saveAction(user: User, type: String) {
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser()!.objectId!, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject(type, forKey: "type")
    skip.saveInBackgroundWithBlock(nil)
}