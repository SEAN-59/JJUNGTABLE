//
//  ReportViewController.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/29/23.
//

import UIKit


@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview(traits: .portrait, body: {
    ReportViewController()
})
class ReportViewController: BaseVC {
    @IBOutlet weak var bottomView: BottomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomView.delegate = self

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
