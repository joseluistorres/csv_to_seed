require 'helper'
#Dir["test/rules/*.rb"].each {|file| require './' + file }
#Dir["test/test_classes/*.rb"].each {|file| require './' + file }

describe CSVToSeed do
  before do
    @csv_to_seed = CSVToSeed.new({ :csv_path_to_file => 'test/csv_files/test.csv', :name_of_array => 'my_test' })
    @csv_to_seed_broken = CSVToSeed.new({ :csv_path_to_file => 'missing.csv', :name_of_array => 'my_test' })
  end

  it "should read a CSV file" do
    @csv_to_seed.get_csv_body.must_match /name,support_practice_type_id,number,width/
  end

  it "should show an error when the CSV file is missing" do
    error = -> { @csv_to_seed_broken.get_csv_body }.must_raise RuntimeError
    error.message.must_match /Invalid file path/
  end

  it "should have a valid CSV object " do
    @csv_to_seed.csv_object.must_be_instance_of CSV
  end

  it "should have a valid hash object before writing" do
    @csv_to_seed.csv_to_hash.must_be_instance_of String
    @csv_to_seed.csv_to_hash.must_match /\n\r\{\ \:name\=\>\"0.05\%\ grade\ channel\"\,/
  end

  it "should have a valid name of array" do
    @csv_to_seed.name_of_array.must_match /^[a-z_][a-zA-Z_0-9]*$/
  end

  it "should raise an error when a name of array is invalid" do
    error =-> { CSVToSeed.new({ :csv_path_to_file => 'test.csv', :name_of_array => '123my_test' }) }.must_raise RuntimeError
    error.message.must_match /Must be a valid variable name/
  end
end
