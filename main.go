package main

import (
	"github.com/hashicorp/terraform-plugin-sdk/plugin"

	"github.com/cvbarros/terraform-provider-teamcity/teamcity"

    "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
    "github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: teamcity.Provider})
}
