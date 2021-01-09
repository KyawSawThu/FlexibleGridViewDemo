//
//  MovieView.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 31/12/2020.
//

import UIKit

class MovieView: UIViewController {
    
    @IBOutlet weak var movieGridView: UIFlexibleGridView!
    
    private var mMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMovieGridView()
        self.fetchMovies()
    }
    
    private func setUpMovieGridView() {
        movieGridView.dataSource = self
        movieGridView.delegate = self
        
        movieGridView.spacing = 8
        movieGridView.itemHeight = 40
        movieGridView.alignment = .left
        movieGridView.selectionStyle = .none
        movieGridView.showsScrollIndicator = false
        movieGridView.contentInsets = UIGridInsets(top: 8, left: 8, bottom: 8, right: 8)
        movieGridView.register(with: UIFlexibleGridViewItem.self, identifier: "movie_item")
    }
    
    private func fetchMovies() {
        ApiService.shared.fetchData(route: "/now_playing", value: MovieListResponse.self) { result in
            switch result {
            case .success(let response):
                self.mMovies = response.results ?? []
                DispatchQueue.main.async { self.movieGridView.reloadData() }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MovieView: UIFlexibleGridViewDataSource, UIFlexibleGridViewDelegate {
    
    func layoutForGridView(_ flexibleGridView: UIFlexibleGridView) -> UIGridLayout {
        return .auto
    }
    
    
    func numberOfItemsInGridView(_ flexibleGridView: UIFlexibleGridView) -> Int {
        return mMovies.count
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, itemForIndexAt index: Int) -> UIFlexibleGridViewItem {
        let item = flexibleGridView.dequeItem(withIdentifier: "movie_item", for: index) as UIFlexibleGridViewItem
        item.titleLabel.text = mMovies[index].originalTitle
        item.layer.borderColor = UIColor.lightGray.cgColor
        item.layer.cornerRadius = 20
        return item
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, didSelectItemAt index: Int) {
        print(mMovies[index].originalTitle ?? "")
    }
    
}
