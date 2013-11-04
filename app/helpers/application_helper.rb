module ApplicationHelper
  ALERT_TYPES = [:error, :info, :success, :warning]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
          content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
            msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def display_sidebar(link_groups)
    if link_groups.present?
      render partial: 'sidebar/show', locals: {link_groups: link_groups}
    end
  end

  def git_version
    root = '/var/www/gt2/current'
    rev_filename = File.join(root, 'REVISION')
    if File.exists?(rev_filename)
      File.read(rev_filename)
    else
      `git rev-parse HEAD`
    end
  end

  private

end
