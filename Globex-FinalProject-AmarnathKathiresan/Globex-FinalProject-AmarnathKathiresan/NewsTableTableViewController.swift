//
//  NewsTableTableViewController.swift
//  Globex-FinalProject-AmarnathKathiresan
//
//  Created by Amarnath  Kathiresan on 2023-12-11.
//

import UIKit

class NewsTableTableViewController: UITableViewController {
    var locationName : String?
    let newsAPIKey = "f4bc8d3da81f45718603a113513d4fc9"
    
    // Data model to represent news information
    struct News {
        var title: String
        var description: String
        var author: String
        var source: String
        var cityName: String // Include cityName in News
    }
    // Define the NewsAPIResponse struct to match the NewsAPI JSON structure
    
    // MARK: - Welcome
    struct NewsAPIURLResponse: Codable {
        let articles: [Article]
    }
    
    // MARK: - Article
    struct Article: Codable {
        let source: Source
        let author: String?
        let title, description: String
    }
    
    // MARK: - Source
    struct Source: Codable {
        let name: String
    }
    var cityName: String?
    
    var selectedCity: String?
    
    // Array to store news data
    var newsData: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the locationName property as needed
        if let locationName = locationName {
            // Do something with the locationName
            print("Received location name in NewsViewController: \(locationName)")
        }
    }
    
    func setCityName(_ cityName: String) {
        print("Received cityName:", cityName)
        self.cityName = cityName
        self.fetchNews(cityName)
    }
    
    // Function to fetch news data from NewsAPI.org
    func fetchNews(_ cityName: String) {
        
        let newsURL = "https://newsapi.org/v2/everything?q=\(cityName)&apiKey=\(newsAPIKey)"
        print(newsURL)
        
        guard let url = URL(string: newsURL) else {
            print("Invalid URL")
            return
        }
        
        // Create a data task to fetch news data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching news: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode JSON data into a struct representing the NewsAPI response
                let decoder = JSONDecoder()
                let newsAPIResponse = try decoder.decode(NewsAPIURLResponse.self, from: data)
                
                // Extract relevant information and populate the newsData array
                self.newsData = newsAPIResponse.articles.map {
                    News(
                        title: $0.title,
                        description: $0.description,
                        author: $0.author ?? "",
                        source: $0.source.name,
                        cityName: cityName // Include cityName in News
                    )
                }
                
                // Save data to UserDefaults
                self.saveToUserDefaults()
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    func saveToUserDefaults() {
        // Include cityName in the dictionary to be saved
        let encodedData = newsData.map {
            [
                "title": $0.title,
                "description": $0.description,
                "author": $0.author,
                "source": $0.source,
                "cityName": $0.cityName // Include cityName in the saved data
            ]
        }
        UserDefaults.standard.set(encodedData, forKey: "savedNewsData")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("NewsData")
        print(newsData.count)
        return newsData.count
    }
    
    @IBAction func addLocation(_ sender: Any) {
        showChangeLocationAlert()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticleCell", for: indexPath) as! NewsTableViewCell
        
        // Get the news for the current row
        let news = newsData[indexPath.row]
        
        // Populate the labels with news data
        cell.newsTitle.text = news.title
        cell.newsDescription.text = news.description
        cell.newsSource.text = "Source : "+news.source
        cell.newsAuthor.text = "Author : "+news.author
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Adjust the cell height based on your design
        return 220.0
    }
    
    
    func showChangeLocationAlert(){
        let alertController = UIAlertController(
            title: "Where would you want news from?",
            message: "Enter your new news location here",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter city name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let changeAction = UIAlertAction(title: "Change", style: .default) { _ in
            if let cityName = alertController.textFields?.first?.text {
                self.selectedCity = cityName
                self.fetchNews(cityName)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(changeAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension NewsTableTableViewController.News {
    init?(fromDictionary data: [String: Any]) {
        guard
            let title = data["title"] as? String,
            let description = data["description"] as? String,
            let author = data["author"] as? String,
            let source = data["source"] as? String,
            let cityName = data["cityName"] as? String // Include cityName in the initialization
        else {
            return nil
        }

        self.title = title
        self.description = description
        self.author = author
        self.source = source
        self.cityName = cityName // Set cityName
    }

    var toDictionary: [String: Any] {
        return [
            "title": title,
            "description": description,
            "author": author,
            "source": source,
            "cityName": cityName // Include cityName in the dictionary
        ]
    }

    
}
