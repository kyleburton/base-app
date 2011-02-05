require 'rubygems'
require 'optparse'

class BaseApp
  attr_accessor :status

  def initialize
    @status = 0
    @options = {}
    @required_opts = []
  end

  def command_line_arguments
    [['v','verbose','Be more verbose.'],
     ['h', 'help',   'Request help.']]
  end

  def construct_opts
    opts = OptionParser.new do |opts|
      command_line_arguments.each do |argspec|
        short, long, description, required, default_value = argspec
        param_name = long.gsub '=', ''
        @required_opts << param_name if required
        @options[param_name] = default_value if default_value
        create_getter_setter(long)
        opts.on("-#{short}", "--#{long} VAL", description) do |val|
          @options[param_name] = val
          setter = param_name.gsub("-", "_") + "="
          self.send(setter,val)
        end
      end
    end
  end

  def create_getter_setter(name)
    name = name.gsub("-", "_").gsub(/=.?/, "")
    self.class.send(:attr_accessor, name) unless self.respond_to?(name)
  end

  def parse_command_line_options
    opts = construct_opts
    opts.parse!
    @required_opts.each do |name|
      unless @options[name]
        raise "Error, required argument '#{name}' must be supplied."
      end
    end
  end

  # file util helpers
  def exists? file
    File.exists? file
  end

  def mkdir dir
    FileUtils.mkdir(dir) unless exists?(dir)
  end

  def help_text_firstline
    "#$0: \n"
  end

  def help_text
    text = help_text_firstline
    command_line_arguments.each do |argspec|
      short, long, description, required, default_value = argspec
      short_text = (long =~ /=/) ? "#{short}=s" : short
      text << sprintf("  -%-3s | --%-20s  %s%s\n", short_text, long, description, (required ? "(required)" : ""))
    end
    text
  end

  def process_template_to_file(name,target,props={})
    write_file(target, process_template(name,target,props))
  end

  def get_template(template_name)
    unless @templates
      @templates = {}
      template_data = DATA.read
      template_data.scan(/(__.+?__.+?__.+?__)/m).each do |template|
        template = template[0]
        template =~ /^(__.+?__)$/m
        name = $1
        template.gsub! /^__.+?__$/m, ''
        @templates[name] = template
      end
    end
    @templates["__#{template_name.to_s.upcase}__"] or
      raise "Error: no template named: #{template_name} (#{@templates.keys.join(", ")})"
  end

  def process_template (template_name, additional_properties={} )
    template = get_template template_name

    @properties.merge(additional_properties).each do |prop,val|
      term = "{{#{prop}}}"
      printf "substituting: %-40s => %s\n", term, val
      template.gsub! term, val
    end

    template
  end

  def write_file(target,*content)
    File.open(target,'w') do |f|
      content.each do |c|
        f.puts c.to_s
      end
    end
  end

  def self.main
    app = self.new
    app.parse_command_line_options

    if app.help
      $stderr.print app.help_text
      exit app.status
    end

    max_width = app.command_line_arguments.map {|x| x[1].length}.max
    if app.verbose
      $stderr.puts "#$0 Parameters:"
      app.command_line_arguments.each do |opt_spec|
        short, arg, descr = opt_spec
        option = arg.gsub(/=.?$/,'').gsub('-','_')
        $stderr.printf( "  %*s : %s\n", max_width, arg.gsub(/=.?$/,''), app.send(option.to_sym))
      end
      $stderr.puts ""
    end

    app.run
    exit app.status
  end
end
