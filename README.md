# FlutterWeatherApp

# FlutterWeatherApp

### Updated to Flutter 3.0 & New Updated Design

A simple weather app created using [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/) and using API from [OpenWeatherMap](https://openweathermap.org/).</br></br>

<p align="center">
<img src="https://github.com/brendenozie/FlutterWeatherApp/blob/main/assets/images/img.png" width="50%" alt="screenshot"></img>
</p>

## App Features

- Display current weather and a **5-day forecast** for a selected city.
- Users can **search** for a city and view its weather details.
- **Loading indicator** while fetching data from the API.
- **Offline support**: Cache weather data for offline access.
- Show **last updated timestamp** when viewing cached data.
- **Error handling** for network issues and API failures.
- **Modern UI/UX** with appropriate icons, typography, and color schemes.
- Responsive design for different screen sizes.

## API Docs

> [!IMPORTANT]  
> This project uses **_version 3.0_** of the OpenWeatherMap API.</br> > **API used in this project**:</br>
>
> - [Current Weather API Docs](https://openweathermap.org/current#one)</br>
> - [One Call API Docs](https://openweathermap.org/api/one-call-api#data)</br>
> - [Geocoding API Docs](https://openweathermap.org/api/geocoding-api)</br>

## How to Run

1. Create an account at [OpenWeatherMap](https://openweathermap.org/).
2. Get your API key from https://home.openweathermap.org/api_keys.
   > Sometimes after getting your OpenWeatherMap API key it won't work right away. </br>
   > To test if your API key is working, paste the following link into your browser:</br>
   > Api Key Provided in the test pdf doesn't seem to work correctly
   >
   > ```
   > https://api.openweathermap.org/data/3.0/weather?lat=53.4794892&lon=-2.2451148&units=metric&appid=YOUR_API_KEY
   > ```
   >
   > Replace `YOUR_API_KEY` with your own API key from OpenWeatherMap.
   > Api Key Provided in the test pdf doesn't seem to work correctly
3. Clone the repo:
   ```sh
   git clone https://github.com/brendenozie/FlutterWeatherApp.git
   ```
4. Install all the packages:
   ```sh
   flutter pub get
   ```
5. Navigate to **lib/provider/weatherProvider.dart** and paste your API key into the `apiKey` variable:
   > Api Key Provided in the test pdf doesn't seem to work correctly
   ```dart
   String apiKey = 'Paste Your API Key Here';
   ```
6. Run the App:
   ```sh
   flutter run
   ```

## Approach & Challenges

### Approach

- Used **Flutter & Dart** to develop the application.
- Integrated **OpenWeather API** for fetching weather data.
- Implemented **local storage** to save weather data for offline access.
- Designed a **responsive UI** to work across different screen sizes.

### Challenges & Solutions

1. **Handling API Errors:**
   - Implemented error handling to display user-friendly messages.
   - Added retry mechanisms when fetching data fails.
2. **Offline Support:**
   - Used **local storage** to save and display cached weather data.
   - Indicate when data was last updated to inform users.
3. **UI/UX Optimization:**
   - Chose a modern and clean design with appropriate colors and typography.
   - Ensured responsiveness on different screen sizes.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Submission

- The source code is available in this GitHub repository.
- This README contains setup instructions and implementation details.

#   F l u t t e r W e a t h e r A p p 
 
 
