#!/usr/bin/env ruby
#######################################
#  script by gr33n7007h               #
#  greets to metalx1000 @filmsbykris  #
#######################################

require 'open-uri'
require 'optparse'
require 'thread'
require 'ostruct'

module GeoLocator

  class StaticMapAddress

    URL = "https://maps.googleapis.com/maps/api/staticmap"

    attr_accessor :address, :map_type, :zoom
    def initialize(address, map_type = "hybrid", zoom = 15)
      @address = address
      @map_type = map_type
      @zoom = zoom
      @size = "512x512"
      @image_file = "/tmp/#{[*?a..?z].sample(10).join}.png"
      @uri_params = { center: @address, 
                      zoom: @zoom,
                      size: @size,
                      maptype: @map_type
      }
    end

    def get_view
      begin
        uri = URI.parse(URL)
        uri.query = URI.encode_www_form(@uri_params)
        uri.open do |f|
          File.open(@image_file, 'w') do |fd|
            IO.copy_stream(f, fd)
          end
        end
        Thread.new do
          spawn("display #{@image_file}")
        end.join
      rescue => e
        puts e
      end
    end
  end

  class StaticMapGps

    URL = "https://maps.googleapis.com/maps/api/staticmap"

    attr_accessor :latitude, :longitude, :map_type, :zoom
    def initialize(latitude, longitude, map_type = "hybrid", zoom = 15)
      @lat = latitude
      @lon = longitude
      @map_type = map_type
      @zoom = zoom
      @size = "512x512"
      @image_file = "/tmp/#{[*?a..?z].sample(10).join}.png"
      @location = "#{@lat},#{@lon}"
      @uri_params = { center: @location,
                      zoom: @zoom,
                      size: @size,
                      maptype: @map_type
      }
    end

    def get_view
      begin
        uri = URI.parse(URL)
        uri.query = URI.encode_www_form(@uri_params)
        uri.open do |f|
          File.open(@image_file, 'w') do |fd|
            IO.copy_stream(f, fd)
          end
        end
        Thread.new do
          spawn("display #{@image_file}")
        end.join
      rescue => e
        puts e
      end
    end
  end

  class StreetViewAddress
    
    URL = "https://maps.googleapis.com/maps/api/streetview"

    attr_accessor :address, :size
    def initialize(address)
      @address = address
      @size = "640x320"
      @image_file = "/tmp/#{[*?a..?z].sample(10).join}.png"
      @uri_params = { size: @size,
                      location: @address
      }
    end

    def get_views
      begin
        (0..270).step(90) do |degree|
          uri = URI.parse(URL)
          uri.query = URI.encode_www_form(@uri_params.merge({heading: degree}))
          uri.open do |f|
            File.open(@image_file, 'w') do |fd|
              IO.copy_stream(f, fd)
            end
          end
          Thread.new do
            spawn("display #{@image_file}")
          end.join
        end
      rescue => e
        puts e
      end
    end
  end


  class StreetViewGps

    URL = "https://maps.googleapis.com/maps/api/streetview"

    attr_accessor :latitude, :longitude, :size
    def initialize(latitude, longitude)
      @lat = latitude
      @lon = longitude
      @size = "640x320"
      @image_file = "/tmp/#{[*?a..?z].sample(10).join}.png"
      @location = "#{@lat},#{@lon}"
      @uri_params = { size: @size,
                      location: @location
      }
    end

    def get_views
      begin
        (0..270).step(90) do |degree|
          uri = URI.parse(URL)
          uri.query = URI.encode_www_form(@uri_params.merge({heading: degree}))
          uri.open do |f|
            File.open(@image_file, 'w') do |fd|
              IO.copy_stream(f, fd)
            end
          end
          Thread.new do
            spawn("display #{@image_file}")
          end.join
        end
      rescue => e
        puts e
      end
    end
  end
end

options = OpenStruct.new(staddress: nil, stcoords: nil, svaddress: nil, svcoords: nil)

begin
  OptionParser.new("\n GG - Tiny Geolocating Script using Google API", 30) do |opts|
    opts.separator ""
    opts.separator " Usage: #{$0} <options>\n\n"
    opts.on('--map-address <address>', String, "          : Address for static view map") do |staddress|
      options.staddress = staddress
    end
    opts.on('--map-gps <latitude>,<longitude>', Array, "          : Latitude and Longitude coordinates for static view map") do |stcoords|
      options.stcoords = stcoords
    end
    opts.on('--view-address <address>', String, "          : Address for street view map") do |svaddress|
      options.svaddress = svaddress
    end
    opts.on('--view-gps <latitude>,<longitude>', Array, "          : Latitude and Longitude coordinates for street view map") do |svcoords| 
      options.svcoords = svcoords
    end
    opts.on('--help', '          : This help screen\n') do
      puts opts
      exit(-1)
    end
    opts.separator ""
  end.parse!(ARGV)
rescue OptionParser::MissingArgument 
  puts "[!] Missing argument, '--help' for more info"
  exit(-1)
rescue OptionParser::InvalidOption
  puts "[!] Invalid option, '--help' for more info"
  exit(-1)
end

if options.staddress.nil? && options.stcoords.nil? && options.svaddress.nil? && options.svcoords.nil?
  puts "[!] Try '--help' for more info"
  exit(-1)
end

#p options
begin  
  if options.staddress
    GeoLocator::StaticMapAddress.new(options.staddress).get_view
  elsif options.stcoords
    GeoLocator::StaticMapGps.new(*options.stcoords).get_view
  elsif options.svaddress
    GeoLocator::StreetViewAddress.new(options.svaddress).get_views
  elsif options.svcoords
    GeoLocator::StreetViewGps.new(*options.svcoords).get_views
  else
    puts "[!] Try '--help' for more info"
    exit(-1)
  end
rescue 
  puts "[!] Try '--help' for more info'"
  exit(-1)
end
## EOF









