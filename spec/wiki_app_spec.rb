# If you are not using Rails, tag all the example
# groups in which you want to use Capybara with
# :type => :feature.
# This is sample code.
describe("index.erb") do
  it("exists and has a working path") do
    visit("/")
    expect(page).to have_content
  end
  it("has a login field") do
    visit("/")
    expect(page).to has_link?("Login")
  end
end

xdescribe "the signin process", :type => :feature do
  before :each do
    User.make(:email => 'user@example.com', :password => 'caplin')
  end

  it "signs me in" do
    visit '/sessions/new'
    within("#session") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Success'
  end
end
