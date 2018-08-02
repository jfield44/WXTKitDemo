//
//  WXTeamsImageViewController.swift
//  DrAnywhere
//
//  Created by jonfiel on 31/07/2018.
//  Copyright © 2018 Cisco. All rights reserved.
//

import UIKit

class WXTeamsImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    var fileName: String?
    var attachmentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: Selector("done:"))
        let shareSheet = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: Selector("shareSheet:"))
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem = shareSheet
        self.navigationItem.title = "Attachment"
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.imageView.image = self.attachmentImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareSheet(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [self.attachmentImage!] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
