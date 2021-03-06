require 'spec_helper'

describe CsiApi::Employee do
  include CsiApiMocks
  
  let(:employee_info) do
    xml_response = File.read("spec/fixtures/authenticate_employee_response.xml")
    mock_savon_response xml_response
  end
  
  let(:employee_auth_token) do
    employee_info.body[:authenticate_employee_response][:authenticate_employee_result][:value][:employee_ticket]
  end
  
  let(:employee) do
    CsiApi::ClientFactory.should_receive(:generate_employee_client).with(employee_auth_token).at_least(:once)
    CsiApi::Employee.new employee_info
  end
  
  it "should initialize" do
    employee.should be_an_instance_of CsiApi::Employee
  end
  
  it "should create attribute accessors from keys" do
    employee.should respond_to :first_name
    employee.should respond_to :last_name
  end
  
  it "should have an array of attributes" do
    employee.class.attr_list.should be_an_instance_of Array
    employee.class.attr_list.should include(:first_name)
  end
  
  it "should properly populate attributes" do
    employee.first_name.should == "Buffy"
    employee.last_name.should == "Wood"
  end
  
  it "should not reset attributes when another instance is initialized" do
    employee
    new_employee = CsiApi::Employee.new employee_info
    employee.first_name.should == "Buffy"
    new_employee.first_name.should == "Buffy"
  end
  
  it "should not have multiple copies of attributes in attribute array after multiple initializations" do
    employee
    new_employee = CsiApi::Employee.new employee_info
    CsiApi::Employee.attr_list.count(:first_name).should == 1
  end
  
  
end