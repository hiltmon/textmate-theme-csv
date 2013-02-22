#!/usr/bin/env ruby

# parseTheme.rb
# Hilton Lipschitz (http://www.hiltmon.com)
# Use and modify freely, attribution appreciated
# 
# This script parses a default or TextMate managed theme into
# the CSV-like format I use for easier theme creation.
#
# Use the -b option to write the theme to the same-named file,
# or -o to your own named file.
#
# Note that this version of the script ignores the Avian folder
# 
# Example usage:
# parseTheme -w Zenburnesque

require 'optparse'
require 'rexml/document'

class ParseTheme
  
  VERSION = '0.0.1'
  AUTHOR = 'Hilton Lipschitz'
  TWITTER = '@hiltmon'
  HOME_URL = 'http://www.hiltmon.com'
  LEDE = 'Parse a Theme to fixed TMCSV'
  
  attr_reader :options
  attr_reader :theme_name
  
  def initialize(arguments)
    @arguments = arguments
    
    parse_options
    parse_parameters
  end
  
  def run

    xml_data = IO.read(@data_path)
    xml_data.gsub!("\v", '') # For Brilliance Black
    doc = REXML::Document.new(xml_data)

    # Build the data structure
    raw_theme = {}
    doc.elements.each('plist/dict') do |plist_dict|
      raw_theme[:attributes] = from_dict(plist_dict)
      raw_theme[:settings] = []
      plist_dict.elements.each('array/dict') do |line|
        line_hash = {}
        line_hash[:attributes] = from_dict(line)
        line.elements.each('dict') do |settings|
          line_hash[:settings] = from_dict(settings)
        end
        raw_theme[:settings] << line_hash
      end
    end

    # Create the CSV-like file using brute force
    lines = []
    # The unkeyed settings are the defaults
    lines << "// Type, author, name, semanticClass, uuid"
    a_line = ["Header"]
    a_line << raw_theme[:attributes]['author']
    a_line << raw_theme[:attributes]['name']
    a_line << raw_theme[:attributes]['semanticClass']
    a_line << raw_theme[:attributes]['uuid']
    lines << a_line.join(', ')
    comment = false
    raw_theme[:settings].each do |line|
      # One of these is the main item, it has no key!
      if line[:attributes]['name'].nil?
        lines << "// Type, background, foreground, caret, selection, invisibles, lineHighlight"
        a_line = ['Main']
        a_line << line_setting(line, 'background')
        a_line << line_setting(line, 'foreground')
        a_line << line_setting(line, 'caret')
        a_line << line_setting(line, 'selection')
        a_line << line_setting(line, 'invisibles')
        a_line << line_setting(line, 'lineHighlight')
        lines << a_line.join(', ')
      else
        # Its a scope line
        if !comment
          lines << "// Type, name, background, foreground, fontStyle (bold, italic, underline), scopes (comma separated)"
          comment = true
        end
        scope = line[:attributes]['scope']
        scope.gsub!("\n", ' ') unless scope.nil?
        a_line = ['Scope']
        a_line << line[:attributes]['name']
        a_line << line_setting(line, 'background')
        a_line << line_setting(line, 'foreground')
        a_line << line_setting(line, 'fontStyle') # bold, underline, italic
        a_line << scope
        lines << a_line.join(', ')
      end
    end

    # And save or display
    if options[:write] || options[:output]
      filename = "#{theme_name}.tmcsv"
      if options[:output]
        filename = "#{output}"
        filename = "#{filename}.tmcsv" if filename !~ /\.tmcsv$/
      end
      IO.write(filename, lines.join("\n"))
      puts "Created #{filename}"
    else
      puts lines
    end
  end
  
  protected
  
  def from_dict(element)
    # Gets keys and strings
    keys = []
    values = []
    element.elements.each('key') do |key|
      keys << key.text unless key.text == 'settings'
    end
    element.elements.each('string') do |value|
      values << value.text
    end
    # Into the hash
    Hash[keys.zip(values)]
  end

  def line_setting(line, setting)
    (line[:settings][setting] || 'nil')
  end
  def from_dict(element)
    # Gets keys and strings
    keys = []
    values = []
    element.elements.each('key') do |key|
      keys << key.text unless key.text == 'settings'
    end
    element.elements.each('string') do |value|
      values << value.text
    end
    # Into the hash
    Hash[keys.zip(values)]
  end

  def line_setting(line, setting)
    (line[:settings][setting] || 'nil')
  end
  
  def parse_options
    @options = {}
    
    title = "#{LEDE}\nBy #{AUTHOR} (#{TWITTER}) #{HOME_URL}\n"
    
    @opts = OptionParser.new
    @opts.banner = "#{title}\nUsage: parseTheme.rb [options] ThemeName"
    @opts.on("-o", "--output FILENAME", "Write a TMCSV file") { |out| options[:output] = out }
    @opts.on("-w", "--[no-]write", "Write a default TMCSV file") { |w| options[:write] = w }
    @opts.on('-h', '--help', 'Display this screen' ) { puts @opts; exit 0 }
    begin
      @opts.parse!(@arguments) 
    rescue => e
      puts e
      puts
      puts @opts
      exit (-1)
    end
  end
  
  def parse_parameters
    if @arguments.empty?
      puts @opts
      exit (-1)
    end
    
    app_support = "#{ENV['HOME']}/Library/Application\ Support"
    avian_bundles = "#{app_support}/Avian/Bundles"
    managed_bundles = "#{app_support}/TextMate/Managed/Bundles"
    default_themes = "#{managed_bundles}/Themes.tmbundle/Themes"
        
    @theme_name = ARGV[0]
    @data_path = "#{default_themes}/#{theme_name}.tmTheme"
    # puts @data_path
    if !File.exists?(@data_path)
      @data_path = "#{managed_bundles}/#{theme_name}.tmbundle/Themes/#{theme_name}.tmTheme"
      # puts @data_path
      if !File.exists?(@data_path)
        @data_path = "#{avian_bundles}/#{theme_name}.tmbundle/Themes/#{theme_name}.tmTheme"
        # puts @data_path
        if !File.exists?(@data_path)
          @data_path = "./#{theme_name}"
          # puts @data_path
          if !File.exists?(@data_path)
            puts "#{@theme_name} Not found"
            exit (-1)
          end
        end
      end
    end
  end
  
end

app = ParseTheme.new(ARGV)
app.run
