module ProjectsHelper
	def isFav(id)
		project = Project.find(id)
	    proj = Favorite.where("project_id = ? AND user_id = ?", project.id, current_user).limit(1)
	    p proj
	    if proj.empty?
	      return false
	    else
	      return true
	    end
	end

end
