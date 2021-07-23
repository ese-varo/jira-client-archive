class AgileTool
    def initialize(tool, user)
      @tool = tool.new(user)
    end
  
    def projects
      @tool.projects
    end

    def project(project_id)
      @tool.project(project_id)
    end

    def backlog(board_id)
      @tool.backlog(board_id)
    end

    def sprints(project_id)
      @tool.sprints(project_id)
    end
  
    def issues_of(project_id)
      @tool.issues_of(project_id)
    end

    def validate_access_token
      @tool.validate_access_token
    end
  end