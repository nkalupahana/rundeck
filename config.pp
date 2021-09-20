class { "rundeck":
    grails_server_url => sprintf("http://%s", $facts["gce"]["instance"]["networkInterfaces"][0]["accessConfigs"][0]["externalIp"])
}
