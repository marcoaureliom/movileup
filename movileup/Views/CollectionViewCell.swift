//
//  CollectionViewCell.swift
//  movileup
//
//  Created by iOS on 7/17/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellNumberLabel: UILabel!
    
    
    /*private var task: RetrieveImageTask?
    func loadShow(show: Show) {
        let placeholder = UIImage(named: "poster")
        if let url = show.poster?.fullImageURL ?? show.poster?.mediumImageURL ?? show.poster?.thumbImageURL {
        posterImageView.kf_setImageWithURL(url, placeholderImage: placeholder)
    } else {
        posterImageView.image = placeholder
        }
        cellNumberLabel.text = show.title
        
    }*/
    
    
    /* array com cores e atribuição delas
    static let colors: [UIColor] = [.greenColor(), .purpleColor(),
        .redColor(), .blueColor(), .orangeColor()]*/
    
    /*func loadCellNumber(number: Int) {
        cellNumberLabel.text = "Cell #\(number)"
        
        let idx = number % CollectionViewCell.colors.count
        backgroundColor = CollectionViewCell.colors[idx]
    } classe da célula - funcoes sao chamadas da classe da collection view*/
    
    /*func numeros(numero: Int){
        cellNumberLabel.text = "Célula numero #\(numero)"
    }*/
    
}
