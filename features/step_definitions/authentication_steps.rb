Given /^a user visits the signin page$/ do
	visit signin_path
end

When /^they submit invalid signin information$/ do
	click_button "Sign in"
end

Then /^they should see an error message$/ do
	have_error_message('Invalid')
end


Given /^the user has an account$/ do
	#let(:user){ FactoryGirl.create(:user) }
	@user = User.create(email: "user@example.com", password:"foobar")
end

Given /^the user submits valid information$/ do
	fill_in "Email", with: @user.email
	fill_in "Password", with: @user.password
	click_button "Sign in"
end

Then /^they should see their profile page$/ do
	expect(page).to have_title(@user.name)
end

Then /^they should see a signout link$/ do
	#expect(page).to have_link('Sign out', href: signout_path)
end
