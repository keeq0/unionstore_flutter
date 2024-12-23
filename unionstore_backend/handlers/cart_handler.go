package handlers

import (
	"encoding/json"
	"net/http"
	"os"
	"unionstore-backend/models"
)

var cart = []models.CartItem{}

func init() {
	LoadCartFromFile()
}

func LoadCartFromFile() {
	file, err := os.Open("./data/cart.json")
	if err != nil {

		cart = []models.CartItem{}
		return
	}
	defer file.Close()

	if err := json.NewDecoder(file).Decode(&cart); err != nil {
		cart = []models.CartItem{}
	}
}

func SaveCartToFile() {
	file, err := os.Create("./data/cart.json")
	if err != nil {
		return
	}
	defer file.Close()

	json.NewEncoder(file).Encode(cart)
}

func GetCart(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(cart)
}

func AddToCart(w http.ResponseWriter, r *http.Request) {
	var item models.CartItem
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, "Некорректный формат данных", http.StatusBadRequest)
		return
	}

	for i, cartItem := range cart {
		if cartItem.ProductID == item.ProductID {
			cart[i].Quantity += item.Quantity
			SaveCartToFile()
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(cart[i])
			return
		}
	}

	cart = append(cart, item)
	SaveCartToFile()
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(item)
}

func RemoveFromCart(w http.ResponseWriter, r *http.Request) {
	var item struct {
		ProductID int `json:"product_id"`
	}

	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, "Некорректный формат данных", http.StatusBadRequest)
		return
	}

	for i, cartItem := range cart {
		if cartItem.ProductID == item.ProductID {

			cart = append(cart[:i], cart[i+1:]...)
			SaveCartToFile()
			w.WriteHeader(http.StatusOK)
			w.Write([]byte("Товар удалён из корзины"))
			return
		}
	}

	http.Error(w, "Товар не найден в корзине", http.StatusNotFound)
}

func IncreaseQuantity(w http.ResponseWriter, r *http.Request) {
	var item struct {
		ProductID int `json:"product_id"`
	}

	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, "Некорректный формат данных", http.StatusBadRequest)
		return
	}

	for i, cartItem := range cart {
		if cartItem.ProductID == item.ProductID {
			cart[i].Quantity++
			SaveCartToFile()
			w.WriteHeader(http.StatusOK)
			json.NewEncoder(w).Encode(cart[i])
			return
		}
	}

	http.Error(w, "Товар не найден в корзине", http.StatusNotFound)
}

func DecreaseQuantity(w http.ResponseWriter, r *http.Request) {
	var item struct {
		ProductID int `json:"product_id"`
	}

	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, "Некорректный формат данных", http.StatusBadRequest)
		return
	}

	for i, cartItem := range cart {
		if cartItem.ProductID == item.ProductID {
			if cart[i].Quantity > 1 {
				cart[i].Quantity--
				SaveCartToFile()
				w.WriteHeader(http.StatusOK)
				json.NewEncoder(w).Encode(cart[i])
			} else {
				http.Error(w, "Нельзя уменьшить количество меньше 1", http.StatusBadRequest)
			}
			return
		}
	}

	http.Error(w, "Товар не найден в корзине", http.StatusNotFound)
}
