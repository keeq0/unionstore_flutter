package models

type User struct {
	ID           int    `json:"id"`
	Username     string `json:"username"`                // Никнейм
	FirstName    string `json:"first_name"`              // Имя
	LastName     string `json:"last_name"`               // Фамилия
	Email        string `json:"email"`                   // Электронная почта
	Password     string `json:"password,omitempty"`      // Пароль (не отображается в JSON)
	PasswordHash string `json:"-"`                       // Хэш пароля (не отображается в JSON)
	ProfileImage string `json:"profile_image,omitempty"` // Путь к изображению профиля
	CreatedAt    string `json:"created_at,omitempty"`    // Дата создания
}
