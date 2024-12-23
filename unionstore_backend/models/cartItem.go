package models

type CartItem struct {
	ProductID int `json:"product_id"`
	Quantity  int `json:"quantity"`
}
