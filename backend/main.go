package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)


type Car struct {
	ID          int     `json:"id"`
	Name        string  `json:"name"`
	ImageURL    string  `json:"imageUrl"`
	Price       float64 `json:"price"`
	Description string  `json:"description"`
	Horsepower  string  `json:"horsepower"`
	Acceleration string `json:"acceleration"`
	EngineType  string  `json:"engineType"`
	MaxSpeed    string  `json:"maxSpeed"`
	IsFavorite  bool    `json:"isFavorite"`
	Quantity    int     `json:"quantity"`
}

// Пример списка автомобилей
var cars = []Car{
	{
		ID:          1,
		Name:        "Tesla Model S",
		ImageURL:    "https://www.zr.ru/d/story/c4/924100/tesla-model-s-samyj-dalnobojnyj-elektromobil.jpg",
		Price:       79999.00,
		Description: "Электрический седан с невероятным запасом хода и высокой производительностью.",
		Horsepower:  "1020",
		Acceleration: "2.1",
		EngineType:  "Электрический",
		MaxSpeed:    "322",
		IsFavorite:  false,
		Quantity:    0,
	},
	{
		ID:          2,
		Name:        "BMW M5",
		ImageURL:    "https://s.auto.drom.ru/i24212/c/photos/fullsize/bmw/m5/gen240x2_bmw_m5_749004.jpg",
		Price:       100000.00,
		Description: "Доработанная подразделением BMW Motorsport версия автомобиля BMW пятой серии. Первое поколение было представлено в 1986 году.",
		Horsepower:  "727",
		Acceleration: "3",
		EngineType:  "Бензиновый",
		MaxSpeed:    "350",
		IsFavorite:  false,
		Quantity:    0,
	},
}


func getCarsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(cars)
}


func addCarHandler(w http.ResponseWriter, r *http.Request) {
	var newCar Car
	if err := json.NewDecoder(r.Body).Decode(&newCar); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	newCar.ID = len(cars) + 1
	cars = append(cars, newCar)
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(newCar)
}


func updateCarHandler(w http.ResponseWriter, r *http.Request) {
	var updatedCar Car
	if err := json.NewDecoder(r.Body).Decode(&updatedCar); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	for i, car := range cars {
		if car.ID == updatedCar.ID {
			cars[i] = updatedCar
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(updatedCar)
			return
		}
	}
	http.Error(w, "Car not found", http.StatusNotFound)
}


func deleteCarHandler(w http.ResponseWriter, r *http.Request) {
	var targetCar Car
	if err := json.NewDecoder(r.Body).Decode(&targetCar); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	for i, car := range cars {
		if car.ID == targetCar.ID {
			cars = append(cars[:i], cars[i+1:]...)
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(targetCar)
			return
		}
	}
	http.Error(w, "Car not found", http.StatusNotFound)
}

func main() {
	http.HandleFunc("/products", getCarsHandler)         // Получить все автомобили
	http.HandleFunc("/products/add", addCarHandler)      // Добавить автомобиль
	http.HandleFunc("/products/update", updateCarHandler) // Обновить автомобиль
	http.HandleFunc("/products/delete", deleteCarHandler) // Удалить автомобиль

	fmt.Println("Server is running on port 8080!")
	http.ListenAndServe(":8080", nil)
}
