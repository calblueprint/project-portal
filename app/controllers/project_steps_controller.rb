class ProjectStepsController < ApplicationController
  include Wicked::Wizard

  steps :org_questions

  def show
    render_wizard
  end

end
