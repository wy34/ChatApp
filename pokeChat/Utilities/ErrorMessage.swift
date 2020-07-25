//
//  ErrorMessage.swift
//  pokeChat
//
//  Created by William Yeung on 7/24/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {
    case SignInError = "Cannot sign in"
    case PutDataError = "Cannot put image data onto Storage"
    case DownloadUrlError = "Cannot download url for image"
    case RegisteringUserError = "Cannot register user"
    case UpdatingDatabaseError = "Cannot put user info into database"
}
