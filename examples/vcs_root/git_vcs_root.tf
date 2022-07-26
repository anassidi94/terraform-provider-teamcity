#This sample shows how to configure a Git VCS root
provider "teamcity" {
  address  = var.teamcity_url
  username = var.teamcity_username
  password = var.teamcity_password
}

resource "teamcity_project" "project" {
  name = "Samples - Git VCS Root"
}

resource "teamcity_vcs_root_git" "vcs" {
  name       = "Application"
  project_id = teamcity_project.project.id

  // Repo fetch URL. Use git@github.com/... if using SSH. Use https://github.com/... if using Anonymous or Userpass authentication.
  fetch_url = "https://github.com/kelseyhightower/nocode"

  // Optional, assumes fetch_url if absent
  push_url = "https://github.com/kelseyhightower/nocode"

  // Default branch to monitor. Required.
  default_branch = "refs/head/master"

  // Additional branch specs to monitor. Optional
  branches = [
    "+:refs/(pull/*)/head",
    "refs/heads/develop",
  ]

  //enable/disable use tags in branch specification. Defaults to false.
  enable_branch_spec_tags = false

  //Can be "userid", "author_name", "author_email", "author_full"
  username_style = "userid"

  //True to include submodules in checkouts, false otherwise.
  submodule_checkout = "checkout"

  // Configure agent settings
  agent {
    // To customize where git binary is located on agent
    git_path = "/usr/bin/git"

    // Can be "branch_change", "always", "never"
    clean_policy = "branch_change"

    // Can be "untracked", "ignored_only", "non_ignored_only"
    clean_files_policy = "untracked"

    //When enabled, TeamCity creates a separate clone of the repository on each agent and uses it in the checkout directory via git alternates.
    //Defaults to true
    use_mirrors = true
  }

  // Auth block configures the authentication to Git VCS
  auth {
    // Can be "userpass", "ssh", "anonymous"
    type     = "userpass"
    username = "admin"

    //If specifying SSH, the following options below are also valid
    // Can be "uploadedKey", "customKey", "defaultKey"
    ssh_type = "uploadedKey"

    // "myKey" if using "uploadedKey" configured in SSH TeamCity keys to reuse or the
    // If using "customKey", refers to path to a private key. Required if "projectKey" or "customKey".
    key_spec = "myKey"

    // Password for userpass auth
    // Private key passphrase if using "uploadedKey" or "customKey".
    // Sensitive -> always updated on apply because TC doesn't return passwords
    // BE CAREFUL - THIS IS STORED IN PLAIN TEXT ON STATE FILE!
    // Refer to: https://www.terraform.io/docs/state/sensitive-data.html
    password = "<<<secret>>>"
  }
}
