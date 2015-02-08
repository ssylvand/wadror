require 'rails_helper'
include OwnTestHelper

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }

  before :each do
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "can be created with a valid name" do
    visit new_beer_path
    fill_in('beer[name]', with: 'Beer')

    expect {
      click_button "Create Beer"
    }.to change { Beer.count }.from(0).to(1)
  end

  it "is not created and the user is redirected back to the creation page if invalid name given" do
    visit new_beer_path

    click_button "Create Beer"
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end