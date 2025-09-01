class Tenant::ProjectsController < Tenant::ApplicationController
  before_action do
    @back_url = action_name == "index" ? root_path : tenant_projects_path
  end

  def index
    render locals: { projects: current_account.projects.order(:created_at) }
  end

  def new
    project = project.new
    project.set_defaults
    project.assign_attributes permitted_params
    render locals: { project: project }
  end

  def edit
    project = current_account.projects.find params[:id]
    render locals: { project: }
  end

  def update
    project = current_account.projects.find params[:id]
    project.update! permitted_params
    redirect_to tenant_project_path(project), notice: "Изменилось расширение #{project.name}"
  rescue ActiveRecord::RecordInvalid => e
    render :edit, locals: { project: e.record }, status: :unprocessable_entity
  end

  def create
    project = current_account.projects.create! permitted_params
    redirect_to tenant_project_path(project), notice: "Создается сервис #{project.name}"
  rescue ActiveRecord::RecordInvalid => e
    render :new, locals: { project: e.record }, status: :unprocessable_entity
  end

  def show
    render :show, locals: { project: current_account.projects.find(params[:id]) }
  end

  def destroy
    project = current_account.projects.find(params[:id])
    project.destroy!
    redirect_back fallback_location: tenant_projects_path, notice: "Сервис #{project.name} удалён"
  end

  private

  def permitted_params
    return {} unless params.key? :project
    params.require(:project).permit(:name, :blockchain_id, :summary, :extra_dataset_paths, :extra_dataset_paths_list)
  end
end
