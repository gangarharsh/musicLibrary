//
//  HomeViewModel.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 30/06/20.
//

import Foundation
class HomeViewModel {
    typealias DataReceived      = () -> ()
    typealias ErrorFetchingData = () -> ()
    typealias ShowLoader        = () -> ()
    typealias HideLoader        = () -> ()
    typealias GoToDetails    = (_ viewModel:MusicViewModel) -> ()

    
    private(set) var musicData : MusicLibraryObject?
    var musicReceived: DataReceived?
    var errorFetchingMusic:ErrorFetchingData?
    var showLoader:ShowLoader?
    var hideLoader:HideLoader?
    var arrayDataSource = [MusicViewModel]()
    var noMusicReceived : ErrorFetchingData?
    var goToDetailsViewController :GoToDetails?

    var deatilsVcSegue = "toDetailsVC"
    func getMusic(searchObj:String){
        if Reachability.isConnectedToNetwork(){
            self.showLoader?()
            APIHelper.shared.fetchMusic(from: searchObj) { (result: Result<MusicLibraryObject, APIHelper.APIServiceError>) in
                self.hideLoader?()
                switch result {
                case .success(let data):
                    self.musicData = data
                    if (self.musicData?.resultCount ?? 0) > 0{
                        self.makeDataSource()
                        self.musicReceived?()
                    }else{
                        self.noMusicReceived?()
                    }
                    self.makeDataSource()
                    self.musicReceived?()
                case .failure(let error):
                    self.musicData = nil
                    print(error.description)
                    self.makeDataSource()
                    self.noMusicReceived?()
                }
            }
        }
    }
    
    func makeDataSource(){
        self.arrayDataSource.removeAll()
        for musicObj in self.musicData?.results ?? []{
            let viewModel = MusicViewModel(musicVmObj: musicObj)
            self.arrayDataSource.append(viewModel)
        }
    }
    
    var musicCount:Int{
        return self.musicData?.resultCount ?? 0
    }
    
    func gotToDetailsVc(for indexPath:IndexPath){
        let vmObj = self.arrayDataSource[indexPath.row]
        
        self.goToDetailsViewController?(vmObj)
    }
}


class MusicViewModel{
    private(set) var musicObj :MusicResult?

    init(musicVmObj:MusicResult) {
        self.musicObj = musicVmObj
    }
    
    var image:String {
        return self.musicObj?.artworkUrl100 ?? ""
    }
    
    var mediaTypeImage:String{
        switch self.musicObj?.kind {
        case .song: return "mediaAudio"
        case .musicVideo: return "mediaVideo"
        case .none: return ""
        }
    }
    
    var price:String{
        return "\(self.musicObj?.currency.rawValue ?? "") \(self.musicObj?.trackPrice ?? 0.0)"
    }
    
    var genre:String{
        return self.musicObj?.primaryGenreName ?? ""
    }
    
    var artistName:String{
        return self.musicObj?.artistName ?? ""
    }
    
    var collectionName:String{
        return self.musicObj?.collectionName ?? ""
    }
    
    var trackName:String{
        return self.musicObj?.trackName ?? ""
    }
    
    var time:String{
        let minute = (self.musicObj?.trackTimeMillis ?? 00) / 60 % 60
        let second = (self.musicObj?.trackTimeMillis ?? 00) % 60
        return String(format: "%02i:%02i", minute, second)
    }
    
    var isSteamable:Bool{
        self.musicObj?.isStreamable ?? false
    }
    
    var streamURL:String{
        self.musicObj?.previewURL ?? ""
    }
}
