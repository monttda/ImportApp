require 'rails_helper'


RSpec.describe "Visiting the home page", :type => :feature do

  it "should have" do
    visit '/'
    expect(page).to have_selector("#home")
    expect(page).to have_selector("#companies")
    expect(page).to have_selector("#import")
  end
end
