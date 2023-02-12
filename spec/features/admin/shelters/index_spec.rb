require 'rails_helper'

  RSpec.describe 'admin shelter index' do

    let!(:shelter_1)  { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }
    let!(:shelter_2)  { Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5) }
    let!(:shelter_3)  { Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10) }
		let!(:pet_1) { shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true) }
		let!(:app_1) { Application.create!(name: 'Steve', 
			street: '152 Steve St.', 
			city: 'Denver', 
			state: 'CO', 
			zip: '40208',
			desc: 'I have home',
			status: 'Pending') }
		let!(:petapp) { PetApplication.create!(pet: pet_1, application: app_1)}
  
    it 'displays all shelter names in reverse alphabetical order' do
      visit '/admin/shelters'

      expect(shelter_2.name).to appear_before(shelter_3.name)
      expect(shelter_3.name).to appear_before(shelter_1.name)
    end

		it 'has a section with pending applications' do
			visit '/admin/shelters'

			expect(page).to have_link('Shelters with Pending Applications')
		end

		it 'filters shelters to show only those with pending applications' do
			visit '/admin/shelters'

			expect(page).to have_content(shelter_1.name)
			expect(page).to have_content(shelter_2.name)
			expect(page).to have_content(shelter_3.name)

			click_link 'Shelters with Pending Applications'

			expect(current_path).to eq('/admin/shelters')
			expect(page).to have_content(shelter_1.name)
			expect(page).to_not have_content(shelter_2.name)
			expect(page).to_not have_content(shelter_3.name)
		end
  end