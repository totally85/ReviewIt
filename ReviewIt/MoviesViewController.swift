//
//  MoviesViewController.swift
//  ReviewIt
//
//  Created by Allison Martin on 1/24/16.
//  Copyright © 2016 Allison Martin. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD



class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
 
    
    var movies: [NSDictionary]? //an array of NSDictionary
  let data = ["The Revenant", "The Hateful Eight", "The Big Short", "The 5th Wave", "Kung Fu Panda 3", "Dirty Grandpa",
    "Joy", "The Boy", "Batman: Sangue Rulm", "Ride Along 2", "13 Hours: The Secret Soldiers of Benghazi", "Daddy's Home",
    "Quindariah Griffin's Interview", "Quo Vado?", "Exposed", "El Americano: The Movie", "The Finest Hours", "Fifty Shades of Black",
        "Hail, Caesar!", "LEGO Friends: Girlz 4 Life", "Pride and Prejudice and Zombies", ]
    
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        //Gets the movies from the database
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed" //tells the database we're legit so we can access their stuff
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)") //URL with apikey plugged in
        
        refreshControl.addTarget(self, action: Selector("refreshControlAction:"), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! //Dictionary is loaded into responseDictionary
                        NSJSONSerialization.JSONObjectWithData( //parses JSCON into something our app can read
                        data, options:[]) as? NSDictionary { //which is an NSDictionary
                            print("response: \(responseDictionary)") //prints the responseDictionary
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary] //needs to get into the results portion of the dictionary
                            self.tableView.reloadData() //reloads data
                            
                    }
                }
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
            })
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tells the table cell how many rows it has
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let movies = movies //if movies has data in it
        {
            return movies.count //returns number of movies in movies array
        }
        else
        {
            return 0 //returns nothing, so no rows
        }
    }
    
    //Communicates and sets the content of each individual cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
                                                               //identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell //indexPath tells us where the cell is in the tableView
        
        let movie = movies![indexPath.row] //! means it will not be nil once you've already declared an optional
        let title = movie["title"] as! String //We want title to be a string so it can go in the cell label
        let overview = movie["overview"] as! String //Overview needs to be a string
        var posterPath = movie["poster_path"] as? String
        
        var imageURL = NSURL()
        if posterPath == nil
        {
             imageURL = NSURL(string: "http://www.hicksvillelibrary.org/images/ComingSoon.png")!
        }
        else
        {
             let baseURL = "http://image.tmdb.org/t/p/w500"
             imageURL = NSURL(string: baseURL + posterPath!)!
        }
        
       
        
        
        //Connects with MovieCell.swift file
        cell.titleLabel.text = title
        cell.posterView.setImageWithURL(imageURL)
        cell.overviewLabel.text = overview
        
        
        
        print ("row \(indexPath.row)") //will print row #
        return cell
    }
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        //Gets the movies from the database
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed" //tells the database we're legit so we can access their stuff
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)") //URL with apikey plugged in

        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
            
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! //Dictionary is loaded into responseDictionary
                        NSJSONSerialization.JSONObjectWithData( //parses JSCON into something our app can read
                            data, options:[]) as? NSDictionary { //which is an NSDictionary
                                print("response: \(responseDictionary)") //prints the responseDictionary
                                
                                self.tableView.reloadData()
                                refreshControl.endRefreshing()
                    }
                }
        })

        task.resume()
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
