module UserHelper

  def get_comments(project, number)
    @comments = Comment.order('created_at').find_all_by_commentable_id_and_commentable_type(project.id, 'Project').last(number)
  end

  def is_client?(id)
  	user = User.find(id)
  	if user.rolable_type == "Client"
  		return true
  	else
  		return false
  	end
  end

  def is_developer?(id)
  	user = User.find(id)
  	if user.rolable_type == "Developer"
  		return true
  	else
  		return false
  	end
  end

  def is_organization?(id)
  	user = User.find(id)
  	if user.rolable_type == "Organization"
  		return true
  	else
  		return false
  	end
  end
end
