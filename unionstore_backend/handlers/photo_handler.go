package handlers

import (
	"encoding/json"
	"net/http"
	"os"
)

func GetUploadedPhotos(w http.ResponseWriter, r *http.Request) {
	const uploadDir = "./uploads"

	files, err := os.ReadDir(uploadDir)
	if err != nil {
		http.Error(w, "Не удалось получить список файлов", http.StatusInternalServerError)
		return
	}

	var photos []string
	for _, file := range files {
		if !file.IsDir() {
			photos = append(photos, "/uploads/"+file.Name())
		}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(photos)
}
