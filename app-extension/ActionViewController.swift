//
//  ActionViewController.swift
//  app-extension
//
//  Created by Kenzan Hase on 1/31/20.
//  Copyright © 2020 kenzan8000. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    weak var weakActivityIndicatorView = self.activityIndicatorView
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { (data, error) in
                        OperationQueue.main.addOperation {
                            if let url = data as? URL {
                                print(url)
                                weakActivityIndicatorView?.startAnimating()
                            }
                        }
                    })
                }
                /*
                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let strongImageView = weakImageView {
                                if let imageURL = imageURL as? URL {
                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                                }
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
                */
            }
        }
    }

    @IBAction func done() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
