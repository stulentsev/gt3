class ChartsController < InheritedResources::Base

  def new
    new! do
      app = App.where(_id: params.fetch_path(:chart, :app_id)).first
      @events = events(app)
    end
  end

  def edit
    edit! do
      @events = events(@chart.app)
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

  def events(app)
    return [] unless app

    app.app_events.map(&:name).sort
  end
end
