import unittest
import "services/teratail/api"

suite "API Client":
  test "Default URL":
    let apiClient = newApiClient()
    check apiClient.endpoint == "https://teratail.com/api/v1"

  test "Change URL":
    let apiClient = newApiClient("http://example.com")
    check apiClient.endpoint == "http://example.com"
