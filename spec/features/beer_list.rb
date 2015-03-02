require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create style: "Lager"
    @style2 = Style.create style: "Rauchbier"
    @style3 = Style.create style: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    #save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it 'shows beers in alphabetical order', js: true do
    visit beerlist_path
    row = find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Fastenbier"
    row = find('table').find('tr:nth-child(3)')
    expect(page).to have_content "Lechte Weisse"
    row = find('table').find('tr:nth-child(4)')
    expect(page).to have_content "Nikolai"
  end

  it 'sorts the beers in alphabetical order (based on style) after clicking', js: true do
    visit beerlist_path
    click_link "Style"
    row = find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Lager"
    row = find('table').find('tr:nth-child(3)')
    expect(page).to have_content "Rauchbier"
    row = find('table').find('tr:nth-child(4)')
    expect(page).to have_content "Weizen"
  end

  it 'sorts the beers in alphabetical order (based on brewery) after clicking', js: true do
    visit beerlist_path
    click_link "Brewery"
    row = find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Ayinger"
    row = find('table').find('tr:nth-child(3)')
    expect(page).to have_content "Koff"
    row = find('table').find('tr:nth-child(4)')
    expect(page).to have_content "Schlenkerla"
  end
end