//
//  RecordedAudioObject.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/27/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
/** This is a custom model that allows to store both a URL and a title for an audio clip.
    // TODO: create a mechanism to display and edit the name of the file.
 */
class RecordedAudioObject: NSObject {
    /// An absolute path to a given file.
    var filePathUrl: URL!
    /// The last component of the url, the name for the file.
    var title: String!
}
