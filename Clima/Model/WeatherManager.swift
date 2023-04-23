import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager:WeatherManager,_ weather:WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    
    var delgate : WeatherManagerDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=22b878e029ebdbe1cd2381f5d1135ac9&units=metric"
    func fetchWeather(cityName:String){
        let urlString = weatherUrl + "&q=" + cityName
        //print(urlString)
        performRequest(with: urlString)
        
    }
    func fetchWeather(latitiude:CLLocationDegrees,longitude:CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitiude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString:String) {
        //1.Create a Url
        if let url = URL(string: urlString){
            //2.create a urlsession
            let session = URLSession(configuration: .default)
            //3.give session a task
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil{
                    self.delgate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString!)
                    if let weather = parseJson(weatherData: safeData){
                        self.delgate?.didUpdateWeather(weatherManager: self,weather)
                    }
                        
                }
            }
            //4.start task
            task.resume()
        }
    }
    func parseJson(weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let weatherModel = WeatherModel(cityName: name, conditionid: id, temperature: temp)
            return weatherModel
        }
        catch{
            self.delgate?.didFailWithError(error: error)
            return nil
        }
    }

}
