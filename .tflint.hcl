plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

config {
  module = true
}

ignore_module {
  name = "examples/simple"
}
