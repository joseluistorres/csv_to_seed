require 'csv'

class CSVToSeed
  attr_accessor :file, :headers, :name_of_array

  def initialize(args)
    @csv_path_to_file = args[:csv_path_to_file]
    @name_of_array = args[:name_of_array]
    validate_name_of_array(@name_of_array)
  end

  def get_csv_body
    begin
      @file = File.open(@csv_path_to_file, "rb")
      @file.read
    rescue
      raise 'Invalid file path'
    end
  end

  def csv_object
    CSV.new(get_csv_body.to_s, {:headers => true, :header_converters => :symbol, :converters => :all})
  end

  def csv_to_hash

    @headers = ''
    fix_csv = csv_object.to_a.map {|row|
      @headers = row.headers
      row.to_hash
    }

    replace_and_fix_csv_string fix_csv.to_s
  end

  def replace_and_fix_csv_string(fix_me)
    fix_me
      .gsub(/\}\,/, "},\n\r")
      .gsub(/\[\{/, "[\n\r{")
      .gsub(/\}\]/, "}\n\r]")
      .gsub(/\{\:/, "{\s:")
      .gsub(/\}\,/, "\s},")
  end

  def validate_name_of_array(value)
    raise 'Must be a valid variable name' if (value =~ /^[a-z_][a-zA-Z_0-9]*$/).nil?
  end

  def set_string_to_create_loop
    if @headers.empty?
      csv_to_hash
    end
    inside_vars = ''
    @headers.each do |header|
      inside_vars = inside_vars + 
    <<-TEXT
        support_practice.#{header.to_s} = attributes[:#{header.to_s}]
    TEXT
    end
    <<-TEXT
    #{@name_of_array}.each do |attributes|
      Static::SupportPracticeLu.find_or_initialize_by_name(attributes[:name]).tap do |support_practice|
        #{inside_vars}
        support_practice.save!
      end
    end
    TEXT
  end

  def write_seedrb_file
    File.write(Dir.pwd + '/db/seeds.rb', "\n\r#{@name_of_array} = #{csv_to_hash} \n\r #{set_string_to_create_loop}", File.size(Dir.pwd + '/db/seeds.rb'), mode: 'a')
    @file.close
  end
end
