# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 2.minutes do
  token = '958822783fb1cd51da8b'

  command %Q[curl "http://localhost/cronworker/schedule_dau?token=#{token}"]
  command %Q[curl "http://localhost/cronworker/schedule_mau?token=#{token}"]
  command %Q[curl "http://localhost/cronworker/schedule_event_uniques?token=#{token}"]
  command %Q[curl "http://localhost/cronworker/schedule_min_max?token=#{token}"]
end