package main

import (
    "pulumi/internal/container"
    "pulumi/internal/config"
    "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
    pulumi.Run(func(ctx *pulumi.Context) error {
        cfg := config.LoadConfig()
        
        // Create the first container
        err := container.CreateProxmoxContainer(cfg.ApiURL, cfg.Token, "KC-HAPROXY01", cfg.Image, cfg.Password)
        if err != nil {
            return err
        }
        ctx.Log.Info("Container 1 has been created successfully")

        // Create the second container
        err = container.CreateProxmoxContainer(cfg.ApiURL, cfg.Token, "KC-HAPROXY02", cfg.Image, cfg.Password)
        if err != nil {
            return err
        }
        ctx.Log.Info("Container 2 has been created successfully")

        return nil
    })
}