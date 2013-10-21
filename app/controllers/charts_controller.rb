class ChartsController < InheritedResources::Base

  def new
    new! do
      @events = []
    end
  end

  def edit
    edit! do
      @events = @chart.app.app_events.map(&:name)
    end
  end

  def create
    create! { edit_app_path(@chart.app) }
  end

  def update
    update! { edit_app_path(@chart.app) }
  end

  def destroy
    destroy! { edit_app_path(@chart.app) }
  end

  private
  def permitted_params
    params.permit(chart: [:name, :config, :app_id])
  end
end
