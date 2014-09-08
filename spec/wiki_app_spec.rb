# TODO: fix test string.
# Cannot get the right test text to go in.
# It works fine when I do it, but not in a test.
mark_text = <<EOF
### Necessary for MVP\\r\\n\\r\\n- **Resources**: `documents`, `users`\\r\\n- **User Story Frames**:\\r\\n  - **(1) NEW & POST:** A user can create a new `document`... (`/documents/new` -> `POST /documents`)\\r\\n  - **(2) SHOW:** A user can show (ie, see) a given `document`... (`/documents/document-id`)\\r\\n  - **(3) INDEX:** A user can see all of the `documents` as a *feed*, up to a maximum of ten... (`/documents`)\\r\\n  - **(4) INDEX:** A user can browse successive pages of ten `documents` each, until the beginning of the feed... (`/documents?first=id-of-first-document`)
EOF

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
    expect(page).to have_link("sign_in")
  end
end

# Need a meaningful test to confirm sign in.
# I think this is template code from Capybara
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

# Interesting that this passed the 'it exists'
# test before I created the page or the link in
# app.rb.
describe("document_new.erb") do
  it("exists and has a working path") do
    visit("/documents/new")
    expect(page).to have_content
  end
  it("has a working form to add content") do
    visit("/documents/new")
    expect(page).to have_field("Author")
    expect(page).to have_field("Title")
    expect(page).to have_field("Text")
    fill_in 'Author', with: 'Michael Coniaris'
    fill_in 'Title', with: '#My Experience at GA'
    fill_in 'Text', with: 'I have found that PJ, ' +
      'Phil and Travis are the greatest teachers ever.'
    click_button 'Submit'
  end
end

describe("documents.erb") do
  it("exists and has content that includes 'I have found'") do
    visit("/documents")
    expect(page).to have_content("I have found")
  end
  it("textbox takes in markdown") do
    visit("/documents/new")
    fill_in 'Author', with: 'PJ'
    fill_in 'Title', with: '#Wiki'
    fill_in 'Text', with: mark_text
    click_button 'Submit'
  end
end

describe("documents.erb") do
  it("exists and has content that includes 'User Story Frames'") do
    visit("/documents")
    expect(page).to have_content("User Story Frames")
  end
end

describe("/documents/Wiki") do
  it("displays PJ's Wiki article") do
    visit("/documents/Wiki")
    expect(page).to have_content("The slug needs to be meaningful")
  end
end
