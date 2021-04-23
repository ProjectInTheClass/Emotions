//
//  ProfileTableViewController.swift
//  Emotions
//
//  Created by 박형석 on 2021/04/23.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    let logoutIndexPath = IndexPath(row: 2, section: 1)
    let deleteUser = IndexPath(row: 3, section: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == logoutIndexPath {
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .destructive) { (alert) in
                AuthManager.shared.logoutUser { (success) in
                    if success {
                        
                    } else {
                        print("로그아웃 실패")
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else if indexPath == deleteUser {
            
            let alert = UIAlertController(title: "회원탈퇴", message: "탈퇴하시겠습니까?\n관련된 모든 정보가 삭제됩니다.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.layer.masksToBounds = true
                textField.layer.cornerRadius = CornerRadius.myValue
                textField.placeholder = "등록하셨던 비밀번호를 적어주세요."
            }
          
            let okAction = UIAlertAction(title: "확인", style: .destructive) {  [unowned alert] _ in
                guard let password = alert.textFields![0].text else { return }
                UserManager.shared.deleteUser(password: password)
                UserManager.shared.userImageDelete()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
