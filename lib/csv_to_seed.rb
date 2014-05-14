require 'csv'

class CSVToSeed
  attr_accessor :file, :headers

  def initialize(args)
    @csv_path_to_file = args[:csv_path_to_file]
    @name_of_array = args[:name_of_array]
  end

  def get_csv_body
    @file = File.open(@csv_path_to_file, "rb")
    @file.read
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

  def set_string_to_create_loop
  <<-TEXT
  #{@name_of_array}.each do |attributes|
    Static::SupportPracticeLu.find_or_initialize_by_name(attributes[:name]).tap do |support_practice|
      support_practice.name = attributes[:name]
      support_practice.support_practice_type_id = attributes[:support_practice_type_id]
      support_practice.number = attributes[:number]
      support_practice.width = attributes[:width]
      support_practice.save!
    end
  end
  TEXT
  end

  def write_seedrb_file
    File.write('db/seeds.rb', "\n\r#{@name_of_array} = #{csv_to_hash} \n\r #{set_string_to_create_loop}", File.size('db/seeds.rb'), mode: 'a')
    @file.close
  end
end