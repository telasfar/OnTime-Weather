//
//  HelpVC.swift
//  OnTime Weather App
//


import UIKit
import WebKit


class HelpVC: UIViewController,WKNavigationDelegate {

 
    //MARKS:- outlets
    @IBOutlet weak var webView: WKWebView!
    
    //vars
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.navigationDelegate = self
        //let url = URL(string: "https://openweathermap.org/")!
        let url = Bundle.main.url(forResource: "vv", withExtension: "html")

        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }


    @IBAction func btnBackPressed(_ sender: UIButton) {
        dissmissDetail()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func writeToFile(){
        let str = generateString()
        let filename = getDocumentsDirectory().appendingPathComponent("output.html")
        
        do {
            try str!.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func generateString() -> String? {
        var resultString: String?
        
        let howToUse = "to use this App. You need to pin a location on the map and it will added automaticly to your Bookmark Locations ...and to delete a location you need to swipe left on any record in the bookmark and a DELETE Button will show to you and you can delete that record...also when you show the menu you can swipe right to hide it OR click again on the menu Button..if you need to get the location result just tap on it in the bookmark list and you will find a full info about the location also a five last days results to show ..."
        
        let firstString = "<DOCTYPE HTML> \r <html lang=\"en\" \r <head> \r <meta charset = \"utf-8\"> \r </head> \r <body>"
        let endString = "</body> \r </html>";
        resultString = firstString + howToUse + endString;
        
        return resultString
    }

}
