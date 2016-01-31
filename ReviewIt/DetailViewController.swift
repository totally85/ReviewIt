//
//  DetailViewController.swift
//  ReviewIt
//
//  Created by Allison Martin on 1/31/16.
//  Copyright © 2016 Allison Martin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView! //Imageview outlet
    @IBOutlet weak var titleLabel: UILabel! //Title outlet
    @IBOutlet weak var overviewLabel: UILabel! //Overview outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    //holds the movie dictionary from the website
    var movie_dictionary: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The size of the scrollView
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie_dictionary["title"] as? String //Parses the movie dictionary for titles and sets the variable to the movie's title
        titleLabel.text = title //Sets the label to the movie's title
        
        let overview = movie_dictionary["overview"] as? String //Parses the movie dictionary for overviews and sets the variable to the movie's overview
        overviewLabel.text = overview //Sets hte label to the movie's overview
        
        overviewLabel.sizeToFit()
        
        let posterBaseURL = "http://image.tmdb.org/t/p/w500" //remains the same
        if let posterPath = movie_dictionary["poster_path"] as? String //added to the base URL to find a specific poster
        {
            
            let posterURL = NSURL(string: posterBaseURL + posterPath)
            posterImageView.setImageWithURL(posterURL!)
        }
        else
        {
            posterImageView.image = nil
        }

        
        print(movie_dictionary)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
