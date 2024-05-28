# MovieDB Application 

An application load movies from https://api.themoviedb.org 

## Features

**1. List Movies

- Load list movies from API
- Search movies by keyword
- Add pull to refresh
- Add load more to load movies when scrolling, 20 items per page
- Favorite / unfavorite a movie
- Load cached movies while offline

**2. View favorite movies
- Display favorite movies in a carousel that the user can scroll through

## Architecture
![img_mvvm.png](images%2Fimg_mvvm.png)

## Libraries

- **provider**: State management
- **get_it**: Dependency injection.
- **dio**: HTTP client
- **json_annotation**: Create code for JSON serialization and deserialization
- **json_serializable**: Automatically generate code for converting to and from JSON by annotating Dart classes
- **cached_network_image**: Load and cache network images
- **carousel_slider**: Display carousel slider widget

## How to run
- Android / iOS: ```flutter run```

## What is incomplete:
- Show loading UI using shimmer
- Detect connectivity change
- Show empty view when movies list is empty