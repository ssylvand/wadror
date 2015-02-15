require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [Place.new(name: "Oljenkorsi", id: "1", street: "Testikatu", city: "Helsinki", zip: "00100", status: "Beer Bar", overall: "72", country: "Finland")]
                             )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if more than one are returned by the API, all of them are shown at the page" do
    Rails.cache.clear
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
                                 [Place.new(name: "Oljenkorsi", id: "1", street: "Testikatu", city: "Helsinki", zip: "00100", status: "Beer Bar", overall: "72", country: "Finland"),
                                 Place.new(name: "Baari", id: "2", street: "Testikatu", city: "Helsinki", zip: "00100", status: "Beer Bar", overall: "72", country: "Finland")])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Baari"
  end

  it "if no clubs are returned by the API, an error message is displayed on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end

end