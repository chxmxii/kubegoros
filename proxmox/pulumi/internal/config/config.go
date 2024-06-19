package config

import (
    "os"
)

type Config struct {
    ApiURL   string
    Token    string
    Image    string
    Password string
}

func LoadConfig() Config {
    return Config{
        ApiURL:   os.Getenv("PROXMOX_API_URL"),
        Token:    os.Getenv("PROXMOX_API_TOKEN"),
        Image:    os.Getenv("PROXMOX_IMAGE"),
        Password: os.Getenv("PROXMOX_PASSWORD"),
    }
}