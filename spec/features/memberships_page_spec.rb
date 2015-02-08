require 'rails_helper'

describe "Membership page" do
  it "should exist" do
    visit memberships_path
    expect(page).to have_content 'Listing Memberships'
  end
end