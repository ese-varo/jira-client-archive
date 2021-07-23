require_relative 'jira'
require 'dotenv'
Dotenv.load

class User
  attr_accessor :jira_access_token, :jira_refresh_token, :jira_auth_code,
                :access_token_created_at, :body, :jira_cloud_id

  def initialize(name)
    @name = name
    @jira_auth_code = nil
    @jira_access_token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik16bERNemsxTVRoRlFVRTJRa0ZGT0VGRk9URkJOREJDTVRRek5EZzJSRVpDT1VKRFJrVXdNZyJ9.eyJodHRwczovL2F0bGFzc2lhbi5jb20vb2F1dGhDbGllbnRJZCI6IlA2OEpOQlF5SjNldjU4ck9pckVQd0RRcjJnb3BDTFBDIiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL2VtYWlsRG9tYWluIjoidGFuZ28uaW8iLCJodHRwczovL2F0bGFzc2lhbi5jb20vc3lzdGVtQWNjb3VudElkIjoiNjBmMGViZTdiOWVmNmYwMDY5MzE1YmQ2IiwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL3N5c3RlbUFjY291bnRFbWFpbERvbWFpbiI6ImNvbm5lY3QuYXRsYXNzaWFuLmNvbSIsImh0dHBzOi8vYXRsYXNzaWFuLmNvbS92ZXJpZmllZCI6dHJ1ZSwiaHR0cHM6Ly9hdGxhc3NpYW4uY29tL2ZpcnN0UGFydHkiOmZhbHNlLCJodHRwczovL2F0bGFzc2lhbi5jb20vM2xvIjp0cnVlLCJpc3MiOiJodHRwczovL2F0bGFzc2lhbi1hY2NvdW50LXByb2QucHVzMi5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NjAxNDc4NjEzMzJjYmUwMDcwZTYxNzFmIiwiYXVkIjoiYXBpLmF0bGFzc2lhbi5jb20iLCJpYXQiOjE2MjcyNDg0MTgsImV4cCI6MTYyNzI1MjAxOCwiYXpwIjoiUDY4Sk5CUXlKM2V2NThyT2lyRVB3RFFyMmdvcENMUEMiLCJzY29wZSI6IndyaXRlOmppcmEtd29yayByZWFkOmppcmEtd29yayByZWFkOmppcmEtdXNlciBvZmZsaW5lX2FjY2VzcyJ9.nv2wr-WAv1y9q_9hUnao47KhQGocRZv-ntmnUiaV4H6SBvtibXC0CVy5JArJJ0Eb7uMD74kgMDnjrEqRjDLPBnG3ApDNRN_PZHd-tUNY6fEA1ibnIj6GO8QK4ig35HVm-X4YbzNTS12a8HzMzzK6J_MS8MkCNuCVQvXmfqxH96riHnhyBuX1SCgdSCC1V6LK2Nc-4stluN5a17Y23lVN3JJ6HjlfyK5QIlXEB0-uAw4KTIVImdpxfH4haWAHA9epbyfmKtNpiWe2qhj5Gh2NtVtegSXxW85kiAoJmyY6OHSy5Bs7QA4IYyHsL1sw0SefCNAfaaemMJyiCrwLAHQ0ug'
    @jira_refresh_token = '4c_JLpozZ8uboIcaVhLaIGtue5c2V7B3aWYVF8qMBhr3K'
    @jira_cloud_id = nil
    @access_token_created_at = nil
  end

  def set_jira_cloud_id(cloud_id)
    @jira_cloud_id = cloud_id
  end
end

@user = User.new('tyler')

def say_hi
  @jira_client ||= AgileTool.new(AgileTool::Jira, @user)
  @jira_client.validate_access_token
end

say_hi
# puts say_hi
# puts @jira_client.jira_cloud_id
# puts @jira_client.projects
puts @jira_client.sprints('PP')
# puts @jira_client.backlog('10')
# puts @jira_client.project('PP')
# puts "access token: #{@user.jira_access_token}"
# puts "cloud id: #{@user.jira_cloud_id}"