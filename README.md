# 🌤️ Weather Forecast App

A production-quality Ruby on Rails application that allows users to input an address, fetches weather data using an external API, caches results using Redis, and displays relevant forecast information. Built with best practices for scalable, maintainable, and testable enterprise-grade software.

---

## 📌 Purpose

This project was developed as part of a take-home coding assessment. While the functionality is straightforward, it is implemented to demonstrate:
- Clean architecture
- Encapsulated service objects
- Test coverage (unit & request specs)
- Redis-backed caching
- Error handling and logging
- Decomposition and reusability

---

## 🛠️ Tech Stack

| Layer        | Tool / Library          |
|--------------|--------------------------|
| Language     | Ruby 3.2.0               |
| Framework    | Ruby on Rails 7.1.5      |
| Caching      | Redis                    |
| HTTP Client  | HTTParty                 |
| Geocoding    | Geocoder                 |
| Testing      | RSpec, Capybara, WebMock |
| Environment  | dotenv-rails             |
| DB (local)   | SQLite3                  |

---

## ✨ Features

- Accept user-entered address
- Convert address to coordinates via **Geocoder**
- Call external weather API (e.g., OpenWeatherMap)
- Display:
  - Temperature
  - High/Low
  - Weather conditions
  - Indicator if served from cache
- Store forecast for 30 minutes in **Redis cache**
- Designed for easy testing and future enhancements

---

## 🧱 App Structure & Object Decomposition

### `app/services/location_resolver_service.rb`
- **Role**: Converts address → latitude/longitude using Geocoder.
- **Why**: Keeps controller clean and testable.
- **Pattern**: Service Object.

### `app/services/forecast_cache_service.rb`
- **Role**: Retrieves forecast (cached or fresh), saves to Redis.
- **Encapsulates**: Caching logic, API integration, error handling.
- **Pattern**: Adapter + Caching Layer.

### `app/services/weather_service.rb`
- **Role**: Calls external API (OpenWeatherMap).
- **Pattern**: Adapter with HTTP abstraction via HTTParty.

### `app/controllers/forecast_controller.rb`
- **Role**: Accepts address param, delegates to services, renders view.
- **Keeps controller**: Lean and focused.

---

## ⚙️ Setup Instructions

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/your-username/weather_forecast_app.git
cd weather_forecast_app
bundle install
