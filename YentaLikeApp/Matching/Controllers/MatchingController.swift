//
//  MatchingController.swift
//  YentaLikeApp
//
//  Created by takahitoyoneda on 2019/01/03.
//  Copyright © 2019 takahitoyoneda. All rights reserved.
//

import UIKit
import Firebase

class MatchingController: UITableViewController {
    
    var users =  [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(MessageCell.self, forCellReuseIdentifier: "cellId")
        setupNavigationBars()
        fetchMatchingUsers()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc fileprivate func handleRefresh(){
        fetchMatchingUsers()
    }
    
    
    fileprivate func fetchMatchingUsers(){
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("matches").document(currentUserUid)
       
        ref.getDocument { (snapshots, err) in
            if let err = err{
                print("failed to get matching document", err)
                return
            }
            
            self.users.removeAll()
            print("successfully fetched matching document")
            guard let matchingUserUids = snapshots?.data()?.keys else {return}
            matchingUserUids.forEach({ (matchingUserUid) in
                
                Firestore.firestore().collection("users").document(matchingUserUid).getDocument(completion: { (snapshot, err) in
                    if let err = err{
                        print("failed to fetch matching user",err)
                        return
                    }
                    print("successfully fetch matching user!!")
                    
                    guard let dictionary = snapshot?.data() else {return}
                    let user = User(dictionary: dictionary)
                    self.users.append(user)
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            })
        }
        
    }
    
    fileprivate func setupNavigationBars(){
        navigationItem.title = "マッチング"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.09851664624, green: 0.2761102814, blue: 0.5600723167, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MessageCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touching..")
        let messagesController = MessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        messagesController.user = users[indexPath.row]
        navigationController?.pushViewController(messagesController, animated: true)
    }
    
//    override func viewDidLoad() {
//
//        collectionView.backgroundColor = .white
//
//        collectionView?.register(MachingHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
//
//        setupNavigationBars()
//    }
//

//
//    //header
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 80)
//    }
//
//    //mainMessges
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
////    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////
////    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////
////    }
////
//
    
}