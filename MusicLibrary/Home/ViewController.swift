//
//  ViewController.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 29/06/20.
//

import UIKit

class ViewController: UIViewController,UIViewControllerTransitioningDelegate {

    @IBOutlet weak var searchBarMusic: UISearchBar!
    @IBOutlet weak var tableViewMusic: UITableView!
    @IBOutlet weak var labelNoMusicFound: UILabel!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var viewModel:HomeViewModel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = "Music"
        searchBarMusic.delegate = self
        searchBarMusic.showsCancelButton = true
        tableViewMusic.register(UINib(nibName: "MusicHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicHomeTableViewCellId")

        setupViewModel()
        setUpIndicator()
        self.tableViewMusic.delegate = self
        self.tableViewMusic.dataSource = self
        self.tableViewMusic.estimatedRowHeight = 50
        self.tableViewMusic.rowHeight = UITableView.automaticDimension
        tableViewMusic.backgroundColor = .black
        searchBarMusic.barStyle = .black
        searchBarMusic.placeholder = "Search for music, artist, etc"
        self.labelNoMusicFound.isHidden = true
    }
    
    func setupViewModel(){
        viewModel = HomeViewModel()
        viewModel.musicReceived = { [weak self] in
            
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.labelNoMusicFound.isHidden = true
                self.tableViewMusic.isHidden = false
                self.tableViewMusic.reloadData()
            }
        }
        
        viewModel.noMusicReceived = {[weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.labelNoMusicFound.isHidden = false
                self.labelNoMusicFound.text = "No Album/Song found, please try a differnt search keyword!"
                self.tableViewMusic.reloadData()

            }
        }
        
        viewModel.errorFetchingMusic = {[weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.labelNoMusicFound.isHidden = false
                self.labelNoMusicFound.text = "Error getting music, please retry!"
                self.tableViewMusic.reloadData()

            }
        }
        
        viewModel.showLoader = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.indicator.startAnimating()
            }
        }
        
        viewModel.hideLoader = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
        }
        
        viewModel.goToDetailsViewController = { [weak self] musicVM in
            guard let `self` = self else {
                return
            }
            
            self.performSegue(withIdentifier: self.viewModel.deatilsVcSegue, sender: musicVM)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.viewModel.deatilsVcSegue,
            let destinationVc = segue.destination as? DetialsViewController,
            let musicVm = sender as? MusicViewModel
        {
            destinationVc.viewModel = musicVm
        }
    }
    
    func setUpIndicator(){
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.musicCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MusicHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MusicHomeTableViewCellId") as! MusicHomeTableViewCell
        let musicVm = viewModel.arrayDataSource[indexPath.row]
        cell.setUpCell(vmObj: musicVm)
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.gotToDetailsVc(for: indexPath)
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        if (searchBar.text?.count ?? 0) >= 3{
            self.viewModel.getMusic(searchObj: searchBar.text ?? "" )
        }
    }
}
