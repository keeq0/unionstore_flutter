package routes

import (
	"net/http"
	"unionstore-backend/handlers"

	"github.com/gorilla/mux"
)

func RegisterRoutes(router *mux.Router) {
	// Продукты
	router.HandleFunc("/products", handlers.GetProducts).Methods("GET")
	router.HandleFunc("/products/create", handlers.CreateProduct).Methods("POST")
	router.HandleFunc("/products/delete", handlers.DeleteProduct).Methods("DELETE")
	router.HandleFunc("/products/update/{id}", handlers.UpdateProduct).Methods("PUT")
	router.HandleFunc("/products/{id:[0-9]+}", handlers.GetProductByID).Methods("GET")

	// Корзина
	router.HandleFunc("/cart", handlers.GetCart).Methods("GET")
	router.HandleFunc("/cart/add", handlers.AddToCart).Methods("POST")
	router.HandleFunc("/cart/remove", handlers.RemoveFromCart).Methods("DELETE")
	router.HandleFunc("/cart/increase", handlers.IncreaseQuantity).Methods("PUT")
	router.HandleFunc("/cart/decrease", handlers.DecreaseQuantity).Methods("PUT")

	// Авторизация
	router.HandleFunc("/register", handlers.Register).Methods("POST")
	router.HandleFunc("/login", handlers.Login).Methods("POST")

	// Фото
	router.HandleFunc("/photos", handlers.GetUploadedPhotos).Methods("GET")

	// Статические файлы
	ServeStaticFiles(router)
}

func ServeStaticFiles(router *mux.Router) {

	router.PathPrefix("/uploads/").Handler(http.StripPrefix("/uploads/", http.FileServer(http.Dir("./uploads/"))))
}
