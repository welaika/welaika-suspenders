require "spec_helper"

RSpec.describe "suspenders:import_dump", type: :generator do
  it "generates the configuration for dump import from heroku" do
    rm "bin/import_dump"

    with_app { generate("suspenders:import_dump") }

    expect("bin/import_dump").to exist_as_a_file
    expect("bin/import_dump").to be_executable
  end

  it "destroys the configuration for dump import from heroku" do
    touch "bin/import_dump"

    with_app { destroy("suspenders:import_dump") }

    expect("bin/import_dump").not_to exist_as_a_file
  end
end
