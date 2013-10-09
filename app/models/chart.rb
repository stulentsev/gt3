class Chart
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :config

  belongs_to :app

  validates_presence_of :name, :config, :app_id

  before_save :convert_tabs

  def lines
    yaml = YAML.load(config)
    yaml['lines']
  end

  private
  def convert_tabs
    if config
      config.gsub!("\t", '  ')
    end
  end
end
