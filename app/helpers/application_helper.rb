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
    return '' if link_groups.empty?

    content_tag(:div, class: 'span3') do
      content_tag(:div, class: 'well sidebar-nav') do
        content = sidebar_title

        content + link_groups.map do |title, rows|
           sidebar_links(title, rows)
        end.join.html_safe
      end
    end
  end

  def sidebar_links(title, rows)
    content_tag(:ul, class: 'nav nav-list') do |c|
      content = content_tag(:li, class: 'nav-header') { title }

      content + rows.map do |row|
        content_tag(:li, link_to(row[:name], row[:href]))
      end.join.html_safe
    end
  end

  def sidebar_title
    content_tag(:h3, I18n.t('labels.sidebar'))
  end

  def format_dates(arr)
    arr.map do |elem|
      d = Date.parse(elem)
      d.strftime('%b %d')
    end
  end

  def git_version
    rev_filename = File.join(Rails.root, 'REVISION')
    if File.exists?(rev_filename)
      File.read(rev_filename)
    else
      `git rev-parse HEAD`
    end
  end

  private

end
