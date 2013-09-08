class ChartsController < InheritedResources::Base

  def create
    create! { app_path(@chart.app) }
  end

  def update
    update! { app_path(@chart.app) }
  end

  def destroy
    destroy! { app_path(@chart.app) }
  end

  private
  def permitted_params
    params.permit(chart: [:name, :config, :app_id])
  end
end
