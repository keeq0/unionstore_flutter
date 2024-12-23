package handlers

import (
	"encoding/json"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"unionstore-backend/models"

	"github.com/gorilla/mux"
)

var products []models.Product

func init() {
	file, err := os.Open("./data/products.json")
	if err != nil {
		panic("Не удалось загрузить данные")
	}
	defer file.Close()

	if err := json.NewDecoder(file).Decode(&products); err != nil {
		panic("Ошибка обработки данных")
	}
}

func GetProducts(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}

func CreateProduct(w http.ResponseWriter, r *http.Request) {

	r.ParseMultipartForm(10 << 20)

	file, _, err := r.FormFile("image")
	if err != nil {
		http.Error(w, "Не удалось загрузить изображение", http.StatusBadRequest)
		return
	}
	defer file.Close()

	var maxID int
	for _, product := range products {
		if product.ID > maxID {
			maxID = product.ID
		}
	}
	newID := maxID + 1

	savePath := filepath.Join("./uploads", strconv.Itoa(newID)+".png")
	saveFile, err := os.Create(savePath)
	if err != nil {
		http.Error(w, "Не удалось сохранить файл", http.StatusInternalServerError)
		return
	}
	defer saveFile.Close()
	_, err = saveFile.ReadFrom(file)
	if err != nil {
		http.Error(w, "Ошибка при записи файла", http.StatusInternalServerError)
		return
	}

	currentPrice, _ := strconv.Atoi(r.FormValue("current_price"))
	product := models.Product{
		ID:           newID,
		Brand:        r.FormValue("brand"),
		Name:         r.FormValue("name"),
		Description:  r.FormValue("description"),
		CurrentPrice: currentPrice,
		Article:      r.FormValue("article"),
		Season:       r.FormValue("season"),
		Material:     r.FormValue("material"),
		MainPhotoID:  newID,
	}

	products = append(products, product)

	if err := saveProductsToFile(); err != nil {
		http.Error(w, "Не удалось сохранить данные в файл", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(product)
}

func saveProductsToFile() error {
	file, err := os.Create("./data/products.json")
	if err != nil {
		return err
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	return encoder.Encode(products)
}

func DeleteProduct(w http.ResponseWriter, r *http.Request) {
	idStr := r.URL.Query().Get("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Некорректный ID", http.StatusBadRequest)
		return
	}

	var indexToRemove = -1
	for i, product := range products {
		if product.ID == id {
			indexToRemove = i
			break
		}
	}

	if indexToRemove == -1 {
		http.Error(w, "Продукт не найден", http.StatusNotFound)
		return
	}

	productToRemove := products[indexToRemove]
	products = append(products[:indexToRemove], products[indexToRemove+1:]...)

	imagePath := filepath.Join("./uploads", strconv.Itoa(productToRemove.MainPhotoID)+".png")
	if err := os.Remove(imagePath); err != nil {
		http.Error(w, "Ошибка при удалении файла изображения", http.StatusInternalServerError)
		return
	}

	if err := saveProductsToFile(); err != nil {
		http.Error(w, "Ошибка при сохранении данных", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Продукт удален"))
}

func UpdateProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Некорректный ID", http.StatusBadRequest)
		return
	}

	r.ParseMultipartForm(10 << 20)

	var productToUpdate *models.Product
	for i := range products {
		if products[i].ID == id {
			productToUpdate = &products[i]
			break
		}
	}
	if productToUpdate == nil {
		http.Error(w, "Продукт не найден", http.StatusNotFound)
		return
	}

	productToUpdate.Brand = r.FormValue("brand")
	productToUpdate.Name = r.FormValue("name")
	productToUpdate.Description = r.FormValue("description")
	currentPrice, _ := strconv.Atoi(r.FormValue("current_price"))
	productToUpdate.CurrentPrice = currentPrice
	productToUpdate.Article = r.FormValue("article")
	productToUpdate.Season = r.FormValue("season")
	productToUpdate.Material = r.FormValue("material")

	file, _, err := r.FormFile("image")
	if err == nil {
		defer file.Close()

		savePath := filepath.Join("./uploads", strconv.Itoa(id)+".png")
		saveFile, err := os.Create(savePath)
		if err != nil {
			http.Error(w, "Не удалось сохранить файл", http.StatusInternalServerError)
			return
		}
		defer saveFile.Close()
		_, err = saveFile.ReadFrom(file)
		if err != nil {
			http.Error(w, "Ошибка при записи файла", http.StatusInternalServerError)
			return
		}
	}

	if err := saveProductsToFile(); err != nil {
		http.Error(w, "Ошибка при сохранении данных", http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(productToUpdate)
}

func saveDataToFile() {
	file, err := os.Create("./data/products.json")
	if err != nil {
		panic("Не удалось сохранить данные")
	}
	defer file.Close()

	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(products); err != nil {
		panic("Ошибка записи данных в файл")
	}
}

func GetProductByID(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	idStr := vars["id"]
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Некорректный ID", http.StatusBadRequest)
		return
	}

	for _, product := range products {
		if product.ID == id {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(product)
			return
		}
	}

	http.Error(w, "Продукт не найден", http.StatusNotFound)
}
