shared_examples_for :requires_parameter do |parameter_name|
  it "works with #{parameter_name}" do
    result.should be_true
  end

  it "does not work without #{parameter_name}" do
    event_params.delete(parameter_name)
    result.should be_false
  end
end