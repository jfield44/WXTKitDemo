//
//  DrAnywhere
//
//  Created by jonfiel on 01/08/2018.
//  Copyright © 2018 Cisco. All rights reserved.
//

import UIKit
import WebKit

class WXTeamsDocumentViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var attachmentURI: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: Selector("done:"))
        let shareSheet = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: Selector("shareSheet:"))
        self.title = "Attachment"
        webView.loadFileURL(self.attachmentURI!, allowingReadAccessTo: self.attachmentURI!)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareSheet(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [self.attachmentURI] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
