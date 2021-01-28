import Foundation

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var name: String = ""
    
    struct Weather: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    struct Main: Codable {
        var temp: Double = 0.0
        var tempString: String {
            return String(format: "%.0f", temp) }
        var pressure: Int = 0
        var humidity: Int = 0
    }
    
}
