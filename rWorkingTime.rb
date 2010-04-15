#!/usr/bin/env ruby

require 'rubygems'
require 'gcal4ruby'
require 'time'

APP_CONFIG = YAML.load_file("config.yml")

service = GCal4Ruby::Service.new
service.authenticate(APP_CONFIG['google']['username'], APP_CONFIG['google']['password'])

puts "Finding calendar..."
calendar = GCal4Ruby::Calendar.find(service, APP_CONFIG['calendar']['title'], :first)

puts calendar.id
puts calendar.title

puts
puts "Finding events..."
events = GCal4Ruby::Event.find(calendar, '', {
  :ctz => APP_CONFIG['calendar']['ctz'],
  # :range => {:start => Time.parse("15-11-2009 00:00:00"), :end => Time.parse("14-12-2009 23:59:59")},
  # :range => {:start => Time.parse("13-12-2009 00:00:00"), :end => Time.parse("14-01-2010 23:59:59")},
  :range => {:start => Time.parse("15-01-2010 00:00:00"), :end => Time.parse("28-02-2010 23:59:59")},
  :sortorder => 'ascending'
})

working_hours = 0

events.each do |event|
  hours = (event.end - event.start)/60/60 # if event.start && event.end
  working_hours += hours if hours
  puts "#{event.title} - #{hours} - #{event.start} - #{event.end}"
end

salary = working_hours*APP_CONFIG['rate_per_hour']

puts "#{working_hours} hours; #{salary} ; #{salary*APP_CONFIG['tax_rate']} brutto"
