package handlers

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"net/http"
	"time"
	"unionstore-backend/db"
	"unionstore-backend/models"
)

func Register(w http.ResponseWriter, r *http.Request) {
	var user models.User
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}

	hash := sha256.Sum256([]byte(user.Password))
	passwordHash := hex.EncodeToString(hash[:])

	query := `
		INSERT INTO users (username, email, password_hash, first_name, last_name, created_at) 
		VALUES ($1, $2, $3, $4, $5, $6) RETURNING id`
	err = db.DB.QueryRow(context.Background(), query, user.Username, user.Email, passwordHash, user.FirstName, user.LastName, time.Now()).Scan(&user.ID)
	if err != nil {
		http.Error(w, "Error saving user to database", http.StatusInternalServerError)
		return
	}

	user.Password = ""
	user.PasswordHash = ""
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

func Login(w http.ResponseWriter, r *http.Request) {
	var input struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}

	var user models.User
	var passwordHash string

	query := `
		SELECT id, username, email, password_hash, first_name, last_name 
		FROM users 
		WHERE email = $1`
	err = db.DB.QueryRow(context.Background(), query, input.Email).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&passwordHash,
		&user.FirstName,
		&user.LastName,
	)
	if err != nil {
		http.Error(w, "User not found", http.StatusUnauthorized)
		return
	}

	hash := sha256.Sum256([]byte(input.Password))
	if passwordHash != hex.EncodeToString(hash[:]) {
		http.Error(w, "Invalid credentials", http.StatusUnauthorized)
		return
	}

	user.Password = ""
	user.PasswordHash = ""
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}
