package db

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

var DB *pgxpool.Pool

func ConnectDB(connString string) error {
	var err error
	DB, err = pgxpool.New(context.Background(), connString)
	if err != nil {
		return fmt.Errorf("unable to connect to database: %w", err)
	}

	config, err := pgxpool.ParseConfig(connString)
	if err != nil {
		return fmt.Errorf("failed to parse config: %w", err)
	}
	config.MaxConns = 10
	config.HealthCheckPeriod = 30 * time.Second

	DB, err = pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		return fmt.Errorf("failed to create connection pool: %w", err)
	}

	log.Println("Database connected successfully")
	return nil
}

func CloseDB() {
	if DB != nil {
		DB.Close()
	}
}
