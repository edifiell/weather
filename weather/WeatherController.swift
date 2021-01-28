
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    // MARK: button layer
    @IBOutlet weak var button: UIButton! {
            didSet {
                button.layer.cornerRadius = button.frame.size.height / 2
                button.layer.masksToBounds = true
                let borderColor = UIColor.white
                button.layer.borderColor = borderColor.cgColor
                button.layer.borderWidth = 1.5
                button.layer.opacity = 2
                button.layer.shadowOffset = CGSize(width: 0, height: 5)
                button.layer.shadowOpacity = 0.5
                button.layer.shadowRadius = 5
            }
        }
    
    // MARK: - Public Properties
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()
    var city = ["London","Kiev","Paris","Berlin","Rome","Riga","Madrid","Damascus","Tunis"]
    var addCity = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        startLocationManager()
        updateWeatherInfoCity(city: "")
    }

    // MARK: Assign
    func updateView() {
        nameCityLabel.text = weatherData.name
        temperature.text = weatherData.main.tempString
    }
    
    
    // MARK: Search by location
    func updateWeatherInfo(latitude: Double, longtitude: Double) {
        let session = URLSession.shared
         let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&units=metric&lang=ru&appid=\(apiKey)")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
           
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                print(self.weatherData)
              
                DispatchQueue.main.async {
                    self.updateView()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Search by city
    
    //add new feature update weatherCity
    func updateWeatherInfoCity(city: String) {
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(addCity)&units=metric&lang=eu&apikey=\(apiKey)")!
    
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
   
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                print(self.weatherData)
   
                DispatchQueue.main.async {
                    self.updateView()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
// MARK: Action
    @IBAction func searchButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Search city", message: "Enter town", preferredStyle: .alert)
                
                let saveTask = UIAlertAction(title: "Ok", style: .default) { [self]
                           action in
                           let tf = alertController.textFields?.first
                           
                    
                            if let newTask = tf?.text {
                            if newTask != "" {
                                if newTask == newTask {
                                    if city.contains(tf?.text ?? "" ) {
                                        addCity = tf?.text ?? ""
                                        updateWeatherInfoCity(city: addCity)
                                        locationManager.stopUpdatingLocation()
                                    } else {
                                        let zeroValueAC = UIAlertController(title: "Warning!", message: "Сity does not exist or city not found(beta version)", preferredStyle: .alert)
                                        let cancelAction2 = UIAlertAction(title: "Cancel", style: .default) {_ in}
                                        
                                        zeroValueAC.addAction(cancelAction2)
                                        present(zeroValueAC, animated: true, completion: nil)
                                    }
                                }
                            
                            } else {
                                let zeroValueAC = UIAlertController(title: "Warning!", message: "You cannot enter an empty word", preferredStyle: .alert)
                                let cancelAction2 = UIAlertAction(title: "Cancel", style: .default) {_ in}
                                
                                zeroValueAC.addAction(cancelAction2)
                                present(zeroValueAC, animated: true, completion: nil)
                            }
                       }
                 }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) {_ in}
                
                alertController.addTextField { [self] tf in
                    tf.placeholder = city.randomElement() }
                alertController.addAction(cancelAction)
                alertController.addAction(saveTask)
                
                present(alertController, animated: true, completion: nil)
               
    }
    
}
// MARK: locationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
        }
    }
}


    

