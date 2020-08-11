//
//  WeatherVC.swift
//  OnTime Weather App

import UIKit

class WeatherVC: UIViewController {

    //MARK:- vars
    var location:LocationDB?
    var weatherArr = [WeatherModel]()
    var isShow = false
    var isFromMap = true
    var weatherResource:WeatherResource?
  
    //MARK:- outlets
 
    @IBOutlet weak var btnShowLast: UIButton!
    @IBOutlet weak var tableView: TanibleView!
    @IBOutlet weak var lblTempMAx: UILabel!
    @IBOutlet weak var lblRain: UILabel!
    @IBOutlet weak var lblWend: UILabel!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var lblHumedity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insetsLayoutMarginsFromSafeArea = false

       setupLayouts()
        isFromMap ? loadDataFromMap():loadDataFromSearch()
        addRefreshController(tabelView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
   
    }
    
    func addRefreshController(tabelView:UITableView){
      let refreshControl = UIRefreshControl()
       refreshControl.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
      refreshControl.addTarget(self, action:
        #selector(handleRefresh(_:_:)),for: .valueChanged)
      tableView.refreshControl = refreshControl
    }
    
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl,_ tableView:UITableView) {
        getLastDaysData {
          refreshControl.endRefreshing()
        }

        }
    
    func loadDataFromSearch(){
        if let weatherResource = weatherResource{
            let weatherModel = WeatherModel(description: weatherResource.weather?.first?.description ?? "", temp: (weatherResource.main?.temp ?? 0)/10, humidity: Double(weatherResource.main?.humidity ?? 0), tempMin: (weatherResource.main?.temp_min ?? 0)/10, tempMax: (weatherResource.main?.temp_max ?? 0)/10, wendSpeed: (weatherResource.wind?.speed ?? 0), rainVolume: 0)
            setupViews(weather: weatherModel)
        }
    }
    
    func setupViews(weather:WeatherModel){
        let temp = String(format: "%.2f", weather.temp)
        let tempMax = String(format: "%.2f", weather.tempMax)
        let tempMin = String(format: "%.2f", weather.tempMin)
        self.lblTemp.text = "Tempreture is \(temp) C"
        self.lblTempMAx.text = "MAX Temp. is \(tempMax) C"
        self.lblTempMin.text = "MIN Temp is \(tempMin) C"
        self.lblWend.text = "Wind Speed is \(weather.wendSpeed ?? 0) m/s"
        self.lblHumedity.text = "Humidity is \(weather.humidity) %"
        self.lblDescription.text = "Weather is \(weather.description)"
        if weather.rainVolume == 0.0 {
            self.lblRain.text = "No Chance For Rain"
        }else {
            self.lblRain.text = "Rain Volume \(weather.rainVolume ?? 0) mm"
            
        }
    }
    
    func loadDataFromMap(){
        shouldPresentLoadingView(true)
        guard let location = location else {return}
        DataService.instance.getWeatherToday(long: location.longitude, lat: location.latitude) { (success, weather) in
                   if success{
                   
                    guard let weather = weather else {return}
                    self.setupViews(weather: weather)
                   }else{
                    self.alertUser(message: "Connection Error")
                   }
               self.shouldPresentLoadingView(false)
               }
    }

    func initLocation(loc:LocationDB) {
        self.location = loc
    }

    func setupLayouts(){
        tableView.isHidden = true
        btnShowLast.layer.borderWidth = 3
        btnShowLast.layer.cornerRadius = 5
        btnShowLast.layer.borderColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
    }
    
    func showLastDays(lat:Double,lang:Double,complition:(()->())?){
        shouldPresentLoadingView(true)
        DataService.instance.getWeatherLastDays(long: lang, lat: lat) { (success, weathArr) in
            if success{
                self.tableView.isHidden = false
                self.weatherArr = weathArr!
                self.tableView.direction = .right
                self.tableView.setNeedsDisplay()
                self.tableView.reloadData()
                if let complition = complition{
                complition()
                }
            }else{
                self.alertUser(message: "Connection Error")
            }
            self.shouldPresentLoadingView(false)
        }
    }
    
    func getLastDaysData(complition:(()->())?){
        if isFromMap{
            self.showLastDays(lat: location?.latitude ?? 0, lang: location?.longitude ?? 0, complition: complition)
        }else{
            if let weatherResource = weatherResource{
                showLastDays(lat: weatherResource.coord?.lat ?? 0, lang: weatherResource.coord?.lon ?? 0, complition: complition)
            }
        }
    }
    
    //MARK:- Action
    
    @IBAction func btnLastShowPressed(_ sender: UIButton) {
        isShow = !isShow
        tableView.isHidden = !isShow
        if isShow{
            self.getLastDaysData(complition: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.btnShowLast.setTitle("HIDE NEXT 10 FORCASTS", for: UIControlState.normal)
                
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.btnShowLast.setTitle("SHOW NEXT 10 FORCASTS", for: UIControlState.normal)
            })
        }
    }
    @IBAction func btbBackPressed(_ sender: UIButton) {
        dissmissDetail()
    }
    
    
}

extension WeatherVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return weatherArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LastDaysCell", for: indexPath) as? LastDaysCell else {return UITableViewCell()}
        cell.configCell(weather: weatherArr[indexPath.row])
        cell.viewBackground.backgroundColor = indexPath.row % 2 == 0 ?#colorLiteral(red: 0.1476022899, green: 0.2752392292, blue: 0.669305649, alpha: 1):#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        return cell
    }
    
}
