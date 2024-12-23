package models

type Product struct {
	ID           int    `json:"id"`
	Brand        string `json:"brand"`
	Name         string `json:"name"`
	MainPhotoID  int    `json:"main_photo_id"`
	Description  string `json:"description"`
	CurrentPrice int    `json:"current_price"`
	OldPrice     *int   `json:"old_price"`
	Article      string `json:"article"`
	Season       string `json:"season"`
	Material     string `json:"material"`
	IsFavorite   bool   `json:"is_favorite"`
}
