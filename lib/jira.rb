require_relative 'agile_tool'
require 'faraday'
require 'json'
require 'cgi'

class AgileTool::Jira
  ONE_HOUR = 3600

  def initialize(user)
    @user = user
    connect
  end

  def projects
    url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/project"
    res = Faraday.get do |req| 
      req.url(url)
      req.headers['Authorization'] = "Bearer #{@user.jira_access_token}"
      req.headers['Accept'] = 'application/json'
    end
    unless res.success?
      # return "Failed getting the projects: #{JSON.parse(res.body)['error_description']}" 
      return "Failed getting the projects: #{res.body}" 
    end
    res.body
  end

  def issues_of(project_id)
    # get issues
  end

  def sprints(project_id)
    # OAuth 2.0 is not enabled for this method
    # url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/board/10/backlog"
    # url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/search?jql=Sprint%3D%27PlanPoke%20-%20Sprint%2011%27&fields=summary"
    # url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/jql/autocompletedata/suggestions?fieldName=Sprint&fieldValue= "
    # url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/jql/autocompletedata/suggestions?order%20by%20created%20DESC"
    params = CGI.escape("assignee='Alvaro Padilla' AND Sprint='PlanPoke - Sprint 10'")
# assignee%3D%27Alvaro+Padilla%27+AND+Sprint%3D%27PlanPoke+-+Sprint+10%27%26fields%3Did%2Cassignee%2Cdescription%2Csummary
    # puts params
    url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/search?jql=#{params}"
    res = Faraday.get do |req| 
      req.url(url)
      req.headers['Authorization'] = "Bearer #{@user.jira_access_token}"
      req.headers['Accept'] = 'application/json'
    end
    unless res.success?
      return "Failed getting the sprints: #{res.body}" 
    end
    res.body
  end

  def backlog(board_id)
    # OAuth 2.0 is not enabled for this method
    url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/board/#{board_id}/backlog"
    res = Faraday.get do |req| 
      req.url(url)
      req.headers['Authorization'] = "Bearer #{@user.jira_access_token}"
      req.headers['Accept'] = 'application/json'
    end
    unless res.success?
      return "Failed getting the backlog: #{res.body}" 
    end
    res.body
  end

  def project(project_id)
    url = "https://api.atlassian.com/ex/jira/#{@user.jira_cloud_id}/rest/api/2/project/#{project_id}"
    res = Faraday.get do |req| 
      req.url(url)
      req.headers['Authorization'] = "Bearer #{@user.jira_access_token}"
      req.headers['Accept'] = 'application/json'
    end
    unless res.success?
      return "Failed getting the project data: #{res.body}" 
    end
    res.body
  end

  def validate_access_token
    # return get_access_token if @user.jira_access_token.blank?
    return get_access_token if @user.jira_access_token.nil?
    valid_access_token? ? @user.jira_access_token : refresh_access_token
  end

  private

  def get_cloud_id
    url = 'https://api.atlassian.com/oauth/token/accessible-resources'
    res = Faraday.get do |req| 
      req.url(url)
      req.headers['Authorization'] = "Bearer #{@user.jira_access_token}"
      req.headers['Accept'] = 'application/json'
    end
    unless res.success?
      puts res.body
      return "Failed getting the cloud id: #{res.body}" 
    end
    @user.jira_cloud_id = JSON.parse(res.body)[0]["id"]
    # @user.jira_access_token
  end

  def get_access_token
    conn = Faraday.new
    res = conn.post(
      ENV['JIRA_ACCESS_TOKEN_URL'],
      URI.encode_www_form(
        grant_type: 'authorization_code',
        client_id: ENV['JIRA_CLIENT_ID'],
        client_secret: ENV['JIRA_CLIENT_SECRET'],
        code: 'CyfSUJxwQYdsvv6k',
        redirect_uri: 'http://localhost:3000/api/v1/agile_integration/jira/authorize',
      ),
      {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json"
      }
    )
    unless res.success?
      return "Failed getting the access token: #{res.body}" 
    end
    @user.jira_access_token = JSON.parse(res.body)['access_token']
    # get_cloud_id
  end

  def valid_access_token?
    # return false if @user.access_token_created_at.nil?
    get_cloud_id
    true
    # (Time.now - @user.access_token_created_at) < ONE_HOUR
  end

  def refresh_access_token
    conn = Faraday.new
    res = conn.post(
      ENV['JIRA_ACCESS_TOKEN_URL'],
      URI.encode_www_form(
        grant_type: 'refresh_token',
        client_id: ENV['JIRA_CLIENT_ID'],
        client_secret: ENV['JIRA_CLIENT_SECRET'],
        refresh_token: '4c_JLpozZ8uboIcaVhLaIGtue5c2V7B3aWYVF8qMBhr3K',
      ),
      {
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json"
      }
    )
    unless res.success?
      return "Refreshing token failed: #{res.body}" 
    end
    @user.jira_access_token = JSON.parse(res.body)['access_token']
    get_cloud_id
  end

  def connect
    # connection
  end
end