package container

import (
    "bytes"
    "encoding/json"
    "fmt"
    "net/http"
)

func CreateProxmoxContainer(apiURL, token, containerName, image, password string) error {
    url := fmt.Sprintf("%s/api2/json/nodes/YOUR_NODE_NAME/lxc", apiURL)
    containerData := map[string]interface{}{
        "vmid":           100, // VMID should be unique
        "ostemplate":     image,
        "password":       password,
        "hostname":       containerName,
        "memory":         512, // Example memory size in MB
        "rootfs":         "local-lvm:8", // Example disk size in GB
        "cpus":           1,
        "nets": map[string]interface{}{
            "net0": "name=eth0,bridge=vmbr0,ip=dhcp",
        },
    }
    data, _ := json.Marshal(containerData)
    req, _ := http.NewRequest("POST", url, bytes.NewBuffer(data))
    req.Header.Set("Authorization", fmt.Sprintf("PVEAPIToken=%s", token))
    req.Header.Set("Content-Type", "application/json")
    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        return err
    }
    defer resp.Body.Close()

    if resp.StatusCode != http.StatusOK {
        return fmt.Errorf("failed to create container, status code: %d", resp.StatusCode)
    }
    return nil
}