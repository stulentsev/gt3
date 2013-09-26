class CronworkerController < ApplicationController
  SECRET_TOKEN = '958822783fb1cd51da8b'

  before_action :authenticate_user

  def schedule_dau
    schedule_for_each_app DauWorker

    render_ok
  end

  def schedule_mau
    schedule_for_each_app MauWorker

    render_ok
  end

  def schedule_event_uniques
    schedule_for_each_app EventUniquesWorker

    render_ok
  end

  def schedule_min_max
    schedule_for_each_app MinMaxWorker

    render_ok
  end

  private
  def schedule_for_each_app klass
    App.all.each do |app|
      klass.perform_async app_id: app.id, time: Time.now
    end
  end

  def authenticate_user
    unless params[:token] == SECRET_TOKEN
      render_error
    end
  end

  def render_ok
    render_json status: 'ok'
  end

  def render_error
    render_json({status: 'error'}, 403)
  end
end
