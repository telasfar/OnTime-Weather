//
//  WeatherVC.swift
//  OnTime Weather App

import UIKit

class WeatherVC: UIViewController {

    //MARK:- vars
    var location:LocationDB!
    var weatherArr = [WeatherModel]()
    var isShow = false
  
    //MARK:- outlets
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var btnShowLast: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTempMAx: UILabel!
    @IBOutlet weak var lblRain: UILabel!
    @IBOutlet weak var lblWend: UILabel!
    @IBOutlet weak var lblTempMin: UILabel!
    @IBOutlet weak var lblHumedity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupLayouts()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.instance.getWeatherToday(long: location.longitude, lat: location.latitude) { (success, weather) in
            if success{
            self.activityIndecator.isHidden = true
            self.lblTemp.text = "Tempreture is \(weather!.temp) C"
            self.lblTempMAx.text = "MAX Temp. is \(weather!.tempMax) C"
            self.lblTempMin.text = "MIN Temp is \(weather!.tempMin) C"
            self.lblWend.text = "Wind Speed is \(weather!.wendSpeed!) m/s"
            self.lblHumedity.text = "Humidity is \(weather!.humidity) %"
            self.lblDescription.text = "Weather is \(weather!.description) in \(self.location.locationname!)"
                if weather?.rainVolume == 0.0 {
                    self.lblRain.text = "No Chance For Rain"
                }else {
                    self.lblRain.text = "Rain Volume \(weather!.rainVolume!) mm"

                }
            }else{
                self.alertUser(msg: "Connection Error")
            }
        }
        
    }

    func initLocation(loc:LocationDB) {
        self.location = loc
    }

    func setupLayouts(){
        tableView.isHidden = true
        activityIndecator.isHidden = false
        btnShowLast.layer.borderWidth = 3
        btnShowLast.layer.cornerRadius = 5
        btnShowLast.layer.borderColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
    }
    
    func showLastDays(){
        activityIndecator.isHidden = false
        DataService.instance.getWeatherLastDays(long: location.longitude, lat: location.latitude) { (success, weathArr) in
            if success{
                self.activityIndecator.isHidden = true
                self.tableView.isHidden = false
                self.weatherArr = weathArr!
                self.tableView.reloadData()
            }else{
                self.activityIndecator.isHidden = true
                self.alertUser(msg: "Connection Error")
                
            }
        }
    }
    
    //MARK:- Action
    
    @IBAction func btnLastShowPressed(_ sender: UIButton) {
        isShow = !isShow
        if isShow{
            btnShowLast.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.btnShowLast.setTitle("HIDE LAST 5 DAYS", for: UIControlState.normal)
                self.showLastDays()
            })
            btnShowLast.isEnabled = true
        }else{
            btnShowLast.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.btnShowLast.setTitle("SHOW LAST 5 DAYS", for: UIControlState.normal)
                self.tableView.isHidden = true

            })
            btnShowLast.isEnabled = true

           
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
        if indexPath.row % 2 == 0{
            cell.viewBackground.backgroundColor = #colorLiteral(red: 0.1476022899, green: 0.2752392292, blue: 0.669305649, alpha: 1)
        }
        return cell
    }
    
}
