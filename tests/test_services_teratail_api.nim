import unittest
import "services/teratail/api"

suite "API Client":
  test "Default URL":
    let apiClient = newApiClient()
    check apiClient.endpoint == "https://teratail.com/api/v1"

  test "Change URL":
    let apiClient = newApiClient("http://example.com")
    check apiClient.endpoint == "http://example.com"

suite "ApiClient.getXxx":
  let endpoint = "https://private-anon-d708d0e3a4-teratailv1.apiary-mock.com/api/v1"
  let apiClient = newApiClient(endpoint)

  test "questions":
    let resp = apiClient.getQuestions("teratail")
    check len(resp.items) == 2
    check not resp.hasNext()

  test "replies":
    let resp = apiClient.getReplies("teratail")
    check len(resp.items) == 2
    check not resp.hasNext()
