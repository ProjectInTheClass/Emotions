//
//  ServiceViewController.swift
//  Emotions
//
//  Created by Jungsang Lim on 2021/05/01.
//

import UIKit

class ServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationConfigureUI()
                
        // Do any additional setup after loading the view.
    }
    
    func navigationConfigureUI() {
        navigationItem.title = "서비스 이용 약관"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .darkGray
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