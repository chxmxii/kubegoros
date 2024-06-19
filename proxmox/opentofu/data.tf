data "ct_config" "node_ignition" {
  strict = true
  content = templatefile("butane/config.yaml.tftpl", {
    ssh_admin_username   = "admin"
    ssh_admin_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr5956zzEBMABw37xfEW5XVaz7do6L/1Wbh+ZPff17zDSeLeUPhzoGN4w0kx/Mg2ir+QVTvYNCZIr/O0f7Vbncn+sELturIMqDZEar5G+66XMpBJZbBqJ6wYcjYUpzk00Ai4ndpybIkxnrp3W4Fb2WyQk6dDpbNLbwfrALb557LXwY+XkIiYvJNfzTAZ6z4ZToYZN37SB9dLJ1BmYwVp9wf6ngSW92g82qJvumxCldR0UxI8bvTZbPeS4nBW01qmhmWwmmMjb3OtdmQ3AFhtHk7Had2lxx6JdEiUn/X6JRBzfO8vaVsz0d4jIO6poWqHitN1tR93cqon9eumxRKNmn root@ansible-controller"
    hostname             = "localhost"
  })
}