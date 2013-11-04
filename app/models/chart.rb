class Chart
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :config

  belongs_to :app

  validates_presence_of :name, :config, :app_id

  before_save :convert_tabs

  def lines
    parsed_config["lines"]
  end

  def format_string
    parsed_config["format_string"]  || "{point.y}"
  end

  private
  def parsed_config
    YAML.load(config)
  end

  def convert_tabs
    if config
      config.gsub!("\t", '  ')
    end
  end
end
