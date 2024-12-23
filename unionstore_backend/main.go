package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"unionstore-backend/db"
	"unionstore-backend/routes"

	"github.com/gorilla/mux"
)

func main() {

	connString := "postgres://postgres:123@localhost:5432/unionstore"
	db.ConnectDB(connString)

	if err := testDBConnection(); err != nil {
		log.Fatalf("Ошибка подключения к базе данных: %v", err)
	} else {
		fmt.Println("Успешное подключение к базе данных!")
	}

	router := mux.NewRouter()
	routes.RegisterRoutes(router)

	fmt.Println("Сервер запущен на http://127.0.0.1:8080")
	log.Fatal(http.ListenAndServe(":8080", router))
}

func testDBConnection() error {
	query := "SELECT 1"
	var result int
	err := db.DB.QueryRow(context.Background(), query).Scan(&result)
	if err != nil {
		return err
	}
	if result != 1 {
		return fmt.Errorf("ожидалось значение 1, получено: %v", result)
	}
	return nil
}
