module UserHelper

  def get_comments(project, number)
    @comments = Comment.order('created_at').find_all_by_commentable_id_and_commentable_type(project.id, 'Project').last(number)
  end

end
