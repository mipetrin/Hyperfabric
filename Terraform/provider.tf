terraform {
  required_providers {
    hyperfabric = {
      source = "CiscoDevNet/hyperfabric"
    }
  }
}

provider "hyperfabric" {
   token = "insert your API Bearer token here"
   # https://developer.cisco.com/docs/hyperfabric/authentication/#bearer-tokens
   retries = 2
   label = "terraform"
  # proxy_url = "http://proxy.esl.cisco.com"
  # proxy_creds = "username:password"
   auto_commit = true
}
